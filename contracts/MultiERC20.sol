
pragma solidity =0.5.16;

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
}