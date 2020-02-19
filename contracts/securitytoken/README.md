## ST合约主要实现功能及其考虑

### 模块化设计
除了ERC1400规定的必要功能之外，其余功能都以模块化组件的方式插入ST逻辑合约，代码实现都位于`./modules`文件夹下。

### ST需求整理

1. 不同条款发行的ST具有不同的转移限制和合规条件以及和公司约定的权益属性，所以使用不同partition实现
2. 每个partition使用一个单独的ERC20合约实现，建议默认设置一个条款发行的ST使用ERC1400所继承的ERC20中实现；所以同一个ST的不同种类partition在交易所也分为不同的交易对单独交易，比如同一ST的RegD和RegS对应的每种token（一个partition就是一种ERC20Token）也列为不同交易对
3. 不同条款的转移限制：
	* RegD.506(b)：一级市场锁仓6到12个月 & 二级市场转移双方必须是SEC规定的合格投资者
	* RegD.506(c)：一级市场锁仓6到12个月 & 二级市场转移双方必须是SEC规定的合格投资者
	* RegD.504：一级市场锁仓6到12个月 & 二级市场转移双方必须是提交了报税单、银行流水和信用报告信息的自然人
	* RegS：提交了报税单、银行流水和信用报告信息的自然人 & 转移双方国籍非美国
4. 不同条款的合规限制：
	* RegD.506(b)：SEC规定的合格投资者
	* RegD.506(c)：SEC规定的合格投资者
	* RegD.504：提交了报税单、银行流水和信用报告信息的自然人
	* RegS：提交了报税单、银行流水和信用报告信息的自然人 & 国籍非美国
5. 综上所述，ST合约遵守如下实现原则：
	1. 一级市场限制条件和二级市场限制条件可以单独分开检查
	2. 提供锁仓功能满足一级市场限制条件，因此转移时依次进行锁仓检查、身份检查来满足合规条件
	3. 身份检查分两种身份，分别是交了报税单、银行流水、信用报告信息的自然人和SEC规定的合格投资者
	4. 身份检查中会需要的身份属性包括国籍、居住地区
	5. 自然人、合格投资者、国籍等条件互相不产生矛盾，所以可以同时以claim的形式存在
	6. 身份检查通过claim实现方便后续扩展
6. 以上信息只针对ST投资人，ST发行方对于不同的发行条款所进行的事务不会影响投资者的行为逻辑，具体事务另行讨论
7. 除ST发行的法律条款之外，ST发行方的会不会对于ST转移提供更多的限制条件（不过这一点可以在线下定制），特别是上述做法默认忽略了例如AB股、优先股等和ST发行的法律条款之间产生的交叉影响
8. 需要确定ST发行和转移（对应于一级市场和二级市场）规则基本只受限于发行备案采用的法律条款

### 功能点
1. 个人持股比例限制，需考虑配合partition，分partition检查
2. 股东数量限制，需考虑配合partition，分partition检查
3. 股票停牌时token转移暂停[已实现:pausable模块]
4. 转移双方身份合规限制，应该设计为使用链上Claim的认证方案
5. 每一最小粒度的股票可能有相应的锁仓期限，需考虑配合partition
6. 时间检查点，记录某一特定时刻token持有数量，用于帮助分红或投票，需考虑配合partition，分partition记录
7. 合约权限管理，比如股票经纪人、发行方、监管部门等相应角色的设立
8. 发行合约，暂定只用稳定比或ETH来购买发行，需考虑增发新股的情况
9. 关于Partially Fungible和Partition的体现:[已实现]

	1. 'The specification for this metadata, beyond the existence of the _partition key to identify it, does not form part of this standard. The token holders address can be paired with the partition to use as a metadata key if data varies across token holders with the same partition (e.g. a "restricted" partition may be associated with different lock up dates for each token holder).' （摘自ERC1410）
	2. 'In order to remain backwards compatible with ERC-20 / ERC-777 (and other fungible token standards) it is necessary to define what partition or partitions are used when a transfer / send operation is executed (i.e. when not explicitly specifying the partition). However this is seen as an implementation detail (could be via a fixed list, or programatically determined). One option is to simple iterate over all partitionsOf for the token holder, although this approach needs to be cognisant of block gas limits.'（摘自ERC1410）
	3. 根据以上原则，考虑定义`transfer`使用的默认partition代表普通股，甚至此partition或此类股无标示索引。
	4. 转账时提供默认转移无锁仓的普通股，转移优先股或其他需要partition来标示的股票使用`transferByPartition`
	5. 根据第二条，partition可以用来标示锁仓期限、不同股种（如普通股、优先股），用户地址也可以用来标示锁仓期限、不同股种（如普通股、优先股），用户地址作为partition的二级标示
	6. 根据第二条，`transfer`先检查无partition标示的普通股，再检查无锁仓的partition（如A、B轮等），最后根据用户地址检查不同锁仓期的partition，因此partition应带有优先级属性
	7. 优先股或同股不同权的partition的转账优先级应该排在最后（使用用户地址标示，只有特定地址拥有此类股票且此地址不可拥有其他partition的股票）或禁止使用`transfer`转移，应提供parititon互转的功能
10. 建议partition功能模块化，采用可插拔方式，每个partition模块都有检查个人持股比例限制、股东数量限制、时间检查点等功能
11. ST的name等属性由合约建立view函数来标示，ST的股票代码默认用合约地址来标示，无需注册表合约登记股票代码的功能[已实现]



## 智能合约合规检查体系考虑

1. 合规检查指ST合约根据转账地址追溯用户聚合身份检查身份合规性，身份合规由链上凭证claim来体现
2. 同一ST要求的合规claim可以是多种并存且相互为‘或’关系，也可以只要求必要的合规字段满足条件即可，必要的合规字段的值可以有多种且相互为‘或’关系
3. ERC780 Claim注册中心是链上合规检查逻辑的数据源，可能需要校验以下内容：
	```
	[1] Claim颁发机构
	[2] Claim接受人
	[3] Claim合规定义来源
	[4] Claim合规类型
	[5] Claim司法管辖区
	[6] Claim接受人居住地区
	[7] Claim接受人国籍
	[8] Claim有效期
	[9] 用于后续有可能增加属性的扩展字段
	```
4. 合规检查基本库ComplianceLib决定合规检查逻辑，需要ST合约注册使用，每个基本库代表一类（一种）检查逻辑，基本逻辑为：
```
	[1] 使用各个字段的`ABIEncode`的哈希值作为Claim的key查询注册中心
	[2] 核实查到的有效期是否满足基本库代表的合规逻辑的规定
```
5. 合规检查合约供SecurityToken注册调用，合规检查基本库需要注册到合规检查合约且检查时相互之间为“或”关系
6. 颁发Claim时需要考虑所有合规条件，说明如下：
```
	[1] Claim颁发机构、Claim接受人、Claim合规定义来源、Claim合规类型、Claim有效期是必须字段，任何Claim都有体现在哈希值key中
	[2] Claim司法管辖区、Claim接受人居住地区、Claim接受人国籍等每个属性为接受人颁发一个Claim，需要将上条所述的所有属性也体现在哈希值key中
	[3] 后续有可能增加属性的扩展字段参考上一条
```























