#include "..\script_component.hpp"
params ["_args", "_qteSequence", "_qteHistory", "", "_incorrectInput"];
_args params ["", ["_tries", 0]];

private _display = uiNamespace getVariable [QGVAR(qteDisplay), displayNull];
if (isNull _display) exitWith {};

private _count = count _qteHistory;
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
    if (GVAR(soundsCorrect) isNotEqualTo (GVAR(availableSounds) select 0) && {_count > 0}) then {
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
    if (_forEachIndex >= _count) then {
        _x ctrlSetFade ([0, 0.5] select GVAR(pendingCharactersDim));
        if (_incorrectInput && _forEachIndex isEqualTo _count) then {
            private _ctrlColor = _x getVariable [QGVAR(originalColor), ctrlTextColor _x];
            _x setVariable [QGVAR(originalColor), _ctrlColor];
            _x ctrlSetTextColor _failColor;
            _x ctrlCommit 0;
            _x setVariable [QGVAR(failTime), time];
            [{
                params ["_ctrl", "_failColor", "_diff", "_startTime", "_endTime"];
                private _time = time;
                private _coef = linearConversion [_startTime, _endTime, _time, 0, 1, true];
                _ctrl ctrlSetTextColor (_failColor vectorAdd (_diff vectorMultiply _coef));
                _ctrl ctrlCommit 0;

                isNull _ctrl || {_endTime <= _time} || {(_ctrl getVariable QGVAR(failTime)) isNotEqualTo _startTime}
            }, {}, [_x, _failColor, _ctrlColor vectorDiff _failColor, time, time + 2]] call CBA_fnc_waitUntilAndExecute;
        } else {
            switch (_qteSequence select _forEachIndex) do {
                case "↑": { _x ctrlSetTextColor GVAR(arrowColorUp) };
                case "↓": { _x ctrlSetTextColor GVAR(arrowColorDown) };
                case "→": { _x ctrlSetTextColor GVAR(arrowColorRight) };
                case "←": { _x ctrlSetTextColor GVAR(arrowColorLeft) };
                default { _x ctrlSetTextColor [1, 1, 1, 1]};
            };
        };
        _x ctrlCommit 0;
    } else {
        _x ctrlSetFade ([0.5, 0] select GVAR(pendingCharactersDim));
        _x ctrlCommit 0.1;
    };
} forEach (_display getVariable QGVAR(ctrlArrows));
