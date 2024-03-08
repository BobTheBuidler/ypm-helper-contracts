
pragma solidity =0.5.16;

interface IUniswapV2Factory {
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);
}

interface IUniswapV2Pool {
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112, uint112, uint32);
}

contract UniswapFactoryHelper {
    function getPairsFor(IUniswapV2Factory factory, address token) public view returns (address[] memory) {
        uint allPairsLength = factory.allPairsLength();
        address[] memory pairs = new address[](allPairsLength);
        uint count = 0;
        for (uint i = 0; i < allPairsLength; i++) {
            address pair = factory.allPairs(i);
            IUniswapV2Pool pool = IUniswapV2Pool(pair);
            if (token == pool.token0()) {
                pairs[count] = pair;
                count++;
            } else if (token == pool.token1()) {
                pairs[count] = pair;
                count++;
            }
        }
        address[] memory resized = new address[](count);
        for (uint i = 0; i < count; i++) {
            resized[i] = pairs[i];
        }
        return resized;
    }
    function deepestPoolFor(IUniswapV2Factory factory, address token, address[] memory ignorePools) public view returns (address, uint112) {
        uint allPairsLength = factory.allPairsLength();
        uint112 deepestReserves = 0;
        address deepestPool = address(0);
        for (uint i = 0; i < allPairsLength; i++) {
            address pair = factory.allPairs(i);
            if (shouldIgnore(pair, ignorePools)) {
                continue;
            }
            IUniswapV2Pool pool = IUniswapV2Pool(pair);
            if (token == pool.token0()) {
                (uint112 reserves,,) = pool.getReserves();
                if (reserves > deepestReserves) {
                    deepestReserves = reserves;
                    deepestPool = pair;
                }
            } else if (token == pool.token1()) {
                (,uint112 reserves,) = pool.getReserves();
                if (reserves > deepestReserves) {
                    deepestReserves = reserves;
                    deepestPool = pair;
                }
            }
        }
        return (deepestPool, deepestReserves);
    }
    function deepestPoolForFrom(IUniswapV2Pool[] memory pools, address token) public view returns (address, uint112) {
        uint poolsLength = pools.length;
        uint112 deepestReserves = 0;
        address deepestPool = address(0);
        for (uint i = 0; i < poolsLength; i++) {
            IUniswapV2Pool pool = pools[i];
            if (token == pool.token0()) {
                (uint112 reserves,,) = pool.getReserves();
                if (reserves > deepestReserves) {
                    deepestReserves = reserves;
                    deepestPool = address(pool);
                }
            } else if (token == pool.token1()) {
                (,uint112 reserves,) = pool.getReserves();
                if (reserves > deepestReserves) {
                    deepestReserves = reserves;
                    deepestPool = address(pool);
                }
            }
        }
        return (deepestPool, deepestReserves);
    }
    function shouldIgnore(address pair, address[] memory ignorePools) internal view returns (bool) {
        for (uint i = 0; i < ignorePools.length; i++) {
            if (pair == ignorePools[i]) {
                return true;
            }
        }
        return false;
    }
}