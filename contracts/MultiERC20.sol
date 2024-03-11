// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.0;

interface IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function balanceOf(address) external view returns (uint);
    function totalSupply() external view returns (uint);
}

contract MultiERC20 {
    function tokenBalancesOf(IERC20 token, address[] memory addresses) public view returns (uint[] memory) {
        uint addressesLength = addresses.length;
        uint[] memory balances = new uint[](addressesLength);
        for (uint i = 0; i < addressesLength; i++) {
            balances[i] = token.balanceOf(addresses[i]);
        }
        return balances;
    }
    function balancesOfTokens(address wallet, IERC20[] memory tokens) public view returns (uint[] memory) {
        uint tokensLength = tokens.length;
        uint[] memory balances = new uint[](tokensLength);
        for (uint i = 0; i < tokensLength; i++) {
            balances[i] = tokens[i].balanceOf(wallet);
        }
        return balances;
    }
    function totalSupplys(IERC20[] memory tokens) public view returns (uint[] memory) {
        uint tokensLength = tokens.length;
        uint[] memory supplys = new uint[](tokensLength);
        for (uint i = 0; i < tokensLength; i++) {
            supplys[i] = tokens[i].totalSupply();
        }
        return supplys;
    }
    function names(IERC20[] memory tokens) public view returns (string[] memory) {
        uint tokensLength = tokens.length;
        string[] memory _names = new string[](tokensLength);
        for (uint i = 0; i < tokensLength; i++) {
            _names[i] = tokens[i].name();
        }
        return _names;
    }
    function symbols(IERC20[] memory tokens) public view returns (string[] memory) {
        uint tokensLength = tokens.length;
        string[] memory _symbols = new string[](tokensLength);
        for (uint i = 0; i < tokensLength; i++) {
            _symbols[i] = tokens[i].symbol();
        }
        return _symbols;
    }
}