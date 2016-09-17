/*
 * Author: alganthe
 * Module calling the garrison function
 *
 * Arguments:
 * 0: The module logic <OBJECT>
 * 1: Position of the module <POSITION>
 * 2: Radius of the task <NUMBER>
 * 3: Filling mode of the garrison function <NUMBER>
 * 4: Enable or not top down filling <BOOLEAN>
 *
 * Return Value:
 * None
*/

#include "script_component.hpp"

params ["_logic", "_pos", "_radius" ,"_mode" , "_topDownMode"];

private _unit = (attachedTo _logic);
private _building = nearestBuilding (getPosASL _unit);

// Handles errors
scopeName "Main";
private _fnc_errorAndClose = {
    params ["_msg"];
    deleteVehicle _logic;
    [_msg] call EFUNC(common,displayTextStructured);
    breakOut "Main";
};

switch (false) do {
    case !(isNull _unit): {
        [LSTRING(NothingSelected)] call _fnc_errorAndClose;
    };
    case (_unit isKindOf "CAManBase"): {
        [LSTRING(OnlyInfantry)] call _fnc_errorAndClose;
    };
    case (alive _unit): {
        [LSTRING(OnlyAlive)] call _fnc_errorAndClose;
    };
    case (_unit distance _building < 500): {
        [LSTRING(BuildingTooFar)] call _fnc_errorAndClose;
    };
};

private _units = units _unit;
// Make sure all units are disembarked.
{
    if (vehicle _x != _x) then {
        moveOut _x;
    };
} forEach _units;

[_pos, ["Building"], _units, _radius, _mode, _topDownMode] call EFUNC(common,garrison);

deleteVehicle _logic;
