#include "\z\ace\addons\cargo\script_component.hpp"

params ["_loader", "_item", ["_vehicle", objNull]];
TRACE_3("params",_loader,_item,_vehicle);

if (isNull _vehicle) then {
    {
        if ([_item, _x] call FUNC(canLoadItemIn)) exitWith {
            _vehicle = _x;
        };
    } forEach (nearestObjects [_loader, GVAR(cargoHolderTypes), MAX_LOAD_DISTANCE + 10]);
};

if (isNull _vehicle) exitWith {
    TRACE_3("Could not find vehicle",_loader,_item,_vehicle);

    false // return
};

// Start progress bar
if ([_item, _vehicle] call FUNC(canLoadItemIn)) then {
    private _duration = [_item, false] call FUNC(getDelayItem);

    // If load time is 0, don't show a progress bar
    if (_duration <= 0) exitWith {
        ["ace_loadCargo", [_item, _vehicle]] call CBA_fnc_localEvent;

        true // return
    };

    // Claim so nobody else can interact with it
    [_loader, _item, true] call EFUNC(common,claim);

    private _sequence = floor (_duration * qte_ace_cargo_difficulty) max 1;
    if (qte_ace_cargo_enable && {!cba_quicktime_qteShorten} && {_sequence <= qte_ace_main_maxLengthRounded}) then {
        _sequence = [_sequence, "cargo"] call qte_ace_main_fnc_generateWordsQTE;
        private _newSuccess = {
            params ["_args"];
            _args params ["", "", "_aceArgs"];
            TRACE_1("load finish",_aceArgs);

            [objNull, _aceArgs select 0, true] call EFUNC(common,claim);

            ["ace_loadCargo", _aceArgs] call CBA_fnc_localEvent;
            true
        };

        private _newFailure = {
            params ["_args", "_elapsedTime"];
            if (_args isEqualTo false) exitWith {};
            _args params ["_maxTime", "", "_aceArgs"];
            if (!qte_ace_cargo_mustBeCompleted && {_maxTime > 0 && {_elapsedTime >= _maxTime}}) then {
                [objNull, _aceArgs select 0, true] call EFUNC(common,claim);

                ["ace_loadCargo", _aceArgs] call CBA_fnc_localEvent;
                true
            } else  {
                TRACE_1("load fail",_aceArgs);
                _aceArgs params ["_item", "_vehicle"];

                [objNull, _item, true] call EFUNC(common,claim);

                [[LSTRING(loadingFailed), [_item, true] call FUNC(getNameItem)], 3] call EFUNC(common,displayTextStructured);

                // Fix cancelling loading a carried item
                if (!isNull attachedTo _item) then {
                    detach _item;

                    // Prevent coliisions between item and vehicle
                    [QEGVAR(common,fixCollision), _vehicle, _vehicle] call CBA_fnc_targetEvent;
                    [QEGVAR(common,fixCollision), _item, _item] call CBA_fnc_targetEvent;

                    [QEGVAR(common,fixPosition), _item, _item] call CBA_fnc_targetEvent;
                    [QEGVAR(common,fixFloating), _item, _item] call CBA_fnc_targetEvent;
                };
                false
            };
        };

        [
            _sequence,
            _newSuccess,
            _newFailure,
            {
                (_this select 0) call FUNC(canLoadItemIn)
            },
            _duration,
            floor qte_ace_cargo_tries,
            [_item, _vehicle],
            format [LLSTRING(loadingItem), [_item, true] call FUNC(getNameItem), getText (configOf _vehicle >> "displayName")],
            qte_ace_cargo_resetUponIncorrectInput,
            ["isNotSwimming"]
        ] call qte_ace_main_fnc_runQTE;
    } else {
        [
            _duration,
            [_item, _vehicle],
            {
                TRACE_1("load finish",_this);

                [objNull, _this select 0 select 0, true] call EFUNC(common,claim);

                ["ace_loadCargo", _this select 0] call CBA_fnc_localEvent;
            },
            {
                TRACE_1("load fail",_this);
                (_this select 0) params ["_item", "_vehicle"];

                [objNull, _item, true] call EFUNC(common,claim);

                [[LSTRING(loadingFailed), [_item, true] call FUNC(getNameItem)], 3] call EFUNC(common,displayTextStructured);

                // Fix cancelling loading a carried item
                if (!isNull attachedTo _item) then {
                    detach _item;

                    // Prevent coliisions between item and vehicle
                    [QEGVAR(common,fixCollision), _vehicle, _vehicle] call CBA_fnc_targetEvent;
                    [QEGVAR(common,fixCollision), _item, _item] call CBA_fnc_targetEvent;

                    [QEGVAR(common,fixPosition), _item, _item] call CBA_fnc_targetEvent;
                    [QEGVAR(common,fixFloating), _item, _item] call CBA_fnc_targetEvent;
                };
            },
            format [LLSTRING(loadingItem), [_item, true] call FUNC(getNameItem), getText (configOf _vehicle >> "displayName")],
            {
                (_this select 0) call FUNC(canLoadItemIn)
            },
            ["isNotSwimming"]
        ] call EFUNC(common,progressBar);
    };

    true // return
} else {
    // Unlock the object
    [objNull, _item, true] call EFUNC(common,claim);

    [[LSTRING(loadingFailed), [_item, true] call FUNC(getNameItem)], 3] call EFUNC(common,displayTextStructured);

    // Fix cancelling loading a carried item
    if (!isNull attachedTo _item) then {
        detach _item;

        // Prevent coliisions between item and vehicle
        [QEGVAR(common,fixCollision), _vehicle, _vehicle] call CBA_fnc_targetEvent;
        [QEGVAR(common,fixCollision), _item, _item] call CBA_fnc_targetEvent;

        [QEGVAR(common,fixPosition), _item, _item] call CBA_fnc_targetEvent;
        [QEGVAR(common,fixFloating), _item, _item] call CBA_fnc_targetEvent;
    };

    false // return
};
