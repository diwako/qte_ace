#include "..\script_component.hpp"
params ["_args"];
_args params ["", "", "", "", "_fail"];
private _return = [_this call _fail, false] call FUNC(handleCompletionReturn);
[_return] call FUNC(closeQTE);
GVAR(escPressed) = false;
