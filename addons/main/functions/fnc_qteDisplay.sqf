#include "..\script_component.hpp"
params ["_args", "", "_qteHistory", "", "_incorrectInput"];
_args params ["", ["_tries", 0]];

private _display = uiNamespace getVariable [QGVAR(qteDisplay), displayNull];
if (isNull _display) exitWith {};

private _count = (count _qteHistory) - 1;
if (_incorrectInput) then {
    GVAR(resetCount) = GVAR(resetCount) + 1;
    _count = count (_display getVariable [QGVAR(qteHistory), []]);
    private _box = _display getVariable QGVAR(ctrlBox);
    _box ctrlSetFade 0;
    _box ctrlCommit 0;
    _box ctrlSetFade 1;
    _box ctrlCommit 0.5;
    if (GVAR(soundsWrong) isNotEqualTo (GVAR(availableSounds) select 0)) then {
        playSound [GVAR(soundsWrong), true];
    };
} else {
    if (GVAR(soundsCorrect) isNotEqualTo (GVAR(availableSounds) select 0) && {_count >= 0}) then {
        playSound [GVAR(soundsCorrect), true];
    };
};
private _failColor = [
    profileNamespace getVariable ['igui_error_RGB_R',0.77],
    profileNamespace getVariable ['igui_error_RGB_G',0.51],
    profileNamespace getVariable ['igui_error_RGB_B',0.08],
    profileNamespace getVariable ['igui_error_RGB_A',0.8]
];
if (_tries > 0) then {
    private _remaining = (_tries - GVAR(resetCount)) max 0;
    private _ctrl = _display getVariable QGVAR(ctrlTries);
    _ctrl ctrlSetStructuredText parseText format ["<t size='1' shadow='1' valign='middle' align='right'>%1/%2</t>", _remaining, _tries];
    if (_remaining isEqualTo 1) then {
        _ctrl ctrlSetTextColor _failColor;
        if (_incorrectInput && {GVAR(soundsLastTry) isNotEqualTo (GVAR(availableSounds) select 0)}) then {
            playSound [GVAR(soundsLastTry), true];
        };
    };
};
_display setVariable [QGVAR(qteHistory), +_qteHistory];
{
    if (_forEachIndex isEqualTo _count) then {
        _x ctrlSetTextColor ([[1, 1, 1, 1], _failColor] select _incorrectInput);
        _x ctrlCommit 0;
    } else {
        _x ctrlSetTextColor ([[0.5, 0.5, 0.5, 1], [1, 1, 1, 1]] select (_forEachIndex < _count));
        _x ctrlCommit 0.1;
    };
} forEach (_display getVariable QGVAR(ctrlArrows));
