class CfgFunctions {
    class ace_rearm {
        tag = "ace_rearm";
        class ace_rearm {
            class grabAmmo {
                file = QPATHTOF(functions\fnc_grabAmmoHijack.sqf);
            };
            class rearm {
                file = QPATHTOF(functions\fnc_rearmHijack.sqf);
            };
            class rearmEntireVehicle {
                file = QPATHTOF(functions\fnc_rearmEntireVehicleHijack.sqf);
            };
            class storeAmmo {
                file = QPATHTOF(functions\fnc_storeAmmoHijack.sqf);
            };
            class takeAmmo {
                file = QPATHTOF(functions\fnc_takeAmmoHijack.sqf);
            };
        };
    };
};
