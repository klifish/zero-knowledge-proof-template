// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@account-abstraction/contracts/core/BaseAccount.sol";
import "@account-abstraction/contracts/core/Helpers.sol";
import "./Commitment.sol";



contract MyAccount is BaseAccount, Initializable {
    Commitment public commitmentModule;
    uint256 public immutable countId;

    IEntryPoint private immutable _entryPoint;

    event MyAccountInitialized(IEntryPoint indexed entryPoint, uint256 indexed commitmentModule);

    constructor(IEntryPoint anEntryPoint) {
        _entryPoint = anEntryPoint;
        _disableInitializers();
    }

    /// @inheritdoc BaseAccount
    function entryPoint() public view virtual override returns (IEntryPoint) {
        return _entryPoint;
    }

    modifier onlyVerified(uint256[24] calldata proof) {
        require(commitmentModule.verify(proof), "Proof verification failed");
        _;
    }

    function _validateSignature(
        PackedUserOperation calldata userOp,
        bytes32 userOpHash
    ) internal override virtual returns (uint256 validationData) {
        if (commitmentModule.verify(commitmentModule.convertBytesToUint256Array(userOp.signature))) {
            return SIG_VALIDATION_SUCCESS;
        }

        userOpHash; // currently unused

        return SIG_VALIDATION_FAILED;
    }

    function initialize(IVerifier _verifier, uint256 _commitment) public virtual initializer {
        _initialize(_verifier, _commitment);   
    }

    // constructor(IVerifier _verifier, uint256 _commitment) {
    //     commitmentModule = new Commitment(_verifier, _commitment);
    // }

    function _initialize(IVerifier _verifier, uint256 _commitment) internal virtual {
        commitmentModule = new Commitment(_verifier, _commitment);
        emit MyAccountInitialized(_entryPoint, _commitment);
    }
}