#include "..\script_component.hpp"
params ["_args", "_elapsedTime", "_resetCount"];
_args params [["_maxtime", 0], ["_tries", 0], ["_innerArgs", []], "", "", ["_progress", {true}]];

private _timer = uiNamespace getVariable [QGVAR(timer), controlNull];
if !(isNull _timer) then {
    private _time = [((uiNamespace getVariable QGVAR(timerEnd)) - time) max 0, "MM:SS.MS"] call BIS_fnc_secondsToString;
    // private _time = [((uiNamespace getVariable QGVAR(timerEnd)) - time) max 0, "SS.MS"] call BIS_fnc_secondsToString;
    _timer ctrlSetStructuredText parseText format ["<t size='1' shadow='1' valign='middle'>%1</t>", _time];
};

GVAR(escPressed) || {_maxtime > 0 && _elapsedTime > _maxtime} || {_tries > 0 && _resetCount >= _tries} || {!(_innerArgs call _progress)};
