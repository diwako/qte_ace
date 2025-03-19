#include "..\script_component.hpp"
params ["_args"];
[false] call FUNC(closeQTE);
if (GVAR(soundsLose) isNotEqualTo (GVAR(availableSounds) select 0)) then {
    playSound [GVAR(soundsLose), true];
};
_args params ["", "", "", "", "_fail"];
_this call _fail;
GVAR(escPressed) = false;
