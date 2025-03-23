#include "\z\ace\addons\magazinerepack\script_component.hpp"

params ["", "_player", "_magazineClassname"];

if (isNil "_magazineClassname" || {_magazineClassname == ""}) exitWith {ERROR("Bad Mag Classname");};
private _magazineCfg = configFile >> "CfgMagazines" >> _magazineClassname;
// Calculate actual ammo to transfer during repack
private _fullMagazineCount = getNumber (_magazineCfg >> "count");
//Is linked belt magazine:
private _isBelt = isNumber (_magazineCfg >> "ACE_isBelt") && {(getNumber (_magazineCfg >> "ACE_isBelt")) == 1};

//Check canInteractWith:
if !([_player, objNull, ["isNotInside", "isNotSwimming", "isNotSitting"]] call EFUNC(common,canInteractWith)) exitWith {};

[_player] call EFUNC(common,goKneeling);

private _startingAmmoCounts = [];
{
    _x params ["_xClassname", "_xCount", "_xLoaded", "_xType"];
    if (_xClassname == _magazineClassname && {_xCount != _fullMagazineCount && {_xCount > 0}}) then {
        if (_xLoaded) then {
            //Try to Remove from weapon and add to inventory, otherwise ignore
            if (GVAR(repackLoadedMagazines) && {_player canAdd [_magazineClassname, 1, true]}) then {
                switch (_xType) do {
                    case (1): {_player removePrimaryWeaponItem _magazineClassname};
                    case (2): {_player removeHandgunItem _magazineClassname};
                    case (4): {_player removeSecondaryWeaponItem _magazineClassname};
                    default {ERROR("Loaded Location Invalid");};
                };
                _player addMagazine [_magazineClassname, _xCount];
                _startingAmmoCounts pushBack _xCount;
                [LLSTRING(repackLoadedMagazinesHint)] call EFUNC(common,displayTextStructured);
            };
        } else {
            _startingAmmoCounts pushBack _xCount;
        };
    };
} forEach (magazinesAmmoFull _player);

if (count _startingAmmoCounts < 2) exitWith {ERROR("Not Enough Mags to Repack");};

private _simEvents = [_fullMagazineCount, _startingAmmoCounts, _isBelt] call FUNC(simulateRepackEvents);
private _totalTime = _simEvents select -1 select 0;

if (GVAR(repackAnimation)) then {
    [_player, "Gear"] call EFUNC(common,doGesture);
};

private _sequence = floor (_totalTime * qte_ace_magazinerepack_difficulty) max 1;
if (qte_ace_magazinerepack_enable && {!cba_quicktime_qteShorten} && {_sequence <= qte_ace_main_maxLengthRounded}) then {
    if (qte_ace_magazinerepack_qteType == 2 || {qte_ace_magazinerepack_qteType == 0 && (floor random 2) isEqualTo 0}) then {
        private _sequenceLength = _sequence;
        _sequence = selectRandom qte_ace_magazinerepack_words;
        while {(count _sequence + 1) < _sequenceLength} do {
            _sequence = format ["%1 %2", _sequence, selectRandom qte_ace_magazinerepack_words];
        };
    } else {
        // comedy option
        if (random 10 < 0.5) then {
            private _sequenceLength = _sequence;
            _sequence = [];
            for "_i" from 1 to _sequenceLength do {
                _sequence pushBack ["↓"];
            };
        };
    };

    private _newSuccess = {
        params ["_args", "_elapsedTime"];
        _args params [["_maxTime", 0], "", "_aceArgs"];
        while {[_aceArgs, _maxTime, _maxTime] call FUNC(magazineRepackProgress)} do {
            // :)
        };
        [_aceArgs, _maxTime, _maxTime, 0] call FUNC(magazineRepackFinish);
        true
    };

    private _newFailure = {
        params ["_args", "_elapsedTime"];
        if (_args isEqualTo false) exitWith {};
        _args params ["_maxTime", "", "_aceArgs"];
        if (!qte_ace_magazinerepack_mustBeCompleted && _elapsedTime >= _maxTime) then {
            while {[_aceArgs, _elapsedTime, _maxTime] call FUNC(magazineRepackProgress)} do {
                // :)
            };
            [_aceArgs, _elapsedTime, _maxTime, 0] call FUNC(magazineRepackFinish);
            true
        } else  {
            [_aceArgs, _elapsedTime, _maxTime, 3] call FUNC(magazineRepackFinish);
            false
        };
    };

    private _newProgress = {
        if (qte_ace_magazinerepack_mustBeCompleted) exitWith {true};
        _this call FUNC(magazineRepackProgress)
    };

    [
        _sequence,
        _newSuccess,
        _newFailure,
        _newProgress,
        _totalTime,
        floor qte_ace_magazinerepack_tries,
        [_magazineClassname, _startingAmmoCounts, _simEvents],
        (localize LSTRING(RepackingMagazine)),
        qte_ace_magazinerepack_resetUponIncorrectInput,
        ["isNotInside", "isNotSwimming", "isNotInZeus"]
    ] call qte_ace_main_fnc_runQTE;
} else {
    [
        _totalTime,
        [_magazineClassname, _startingAmmoCounts, _simEvents],
        {call FUNC(magazineRepackFinish)},
        {call FUNC(magazineRepackFinish)},
        (localize LSTRING(RepackingMagazine)),
        {call FUNC(magazineRepackProgress)},
        ["isNotInside", "isNotSwimming", "isNotSitting"]
    ] call EFUNC(common,progressBar);
};
