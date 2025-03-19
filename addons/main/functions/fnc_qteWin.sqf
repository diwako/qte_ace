#include "..\script_component.hpp"
params ["_args"];
if (GVAR(soundsWin) isNotEqualTo (GVAR(availableSounds) select 0)) then {
    playSound [GVAR(soundsWin), true];
};
[true] call FUNC(closeQTE);
_args params ["", "", "", "_success"];
_this call _success;
