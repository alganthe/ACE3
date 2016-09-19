/*
 * Author: alganthe
 * Garrison function used to place / give a move waypoint, inside buildings to AI
 *
 * Arguments:
 * 0: The building(s) nearest this position are used <POSITION>
 * 1: Limit the building search to those type of building <ARRAY>
 * 2: Units that will be garrisoned <ARRAY>
 * 3: Radius to fill building(s) <SCALAR> default: 50
 * 4: 0: even filling, 1: building by building, 2: random filling <SCALAR> default: 0
 * 5: True to fill building(s) from top to bottom <BOOL> default: false

 * Return Value:
 * Array of units not garrisoned
 *
 * Public: Yes
 *
 * Example:
 * [position, nil, [unit1, unit2, unit3, unitN], 200, 1, false] call ace_common_fnc_garrison
*/
#include "script_component.hpp"

params [["_startingPos",[0,0,0], [[]], 3], ["_buildingTypes", ["Building"], [[]]], ["_unitsArray", [], [[]]], ["_fillingRadius", 50, [0]], ["_fillingType", 0, [0]], ["_topDownFilling", false, [true]]];

_unitsArray = _unitsArray select {alive _x && {!isPlayer _x}};

if (_startingPos isEqualTo [0,0,0]) exitWith {
    [CSTRING(GarrisonInvalidPosition)] call EFUNC(common,displayTextStructured);
};

if (count _unitsArray == 0 || {isNull (_unitsArray select 0)}) exitWith {
    [CSTRING(GarrisonNoUnits)] call EFUNC(common,displayTextStructured);
};

private _buildings = [];

if (_fillingRadius < 50) then {
    _buildings = nearestObjects [_startingPos, _buildingTypes, 50];
} else {
    _buildings = nearestObjects [_startingPos, _buildingTypes, _fillingRadius];
    _buildings = _buildings call BIS_fnc_arrayShuffle;
};

if (count _buildings == 0) exitWith {
    [CSTRING(GarrisonNoBuilding)] call EFUNC(common,displayTextStructured);
};

private _buildingsIndexes = [];

if (_topDownFilling) then {
    {
        private _buildingPos = _x buildingPos -1;

        // Those reverse are necessary, as dumb as it is there's no better way to sort those subarrays in sqf
        {
            reverse _x;
        } foreach _buildingPos;

        _buildingPos sort false;

        {
            reverse _x;
        } foreach _buildingPos;

        _buildingsIndexes pushback _buildingPos;
    } foreach _buildings;
} else {
    {
        _buildingsIndexes pushback (_x buildingPos -1);
    } foreach _buildings;
};

// Remove buildings without positions
{
    _buildingsIndexes deleteAt (_buildingsIndexes find _x);
} foreach (_buildingsIndexes select {count _x == 0});

// Warn the user that there's not enough positions to place all units
private _cnt = 0;
{_cnt = _cnt + count _x} foreach _buildingsIndexes;
private _leftOverAICount = (count _unitsArray) - _cnt;
if (_leftOverAICount > 0) then {
    [CSTRING(GarrisonNotEnoughPos)] call EFUNC(common,displayTextStructured);
};

[_fillingType, _unitsArray, _buildingsIndexes] call FUNC(garrisonPlacement)
