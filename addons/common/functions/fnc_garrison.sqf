/*
 * Author: alganthe
 * Garrison function used to place / give a move waypoint, inside buildings to AI
 *
 * Arguments:
 * 0: The building(s) nearest this position are used <POSITION>
 * 1: Limit the building search to those type of building <ARRAY>
 * 2: Units that will be garrisoned <ARRAY>
 * 3: Radius to fill building(s) -1 for nearest only <SCALAR> default: -1
 * 4: 0: even filling, 1: building by building, 2: random filling <SCALAR> default: 0
 * 5: True to fill building(s) from top to bottom <BOOL> default: false

 * Return Value:
 * Array of units not garrisoned
 *
 * Example:
 * [position, nil, [unit1, unit2, unit3, unitN], 200, 1, false] call ace_common_fnc_garrison
*/
#include "script_component.hpp"


params ["_startingPos", ["_buildingTypes", ["Building"]], "_unitsArray", ["_fillingRadius", -1], ["_fillingType", 0], ["_topDownFilling", false]];

if (_startingPos isEqualTo [0,0,0]) exitWith {
    ["Invalid position given."] call EFUNC(common,displayTextStructured);
};

if (count _unitsArray == 0 || {isNull (_unitsArray select 0)}) exitWith {
    ["No units provided."] call EFUNC(common,displayTextStructured);
};

private _buildings = [];

if (_fillingRadius == -1) then {
    _buildings = nearestObjects [_startingPos, _buildingTypes, 50];
} else {
    _buildings = nearestObjects [_startingPos, _buildingTypes, _fillingRadius];
    _buildings = _buildings call BIS_fnc_arrayShuffle;
};

if (count _buildings == 0) exitWith {
    ["No building found."] call EFUNC(common,displayTextStructured);
};

private _buildingsIndexes = [];

if (_topDownFilling) then {
    {
        private _buildingPos = _x buildingPos -1;

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

// Remove buildings without pos
{
    _buildingsIndexes deleteAt (_buildingsIndexes find _x);
} foreach (_buildingsIndexes select {count _x == 0});

private _cnt = 0;
{_cnt = _cnt + count _x} foreach _buildingsIndexes;
private _leftOverAICount = (count _unitsArray) - _cnt;
if (_leftOverAICount > 0) then {
    ["there weren't enough spots to place all units"] call EFUNC(common,displayTextStructured);
};

switch (_fillingType) do {
    case 0: {
        while {count _unitsArray > 0} do {
            scopeName "UnitScope";
            if (count _buildingsIndexes == 0) exitWith {breakOut "UnitScope"};

            private _building = _buildingsIndexes select 0;

            // Remove building if all pos are used
            if (_building isEqualTo []) then {
                _buildingsIndexes deleteAt 0;
                breakTo "UnitScope";
            };

            private _pos = _building select 0;

            if ( count (_pos nearEntities ["CAManBase", 1]) > 0) then {
                _buildingsIndexes set [0,  _building - [_pos]];
                breakTo "UnitScope";

            } else {
                private _unit = _unitsArray select 0;
                _unit disableAI "AUTOCOMBAT";
                _unit disableAI "PATH";
                _unit setPos _pos;
                _unitsArray deleteAt (_unitsArray find _unit);
                _building deleteAt 0;
                _buildingsIndexes deleteAt 0;
                _buildingsIndexes pushbackUnique _building;
            };
        };
    };

    case 1: {
        while {count _unitsArray > 0} do {
            scopeName "UnitScope";
            if (count _buildingsIndexes == 0) exitWith {breakOut "UnitScope"};

            private _building = _buildingsIndexes select 0;

            // Remove building if all pos are used
            if (_building isEqualTo []) then {
                _buildingsIndexes deleteAt 0;
                breakTo "UnitScope";
            };

            private _pos = _building select 0;

            // Remove building if all pos are used
            if ( count (_pos nearEntities ["CAManBase", 1]) > 0) then {
                _buildingsIndexes set [0, _building - [_pos]];
                breakTo "UnitScope";

            } else {
                private _unit = _unitsArray select 0;
                _unit disableAI "AUTOCOMBAT";
                _unit disableAI "PATH";
                _unit setPos _pos;
                _unitsArray deleteAt (_unitsArray find _unit);
                _buildingsIndexes set [0, _building - [_pos]];
            };
        };
    };

    case 2: {
        while {count _unitsArray > 0} do {
            scopeName "UnitScope";
            if (count _buildingsIndexes == 0) exitWith {breakOut "UnitScope"};

            private _building = selectRandom _buildingsIndexes;

            // Remove building if all pos are used
            if (_building isEqualTo []) then {
                _buildingsIndexes deleteAt (_buildingsIndexes find _building);
                breakTo "UnitScope";
            };

            private _pos = selectRandom _building;

            // Remove pos if unit nearby
            if ( count (_pos nearEntities ["CAManBase", 1]) > 0) then {
                _buildingsIndexes set [(_buildingsIndexes find _building), _building - [_pos]];
                breakTo "UnitScope";

            } else {
                private _unit = _unitsArray select 0;
                _unit disableAI "AUTOCOMBAT";
                _unit disableAI "PATH";
                _unit setPos _pos;
                _unitsArray deleteAt (_unitsArray find _unit);
                _buildingsIndexes set [(_buildingsIndexes find _building), _building - [_pos]];
            };
        };
    };
};

_unitsArray
