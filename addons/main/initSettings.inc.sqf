[
    QGVAR(soundsCorrect),
    "LIST",
    [LSTRING(correct), LSTRING(correct_desc)],
    LSTRING(Category),
    [GVAR(availableSounds), GVAR(availableSounds), GVAR(availableSounds) findIf {_x isEqualTo "ClickSoft"}],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(soundsWrong),
    "LIST",
    [LSTRING(wrong), LSTRING(wrong_desc)],
    LSTRING(Category),
    [GVAR(availableSounds), GVAR(availableSounds), GVAR(availableSounds) findIf {_x isEqualTo "addItemFailed"}],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(soundsWin),
    "LIST",
    [LSTRING(win), LSTRING(win_desc)],
    LSTRING(Category),
    [GVAR(availableSounds), GVAR(availableSounds), GVAR(availableSounds) findIf {_x isEqualTo "3DEN_notificationDefault"}],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(soundsLose),
    "LIST",
    [LSTRING(lose), LSTRING(lose_desc)],
    LSTRING(Category),
    [GVAR(availableSounds), GVAR(availableSounds), GVAR(availableSounds) findIf {_x isEqualTo "Simulation_Fatal"}],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(soundsLastTry),
    "LIST",
    [LSTRING(last_try), LSTRING(last_try_desc)],
    LSTRING(Category),
    [GVAR(availableSounds), GVAR(availableSounds), GVAR(availableSounds) findIf {_x isEqualTo "vtolAlarm"}],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(maxLength),
    "SLIDER",
    [LSTRING(maxLength), LSTRING(maxLength_desc)],
    LSTRING(Category),
    [0, 1000, 500, 0],
    true,
    {
        params ["_value"];
        GVAR(maxLengthRounded) = round _value;
    }
] call CBA_fnc_addSetting;
