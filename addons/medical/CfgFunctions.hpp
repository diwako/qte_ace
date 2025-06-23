class CfgFunctions {
    class ace_medical_treatment {
        tag = "ace_medical_treatment";
        class ace_medical_treatment {
            class treatment {
                file = QPATHTOF(functions\fnc_treatmentHijack.sqf);
            };
        };
    };
};
class ACE_Medical_StateMachine {
    class Unconscious {
        onState = QPATHTOF(functions\fnc_handleStateUnconsciousHijack.sqf);
    };
};
