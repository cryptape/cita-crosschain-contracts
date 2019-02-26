pragma solidity ^0.4.24;

contract CrossChainChecker {

    // TODO Implement a native contract to check proof.
    address nativeChecker = 0xfFFfFfFffFFfFFFffFFffffFfFFfFfFfffff0001;

    function checkProof(bytes _proof, uint _dataSize) public returns (bytes data) {
        address checkerAddr = nativeChecker;
        // TODO Implement a native function to check proof.
        bytes4 checkerFunc = bytes4(keccak256("checkProof(bytes)"));
        // bytes length + bytes
        uint proofSize = 0x20 + _proof.length / 0x20 * 0x20;
        if (_proof.length % 0x20 != 0) {
            proofSize += 0x20;
        }
        // bytes position + bytes length + bytes
        uint outSize = 0x20 + 0x20 + _dataSize / 0x20 * 0x20;
        if (_dataSize % 0x20 != 0) {
            outSize += 0x20;
        }
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, checkerFunc)
            mstore(add(ptr, 0x04), 0x20)
            // Copy whole proof bytes.
            let ptrL := add(ptr, 0x24)
            for {
                    let proofL := _proof
                    let proofR := add(_proof, proofSize)
                }
                lt(proofL, proofR)
                {
                    proofL := add(proofL, 0x20)
                    ptrL := add(ptrL, 0x20)
                }
                {
                mstore(ptrL, mload(proofL))
            }
            let inSize := sub(ptrL, ptr)
            switch call(100000, checkerAddr, 0, ptr, inSize, ptr, outSize)
            case 0 { revert(0, 0) }
            default {
                data := add(ptr, 0x20)
            }
        }
    }
}
