#include "..\script_component.hpp"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"
params [["_display", displayNull]];
_display displayAddEventHandler ["KeyDown", {
    params ["", "_key"];
    if (_key == DIK_ESCAPE && {alive player}) exitWith {
        GVAR(escPressed) = true;
    };

    switch (_key) do {
        case DIK_UPARROW: {
            ["↑"] call CBA_fnc_keyPressedQTE;
        };
        case DIK_DOWNARROW: {
            ["↓"] call CBA_fnc_keyPressedQTE;
        };
        case DIK_RIGHTARROW: {
            ["→"] call CBA_fnc_keyPressedQTE;
        };
        case DIK_LEFTARROW: {
            ["←"] call CBA_fnc_keyPressedQTE;
        };
        case DIK_SPACE: {
            [" "] call CBA_fnc_keyPressedQTE;
        };
        case DIK_NUMPAD0;
        case DIK_NUMPAD1;
        case DIK_NUMPAD2;
        case DIK_NUMPAD3;
        case DIK_NUMPAD4;
        case DIK_NUMPAD5;
        case DIK_NUMPAD6;
        case DIK_NUMPAD7;
        case DIK_NUMPAD8;
        case DIK_NUMPAD9: {
            private _translated = (([_key] call CBA_fnc_localizeKey) splitString " ") select 0;
            [_translated] call CBA_fnc_keyPressedQTE
        };
        case DIK_BACKSPACE;
        case DIK_CAPSLOCK;
        case DIK_LCONTROL;
        case DIK_RCONTROL;
        case DIK_LALT;
        case DIK_RALT;
        case DIK_PGUP;
        case DIK_PGDN;
        case DIK_LWIN;
        case DIK_RWIN: {
            // hey do nothing :)
        };
        default {
            private _qteSequence = cba_quicktime_QTEArgs get "qteSequence";
            private _curSeq = _qteSequence select (count cba_quicktime_QTEHistory);
            private _translated = [_key] call CBA_fnc_localizeKey;

            if (_curSeq in "↑↓→←") then {
                switch (_translated) do {
                    case "A": { ["←"] call CBA_fnc_keyPressedQTE };
                    case "S": { ["↓"] call CBA_fnc_keyPressedQTE };
                    case "D": { ["→"] call CBA_fnc_keyPressedQTE };
                    case "W": { ["↑"] call CBA_fnc_keyPressedQTE };
                    default { [_translated] call CBA_fnc_keyPressedQTE };
                };
            } else {
                [_translated] call CBA_fnc_keyPressedQTE;
            };
        };
    };
    _key > 0
}];
