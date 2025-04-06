#include "..\script_component.hpp"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"
params [["_display", displayNull]];
_display displayAddEventHandler ["KeyDown", {
    params ["", "_key"];
    if (_key == DIK_ESCAPE && {alive player}) exitWith {
        GVAR(escPressed) = true;
    };

    switch (_key) do {
        // French keyboard support, for some reason their M is at the semicolon key
        // also means the german Ö is now an M, oh well...
        // if only it was possible to detect the keyboard layout
        case 39: { // DIK_SEMICOLON
            ["M"] call CBA_fnc_keyPressedQTE;
        };
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
        case DIK_UNDERLINE;
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
        case DIK_F1;
        case DIK_F2;
        case DIK_F3;
        case DIK_F4;
        case DIK_F5;
        case DIK_F6;
        case DIK_F7;
        case DIK_F8;
        case DIK_F9;
        case DIK_F10;
        case DIK_F11;
        case DIK_F12;
        case DIK_F13;
        case DIK_F14;
        case DIK_F15;
        case DIK_TAB;
        case DIK_NEXTTRACK;
        case DIK_MUTE;
        case DIK_CALCULATOR;
        case DIK_PLAYPAUSE;
        case DIK_MEDIASTOP;
        case DIK_VOLUMEDOWN;
        case DIK_VOLUMEUP;
        case DIK_WEBHOME;
        case DIK_SYSRQ;
        case DIK_PAUSE;
        case DIK_APPS;
        case DIK_POWER;
        case DIK_SLEEP;
        case DIK_WAKE;
        case DIK_WEBSEARCH;
        case DIK_WEBFAVORITES;
        case DIK_WEBREFRESH;
        case DIK_WEBSTOP;
        case DIK_WEBFORWARD;
        case DIK_WEBBACK;
        case DIK_MYCOMPUTER;
        case DIK_MAIL;
        case DIK_MEDIASELECT;
        case DIK_AT;
        case DIK_COLON;
        case DIK_MINUS;
        case DIK_EQUALS;
        case DIK_LBRACKET;
        case DIK_RBRACKET;
        case DIK_APOSTROPHE;
        case DIK_GRAVE;
        case DIK_BACKSLASH;
        case DIK_COMMA;
        case DIK_PERIOD;
        case DIK_SLASH;
        case DIK_MULTIPLY;
        case DIK_NUMPADSTAR;
        case DIK_SUBTRACT;
        case DIK_ADD;
        case DIK_DECIMAL;
        case DIK_NUMPADEQUALS;
        case DIK_LSHIFT;
        case DIK_RSHIFT;
        case DIK_ESCAPE;
        case DIK_BACK;
        case DIK_RETURN;
        case DIK_NUMPADENTER;
        case DIK_LMENU;
        case DIK_CAPITAL;
        case DIK_NUMLOCK;
        case DIK_SCROLL;
        case DIK_RMENU;
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
