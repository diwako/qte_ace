class CfgFunctions {
    class ace_cargo {
        tag = "ace_cargo";
        class ace_cargo {
            class startUnload {
                file = QPATHTOF(functions\fnc_startUnloadHijack.sqf);
            };
            class startLoadIn {
                file = QPATHTOF(functions\fnc_startLoadInHijack.sqf);
            };
            class deployConfirm {
                file = QPATHTOF(functions\fnc_deployConfirmHijack.sqf);
            };
        };
    };
};
