#！/bin/bash

# only for magic-contract release v0.0.1
cp ./contracts/sol-v0.4/truffle-config.js ./truffle-config.js \
&& truffle compile && \
cp ./contracts/sol-v0.5/truffle-config.js ./truffle-config.js \
&& truffle compile