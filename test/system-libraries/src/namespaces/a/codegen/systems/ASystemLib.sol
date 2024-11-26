// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { ASystem } from "../../ASystem.sol";
import { revertWithBytes } from "@latticexyz/world/src/revertWithBytes.sol";
import { IWorldCall } from "@latticexyz/world/src/IWorldKernel.sol";
import { SystemCall } from "@latticexyz/world/src/SystemCall.sol";
import { Systems } from "@latticexyz/world/src/codegen/tables/Systems.sol";
import { ResourceId } from "@latticexyz/store/src/ResourceId.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";

type ASystemType is bytes32;

// equivalent to WorldResourceIdLib.encode({ typeId: RESOURCE_SYSTEM, namespace: "a", name: "ASystem" }))
ASystemType constant aSystem = ASystemType.wrap(0x737961000000000000000000000000004153797374656d000000000000000000);

struct CallWrapper {
  ResourceId systemId;
  address from;
}

struct RootCallWrapper {
  ResourceId systemId;
  address from;
}

/**
 * @title ASystemLib
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This library is automatically generated from the corresponding system contract. Do not edit manually.
 */
library ASystemLib {
  error ASystemLib_CallingFromRootSystem();

  function setValue(ASystemType self, uint256 value) internal {
    return CallWrapper(self.toResourceId(), address(0)).setValue(value);
  }

  function getValue(ASystemType self) internal view returns (uint256) {
    return CallWrapper(self.toResourceId(), address(0)).getValue();
  }

  function getTwoValues(ASystemType self) internal view returns (uint256, uint256) {
    return CallWrapper(self.toResourceId(), address(0)).getTwoValues();
  }

  function setAddress(ASystemType self) internal returns (address) {
    return CallWrapper(self.toResourceId(), address(0)).setAddress();
  }

  function setValue(CallWrapper memory self, uint256 value) internal {
    // if the contract calling this function is a root system, it should use `callAsRoot`
    if (address(_world()) == address(this)) revert ASystemLib_CallingFromRootSystem();

    bytes memory systemCall = abi.encodeCall(ASystem.setValue, (value));
    self.from == address(0)
      ? _world().call(self.systemId, systemCall)
      : _world().callFrom(self.from, self.systemId, systemCall);
  }

  function getValue(CallWrapper memory self) internal view returns (uint256) {
    // if the contract calling this function is a root system, it should use `callAsRoot`
    if (address(_world()) == address(this)) revert ASystemLib_CallingFromRootSystem();

    bytes memory systemCall = abi.encodeCall(ASystem.getValue, ());
    bytes memory worldCall = self.from == address(0)
      ? abi.encodeCall(IWorldCall.call, (self.systemId, systemCall))
      : abi.encodeCall(IWorldCall.callFrom, (self.from, self.systemId, systemCall));
    (bool success, bytes memory returnData) = address(_world()).staticcall(worldCall);
    if (!success) revertWithBytes(returnData);

    bytes memory result = abi.decode(returnData, (bytes));
    return abi.decode(result, (uint256));
  }

  function getTwoValues(CallWrapper memory self) internal view returns (uint256, uint256) {
    // if the contract calling this function is a root system, it should use `callAsRoot`
    if (address(_world()) == address(this)) revert ASystemLib_CallingFromRootSystem();

    bytes memory systemCall = abi.encodeCall(ASystem.getTwoValues, ());
    bytes memory worldCall = self.from == address(0)
      ? abi.encodeCall(IWorldCall.call, (self.systemId, systemCall))
      : abi.encodeCall(IWorldCall.callFrom, (self.from, self.systemId, systemCall));
    (bool success, bytes memory returnData) = address(_world()).staticcall(worldCall);
    if (!success) revertWithBytes(returnData);

    bytes memory result = abi.decode(returnData, (bytes));
    return abi.decode(result, (uint256, uint256));
  }

  function setAddress(CallWrapper memory self) internal returns (address) {
    // if the contract calling this function is a root system, it should use `callAsRoot`
    if (address(_world()) == address(this)) revert ASystemLib_CallingFromRootSystem();

    bytes memory systemCall = abi.encodeCall(ASystem.setAddress, ());

    bytes memory result = self.from == address(0)
      ? _world().call(self.systemId, systemCall)
      : _world().callFrom(self.from, self.systemId, systemCall);
    return abi.decode(result, (address));
  }

  function setValue(RootCallWrapper memory self, uint256 value) internal {
    bytes memory systemCall = abi.encodeCall(ASystem.setValue, (value));
    SystemCall.callWithHooksOrRevert(self.from, self.systemId, systemCall, msg.value);
  }

  function getValue(RootCallWrapper memory self) internal view returns (uint256) {
    bytes memory systemCall = abi.encodeCall(ASystem.getValue, ());

    bytes memory result = SystemCall.staticcallOrRevert(self.from, self.systemId, systemCall);
    return abi.decode(result, (uint256));
  }

  function getTwoValues(RootCallWrapper memory self) internal view returns (uint256, uint256) {
    bytes memory systemCall = abi.encodeCall(ASystem.getTwoValues, ());

    bytes memory result = SystemCall.staticcallOrRevert(self.from, self.systemId, systemCall);
    return abi.decode(result, (uint256, uint256));
  }

  function setAddress(RootCallWrapper memory self) internal returns (address) {
    bytes memory systemCall = abi.encodeCall(ASystem.setAddress, ());

    bytes memory result = SystemCall.callWithHooksOrRevert(self.from, self.systemId, systemCall, msg.value);
    return abi.decode(result, (address));
  }

  function callFrom(ASystemType self, address from) internal pure returns (CallWrapper memory) {
    return CallWrapper(self.toResourceId(), from);
  }

  function callAsRoot(ASystemType self) internal view returns (RootCallWrapper memory) {
    return RootCallWrapper(self.toResourceId(), msg.sender);
  }

  function callAsRootFrom(ASystemType self, address from) internal pure returns (RootCallWrapper memory) {
    return RootCallWrapper(self.toResourceId(), from);
  }

  function toResourceId(ASystemType self) internal pure returns (ResourceId) {
    return ResourceId.wrap(ASystemType.unwrap(self));
  }

  function fromResourceId(ResourceId resourceId) internal pure returns (ASystemType) {
    return ASystemType.wrap(resourceId.unwrap());
  }

  function getAddress(ASystemType self) internal view returns (address) {
    return Systems.getSystem(self.toResourceId());
  }

  function _world() private view returns (IWorldCall) {
    return IWorldCall(StoreSwitch.getStoreAddress());
  }
}

using ASystemLib for ASystemType global;
using ASystemLib for CallWrapper global;
using ASystemLib for RootCallWrapper global;
