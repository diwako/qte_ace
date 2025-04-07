#include "\z\ace\addons\rearm\script_component.hpp"

params ["_truck", "_unit", "_args"];
_args params ["_magazineClass", "_vehicle"];
TRACE_5("takeAmmo",_truck,_unit,_args,_magazineClass,_vehicle);

([_magazineClass] call FUNC(getCaliber)) params ["", "_idx"];

REARM_HOLSTER_WEAPON;

private _targetName = if (_vehicle == _unit) then {
    "CSW"
} else {
    getText(configOf _vehicle >> "displayName")
};

private _rearmTime = TIME_PROGRESSBAR(REARM_DURATION_TAKE select _idx);
private _sequence = floor (_rearmTime * qte_ace_rearm_difficulty) max 1;
if (qte_ace_rearm_enable && {!cba_quicktime_qteShorten} && {_sequence <= qte_ace_main_maxLengthRounded}) then {
    _sequence = [_sequence, "rearm"] call qte_ace_main_fnc_generateWordsQTE;

    private _newSuccess = {
        params ["_args"];
        _args params ["", "", "_aceArgs", "", "", ""];
        [_aceArgs] call FUNC(takeSuccess);
        true
    };

    private _newFailure = {
        params ["_args", "_elapsedTime"];
        if (_args isEqualTo false) exitWith {};
        _args params ["_maxTime", "", "_aceArgs", "", "", ""];
        if (!qte_ace_rearm_mustBeCompleted && {_maxTime > 0 && {_elapsedTime >= _maxTime}}) then {
            [_aceArgs] call FUNC(takeSuccess);
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
        [_unit, _magazineClass, _truck, _vehicle],
        format [localize LSTRING(TakeAction), _magazineClass call FUNC(getMagazineName), _targetName],
        qte_ace_rearm_resetUponIncorrectInput,
        ["isnotinside"],
        qte_ace_rearm_mustBeCompleted
    ] call qte_ace_main_fnc_runQTE;
} else {
    [
        TIME_PROGRESSBAR(REARM_DURATION_TAKE select _idx),
        [_unit, _magazineClass, _truck, _vehicle],
        FUNC(takeSuccess),
        "",
        format [localize LSTRING(TakeAction), _magazineClass call FUNC(getMagazineName), _targetName],
        {true},
        ["isnotinside"]
    ] call EFUNC(common,progressBar);
};
