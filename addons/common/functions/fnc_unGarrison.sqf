/*
 * Author: alganthe
 * Used to un-garrison units garrisoned with ace_common_fnc_garrison
 *
 * Arguments:
 * 0: Array of units to un-garrison <ARRAY>
 *
 * Return Value:
 * Nothing
 *
 * Public: Yes
 *
*/
#include "script_component.hpp"

params [["_unitsArray", [], [[]]]];

{
    if !(isPlayer _x) then {
        ["AUTOCOMBAT"] remoteExec ["enableAI", _x];
        ["PATH"] remoteExec ["enableAI", _x];
        if (leader _x != _x) then {
            doStop _x;
            [_x, (leader _x)] remoteExec ["doFollow", _x];
        } else {
            doStop _x;
            [_x, ((nearestBuilding (getPos _x)) buildingExit 0)] remoteExec ["doMove", _x];
        };
    };
} foreach _unitsArray;
