#include "script_component.hpp"
#include "..\defines.hpp"

params ["_display", "_control"];

if !(ctrlEnabled _control) exitWith {};

private _contentPanelCtrl = _display displayCtrl IDC_contentPanel;
private _contentPanelCursSel = lnbCurSelRow _contentPanelCtrl;
private _loadoutName = _contentPanelCtrl lnbText [_contentPanelCursSel, 1];
private _profileName = profileName; // GVAR(center) could be a remote unit
private _loadoutVar = _profileName + _loadoutName;

private _loadoutIndex = GVAR(sharedLoadoutsVars) find _loadoutVar;
private _loadoutData = _contentPanelCtrl getVariable _loadoutName;

if (_loadoutIndex > -1) then {
    GVAR(sharedLoadoutsNamespace) setVariable [_loadoutVar, nil, true];
    GVAR(sharedLoadoutsVars) = GVAR(sharedLoadoutsVars) - [_loadoutVar];

    _contentPanelCtrl lnbSetText [[_contentPanelCursSel, 0], ""];

} else {
    GVAR(sharedLoadoutsNamespace) setVariable [_loadoutVar, [_profileName ,_loadoutName , _loadoutData], true];
    GVAR(sharedLoadoutsVars) pushBackUnique _loadoutVar;

    _contentPanelCtrl lnbSetText [[_contentPanelCursSel, 0], "X"];
};

publicVariable QGVAR(sharedLoadoutsVars);
