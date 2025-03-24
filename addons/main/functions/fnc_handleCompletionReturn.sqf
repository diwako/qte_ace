#include "..\script_component.hpp"
params ["_return", "_default"];
if (isNil "_return" || {!(_return isEqualType true)}) then {
    _return = _default;
};
if (_return) then {
    if (GVAR(soundsWin) isNotEqualTo (GVAR(availableSounds) select 0)) then {
        playSound [GVAR(soundsWin), true];
    }
} else {
    if (GVAR(soundsLose) isNotEqualTo (GVAR(availableSounds) select 0)) then {
        playSound [GVAR(soundsLose), true];
    };
};

_return
