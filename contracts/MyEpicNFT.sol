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
  string[] firstWords = ["Pajama", "Aloha", "Bourbon", "Sedan", "Continent", "Puzzle"];
  string[] secondWords = ["Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot"];
  string[] thirdWords = ["Crepe", "Burrito", "Hoagie", "Gyro", "PBJ", "Quiche"];
  string[][] allWords = [firstWords, secondWords, thirdWords];

  string[] face = ["#FDDC43", "#43DDFD", "#FD9143", "#FFA4CE", "#4DAA57"];
  string[] eyes = ["#0AFFED", "#255C99", "#31D843", "#A85751", "#251351", "#7D2E68"];
  string[] beret = ["#78F0A0", "#F08278", "#000", "#FF0707"];
  string[] pompom = ["#07B4F9", "#EDE471", "#FF7F00"];
  string[] background = ["#FFF", "#825A96", "#3366De", "#CDE77F", "#B744B8"];


  uint private _maxTokens;
  event NewEpicNFTMinted(address sender, uint256 tokenId, uint maxTokens, string finalTokenUri);
  event EpicNFTsRemaining(uint remaining);

  constructor(uint maxTokens) ERC721 ("PlantimalsNFT", "POTZ") {
    _maxTokens = maxTokens;
    console.log("NFT Contract with %n max", maxTokens);
  }

  function pickRandomWord(uint word, string memory seed, uint256 tokenId) public view returns (string memory) {
    require(word < allWords.length, "Invalid Input");
    // I seed the random generator. More on this in the lesson. 
    uint256 rand = random(string(abi.encodePacked(seed, Strings.toString(tokenId))));
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    rand = rand % allWords[word].length;
    return allWords[word][rand];
  }

  function pickRandomBackgroundColor(string memory seed, uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked(seed, Strings.toString(tokenId))));
    rand = rand % background.length;
    return background[rand];
  }

  function pickRandomEyeColor(string memory seed, uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked(seed, Strings.toString(tokenId))));
    rand = rand % eyes.length;
    return eyes[rand];
  }

  function pickRandomBeretColor(string memory seed, uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked(seed, Strings.toString(tokenId))));
    rand = rand % beret.length;
    return beret[rand];
  }

  function pickRandomPompomColor(string memory seed, uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked(seed, Strings.toString(tokenId))));
    rand = rand % pompom.length;
    return pompom[rand];
  }

  function pickRandomFaceColor(string memory seed, uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked(seed, Strings.toString(tokenId))));
    rand = rand % face.length;
    return face[rand];
  }


  function makeDef(string memory id, string memory value) internal pure returns (string memory) {
    /*
    <linearGradient id="eyes">
            <stop stop-color="#991132"/>
        </linearGradient>
    */
    return string(abi.encodePacked("<linearGradient id=\"", id, "\"><stop stop-color=\"", value, "\"/></linearGradient>"));
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
      "<svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' viewBox='0 0 327 550' version='1.1'><title>Plantimal ", 
      Strings.toString(newItemId), 
      "</title><defs>",
      makeDef("background", pickRandomBackgroundColor("background", newItemId)),
      makeDef("eyes", pickRandomEyeColor("eyes", newItemId)),
      makeDef("face", pickRandomFaceColor("face", newItemId)),
      makeDef("beret", pickRandomBeretColor("beret", newItemId)),
      makeDef("pompom", pickRandomPompomColor("pompom", newItemId)),
      "<radialGradient cx='68.6444302%' cy='0%' fx='68.6444302%' fy='0%' r='100%' gradientTransform='translate(0.686444,0.000000),scale(0.124138,1.000000),rotate(90.000000),scale(1.000000,4.469958),translate(-0.686444,-0.000000)' id='radialGradient-1'> \
            <stop stop-color='#E47C00' stop-opacity='0.5' offset='0%'></stop> \
            <stop stop-color='#D67500' stop-opacity='0.5' offset='100%'></stop> \
        </radialGradient> \
        <radialGradient cx= '50%' cy='0%' fx='50%' fy='0%' r='100%' gradientTransform='translate(0.500000,0.000000),scale(0.124138,1.000000),rotate(90.000000),translate(-0.500000,-0.000000)' id='radialGradient-2'> \
            <stop stop-color='#FE9429' stop-opacity='0.5' offset='0%'></stop> \
            <stop stop-color='#D88700' stop-opacity='0.5' offset='100%'></stop> \
        </radialGradient> \
        <rect id='path-3' x='0' y='0' width='145' height='18'></rect> \
        <radialGradient cx='69.5521499%' cy='0%' fx='69.5521499%' fy='0%' r='100%' gradientTransform='translate(0.695521,0.000000),scale(0.675651,1.000000),rotate(90.000000),translate(-0.695521,-0.000000)' id='radialGradient-4'> \
            <stop stop-color='#D67500' stop-opacity='0.5' offset='0%'></stop> \
            <stop stop-color='#FE9429' stop-opacity='0.5' offset='100%'></stop> \
        </radialGradient> \
        <polygon id='path-5' points='6 17.8140259 138 17.8140259 107.476807 107 36.5231934 107'></polygon> \
    </defs> \
    <g id='Page-1' stroke='none' stroke-width='1' fill='none' fill-rule='evenodd'> \
        <g id='Plantimal' transform='translate(0.000000, 0.764664)'> \
            <rect id='Background' stroke='#979797' fill='url(#background)' x='0.5' y='0.5' width='326' height='548'></rect> \
            <g id='Stem' transform='translate(87.404633, 271.735336)'> \
                <path d='M81.3604123,0 C85.6279855,10.5677136 87.7040138,21.48445 87.5884972,32.7502091 C87.4729807,44.0159681 85.1739143,54.8510449 80.691298,65.2554394 C73.4102077,77.4060131 69.7118591,89.1185939 69.596252,100.393182 C69.4228414,117.305064 76.3664253,165.783369 79.9763935,134.976564' id='Line' stroke='#00BA0B' stroke-width='8' stroke-linecap='round' stroke-linejoin='round'></path> \
                <ellipse id='Oval' fill='#43B34A' transform='translate(121.595367, 43.000000) rotate(-25.000000) translate(-121.595367, -43.000000) ' cx='121.595367' cy='43' rx='39' ry='14.5'></ellipse> \
                <ellipse id='Oval' fill='#4AAF50' transform='translate(41.473968, 56.239136) rotate(25.000000) translate(-41.473968, -56.239136) ' cx='41.4739685' cy='56.2391357' rx='39' ry='14.5'></ellipse> \
            </g> \
            <circle id='Face' fill='url(#face)' cx='164' cy='191.235336' r='80'></circle> \
            <g id='EyeWhites' transform='translate(120.000000, 159.235336)' fill='#FFFFFF'> \
                <circle id='Oval' cx='16.5' cy='16.5' r='16.5'></circle> \
                <circle id='Oval' cx='61.5' cy='16.5' r='16.5'></circle> \
            </g> \
            <g id='Pupils' transform='translate(124.000000, 167.235336)' fill='url(#eyes)'> \
                <circle id='Oval' cx='53' cy='9' r='9'> \
                </circle> \
                <circle id='Oval' cx='9' cy='9' r='9'> \
                </circle> \
            </g> \
            <path d='M158.76123,144.851128 C130.79541,124.400668 122.572998,104.243743 134.093994,84.3803554 C145.61499,64.5169675 170.423809,67.2400409 208.520452,92.5495755 C240.658673,75.0519151 265.405599,69.6711879 282.76123,76.407394 C308.794678,86.511703 290.424316,132.357528 276.610107,144.851128 C267.400635,153.180195 258.116048,156.390458 248.756348,154.481918 L222.756506,153.067777 C221.426322,154.010537 211.094564,154.481918 191.76123,154.481918 C172.427897,154.481918 161.427897,151.271655 158.76123,144.851128 Z' id='Beret' fill='url(#beret)' transform='translate(212.476958, 113.147255) rotate(35.000000) translate(-212.476958, -113.147255) '></path> \
            <g id='Teeth' transform='translate(142.000000, 208.235336)' fill='#FFFFFF'> \
                <rect id='Rectangle' x='0' y='0' width='13' height='14'></rect> \
                <rect id='Rectangle' x='15' y='0' width='13' height='14'></rect> \
            </g> \
            <g id='Pot' transform='translate(91.000000, 402.235336)'> \
                <g id='Rectangle'> \
                    <use fill='#C47524' xlink:href='#path-3'></use> \
                    <use fill='url(#radialGradient-1)' xlink:href='#path-3'></use> \
                    <use fill='url(#radialGradient-2)' xlink:href='#path-3'></use> \
                </g> \
                <g id= 'Rectangle'> \
                    <use fill='#C47524' style='mix-blend-mode: soft-light;' xlink:href='#path-5'></use> \
                    <use fill='url(#radialGradient-4)' xlink:href='#path-5'></use> \
                </g> \
            </g> \
            <circle id='Pompom' fill='url(#pompom)' cx='226' cy='91.2353359' r='9'></circle> \
        </g> \
    </g> \
</svg>"));
    
    
    string memory plantimalName = string(abi.encodePacked("Plantimal #", Strings.toString(newItemId)));
    
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    plantimalName,
                    '", "description": "A cute little French monster in a flower pot.", "image": "data:image/svg+xml;base64,',
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