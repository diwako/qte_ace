#include "..\script_component.hpp"
params [
    ["_length", 5, [0, "", []]],
    ["_success", {}, [{}]],
    ["_fail", {}, [{}]],
    ["_progress", {true}, [{}]],
    ["_maxTime", 0, [0]],
    ["_tries", 0, [0]],
    ["_args", []],
    ["_text", "", [""]],
    ["_resetUponIncorrectInput", true, [false]],
    ["_aceExpections", []]
];
private _sequence = [];
switch (typeName _length) do {
    case "SCALAR": { _sequence = [_length] call FUNC(generateArrowSequence); };
    case "STRING": { _sequence = toUpper _length splitString "" };
    case "ARRAY": { _sequence = _length apply {toUpper _x} };
    default {};
};

if (_sequence isEqualTo []) exitWith {
    systemChat "Input resulted in an empty sequence";
    false
};

GVAR(resetCount) = 0;

private _argsDisplay = [_maxTime, _tries, _args, _success, _fail, _progress, _text, _aceExpections];

private _display = [_sequence, _maxTime, _tries, _text] call FUNC(createDisplay);
[_display] call FUNC(hijack);
[_argsDisplay, nil, [], nil, false] call FUNC(qteDisplay);
[
    _argsDisplay, // args
    // fail condition
    FUNC(qteProgress),
    // on display
    FUNC(qteDisplay),
    // on finish
    FUNC(qteWin),
    // on fail
    FUNC(qteFail),
    _sequence,
    _resetUponIncorrectInput
] call CBA_fnc_runQTE
