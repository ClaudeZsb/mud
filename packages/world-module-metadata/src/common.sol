// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ResourceId, WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";
import { IWorldErrors } from "@latticexyz/world/src/IWorldErrors.sol";
import { ResourceAccess } from "@latticexyz/world/src/codegen/tables/ResourceAccess.sol";
import { NamespaceOwner } from "@latticexyz/world/src/codegen/tables/NamespaceOwner.sol";
import { ResourceIds } from "@latticexyz/store/src/codegen/tables/ResourceIds.sol";

using WorldResourceIdInstance for ResourceId;

// TODO: move these to world

/**
 * @notice Checks if the caller has access to the given resource ID or its namespace.
 * @param resourceId The resource ID to check access for.
 * @param caller The address of the caller.
 * @return true if the caller has access, false otherwise.
 */
function hasAccess(ResourceId resourceId, address caller) view returns (bool) {
  return
    // First check access based on the namespace. If caller has no namespace access, check access on the resource.
    ResourceAccess.get(resourceId.getNamespaceId(), caller) || ResourceAccess.get(resourceId, caller);
}

/**
 * @notice Check for access at the given namespace or resource.
 * @param resourceId The resource ID to check access for.
 * @param caller The address of the caller.
 * @dev Reverts with IWorldErrors.World_AccessDenied if access is denied.
 */
function requireAccess(ResourceId resourceId, address caller) view {
  // Check if the given caller has access to the given namespace or name
  if (!hasAccess(resourceId, caller)) {
    revert IWorldErrors.World_AccessDenied(resourceId.toString(), caller);
  }
}

/**
 * @notice Check for ownership of the namespace of the given resource ID.
 * @dev Reverts with IWorldErrors.World_AccessDenied if caller is not owner of the namespace of the resource.
 * @param resourceId The resource ID to check ownership for.
 * @param caller The address of the caller.
 */
function requireOwner(ResourceId resourceId, address caller) view {
  if (NamespaceOwner.get(resourceId.getNamespaceId()) != caller) {
    revert IWorldErrors.World_AccessDenied(resourceId.toString(), caller);
  }
}

/**
 * @notice Check for existence of the given resource ID.
 * @dev Reverts with IWorldErrors.World_ResourceNotFound if the resource does not exist.
 * @param resourceId The resource ID to check existence for.
 */
function requireExistence(ResourceId resourceId) view {
  if (!ResourceIds.getExists(resourceId)) {
    revert IWorldErrors.World_ResourceNotFound(resourceId, resourceId.toString());
  }
}
