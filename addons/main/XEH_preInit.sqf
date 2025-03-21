#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

GVAR(escPressed) = false;
GVAR(resetCount) = 0;

private _soundsConfig = 'true' configClasses (configFile >> "CfgSounds") apply {configName _x};
private _soundsMission = 'true' configClasses (missionConfigFile >> "CfgSounds") apply {configName _x};
_soundsConfig = _soundsMission + _soundsConfig;
_soundsConfig = _soundsConfig arrayIntersect _soundsConfig;
_soundsConfig sort true;
GVAR(availableSounds) = [LSTRING(no_sound)] + _soundsConfig;

#include "initSettings.inc.sqf"

GVAR(words) = call compileScript [QPATHTOF(words.inc.sqf)];

ADDON = true;
