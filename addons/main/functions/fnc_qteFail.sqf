#include "..\script_component.hpp"
params ["_args", "_elapsedTime", "_resetCount"];
[false] call FUNC(closeQTE);
_args params ["", "", "", "", "_fail"];
_this call _fail;
GVAR(escPressed) = false;
