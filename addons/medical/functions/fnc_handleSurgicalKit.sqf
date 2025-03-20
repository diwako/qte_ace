params ["_args", "_maxtime"];
_args params ["", "", "", "_classname"];

if !(_className in GVAR(surgicalKits)) exitWith {};
private _function = getText (configFile >> "ace_medical_treatment_actions" >> _classname >> "callbackProgress");
if (missionNamespace isNil _function) then {
    _function = compile _function;
} else {
    _function = missionNamespace getVariable _function;
};
if (_function isEqualTo {}) then {
    _function = {true};
};
diw_debug = _function;
while {[_args, _maxtime+1, _maxtime] call _function} do {
    // uhuh, i hope this aint thaat bad huh?
};

nil
