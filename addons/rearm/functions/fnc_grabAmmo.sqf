#include "\z\ace\addons\rearm\script_component.hpp"

params ["_dummy", "_unit"];

REARM_HOLSTER_WEAPON;
[_unit, "forceWalk", QUOTE(ADDON), true] call EFUNC(common,statusEffect_set);
[_unit, "blockThrow", QUOTE(ADDON), true] call EFUNC(common,statusEffect_set);

private _rearmTime = (TIME_PROGRESSBAR(5));
private _sequence = floor (_rearmTime * qte_ace_rearm_difficulty) max 1;
if (qte_ace_rearm_enable && {!cba_quicktime_qteShorten} && {_sequence <= qte_ace_main_maxLengthRounded}) then {
    _sequence = [_sequence, "rearm"] call qte_ace_main_fnc_generateWordsQTE;

    DFUNC(grabAmmoSuccess) = {
        params ["_args"];
        _args params ["_dummy", "_unit"];
        [_dummy, _unit] call FUNC(pickUpAmmo);

        private _actionID = _unit getVariable [QGVAR(ReleaseActionID), -1];
        if (_actionID != -1) then {
            _unit removeAction _actionID;
        };
        _actionID = _unit addAction [
            format ["<t color='#FF0000'>%1</t>", LELSTRING(common,Drop)],
            '(_this select 0) call FUNC(dropAmmo)',
            nil,
            20,
            false,
            true,
            "",
            '!isNull (_target getVariable [QGVAR(dummy), objNull])'
        ];
        _unit setVariable [QGVAR(ReleaseActionID), _actionID];
    };

    private _newSuccess = {
        params ["_args"];
        _args params ["", "", "_aceArgs", "", "", ""];
        [_aceArgs] call DFUNC(grabAmmoSuccess);
        true
    };

    private _newFailure = {
        params ["_args", "_elapsedTime"];
        if (_args isEqualTo false) exitWith {};
        _args params ["_maxTime", "", "_aceArgs", "", "", ""];
        if (!qte_ace_rearm_mustBeCompleted && {_maxTime > 0 && {_elapsedTime >= _maxTime}}) then {
            [_aceArgs] call DFUNC(grabAmmoSuccess);
            true
        } else {
            // nothing happens in ace
            false
        };
    };

    if (qte_ace_rearm_noTimer) then {
        _rearmTime = 0;
    };

    [
        _sequence,
        _newSuccess,
        _newFailure,
        {true},
        _rearmTime,
        floor qte_ace_rearm_tries,
        [_dummy, _unit],
        localize LSTRING(GrabAction),
        qte_ace_rearm_resetUponIncorrectInput,
        ["isnotinside"]
    ] call qte_ace_main_fnc_runQTE;
} else {
    [
        TIME_PROGRESSBAR(5),
        [_dummy, _unit],
        {
            params ["_args"];
            _args params ["_dummy", "_unit"];
            [_dummy, _unit] call FUNC(pickUpAmmo);

            private _actionID = _unit getVariable [QGVAR(ReleaseActionID), -1];
            if (_actionID != -1) then {
                _unit removeAction _actionID;
            };
            _actionID = _unit addAction [
                format ["<t color='#FF0000'>%1</t>", LELSTRING(common,Drop)],
                '(_this select 0) call FUNC(dropAmmo)',
                nil,
                20,
                false,
                true,
                "",
                '!isNull (_target getVariable [QGVAR(dummy), objNull])'
            ];
            _unit setVariable [QGVAR(ReleaseActionID), _actionID];
        },
        "",
        localize LSTRING(GrabAction),
        {true},
        ["isnotinside"]
    ] call EFUNC(common,progressBar);
};
