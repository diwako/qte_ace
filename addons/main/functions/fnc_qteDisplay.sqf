#include "..\script_component.hpp"
params ["_args", "_qteSequence", "_qteHistory", "_resetCount", "_incorrectInput"];

private _display = uiNamespace getVariable [QGVAR(qteDisplay), displayNull];
if (isNull _display) exitWith {};

private _count = (count _qteHistory) - 1;
if (_incorrectInput) then {
    _count = count (_display getVariable [QGVAR(qteHistory), []]);
    private _box = _display getVariable QGVAR(ctrlBox);
    _box ctrlSetFade 0;
    _box ctrlCommit 0;
    _box ctrlSetFade 1;
    _box ctrlCommit 0.5;
};
_display setVariable [QGVAR(qteHistory), +_qteHistory];
private _failColor = [
    profileNamespace getVariable ['igui_error_RGB_R',0.77],
    profileNamespace getVariable ['igui_error_RGB_G',0.51],
    profileNamespace getVariable ['igui_error_RGB_B',0.08],
    profileNamespace getVariable ['igui_error_RGB_A',0.8]
];
{
    if (_forEachIndex isEqualTo _count) then {
        _x ctrlSetTextColor ([[1, 1, 1, 1], _failColor] select _incorrectInput);
        _x ctrlCommit 0;
    } else {
        _x ctrlSetTextColor ([[0.5, 0.5, 0.5, 1], [1, 1, 1, 1]] select (_forEachIndex < _count));
        _x ctrlCommit 0.1;
    };
} forEach (_display getVariable QGVAR(ctrlArrows));
