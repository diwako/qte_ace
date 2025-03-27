#include "\z\ace\addons\rearm\script_component.hpp"

params ["_target", "_unit"];
TRACE_2("rearm",_target,_unit);

private _attachedDummy = _unit getVariable [QGVAR(dummy), objNull];
if (isNull _attachedDummy) exitWith {ERROR_1("attachedDummy null %1",_attachedDummy);};
private _magazineClass = _attachedDummy getVariable QGVAR(magazineClass);
if (isNil "_magazineClass") exitWith {ERROR_1("magazineClass nil %1",_attachedDummy);};

([_magazineClass] call FUNC(getCaliber)) params ["", "_idx"];

// Get magazines that can be rearmed
private _needRearmMags = [_target] call FUNC(getNeedRearmMagazines);
private _needRearmMagsOfClass = _needRearmMags select {(_x select 0) isEqualTo _magazineClass};

// Exit if no magazines need rearming
if ((count _needRearmMagsOfClass) == 0) exitWith {ERROR_2("Could not find turret for %1 in %2",_magazineClass,typeOf _target);};

private _currentRearmableMag = _needRearmMagsOfClass select 0;
_currentRearmableMag params ["", "_turretPath", "", "_pylon", "", "_magazineCount"];

private _magazineDisplayName = _magazineClass call FUNC(getMagazineName);

private _rearmTime = (TIME_PROGRESSBAR(REARM_DURATION_REARM select _idx));
private _sequence = floor (_rearmTime * qte_ace_rearm_difficulty) max 1;
if (qte_ace_rearm_enable && {!cba_quicktime_qteShorten} && {_sequence <= qte_ace_main_maxLengthRounded}) then {
    _sequence = [_sequence, "rearm"] call qte_ace_main_fnc_generateWordsQTE;

    private _newSuccess = {
        params ["_args"];
        _args params ["", "", "_aceArgs", "", "", ""];
        _aceArgs call FUNC(rearmSuccess);
        true
    };

    private _newFailure = {
        params ["_args", "_elapsedTime"];
        if (_args isEqualTo false) exitWith {};
        _args params ["_maxTime", "", "_aceArgs", "", "", ""];
        if (!qte_ace_rearm_mustBeCompleted && {_maxTime > 0 && {_elapsedTime >= _maxTime}}) then {
            _aceArgs call FUNC(rearmSuccess);
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
            //IGNORE_PRIVATE_WARNING ["_player"];
            param [0] params ["_target"];
            _player distance _target <= GVAR(distance);
        },
        _rearmTime,
        floor qte_ace_rearm_tries,
        [_target, _unit, _turretPath, _magazineCount, _magazineClass, (REARM_COUNT select _idx), _pylon],
        format [localize LSTRING(RearmAction), getText(configOf _target >> "displayName"), _magazineDisplayName],
        qte_ace_rearm_resetUponIncorrectInput,
        ["isnotinside"]
    ] call qte_ace_main_fnc_runQTE;
} else {
    [
        TIME_PROGRESSBAR(REARM_DURATION_REARM select _idx),
        [_target, _unit, _turretPath, _magazineCount, _magazineClass, (REARM_COUNT select _idx), _pylon],
        {(_this select 0) call FUNC(rearmSuccess)},
        "",
        format [localize LSTRING(RearmAction), getText(configOf _target >> "displayName"), _magazineDisplayName],
        {
            //IGNORE_PRIVATE_WARNING ["_player"];
            param [0] params ["_target"];
            _player distance _target <= GVAR(distance);
        },
        ["isnotinside"]
    ] call EFUNC(common,progressBar);
};
