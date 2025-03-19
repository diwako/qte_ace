#include "..\script_component.hpp"
params [["_isWin", false, [false]]];
private _display = uiNamespace getVariable [QGVAR(qteDisplay), displayNull];

private _box = _display getVariable QGVAR(ctrlGrp);
private _boxPos = ctrlPosition _box;
_box ctrlSetFade 1;
_boxPos set [1, 0.5];
_boxPos set [3, 0];
_box ctrlSetPosition _boxPos;
_box ctrlCommit 0.25;

private _col = [
    profileNamespace getVariable ['igui_error_RGB_R',0.77],
    profileNamespace getVariable ['igui_error_RGB_G',0.51],
    profileNamespace getVariable ['igui_error_RGB_B',0.08],
    profileNamespace getVariable ['igui_error_RGB_A',0.8]
];
if (_isWin) then {
    _col = [1, 1, 1, 1];
    private _background = _display getVariable QGVAR(ctrlBox);
    _background ctrlSetFade 1;
    _background ctrlSetBackgroundColor [0, 1, 0, 0.5];
    _background ctrlCommit 0;
    _background ctrlSetFade 0;
    _background ctrlCommit 0.1;
};

{
    _x ctrlSetTextColor _col;
    _x ctrlCommit 0;
} forEach (_display getVariable QGVAR(ctrlArrows));

private _text = _display getVariable [QGVAR(ctrlText), controlNull];
if !(isNull _text) then {
    _text ctrlSetFade 0;
    _text ctrlCommit 0;
    _text ctrlSetFade 1;
    _text ctrlCommit 0.1;
};

private _tries = _display getVariable [QGVAR(ctrlTries), controlNull];
if !(isNull _tries) then {
    _tries ctrlSetFade 0;
    _tries ctrlCommit 0;
    _tries ctrlSetFade 1;
    _tries ctrlCommit 0.1;
};

[{
    _this closeDisplay 0;
}, _display, 0.26] call CBA_fnc_waitAndExecute;
