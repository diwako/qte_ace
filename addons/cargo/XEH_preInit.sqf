#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

#include "initSettings.inc.sqf"

private _moduleWords = call compileScript [QPATHTOF(words.inc.sqf)];
_moduleWords append _moduleWords;
_moduleWords append _moduleWords;
_moduleWords append _moduleWords;
private _words = (+EGVAR(main,words)) + _moduleWords;
GVAR(words) = [_words] call EFUNC(main,filterWordList);

ADDON = true;
