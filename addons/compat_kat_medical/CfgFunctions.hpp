class CfgFunctions {
    class overwrite_medical_treatment {
        class ace_medical_treatment {
            delete treatment;
        };
    };
    class ace_medical_treatment {
        tag = "ace_medical_treatment";
        class ace_medical_treatment {
            class treatment {
                file = QPATHTOF(functions\fnc_treatmentHijack.sqf);
            };
        };
    };
};
