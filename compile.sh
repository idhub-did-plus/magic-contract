#！/bin/bash

# only for magic-contract release v0.0.1

output=`cp -r ./contracts/compliance ./contracts/sol-v0.4/compliance`
echo \"[File Copied] /contracts/compliance/\"

output=`cp ./contracts/sol-v0.4/truffle-config.js ./truffle-config.js`
echo \"Copied: solidity version ^0.4.21 to truffle config\"

output=`truffle compile`
echo \"Compiled: solidity version ^0.4.21 compile finished\"

output=`cp -r ./contracts/identity ./contracts/sol-v0.5/identity`
echo \"[File Copied] /contracts/identity/\"

output=`cp -r ./contracts/claim ./contracts/sol-v0.5/claim`
echo \"[File Copied] /contracts/claim/\"

output=`cp -r ./contracts/interfaces ./contracts/sol-v0.5/interfaces`
echo \"[File Copied] /contracts/interfaces/\"

output=`cp -r ./contracts/ownable ./contracts/sol-v0.5/ownable`
echo \"[File Copied] /contracts/ownable/\"

output=`cp -r ./contracts/token ./contracts/sol-v0.5/token`
echo \"[File Copied] /contracts/token/\"

output=`cp ./contracts/Migrations.sol ./contracts/sol-v0.5/Migrations.sol`
echo \"[File Copied] /contracts/Migrations.sol\"

output=`cp ./contracts/sol-v0.5/truffle-config.js ./truffle-config.js`
echo \"Copied: solidity version ^0.5.0 to truffle config\"

output=`truffle compile`
echo \"Compiled: solidity version ^0.5.0 compile finished\"
