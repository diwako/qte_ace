#include "\z\ace\addons\rearm\script_component.hpp"

params ["_truck", "_player", "_vehicle"];
TRACE_3("rearmEntireVehicle",_truck,_player,_vehicle);

private _rearmTime = TIME_PROGRESSBAR(10);
private _sequence = floor (_rearmTime * qte_ace_rearm_difficulty) max 1;
if (qte_ace_rearm_enable && {!cba_quicktime_qteShorten} && {_sequence <= qte_ace_main_maxLengthRounded}) then {
    _sequence = [_sequence, "rearm"] call qte_ace_main_fnc_generateWordsQTE;

    private _newSuccess = {
        params ["_args"];
        _args params ["", "", "_aceArgs", "", "", ""];
        _aceArgs call FUNC(rearmEntireVehicleSuccess);
        true
    };

    private _newFailure = {
        params ["_args", "_elapsedTime"];
        if (_args isEqualTo false) exitWith {};
        _args params ["_maxTime", "", "_aceArgs", "", "", ""];
        if (!qte_ace_rearm_mustBeCompleted && {_maxTime > 0 && {_elapsedTime >= _maxTime}}) then {
            _aceArgs call FUNC(rearmEntireVehicleSuccess);
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
        {
            param [0] params ["", "_vehicle", "_player"];
            _player distance _vehicle <= GVAR(distance);
        },
        _rearmTime,
        floor qte_ace_rearm_tries,
        [_truck, _vehicle, _player],
        format [localize LSTRING(BasicRearmAction), getText(configOf _vehicle >> "displayName")],
        qte_ace_rearm_resetUponIncorrectInput,
        ["isnotinside"]
    ] call qte_ace_main_fnc_runQTE;
} else {
    [
        TIME_PROGRESSBAR(10),
        [_truck, _vehicle, _player],
        {(_this select 0) call FUNC(rearmEntireVehicleSuccess)},
        "",
        format [localize LSTRING(BasicRearmAction), getText(configOf _vehicle >> "displayName")],
        {
            param [0] params ["", "_vehicle", "_player"];
            _player distance _vehicle <= GVAR(distance);
        },
        ["isnotinside"]
    ] call EFUNC(common,progressBar);
};
