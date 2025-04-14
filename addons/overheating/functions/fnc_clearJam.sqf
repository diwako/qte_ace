#include "\z\ace\addons\overheating\script_component.hpp"

params ["_unit", "_weapon", ["_skipAnim", false]];
TRACE_3("params",_unit,_weapon,_skipAnim);

private _jammedWeapons = _unit getVariable [QGVAR(jammedWeapons), []];

if (_weapon in _jammedWeapons) then {
    private _delay = 0;
    if !(_skipAnim) then {
        _delay = 2.5;
        private _clearJamAction = getText (configFile >> "CfgWeapons" >> _weapon >> "ACE_clearJamAction");

        if (_clearJamAction == "") then {
            _clearJamAction = getText (configFile >> "CfgWeapons" >> _weapon >> "reloadAction");
        };

        [_unit, _clearJamAction, 1] call EFUNC(common,doGesture);

        if (_weapon == primaryWeapon _unit) then {
            playSound QGVAR(fixing_rifle);
        } else {
            if (_weapon == handgunWeapon _unit) then {
                playSound QGVAR(fixing_pistol);
            };
        };
    };

    private _sequence = floor (_delay * qte_ace_overheating_difficulty) max 1;
    if (!_skipAnim && {qte_ace_overheating_enable && {!cba_quicktime_qteShorten} && {_sequence <= qte_ace_main_maxLengthRounded}}) then {
        private _newSuccess = {
            params ["_args", "_elapsedTime"];
            _args params ["", "", "_aceArgs"];
            _aceArgs call qte_ace_overheating_clearJamLogicSuccess;
            true
        };

        private _newFailure = {
            params ["_args", "_elapsedTime"];
            if (_args isEqualTo false) exitWith {};
            _args params ["_maxTime", "", "_aceArgs"];
            if (!qte_ace_overheating_mustBeCompleted && {_maxTime > 0 && {_elapsedTime >= _maxTime && {random 1 > GVAR(unJamFailChance)}}}) then {
                _aceArgs call qte_ace_overheating_clearJamLogicSuccess;
                true
            } else {
                if (GVAR(DisplayTextOnJam)) then {
                    [localize LSTRING(WeaponUnjamFailed)] call EFUNC(common,displayTextStructured);
                };
                false
            };
        };

        _sequence = [_sequence, "overheating"] call qte_ace_main_fnc_generateWordsQTE;

        if (qte_ace_overheating_noTimer) then {
            _delay = 0;
        } else {
            _delay = (_delay * 2.5) min 5;
        };
        [
            _sequence,
            _newSuccess,
            _newFailure,
            _newProgress,
            _delay,
            floor qte_ace_overheating_tries,
            [_unit, _weapon, _jammedWeapons],
            localize LSTRING(UnjamWeapon),
            qte_ace_overheating_resetUponIncorrectInput,
            [],
            qte_ace_overheating_mustBeCompleted
        ] call qte_ace_main_fnc_runQTE;
    } else {
        // Check if the jam clearing will be successfull
        if (random 1 > GVAR(unJamFailChance)) then {
            // Success
            [qte_ace_overheating_clearJamLogicSuccess, [_unit, _weapon, _jammedWeapons], _delay] call CBA_fnc_waitAndExecute;
        } else {
            // Failure
            if (GVAR(DisplayTextOnJam)) then {
                [{
                    [localize LSTRING(WeaponUnjamFailed)] call EFUNC(common,displayTextStructured);
                }, [], _delay] call CBA_fnc_waitAndExecute;
            };
        };
    };
};
