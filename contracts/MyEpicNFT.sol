// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  uint256 private supplyCap = 50;

  string svgPartOne =
    "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
  string svgPartTwo = "'/>";
  string svgPartThree =
    "</text><text x='50%' y='35%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  string svgFirstTrait =
    "<text x='50%' y='35%' class='base' dominant-baseline='middle' text-anchor='middle'>";
  string svgSecondTrait =
    "</text><text x='50%' y='45%' class='base' dominant-baseline='middle' text-anchor='middle'>";
  string svgThirdTrait =
    "</text><text x='50%' y='55%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  string[] colors = [
    "#7400b8",
    "#6930C3",
    "#5E60CE",
    "#5390D9",
    "#4EA8DE",
    "#48BFE3",
    "#56CFE1",
    "#64DFDF",
    "#72EFDD",
    "#80FFDB"
  ];

  string[] firstWords = [
    "Adamant",
    "Bashful",
    "Bold",
    "Brave",
    "Calm",
    "Careful",
    "Docile",
    "Gentle",
    "Hardy",
    "Hasty",
    "Impish",
    "Jolly",
    "Lax",
    "Lonely",
    "Mild",
    "Modest",
    "Naive",
    "Naughty",
    "Quiet",
    "Rash",
    "Relaxed",
    "Sassy",
    "Serious",
    "Timid"
  ];

  string[] secondWords = [
    "Ada",
    "Assembly",
    "Bash",
    "BASIC",
    "C",
    "C++",
    "C#",
    "Clojure",
    "COBOL",
    "CoffeeScript",
    "Crystal",
    "Dart",
    "Elixir",
    "Emacs Lisp",
    "Erlang",
    "Fortran",
    "Go",
    "Haskell",
    "Holy C",
    "Java",
    "JavaScript",
    "Julia",
    "Kotlin",
    "LISP",
    "PHP",
    "Perl",
    "Python",
    "Scala",
    "Solidity",
    "SQL",
    "Swift",
    "R",
    "Rust",
    "Ruby",
    "TeX",
    "TypeScript",
    "Vimscript",
    "Vyper"
  ];

  string[] thirdWords = [
    "Developer",
    "Full Stack Developer",
    "Front End Developer",
    "Back End Developer",
    "Mobile Developer",
    "UI Developer",
    "Web3 Developer",
    "Software Developer",
    "Tech Lead",
    "Designer",
    "Architect",
    "Engineer",
    "Software Engineer",
    "Student",
    "Scientist",
    "Engineering Manager",
    "Data Analyst",
    "Researcher",
    "Evangelist",
    "Guru",
    "Influencer",
    "Ninja",
    "Rockstar",
    "Programmer",
    "Hipster"
  ];

  event NewEpicNFTMinted(address sender, uint256 tokenId);

  constructor() ERC721("SquareNFT", "SQUARE") {}

  function random(string memory input) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(input)));
  }

  function pickRandomFirstWord(uint256 tokenId)
    public
    view
    returns (string memory)
  {
    uint256 rand = random(
      string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
    );
    rand = rand % firstWords.length;
    return firstWords[rand];
  }

  function pickRandomSecondWord(uint256 tokenId)
    public
    view
    returns (string memory)
  {
    uint256 rand = random(
      string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId)))
    );
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId)
    public
    view
    returns (string memory)
  {
    uint256 rand = random(
      string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
    );
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function pickRandomColor(uint256 tokenId)
    public
    view
    returns (string memory)
  {
    uint256 rand = random(
      string(abi.encodePacked("COLOR", Strings.toString(tokenId)))
    );
    rand = rand % colors.length;
    return colors[rand];
  }

  function makeAnEpicNFT() public {
    require(_tokenIds.current() < supplyCap, "Mint limit exceeded");
    uint256 newItemId = _tokenIds.current();

    string memory randomColor = pickRandomColor(newItemId);
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);
    string memory combinedWord = string(abi.encodePacked(first, second, third));

    // concatenate it all together, and then close the <text> and <svg> tags.
    string memory finalSvg = string(
      abi.encodePacked(
        svgPartOne,
        randomColor,
        svgPartTwo,
        svgFirstTrait,
        first,
        svgSecondTrait,
        second,
        svgThirdTrait,
        third,
        "</text></svg>"
      )
    );

    // Get all the JSON metadata in place and base64 encode it
    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "',
            // set the title of NFT as the generated word
            combinedWord,
            '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
            // Add data:image/svg+xml;base64 and then append the base64 encode svg
            Base64.encode(bytes(finalSvg)),
            '"}'
          )
        )
      )
    );

    string memory finalTokenUri = string(
      abi.encodePacked("data:application/json;base64,", json)
    );

    console.log(finalTokenUri);
    console.log("\n--------------------");
    console.log(
      string(
        abi.encodePacked("https://nftpreview.0xdev.codes/?code=", finalTokenUri)
      )
    );
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);

    // Sets the NFTs data
    _setTokenURI(newItemId, finalTokenUri);

    // Increment the counter for when the next NFT is minted
    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    emit NewEpicNFTMinted(msg.sender, newItemId);
  }
}
