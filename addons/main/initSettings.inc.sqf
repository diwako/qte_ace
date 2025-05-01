[
    QGVAR(pendingCharactersDim),
    "CHECKBOX",
    [LSTRING(pendingCharactersDim), LSTRING(pendingCharactersDim_desc)],
    [LSTRING(Category), format ["1: %1", localize "str_general"]],
    true,
    false
] call CBA_fnc_addSetting;

[
    QGVAR(soundsCorrect),
    "LIST",
    [LSTRING(correct), LSTRING(correct_desc)],
    [LSTRING(Category), format ["1: %1", localize "str_general"]],
    [GVAR(availableSounds), GVAR(availableSounds), GVAR(availableSounds) findIf {_x isEqualTo "ClickSoft"}],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(soundsWrong),
    "LIST",
    [LSTRING(wrong), LSTRING(wrong_desc)],
    [LSTRING(Category), format ["1: %1", localize "str_general"]],
    [GVAR(availableSounds), GVAR(availableSounds), GVAR(availableSounds) findIf {_x isEqualTo "addItemFailed"}],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(soundsWin),
    "LIST",
    [LSTRING(win), LSTRING(win_desc)],
    [LSTRING(Category), format ["1: %1", localize "str_general"]],
    [GVAR(availableSounds), GVAR(availableSounds), GVAR(availableSounds) findIf {_x isEqualTo "3DEN_notificationDefault"}],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(soundsLose),
    "LIST",
    [LSTRING(lose), LSTRING(lose_desc)],
    [LSTRING(Category), format ["1: %1", localize "str_general"]],
    [GVAR(availableSounds), GVAR(availableSounds), GVAR(availableSounds) findIf {_x isEqualTo "Simulation_Fatal"}],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(soundsLastTry),
    "LIST",
    [LSTRING(last_try), LSTRING(last_try_desc)],
    [LSTRING(Category), format ["1: %1", localize "str_general"]],
    [GVAR(availableSounds), GVAR(availableSounds), GVAR(availableSounds) findIf {_x isEqualTo "vtolAlarm"}],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(maxLength),
    "SLIDER",
    [LSTRING(maxLength), LSTRING(maxLength_desc)],
    [LSTRING(Category), format ["1: %1", localize "str_general"]],
    [0, 1000, 500, 0],
    true,
    {
        params ["_value"];
        GVAR(maxLengthRounded) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(qtePosition),
    "LIST",
    [LSTRING(qte_position), LSTRING(qte_position_desc)],
    [LSTRING(Category), format ["1: %1", localize "str_general"]],
    [[0, 1, 2], [localize "str_a3_cfguigrids_gui_variables_grid_center_0", LSTRING(qte_position_bottom), LSTRING(qte_position_top)], 0],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(bannedWords),
    "EDITBOX",
    [LSTRING(bannedWords), LSTRING(bannedWords_desc)],
    [LSTRING(Category), format ["1: %1", localize "str_general"]],
    "[""coolexample1"",""coolexample2""]",
    false,
    {
        params ["_value"];
        private _list = (_value splitString "[,""']") apply {toUpper trim _x};
        GVAR(bannedWordsArr) = (_list arrayIntersect _list) - [""];
    },
    true
] call CBA_fnc_addSetting;

[
    QGVAR(addedWords),
    "EDITBOX",
    [LSTRING(addedWords), LSTRING(addedWords_desc)],
    [LSTRING(Category), format ["1: %1", localize "str_general"]],
    "[]",
    false,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(arrowStyle),
    "LIST",
    [LSTRING(arrowStyle), LSTRING(arrowStyle_desc)],
    [LSTRING(Category), format ["2: %1", localize LSTRING(qte_type_arrows)]],
    [["arrowsCharacters", "arrows", "characters"], [LSTRING(arrowstyle_arrowsCharacters), LSTRING(arrowstyle_arrows), LSTRING(arrowstyle_characters)], 0],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(arrowColorUp),
    "COLOR",
    [format ["%1: %2", localize "str_cfg_markers_arrow", localize "str_dik_up"], LSTRING(arrowColor_desc)],
    [LSTRING(Category), format ["2: %1", localize LSTRING(qte_type_arrows)]],
    [1, 0.67, 0.67, 1],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(arrowColorDown),
    "COLOR",
    [format ["%1: %2", localize "str_cfg_markers_arrow", localize "str_dik_down"], LSTRING(arrowColor_desc)],
    [LSTRING(Category), format ["2: %1", localize LSTRING(qte_type_arrows)]],
    [0.67, 1, 0.67, 1],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(arrowColorLeft),
    "COLOR",
    [format ["%1: %2", localize "str_cfg_markers_arrow", localize "str_dik_left"], LSTRING(arrowColor_desc)],
    [LSTRING(Category), format ["2: %1", localize LSTRING(qte_type_arrows)]],
    [0.67, 0.67, 1, 1],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(arrowColorRight),
    "COLOR",
    [format ["%1: %2", localize "str_cfg_markers_arrow", localize "str_dik_right"], LSTRING(arrowColor_desc)],
    [LSTRING(Category), format ["2: %1", localize LSTRING(qte_type_arrows)]],
    [1, 1, 0.67, 1],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(debug),
    "CHECKBOX",
    format ["%1 %2", localize "str_enable_controller", localize "str_a3_cfgsounds_debug0"],
    [LSTRING(Category), format ["3: %1", localize "str_a3_cfgsounds_debug0"]],
    false,
    false
] call CBA_fnc_addSetting;
