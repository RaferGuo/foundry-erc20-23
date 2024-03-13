// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test} from "lib/forge-std/src/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract OurTokenTest is Test {
      OurToken public ourToken;//src
      DeployOurToken public deployer;//script

      uint256 public constant STARTING_BALANCE = 100 ether;
      
      //Creates an address derived from the provided name.
      address bob = makeAddr("bob");
      address alice = makeAddr("alice");

      function setUp() public {
           deployer = new DeployOurToken();
           ourToken = deployer.run();

           vm.prank(msg.sender);
           ourToken.transfer(bob, STARTING_BALANCE);//trans to bob
      }

      function testBobBalance() view public {
            assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
      }

      //count how many tokens from you
      function testAllowancesWorks() public {
            uint256 initialAllowance = 1000;

            //bob approves alice to spend tokens on her behalf
            vm.prank(bob);
            ourToken.approve(alice, initialAllowance);//dont prove others use token,but alice

            uint256 transferAmount = 500;

            vm.prank(alice);
            //bob -> alice 
            ourToken.transferFrom(bob, alice, transferAmount);

            assertEq(ourToken.balanceOf(alice), transferAmount);
            assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
      }
}
