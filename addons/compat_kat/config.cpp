#include "script_component.hpp"
class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"qte_ace_medical", "kat_misc"};
        author = "diwako";
        url = "https://github.com/diwako/qte_ace";
        authorUrl = "https://github.com/diwako/qte_ace";
        skipWhenMissingDependencies = 1;
        VERSION_CONFIG;
    };
};

#include "CfgFunctions.hpp"
