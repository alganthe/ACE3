/*
 * Author: alganthe
 * Function that actually takes care of the unit placement of fnc_garrison
 *
 * Arguments:
 * 0: The building(s) nearest this position are used <POSITION>
 * 1: Limit the building search to those type of building <ARRAY>
 * 2: Units that will be garrisoned <ARRAY>
 *
 * Return Value:
 * None
 *
 * Public: No
*/
#include "script_component.hpp"

params ["_fillingType", "_unitsArray", "_buildingsIndexes"];

scopeName "UnitScope";
switch (_fillingType) do {
    case 0: {
        if (count _unitsArray > 0) then {
            if (count _buildingsIndexes == 0) exitWith {
                _unitsArray breakOut "UnitScope";
            };

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
                diag_log "Unit placed";
            };
        } else {
            breakOut "UnitScope";
        };
    };

    case 1: {
        if (count _unitsArray > 0) then {
            if (count _buildingsIndexes == 0) exitWith {
                _unitsArray breakOut "UnitScope";
            };

            private _building = _buildingsIndexes select 0;

            // Remove building if all pos are used
            if (_building isEqualTo []) then {
                _buildingsIndexes deleteAt 0;
                breakTo "UnitScope";
            };

            private _pos = _building select 0;

            // Remove building if all pos are used
            if (count (_pos nearEntities ["CAManBase", 1]) > 0) then {
                _buildingsIndexes set [0, _building - [_pos]];
                breakTo "UnitScope";

            } else {
                private _unit = _unitsArray select 0;
                _unit disableAI "AUTOCOMBAT";
                _unit disableAI "PATH";
                _unit setPos _pos;
                _unitsArray deleteAt (_unitsArray find _unit);
                _buildingsIndexes set [0, _building - [_pos]];
                diag_log "Unit placed";
            };
        } else {
            breakOut "UnitScope";
        };
    };

    case 2: {
        if (count _unitsArray > 0) then {
            if (count _buildingsIndexes == 0) exitWith {
                _unitsArray breakOut "UnitScope";
            };

            private _building = selectRandom _buildingsIndexes;

            // Remove building if all pos are used
            if (_building isEqualTo []) then {
                _buildingsIndexes deleteAt (_buildingsIndexes find _building);
                breakTo "UnitScope";
            };

            private _pos = selectRandom _building;

            // Remove pos if unit nearby
            if (count (_pos nearEntities ["CAManBase", 1]) > 0) then {
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
        } else {
            breakOut "UnitScope";
        };
    };
};

[_fillingType, _unitsArray, _buildingsIndexes] call FUNC(garrisonPlacement);

// Return the unit array with the units that weren't able to be placed (or empty)
_unitsArray
