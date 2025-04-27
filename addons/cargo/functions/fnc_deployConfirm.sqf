#include "\z\ace\addons\cargo\script_component.hpp"

if (GVAR(deployPFH) == -1) exitWith {};

params ["_unit"];

// Delete placement dummy and unload real item from cargo at dummy position
if (!isNull GVAR(itemPreviewObject) && {[GVAR(selectedItem), GVAR(interactionVehicle), _unit, false, true] call FUNC(canUnloadItem)}) then {
    // Position is AGL for unloading event
    private _position = ASLToAGL getPosASL GVAR(itemPreviewObject);
    private _direction = getDir GVAR(itemPreviewObject);
    private _duration = [GVAR(selectedItem), false] call FUNC(getDelayItem);

    // If unload time is 0, don't show a progress bar
    if (_duration <= 0) exitWith {
        ["ace_unloadCargo", [GVAR(selectedItem), GVAR(interactionVehicle), _unit, [_position, _direction]]] call CBA_fnc_localEvent;
    };

    private _sequence = floor (_duration * qte_ace_cargo_difficulty) max 1;
    if (qte_ace_cargo_enable && {!cba_quicktime_qteShorten} && {_sequence <= qte_ace_main_maxLengthRounded}) then {
        _sequence = [_sequence, "cargo"] call qte_ace_main_fnc_generateWordsQTE;
        private _newSuccess = {
            params ["_args"];
            _args params ["", "", "_aceArgs"];
            TRACE_1("deploy finish",_aceArgs);

            ["ace_unloadCargo", _aceArgs] call CBA_fnc_localEvent;
            true
        };

        private _newFailure = {
            params ["_args", "_elapsedTime"];
            if (_args isEqualTo false) exitWith {};
            _args params ["_maxTime", "", "_aceArgs"];
            if (!qte_ace_cargo_mustBeCompleted && {_maxTime > 0 && {_elapsedTime >= _maxTime}}) then {
                ["ace_unloadCargo", _aceArgs] call CBA_fnc_localEvent;
                true
            } else {
                // ace cargo does nothing on fail
                false
            };
        };

        if (qte_ace_cargo_noTimer) then {
            _duration = 0;
        };

        [
            _sequence,
            _newSuccess,
            _newFailure,
            {
                (_this select 0) params ["_item", "_vehicle", "_unit"];

                [_item, _vehicle, _unit, false, true] call FUNC(canUnloadItem)
            },
            _duration,
            round qte_ace_cargo_tries,
            [GVAR(selectedItem), GVAR(interactionVehicle), _unit, [_position, _direction]],
            format [LLSTRING(unloadingItem), [GVAR(selectedItem), true] call FUNC(getNameItem), getText (configOf GVAR(interactionVehicle) >> "displayName")],
            qte_ace_cargo_resetUponIncorrectInput,
            ["isNotSwimming"],
            qte_ace_cargo_mustBeCompleted
        ] call qte_ace_main_fnc_runQTE;
    } else {
        [
            _duration,
            [GVAR(selectedItem), GVAR(interactionVehicle), _unit, [_position, _direction]],
            {
                TRACE_1("deploy finish",_this);

                ["ace_unloadCargo", _this select 0] call CBA_fnc_localEvent;
            },
            {
                TRACE_1("deploy fail",_this);
            },
            format [LLSTRING(unloadingItem), [GVAR(selectedItem), true] call FUNC(getNameItem), getText (configOf GVAR(interactionVehicle) >> "displayName")],
            {
                (_this select 0) params ["_item", "_vehicle", "_unit"];

                [_item, _vehicle, _unit, false, true] call FUNC(canUnloadItem) // don't check for a suitable unloading position when deploying
            },
            ["isNotSwimming"]
        ] call EFUNC(common,progressBar);
    };
};

// Cleanup EHs and preview object
_unit call FUNC(deployCancel);
