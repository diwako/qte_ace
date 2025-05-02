#include "\z\ace\addons\rearm\script_component.hpp"

params ["_truck", "_unit"];

private _attachedDummy = _unit getVariable [QGVAR(dummy), objNull];
if (isNull _attachedDummy) exitWith {};

private _magazineClass = _attachedDummy getVariable [QGVAR(magazineClass), "#noVar"];

private _rearmTime = TIME_PROGRESSBAR(5);
private _sequence = floor (_rearmTime * qte_ace_rearm_difficulty) max 1;
if (qte_ace_rearm_enable && {!cba_quicktime_qteShorten} && {_sequence <= qte_ace_main_maxLengthRounded}) then {
    _sequence = [_sequence, "rearm"] call qte_ace_main_fnc_generateWordsQTE;

    DFUNC(storeAmmoSuccess) = {
        params ["_args"];
        _args params ["_unit", "_truck", "_attachedDummy"];
        [_truck, (_attachedDummy getVariable [QGVAR(magazineClass), ""]), true] call FUNC(addMagazineToSupply);
        [_unit, true, true] call FUNC(dropAmmo);
    };

    private _newSuccess = {
        params ["_args"];
        _args params ["", "", "_aceArgs", "", "", ""];
        [_aceArgs] call DFUNC(storeAmmoSuccess);
        true
    };

    private _newFailure = {
        params ["_args", "_elapsedTime"];
        if (_args isEqualTo false) exitWith {};
        _args params ["_maxTime", "", "_aceArgs", "", "", ""];
        if (!qte_ace_rearm_mustBeCompleted && {_maxTime > 0 && {_elapsedTime >= _maxTime}}) then {
            [_aceArgs] call DFUNC(storeAmmoSuccess);
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
        round qte_ace_rearm_tries,
        [_unit, _truck, _attachedDummy],
        format [localize LSTRING(StoreAmmoAction), _magazineClass call FUNC(getMagazineName), getText(configOf _truck >> "displayName")],
        qte_ace_rearm_resetUponIncorrectInput,
        ["isnotinside"],
        qte_ace_rearm_mustBeCompleted
    ] call qte_ace_main_fnc_runQTE;
} else {
    [
        TIME_PROGRESSBAR(5),
        [_unit, _truck, _attachedDummy],
        {
            params ["_args"];
            _args params ["_unit", "_truck", "_attachedDummy"];
            [_truck, (_attachedDummy getVariable [QGVAR(magazineClass), ""]), true] call FUNC(addMagazineToSupply);
            [_unit, true, true] call FUNC(dropAmmo);
        },
        "",
        format [localize LSTRING(StoreAmmoAction), _magazineClass call FUNC(getMagazineName), getText(configOf _truck >> "displayName")],
        {true},
        ["isnotinside"]
    ] call EFUNC(common,progressBar);
};
