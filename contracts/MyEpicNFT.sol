// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  
  // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
  // So, we make a baseSvg variable here that all our NFTs can use.
  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
  // I create three arrays, each with their own theme of random words.
  // Pick some random funny words, names of anime characters, foods you like, whatever! 

  string[] left = ["#5ADD38", "#EBF725", "#FDC536"];
  string[] right = ["#1186E2", "#DD38B2", "#A011E2"];
  string[] angle = ["0", "10", "20", "30"];
  string[] aura = ["<feColorMatrix values='0 0 0 0 0.0099638437   0 0 0 0 0.924672887   0 0 0 0 0.855803602  0 0 0 1 0' type='matrix' in='shadowBlurOuter1'></feColorMatrix>", 
                   "<feColorMatrix values='0 0 0 0 0.925490196   0 0 0 0 0.850980392   0 0 0 0 0.0117647059  0 0 0 1 0' type='matrix' in='shadowBlurOuter1'></feColorMatrix>", 
                   "<feColorMatrix values='0 0 0 0 0.925490196   0 0 0 0 0.0117647059   0 0 0 0 0.505882353  0 0 0 1 0' type='matrix' in='shadowBlurOuter1'></feColorMatrix>"];
  

  uint private _maxTokens;
  event NewEpicNFTMinted(address sender, uint256 tokenId, uint maxTokens, string finalTokenUri);
  event EpicNFTsRemaining(uint remaining);

  constructor(uint maxTokens) ERC721 ("PlantimalsNFT", "POTZ") {
    _maxTokens = maxTokens;
    console.log("NFT Contract with %n max", maxTokens);
  }

  function pickRandomLeftColor(string memory seed, uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked(seed, Strings.toString(tokenId))));
    rand = rand % left.length;
    return left[rand];
  }

  function pickRandomRightColor(string memory seed, uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked(seed, Strings.toString(tokenId))));
    rand = rand % right.length;
    return right[rand];
  }

  function pickRandomAngle(string memory seed, uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked(seed, Strings.toString(tokenId))));
    rand = rand % angle.length;
    return angle[rand];
  }

  function pickRandomAura(string memory seed, uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked(seed, Strings.toString(tokenId))));
    rand = rand % aura.length;
    return aura[rand];
  }
  
  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  function remainingEpicNFTs() public view returns (uint) { 
    return _maxTokens - _tokenIds.current();
  }

  function getURI(uint256 id) public view returns (string memory) {
    require(id <= _tokenIds.current(), "invalid token ID");
    return tokenURI(id);
  }

  function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();
    require(newItemId < _maxTokens, "NFTs all gone");
    string memory newBaseSvg = string(abi.encodePacked(

"<svg width='500px' height='500px' viewBox='0 0 500 500' version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'>",
    "<title>buildspaceNFT #", Strings.toString(newItemId), "</title>",
    "<defs>",
        "<linearGradient x1='0%' y1='19.7280151%' x2='100%' y2='80.0442017%' id='linearGradient-1'>",
            "<stop stop-color='", 
            pickRandomLeftColor("LeftColor", newItemId), 
            "' offset='0%'></stop>",
            "<stop stop-color='", 
            pickRandomRightColor("RightColor", newItemId), 
            "' offset='100%'></stop>",
        "</linearGradient>",
        "<text id='text-2' font-family='AppleColorEmoji, Apple Color Emoji' font-size='216' font-weight='normal' fill='#000000'>",
            unicode"<tspan x='142' y='324'>🦄</tspan>",
        "</text>",
        "<filter x='-12.0%' y='-9.2%' width='126.4%' height='119.7%' filterUnits='objectBoundingBox' id='filter-3'>",
            "<feOffset dx='2' dy='2' in='SourceAlpha' result='shadowOffsetOuter1'></feOffset>",
            "<feGaussianBlur stdDeviation='9' in='shadowOffsetOuter1' result='shadowBlurOuter1'></feGaussianBlur>",
            pickRandomAura("Aura", newItemId),
        "</filter>",
    "</defs>",
    "<g id='Page-2' stroke='none' stroke-width='1' fill='none' fill-rule='evenodd'>",
        "<g id='BuildspaceNFT'>",
            "<rect id='Rectangle' fill='url(#linearGradient-1)' x='0' y='0' width='500' height='500'></rect>",
            "<text id='buildspace' font-family='SFProText-Heavy, SF Pro Text' font-size='36' font-weight='600' fill='#FFFFFF'>",
                "<tspan x='147' y='407'>buildspace</tspan>",
            "</text>",
            unicode"<g id='🦄' transform='translate(250.000000, 250.000000) rotate(", pickRandomAngle("Angle", newItemId), ".000000) translate(-250.000000, -250.000000) ' fill='#000000' fill-opacity='1'>",
                "<use filter='url(#filter-3)' xlink:href='#text-2'></use>",
                "<use xlink:href='#text-2'></use>",
            "</g>",
        "</g>",
    "</g>",
"</svg>"));
    
    
    string memory plantimalName = string(abi.encodePacked("_buildspaceNFT #", Strings.toString(newItemId)));
    
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    plantimalName,
                    '", "description": "Special _buildspace unicorn.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(newBaseSvg)),
                    '"}'
                )
            )
        )
    );
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );
    
    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");
    _safeMint(msg.sender, newItemId);
    _setTokenURI(newItemId, finalTokenUri);
    console.log("An NFT with the ID of %s has been minted to %s", newItemId, msg.sender);

    _tokenIds.increment();

    emit NewEpicNFTMinted(msg.sender, newItemId, _maxTokens, finalTokenUri);
    emit EpicNFTsRemaining(_maxTokens - (newItemId + 1));
  }

}