#include "..\script_component.hpp"
params [["_qteSequence", []], ["_maxTime", 0], ["_tries", 0], ["_text", ""], ["_countdown", true]];

// close any other dialog
closeDialog 0;
// close inventory
private _inventoryDisplay = uiNamespace getVariable ["RscDisplayInventory", displayNull];
if !(isNull _inventoryDisplay) then {
    _inventoryDisplay closeDisplay 0;
};

// check for dynamic groups framework
if (!isNil QDYN_GROUP_KEY_VAR && isNil QGVAR(dynGroupKeys)) then {
    private _missionDisplay = findDisplay 46;
    if !(isNull _missionDisplay) then {
        // Reset event handlers
        DYN_GROUP_KEY_VAR params ["_down", "_up"];
        _missionDisplay displayRemoveEventHandler ["KeyDown", _down];
        _missionDisplay displayRemoveEventHandler ["KeyUp", _up];
        _down = _missionDisplay displayAddEventHandler ["KeyDown", format ["if !(%1) then {['OnKeyDown', _this] call BIS_fnc_dynamicGroups;}", QGVAR(qteRunning)]];
        _up = _missionDisplay displayAddEventHandler ["KeyUp", format ["if !(%1) then {['OnKeyUp', _this] call BIS_fnc_dynamicGroups;}", QGVAR(qteRunning)]];
        GVAR(dynGroupKeys) = [_down, _up];
        DYN_GROUP_KEY_VAR = GVAR(dynGroupKeys);
    };
};

// create dialog from config instead of hooking into the mission display
// this prevents modded a3 keybinds from passing through during the hijack
createDialog QGVAR(qteDisplay);
private _display = uiNamespace getVariable QGVAR(qteDisplay);

private _background = _display ctrlCreate ["CtrlMapEmpty", -1];
_background ctrlSetPosition [safeZoneX, safeZoneY, safeZoneW, safeZoneH];
_background ctrlSetFade 1;
_background ctrlMapCursor ["", QGVAR(hidden)];
_background ctrlCommit 0;

private _length = count _qteSequence;
private _gridHeight = pixelH * pixelGrid;

private _arrowWidth = 4 * pixelW * pixelGrid;
private _arrowHeight = 4 * _gridHeight;

private _maxWidth = safeZoneW - 2 * _arrowWidth;

private _charWidth = 2 * _arrowWidth;
private _charHeight = 2 * _arrowHeight;
private _boxWidth = _arrowWidth * _length + 2 * _arrowWidth; // count + 2
private _boxHeight = 7 * _gridHeight;  // always 7

private _rows = ceil (_boxWidth / (_maxWidth - (2 * _arrowWidth)));
private _maxArrowsPerRow = ceil (_length / _rows);
if (_rows > 1) then {
    _boxWidth = _maxArrowsPerRow * _arrowWidth + 2 * _arrowWidth;
    _boxHeight = _boxHeight * _rows;
};
private _startingBoxPosY = 0.5;
private _endingBoxPosY = 0.5 - _boxHeight / 2;
switch (GVAR(qtePosition)) do {
    case 1: {
        _startingBoxPosY = safeZoneH + safeZoneY - _gridHeight * 8;
        _endingBoxPosY = safeZoneH + safeZoneY - (_gridHeight * 8 + _boxHeight / 2);
    };
    case 2: {
        _startingBoxPosY = safeZoneY + _gridHeight * 5 + _boxHeight / 2;
        _endingBoxPosY = safeZoneY + _gridHeight * 5;
    };
    default { };
};
_display setVariable [QGVAR(startingBoxPosY), _startingBoxPosY];

private _ctrlGrp = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1];
_display setVariable [QGVAR(ctrlGrp), _ctrlGrp];
_ctrlGrp ctrlSetPosition [0.5 - (_boxWidth / 2), _startingBoxPosY, _boxWidth, 0];
_ctrlGrp ctrlCommit 0;
_ctrlGrp ctrlSetPosition [0.5 - (_boxWidth / 2), _endingBoxPosY, _boxWidth, _boxHeight + _arrowHeight];
_ctrlGrp ctrlCommit 0.25;

private _ctrlBox = _display ctrlCreate ["RscBackground", -1, _ctrlGrp];
// _ctrlBox ctrlSetBackgroundColor [
//     profileNamespace getVariable ['igui_bcg_RGB_R', 0],
//     profileNamespace getVariable ['igui_bcg_RGB_G', 0],
//     profileNamespace getVariable ['igui_bcg_RGB_B', 0],
//     profileNamespace getVariable ['igui_bcg_RGB_A', 0.75]
// ];
_ctrlBox ctrlSetBackgroundColor [0, 0, 0, 0.75];
_ctrlBox ctrlSetPosition [0, 0, safeZoneW, 5 * _gridHeight * _rows + _gridHeight];
_ctrlBox ctrlCommit 0;

private _nuhUhBox = _display ctrlCreate ["RscBackground", -1, _ctrlGrp];
_display setVariable [QGVAR(ctrlBox), _nuhUhBox];
_nuhUhBox ctrlSetBackgroundColor [
    profileNamespace getVariable ['igui_error_RGB_R', 1],
    profileNamespace getVariable ['igui_error_RGB_G', 0.1],
    profileNamespace getVariable ['igui_error_RGB_B', 0.1],
    profileNamespace getVariable ['igui_error_RGB_A', 1]
];
_nuhUhBox ctrlSetPosition [0, 0, safeZoneW, 5 * _gridHeight * _rows + _gridHeight];
_nuhUhBox ctrlSetFade 1;
_nuhUhBox ctrlCommit 0;

if (_text isNotEqualTo "") then {
    private _ctrl = _display ctrlCreate ["RscStructuredText", -1];
    _display setVariable [QGVAR(ctrlText), _ctrl];
    _ctrl ctrlSetStructuredText parseText format ["<t size='1' shadow='1' valign='middle'>%1</t>", _text];
    _ctrl ctrlSetPosition [0.5 - (_boxWidth / 2), _endingBoxPosY - _gridHeight * 3, _boxWidth, _gridHeight * 3];
    _ctrl ctrlSetBackgroundColor [
        profileNamespace getVariable ['GUI_BCG_RGB_R', 0],
        profileNamespace getVariable ['GUI_BCG_RGB_G', 0],
        profileNamespace getVariable ['GUI_BCG_RGB_B', 0],
        profileNamespace getVariable ['GUI_BCG_RGB_A', 0.75]
    ];
    _ctrl ctrlSetTextColor [1, 1, 1, 1];
    _ctrl ctrlSetFade 1;
    _ctrl ctrlCommit 0;
    _ctrl ctrlSetFade 0;
    _ctrl ctrlCommit 0.25;
};

if (_tries > 0) then {
    private _ctrl = _display ctrlCreate ["RscStructuredText", -1];
    _display setVariable [QGVAR(ctrlTries), _ctrl];
    _ctrl ctrlSetStructuredText parseText format ["<t size='1' shadow='1' valign='middle' align='right'>%1/%1</t>", _tries];
    _ctrl ctrlSetPosition [0.5 - (_boxWidth / 2), _endingBoxPosY - _gridHeight * 3, _boxWidth, _gridHeight * 3];
    _ctrl ctrlSetTextColor [1, 1, 1, 1];
    _ctrl ctrlSetFade 1;
    _ctrl ctrlCommit 0;
    _ctrl ctrlSetFade 0;
    _ctrl ctrlCommit 0.25;
};

private _arrowY = _gridHeight;
private _minBoxX = _arrowWidth / 2;
private _maxBoxX = (_maxArrowsPerRow + 1) * _arrowWidth - _minBoxX;
private _arrowRowNum = 0;
private _walker = 0;

private _arrows = [];
private _isArrowStyle = "arrows" in GVAR(arrowStyle);
private _isArrowCharStyle = "arrowsCharacters" isEqualTo GVAR(arrowStyle);
for "_i" from 1 to _length do {
    _walker = _walker + 1;
    if (_i>1 && ((_i-1) mod _maxArrowsPerRow) == 0) then {
        _arrowRowNum = _arrowRowNum + 1;
        _walker = 1;
    };
    private _xPos = linearConversion [1, _maxArrowsPerRow, _walker, _minBoxX, _maxBoxX];
    private _ctrl = controlNull;
    private _curSeq = _qteSequence select (_i - 1);
    if (_curSeq in "↑↓→←") then {
        if (_isArrowStyle) then {
            _ctrl = _display ctrlCreate ["RscPicture", -1, _ctrlGrp];
            _ctrl ctrlSetPosition [_xPos, _arrowY + (_arrowRowNum * (_arrowHeight + _arrowY)), _arrowWidth, _arrowHeight];
            if (_isArrowCharStyle) then {
                switch (_curSeq) do {
                    case "↑": { _ctrl ctrlSetText QPATHTOF(ui\arrows\up_char.paa)  };
                    case "↓": { _ctrl ctrlSetText QPATHTOF(ui\arrows\down_char.paa) };
                    case "→": { _ctrl ctrlSetText QPATHTOF(ui\arrows\right_char.paa) };
                    case "←": { _ctrl ctrlSetText QPATHTOF(ui\arrows\left_char.paa)  };
                    default {};
                };
            } else {
                switch (_curSeq) do {
                    case "↑": { _ctrl ctrlSetText QPATHTOF(ui\arrows\up.paa)  };
                    case "↓": { _ctrl ctrlSetText QPATHTOF(ui\arrows\down.paa) };
                    case "→": { _ctrl ctrlSetText QPATHTOF(ui\arrows\right.paa) };
                    case "←": { _ctrl ctrlSetText QPATHTOF(ui\arrows\left.paa)  };
                    default {};
                };
            };
        } else {
            _ctrl = _display ctrlCreate ["RscStructuredText", -1, _ctrlGrp];
            _ctrl ctrlSetPosition [_xPos, _arrowY + (_arrowRowNum * (_arrowHeight + _arrowY)), _charWidth, _charHeight];
            switch (_curSeq) do {
                case "↑": { _ctrl ctrlSetStructuredText parseText "<t size='1.8' font='PuristaBold'>W</t>" };
                case "↓": { _ctrl ctrlSetStructuredText parseText "<t size='1.8' font='PuristaBold'>S</t>" };
                case "→": { _ctrl ctrlSetStructuredText parseText "<t size='1.8' font='PuristaBold'>D</t>" };
                case "←": { _ctrl ctrlSetStructuredText parseText "<t size='1.8' font='PuristaBold'>A</t>" };
                default {};
            };
        };
    } else {
        _ctrl = _display ctrlCreate ["RscStructuredText", -1, _ctrlGrp];
        switch (_curSeq) do {
            case " ": { _ctrl ctrlSetStructuredText parseText "<t size='1.8' font='PuristaBold'>_</t>" };
            default   { _ctrl ctrlSetStructuredText parseText format ["<t size='1.8' font='PuristaBold'>%1</t>", _curSeq] };
        };
        _ctrl ctrlSetPosition [_xPos, _arrowY + (_arrowRowNum * (_arrowHeight + _arrowY)), _charWidth, _charHeight];
    };
    _ctrl ctrlSetTextColor [0.5, 0.5, 0.5, 1];
    _ctrl ctrlCommit 0;
    _arrows pushBack _ctrl;
};
_display setVariable [QGVAR(ctrlArrows), _arrows];

if (_maxtime > 0) then {
    private _waitBarWhite = _display ctrlCreate ["RscStructuredText", -1, _ctrlGrp];
    private _waitBarCountDown = _display ctrlCreate ["RscStructuredText", -1, _ctrlGrp];

    if (_countdown) then {
        _waitBarWhite ctrlSetBackgroundColor [
            profileNamespace getVariable ['GUI_BCG_RGB_R',0.77],
            profileNamespace getVariable ['GUI_BCG_RGB_G',0.51],
            profileNamespace getVariable ['GUI_BCG_RGB_B',0.08],
            profileNamespace getVariable ['GUI_BCG_RGB_A',0.8]
        ];
        _waitBarWhite ctrlSetPosition [0, 5 * _gridHeight * _rows + _gridHeight, _boxWidth, _gridHeight];
        _waitBarWhite ctrlCommit 0;
        _waitBarWhite ctrlSetPosition [0, 5 * _gridHeight * _rows + _gridHeight, 0, _gridHeight];

        _waitBarCountDown ctrlSetBackgroundColor [
            profileNamespace getVariable ['igui_error_RGB_R',0.77],
            profileNamespace getVariable ['igui_error_RGB_G',0.51],
            profileNamespace getVariable ['igui_error_RGB_B',0.08],
            profileNamespace getVariable ['igui_error_RGB_A',0.8]
        ];
        _waitBarCountDown ctrlSetPosition [0, 5 * _gridHeight * _rows + _gridHeight, _boxWidth, _gridHeight];
        _waitBarCountDown ctrlSetFade 1;
        _waitBarCountDown ctrlCommit 0;
        _waitBarCountDown ctrlSetPosition [0, 5 * _gridHeight * _rows + _gridHeight, 0, _gridHeight];
    } else {
        _waitBarWhite ctrlSetPosition [0, 5 * _gridHeight * _rows + _gridHeight, _boxWidth, _gridHeight];
        _waitBarWhite ctrlSetBackgroundColor [0, 0, 0, 0.75];
        _waitBarWhite ctrlCommit 0;

        _waitBarCountDown ctrlSetBackgroundColor [0, 1, 0, 0.5];
        _waitBarCountDown ctrlSetPosition [0, 5 * _gridHeight * _rows + _gridHeight, 0, _gridHeight];
        _waitBarCountDown ctrlCommit 0;
        _waitBarCountDown ctrlSetPosition [0, 5 * _gridHeight * _rows + _gridHeight, _boxWidth, _gridHeight];
    };
    _waitBarCountDown ctrlSetFade 0;
    _waitBarWhite ctrlCommit _maxtime;
    _waitBarCountDown ctrlCommit _maxtime;

    private _ctrlWait = _display ctrlCreate ["RscStructuredText", -1, _ctrlGrp];
    _ctrlWait ctrlSetPosition [0, 5 * _gridHeight * _rows + 2 * _gridHeight, _boxWidth, _arrowHeight];
    _ctrlWait ctrlSetStructuredText parseText format ["<t size='1' shadow='1' valign='middle'>%1</t>", _maxtime];
    _ctrlWait ctrlCommit 0;
    uiNamespace setVariable [QGVAR(timer), _ctrlWait];
    uiNamespace setVariable [QGVAR(timerEnd), time + _maxtime];
};

_display
