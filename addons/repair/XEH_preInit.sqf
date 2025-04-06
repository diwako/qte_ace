#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

#include "initSettings.inc.sqf"

private _moduleWords = call compileScript [QPATHTOF(words.inc.sqf)];
_moduleWords = [_moduleWords] call EFUNC(main,filterWordList);
_moduleWords append _moduleWords;
_moduleWords append _moduleWords;
_moduleWords append _moduleWords;
GVAR(words) = (+EGVAR(main,words)) + _moduleWords;

GVAR(progressFncCache) = createHashMap;
GVAR(actionsWithProgress) = ["PatchWheel", "FullRepair"];

ADDON = true;
