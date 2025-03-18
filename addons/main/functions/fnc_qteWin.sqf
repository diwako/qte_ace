#include "..\script_component.hpp"
params ["_args", "_elapsedTime", "_resetCount"];
[true] call FUNC(closeQTE);
_args params ["", "", "", "_success"];
_this call _success;
