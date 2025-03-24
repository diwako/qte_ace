[
    QGVAR(enable),
    "CHECKBOX",
    [ELSTRING(main,enable), ELSTRING(main,enable_desc)],
    LSTRING(Category),
    true,
    false
] call CBA_fnc_addSetting;

[
    QGVAR(difficulty),
    "SLIDER",
    [ELSTRING(main,difficulty), ELSTRING(main,difficulty_desc)],
    LSTRING(Category),
    [0, 10, 4, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(qteType),
    "LIST",
    [ELSTRING(main,qte_type), ELSTRING(main,qte_type_desc)],
    LSTRING(Category),
    [[0, 1, 2], [ELSTRING(main,qte_type_all), ELSTRING(main,qte_type_arrows), ELSTRING(main,qte_type_words)], 0],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(resetUponIncorrectInput),
    "CHECKBOX",
    [ELSTRING(main,resetUponIncorrectInput), ELSTRING(main,resetUponIncorrectInput_desc)],
    LSTRING(Category),
    true,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(tries),
    "SLIDER",
    [ELSTRING(main,tries), ELSTRING(main,tries_desc)],
    LSTRING(Category),
    [0, 100, 1, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(explodeOnFail),
    "CHECKBOX",
    [LSTRING(explodeOnFail), LSTRING(explodeOnFail_desc)],
    LSTRING(Category),
    true,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(noTimer),
    "CHECKBOX",
    [LSTRING(noTimer), LSTRING(noTimer_desc)],
    LSTRING(Category),
    true,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(mustBeCompleted),
    "CHECKBOX",
    [ELSTRING(main,qte_must_be_completed), ELSTRING(main,qte_must_be_completed_desc)],
    LSTRING(Category),
    false,
    false
] call CBA_fnc_addSetting;
