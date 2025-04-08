#include "script_component.hpp"
class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_quicktime", "ace_main"};
        author = "diwako";
        url = "https://github.com/diwako/qte_ace";
        authorUrl = "https://github.com/diwako/qte_ace";
        license = "https://www.bohemia.net/community/licenses/arma-public-license-share-alike";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgWrapperUI.hpp"
#include "qteDisplay.hpp"
