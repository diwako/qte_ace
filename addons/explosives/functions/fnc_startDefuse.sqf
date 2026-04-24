#include "\z\ace\addons\explosives\script_component.hpp"

params [["_unit", objNull, [objNull]], ["_target", objNull, [objNull]]];
TRACE_2("params",_unit,_target);

if (!alive _unit) exitWith {};

if (_target isKindOf "ACE_DefuseObject") then {
    _target = attachedTo _target;
};

if (isNull _target) exitWith {};

if (!local _unit) exitWith {
    [QGVAR(startDefuse), [_unit, _target], _unit] call CBA_fnc_targetEvent;
};

[_unit, ["MedicOther", "PutDown"] select (stance _unit == "Prone")] call EFUNC(common,doGesture);

// Adapt defusal time based of skill
private _isEOD = _unit call EFUNC(common,isEOD);
private _defuseTime = [configOf _target >> QGVAR(defuseTime), "NUMBER", 5] call CBA_fnc_getConfigEntry;

if (!_isEOD && GVAR(punishNonSpecialists)) then {
    _defuseTime = _defuseTime * 1.5;
};


if (ACE_player == _unit) then {
    if (_isEOD || !GVAR(requireSpecialist)) then {
        // API
        [QGVAR(defuseStart), [_target, _unit]] call CBA_fnc_globalEvent;

        // here start
        private _sequence = floor (_defuseTime * qte_ace_explosives_difficulty) max 1;
        if (qte_ace_explosives_enable && {!cba_quicktime_qteShorten} && {_sequence <= qte_ace_main_maxLengthRounded}) then {
            _sequence = [_sequence, "explosives"] call qte_ace_main_fnc_generateWordsQTE;

            private _newSuccess = {
                params ["_args"];
                _args params ["", "", "_aceArgs", "", "", ""];
                _aceArgs call FUNC(defuseExplosive);
                true
            };

            private _newFailure = {
                params ["_args", "_elapsedTime"];
                if (_args isEqualTo false) exitWith {};
                _args params ["_maxTime", "", "_aceArgs", "", "", ""];
                if (!qte_ace_explosives_mustBeCompleted && {_maxTime > 0 && {_elapsedTime >= _maxTime}}) then {
                    _aceArgs call FUNC(defuseExplosive);
                    true
                } else {
                    // nothing happens in ace usually, but...
                    if (!qte_ace_main_escPressed && qte_ace_explosives_explodeOnFail) then {
                        _aceArgs params ["_unit", "_explosive"];
                        // Kaboom :D
                        [_unit, -1, [_explosive, 1], "#ExplodeOnDefuse"] call FUNC(detonateExplosive);
                        [QGVAR(explodeOnDefuse), [_explosive, _unit]] call CBA_fnc_globalEvent;
                    };
                    false
                };
            };

            if (qte_ace_explosives_noTimer) then {
                _defuseTime = 0;
            };

            [
                _sequence,
                _newSuccess,
                _newFailure,
                {true},
                _defuseTime,
                round qte_ace_explosives_tries,
                [_unit,_target],
                localize LSTRING(DefusingExplosive),
                qte_ace_explosives_resetUponIncorrectInput,
                ["isNotSwimming"],
                qte_ace_explosives_mustBeCompleted
            ] call qte_ace_main_fnc_runQTE;
        } else {
            [_defuseTime, [_unit, _target], {(_this select 0) call FUNC(defuseExplosive)}, {}, LLSTRING(DefusingExplosive), {true}, ["isNotSwimming"]] call EFUNC(common,progressBar);
        };
        // here stop
    };
} else {
    // API
    [QGVAR(defuseStart), [_target, _unit]] call CBA_fnc_globalEvent;

    // Disable parts of the AI to simulate defusal
    private _features = [];

    {
        _features pushBack [_x, _unit checkAIFeature _x];

        _unit disableAI _x;
    } forEach ["MOVE", "TARGET", "FIREWEAPON"];

    [{
        params ["_unit", "_target", "_features"];
        TRACE_3("defuse finished",_unit,_target,_features);

        [_unit, _target] call FUNC(defuseExplosive);

        // Reenable what was previously enabled
        {
            _unit enableAIFeature _x;
        } forEach _features;
    }, [_unit, _target, _features], _defuseTime] call CBA_fnc_waitAndExecute;
};
