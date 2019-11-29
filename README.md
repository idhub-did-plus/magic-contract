# magic-contract
包括 Magic Circle 的合约及其配套系统。
合约内容包括链上身份合约、链上合规合约以及证券性通证合约；配套体系包括网页端身份管理系统、证券通证部署发行平台、证券通证支持设施（停牌、分红、持股比例统计、收录网站等）和合规管理平台。

## Requirements

* [Node.js](https://nodejs.org/en/)
* [Solidity & Solc](https://solidity.readthedocs.io/en/v0.5.13/installing-solidity.html)
* [Truffle](https://www.trufflesuite.com/)
* [sol-compiler](https://sol-compiler.com/)
* [React](https://reactjs.org/)
* [yarn](https://www.yarnpkg.com/en/)

## Installation

```
git clone https://github.com/idhub-did-plus/magic-contract.git

cd magic-contract
```

## Usage

### compile contract
如果修改了 solidity 合约，那么你需要编辑 `compile.sh` 文件（ `.example.compile.sh` 文件中有一些示例代码供参考）以将正确的版本拷贝进入正确的编译目录， `output=`truffle compile`
echo \"Compiled: solidity version ^0.4.21 compile finished\"` 这行代码之前被拷贝进入 `contracts/sol-v0.4` 文件夹的合约会被 `^0.4.21` 版本的 solidity 编译器所编译；相应的这行代码之后被拷贝进入 `contracts/sol-v0.5` 文件夹的合约会被 `^0.5.10` 版本的 solidity 编译器所编译。当然你也可以在 `contracts/sol-v0.4/truffle-config.js` 和 `contracts/sol-v0.5/truffle-config.js` 文件中修改相应的编译配置，配置规则请参考 truffle 文档。在配置完成后运行以下命令编译合约：

```
npm run compile
```

### deploy contract
合约部署完全遵照 truffle 的[部署方法](https://www.trufflesuite.com/blog/an-easier-way-to-deploy-your-smart-contracts)，你可以[设置不同的配置](https://www.trufflesuite.com/docs/truffle/reference/configuration#networks)以适应各个[以太坊网络](https://www.trufflesuite.com/docs/truffle/reference/choosing-an-ethereum-client)，默认使用 [Ganache](https://www.trufflesuite.com/ganache) 客户端节点；通过修改 `migrations/` 目录下的脚本可以自定义配置部署流程，最后运行 truffle 的[迁移命令](https://www.trufflesuite.com/docs/truffle/getting-started/running-migrations#running-migrations)就可以完成部署。下面是使用 truffle 提供的内嵌 EVM 环境的合约部署命令：

```
truffle develop

truffle migrate
``` 

### start/build app
你可以选择直接在本地启动项目，或打包文件进行部署；具体请参考 [React文档](https://reactjs.org/docs/getting-started.html) 。

```
cd app

yarn

yarn start
// Or
yarn build 
```

## Reference

* https://www.trufflesuite.com/blog/an-easier-way-to-deploy-your-smart-contracts
* https://www.jianshu.com/p/0d2e388787c6
* https://medium.com/@mweststrate/how-to-safely-use-react-context-b7e343eff076
* https://reacttraining.com/react-router/web/guides/quick-start
* https://reactjs.org/docs/context.html