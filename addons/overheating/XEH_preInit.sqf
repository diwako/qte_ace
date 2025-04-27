#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

#include "initSettings.inc.sqf"

private _moduleWords = call compileScript [QPATHTOF(words.inc.sqf)];
_moduleWords = [_moduleWords] call EFUNC(main,filterWordList);
_moduleWords append _moduleWords;
_moduleWords append _moduleWords;
_moduleWords append _moduleWords;
_moduleWords append _moduleWords;
GVAR(words) = (+EGVAR(main,words)) + _moduleWords;

GVAR(clearJamLogicSuccess) = {
    params ["_unit", "_weapon", "_jammedWeapons"];
    _jammedWeapons = _jammedWeapons - [_weapon];
    _unit setVariable ["ace_overheating_jammedWeapons", _jammedWeapons];

    // If the round is a dud eject the round
    if (_unit getVariable [format ["ace_overheating_%1_jamType", _weapon], "None"] isEqualTo "Dud") then {
        private _ammo = _unit ammo _weapon;
        _unit setAmmo [_weapon, _ammo - 1];
    };

    _unit setVariable [format ["ace_overheating_%1_jamType", _weapon], "None"];

    if (_jammedWeapons isEqualTo []) then {
        private _id = _unit getVariable ["ace_overheating_JammingActionID", -1];
        [_unit, "DefaultAction", _id] call ace_common_fnc_removeActionEventHandler;
        _unit setVariable ["ace_overheating_JammingActionID", -1];
    };

    if (ace_overheating_DisplayTextOnJam) then {
        [localize "STR_ACE_Overheating_WeaponUnjammed"] call ace_common_fnc_displayTextStructured;
    };
};

ADDON = true;
