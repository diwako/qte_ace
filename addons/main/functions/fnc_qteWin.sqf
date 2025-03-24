#include "..\script_component.hpp"
params ["_args"];
_args params ["", "", "", "_success"];
private _return = [_this call _success, true] call FUNC(handleCompletionReturn);
[_return] call FUNC(closeQTE);
