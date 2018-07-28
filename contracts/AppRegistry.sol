pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol";

import "./App.sol";
import "./DataCategory.sol";

/**
 * AppRegistry stores an app information, and user IDs of the app.
 * A certain amount of token stake — proportional to the number of users — is required for apps.
 *
 * If an app did some bad things that prohibited by Airbloc Protocol's Law,
 * then there's a risk for app can LOSE some amount of it's stake.
 */
contract AppRegistry {
    using AddressUtils for address;
    using SafeMath for uint256;

    ERC20 token;
    address receiver;
    address punisher;

    DataCategory dataCtg;
    mapping(bytes32 => App) public apps;

    event AppRegistered(bytes32 appId, address owner);
    event AppUnregistered(bytes32 appId, address owner);

    /**
     * @param token The address of token for stake.
     * @param penaltyBeneficiary The destination wallet that stake losses are transferred to.
     */
    constructor(
        ERC20 _token,
        address _receiver,
        address _punisher,
        DataCategory _dataCtg
    ) public {
        token = _token;
        receiver = _receiver;
        punisher = _punisher;
        dataCtg = _dataCtg;
    }

    /**
     * @param appId ID of off-chain app metadata.
     */
    function register(bytes32 appId) public {
        apps[appId] = new App(token, receiver, punisher, dataCtg);
        emit AppRegistered(appId, msg.sender);
    }

    function unregister(bytes32 appId) public {
        App app = apps[appId];

        require(hasAppOf(appId), "App not found.");
        require(app.owner() == msg.sender, "Only app owner can do this.");

        delete apps[appId];
        emit AppUnregistered(appId, msg.sender);
    }

    function isAppOwner(bytes32 appId, address addr) public view returns (bool) {
        return apps[appId].owner() == addr;
    }

    function hasAppOf(bytes32 appId) public view returns (bool) {
        return apps[appId].token() != address(0);
    }
}
