#include "..\script_component.hpp"
params ["_length", "_component"];

private _qteType = missionNamespace getVariable format [QEGVAR(%1,qteType), _component];

if (_qteType == 2 || {_qteType == 0 && (floor random 2) isEqualTo 0}) then {
    private _words = missionNamespace getVariable format [QEGVAR(%1,words), _component];
    private _sequenceLength = _length;
    _length = selectRandom _words;
    while {(count _length + 1) < _sequenceLength} do {
        _length = format ["%1 %2", _length, selectRandom _words];
    };
};

_length
