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

            // Remove building if all the positions are used
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
                [_unit, "AUTOCOMBAT"] remoteExec ["disableAI", _unit];
                [_unit,"PATH"] remoteExec ["disableAI", _unit];
                _unit setPos _pos;
                _unitsArray deleteAt (_unitsArray find _unit);
                _building deleteAt 0;
                _buildingsIndexes deleteAt 0;
                _buildingsIndexes pushbackUnique _building;
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

            if (_building isEqualTo []) then {
                _buildingsIndexes deleteAt 0;
                breakTo "UnitScope";
            };

            private _pos = _building select 0;

            if (count (_pos nearEntities ["CAManBase", 1]) > 0) then {
                _buildingsIndexes set [0, _building - [_pos]];
                breakTo "UnitScope";

            } else {
                private _unit = _unitsArray select 0;
                [_unit, "AUTOCOMBAT"] remoteExec ["disableAI", _unit];
                [_unit,"PATH"] remoteExec ["disableAI", _unit];
                _unit setPos _pos;
                _unitsArray deleteAt (_unitsArray find _unit);
                _buildingsIndexes set [0, _building - [_pos]];
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

            if (_building isEqualTo []) then {
                _buildingsIndexes deleteAt (_buildingsIndexes find _building);
                breakTo "UnitScope";
            };

            private _pos = selectRandom _building;


            if (count (_pos nearEntities ["CAManBase", 1]) > 0) then {
                _buildingsIndexes set [(_buildingsIndexes find _building), _building - [_pos]];
                breakTo "UnitScope";

            } else {
                private _unit = _unitsArray select 0;
                [_unit, "AUTOCOMBAT"] remoteExec ["disableAI", _unit];
                [_unit,"PATH"] remoteExec ["disableAI", _unit];
                _unit setPos _pos;
                _unitsArray deleteAt (_unitsArray find _unit);
                _buildingsIndexes set [(_buildingsIndexes find _building), _building - [_pos]];
            };
        } else {
            breakOut "UnitScope";
        };
    };
};

/*
 * When all units are placed the function will break out of UnitScope
 * and thus will result in all of the subsequent calls to be ended; with _unitsArray
 * being sent back through all of it
 * Otherwise the function just get called again to handle the next unit
*/
[_fillingType, _unitsArray, _buildingsIndexes] call FUNC(garrisonPlacement);

_unitsArray
