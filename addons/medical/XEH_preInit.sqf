#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

#include "initSettings.inc.sqf"

GVAR(words) = call compile preprocessFileLineNumbers "\z\qte_ace\addons\main\words.inc.sqf";
GVAR(surgicalKits) = ["SurgicalKit"];

ADDON = true;
