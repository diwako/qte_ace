#include "..\script_component.hpp"
params ["_args", "_elapsedTime"];
_args params [["_maxtime", 0], ["_tries", 0], ["_innerArgs", []], "", "", ["_progress", {true}], "", ["_aceExpections", []]];

private _timer = uiNamespace getVariable [QGVAR(timer), controlNull];
if !(isNull _timer) then {
    private _time = [((uiNamespace getVariable QGVAR(timerEnd)) - time) max 0, "MM:SS.MS"] call BIS_fnc_secondsToString;
    _timer ctrlSetStructuredText parseText format ["<t size='1' shadow='1' valign='middle'>%1</t>", _time];
};
private _player = [] call CBA_fnc_currentUnit; // some progress functions need this variable defined at this scope level
GVAR(escPressed) ||
{!([_innerArgs, _elapsedTime, _maxtime, -1] call _progress)} ||
{_maxtime > 0 && _elapsedTime > _maxtime} ||
{_tries > 0 && GVAR(resetCount) >= _tries} ||
{!([_player, objNull, _aceExpections] call (missionNamespace getVariable ["ace_common_fnc_canInteractWith", {true}]))}
