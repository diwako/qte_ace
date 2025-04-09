#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

GVAR(escPressed) = false;
GVAR(resetCount) = 0;
GVAR(qteRunning) = false;
GVAR(qteQueue) = [];

private _soundsConfig = 'true' configClasses (configFile >> "CfgSounds") apply {configName _x};
private _soundsMission = 'true' configClasses (missionConfigFile >> "CfgSounds") apply {configName _x};
_soundsConfig = _soundsMission + _soundsConfig;
_soundsConfig = _soundsConfig arrayIntersect _soundsConfig;
_soundsConfig sort true;
GVAR(availableSounds) = [LSTRING(no_sound)] + _soundsConfig;

#include "initSettings.inc.sqf"

private _negativeList = (GVAR(bannedWords) splitString "[,""']") apply {toUpper trim _x};
GVAR(bannedWordsArr) = (_negativeList arrayIntersect _negativeList) - [""];

private _positiveList = (GVAR(addedWords) splitString "[,""']") apply {toUpper trim _x};
_positiveList = (_positiveList arrayIntersect _positiveList) - [""];
private _words = (call compileScript [QPATHTOF(words.inc.sqf)]) + _positiveList;
GVAR(words) = [_words] call FUNC(filterWordList);

ADDON = true;
