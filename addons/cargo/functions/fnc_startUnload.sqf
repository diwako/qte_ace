#include "\z\ace\addons\cargo\script_component.hpp"

private _item = call FUNC(getSelectedItem);

if (isNil "_item") exitWith {};

params ["_unit"];

if (GVAR(interactionParadrop)) exitWith {
    // Close the cargo menu
    closeDialog 0;

    private _duration = [_item, true] call FUNC(getDelayItem);

    // If drop time is 0, don't show a progress bar
    if (_duration <= 0) exitWith {
        [QGVAR(paradropItem), [_item, GVAR(interactionVehicle)]] call CBA_fnc_localEvent;
    };

    private _sequence = floor (_duration * qte_ace_cargo_difficulty) max 1;
    if (qte_ace_cargo_enable && {!cba_quicktime_qteShorten} && {_sequence <= qte_ace_main_maxLengthRounded}) then {

        _sequence = [_sequence, "cargo"] call qte_ace_main_fnc_generateWordsQTE;
        private _newSuccess = {
            params ["_args"];
            _args params ["", "", "_aceArgs"];
            [QGVAR(paradropItem), _aceArgs select 0] call CBA_fnc_localEvent;
            true
        };

        private _newFailure = {
            params ["_args", "_elapsedTime"];
            if (_args isEqualTo false) exitWith {};
            _args params ["_maxTime", "", "_aceArgs"];
            if (!qte_ace_cargo_mustBeCompleted && {_maxTime > 0 && {_elapsedTime >= _maxTime}}) then {
                [QGVAR(paradropItem), _aceArgs select 0] call CBA_fnc_localEvent;
                true
            } else  {
                _aceArgs params ["", "", "", "_errorCode"];
                if (_errorCode == 3) then { // show warning if we failed because of flight conditions
                    [LSTRING(unlevelFlightWarning)] call EFUNC(common,displayTextStructured);
                };
                false
            };
        };

        if (qte_ace_cargo_noTimer) then {
            _duration = 0;
        };

        [qte_ace_main_fnc_runQTE, [
            _sequence,
            _newSuccess,
            _newFailure,
            {
                (_this select 0) params ["", "_vehicle"];

                if ((acos ((vectorUp _vehicle) select 2)) > 30) exitWith {false}; // check flight level
                if (((getPos _vehicle) select 2) < 25) exitWith {false}; // check height
                if ((speed _vehicle) < -5) exitWith {false}; // check reverse

                true
            },
            _duration,
            floor qte_ace_cargo_tries,
            [_item, GVAR(interactionVehicle)],
            format [LLSTRING(unloadingItem), [_item, true] call FUNC(getNameItem), getText (configOf GVAR(interactionVehicle) >> "displayName")],
            qte_ace_cargo_resetUponIncorrectInput,
            ["isNotSwimming", "isNotInside"]
        ]] call CBA_fnc_execNextFrame;
    } else {
        // Start progress bar - paradrop
        // Delay execution by a frame, to avoid progress bar stopping prematurely because of the cargo menu still being open
        [EFUNC(common,progressBar), [
            _duration,
            [_item, GVAR(interactionVehicle)],
            {
                [QGVAR(paradropItem), _this select 0] call CBA_fnc_localEvent;
            },
            {
                params ["", "", "", "_errorCode"];

                if (_errorCode == 3) then { // show warning if we failed because of flight conditions
                    [LSTRING(unlevelFlightWarning)] call EFUNC(common,displayTextStructured);
                };
            },
            format [LLSTRING(unloadingItem), [_item, true] call FUNC(getNameItem), getText (configOf GVAR(interactionVehicle) >> "displayName")],
            {
                (_this select 0) params ["", "_vehicle"];

                if ((acos ((vectorUp _vehicle) select 2)) > 30) exitWith {false}; // check flight level
                if (((getPos _vehicle) select 2) < 25) exitWith {false}; // check height
                if ((speed _vehicle) < -5) exitWith {false}; // check reverse

                true
            },
            ["isNotSwimming", "isNotInside"],
            false
        ]] call CBA_fnc_execNextFrame;
    };
};

// If in zeus
if (!isNull curatorCamera) exitWith {
    // Do not check distance to unit, but do check for valid position
    if !([_item, GVAR(interactionVehicle), objNull, true] call FUNC(canUnloadItem)) exitWith {
        [[LSTRING(unloadingFailed), [_item, true] call FUNC(getNameItem)], 3] call EFUNC(common,displayTextStructured);
    };

    // Close the cargo menu
    closeDialog 1;

    ["ace_unloadCargo", [_item, GVAR(interactionVehicle)]] call CBA_fnc_localEvent;
};

// Start progress bar - normal ground unload
if ([_item, GVAR(interactionVehicle), _unit] call FUNC(canUnloadItem)) then {
    // Close the cargo menu
    closeDialog 0;

    private _duration = [_item, false] call FUNC(getDelayItem);

    // If unload time is 0, don't show a progress bar
    if (_duration <= 0) exitWith {
        ["ace_unloadCargo", [_item, GVAR(interactionVehicle), _unit]] call CBA_fnc_localEvent;
    };

    private _sequence = floor (_duration * qte_ace_cargo_difficulty) max 1;
    if (qte_ace_cargo_enable && {!cba_quicktime_qteShorten} && {_sequence <= qte_ace_main_maxLengthRounded}) then {
        _sequence = [_sequence, "cargo"] call qte_ace_main_fnc_generateWordsQTE;
        private _newSuccess = {
            params ["_args"];
            _args params ["", "", "_aceArgs"];
            TRACE_1("unload finish",_aceArgs);

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
            } else  {
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
            floor qte_ace_cargo_tries,
            [_item, GVAR(interactionVehicle), _unit],
            format [LLSTRING(unloadingItem), [_item, true] call FUNC(getNameItem), getText (configOf GVAR(interactionVehicle) >> "displayName")],
            qte_ace_cargo_resetUponIncorrectInput,
            ["isNotSwimming"]
        ] call qte_ace_main_fnc_runQTE;
    } else {
        [
            _duration,
            [_item, GVAR(interactionVehicle), _unit],
            {
                TRACE_1("unload finish",_this);

                ["ace_unloadCargo", _this select 0] call CBA_fnc_localEvent;
            },
            {
                TRACE_1("unload fail",_this);
            },
            format [LLSTRING(unloadingItem), [_item, true] call FUNC(getNameItem), getText (configOf GVAR(interactionVehicle) >> "displayName")],
            {
                (_this select 0) params ["_item", "_vehicle", "_unit"];

                [_item, _vehicle, _unit, false, true] call FUNC(canUnloadItem) // don't check for a suitable unloading position every frame
            },
            ["isNotSwimming"]
        ] call EFUNC(common,progressBar);
    };
} else {
    [[LSTRING(unloadingFailed), [_item, true] call FUNC(getNameItem)], 3] call EFUNC(common,displayTextStructured);
};
