// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; 

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LiquidityPool{
    IERC20 token1;
    IERC20 token2;
    uint token1Count;
    uint token2Count;
    uint fixedConstantSupply;
   
   function initializeTokens(IERC20 _token1, IERC20 _token2) public{
       token1=_token1;
       token2=_token2;
   }

    function addToPool(uint amountOfToken1,uint amountOfToken2)public{
        require(amountOfToken1>0 && amountOfToken2>0, "Amount Should be > 0");
        token1Count+=amountOfToken1;
        token2Count+=amountOfToken2;
        token1.transferFrom(msg.sender,address(this),amountOfToken1);
        token2.transferFrom(msg.sender,address(this),amountOfToken2);
    }

    function withdrawFromPool(uint amountOfToken1,uint amountOfToken2) public {
         require(amountOfToken1>0 && amountOfToken2>0, "Amount Should be > 0");
        token1Count-=amountOfToken1;
        token2Count-=amountOfToken2;
        token1.transfer(msg.sender,amountOfToken1);
        token2.transfer(msg.sender,amountOfToken2);
    }

    function swapTokens(uint amountIn, IERC20 fromToken, IERC20 toToken) external {
  
        require(fromToken != toToken, "Tokens must be different");
        uint fromTokenBalance = fromToken == token1 ? token1Count : token2Count;
        uint toTokenBalance = toToken == token1 ? token1Count : token2Count;
        
        require(fromTokenBalance >= amountIn, "Insufficient balance");

        uint256 amountOut = (amountIn * toTokenBalance) / fromTokenBalance;
        
        if (fromToken == token1) {
            token1Count -= amountIn;
            token2Count += amountOut;
        } else {
            token2Count -= amountIn;
            token1Count += amountOut;
        }

       fromToken.transferFrom(msg.sender, address(this), amountIn);
       toToken.transfer(msg.sender, amountOut);
        
    }


}