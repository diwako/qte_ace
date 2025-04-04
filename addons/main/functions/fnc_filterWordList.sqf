#include "..\script_component.hpp"
params [["_list", [], [[]]], ["_badWords", GVAR(bannedWordsArr), [[]]], ["_makeUpperCompare", false, [false]]];

private _listUpper = if (_makeUpperCompare) then {
    _badWords = _badWords apply { toUpper _x };
    +(_list apply { toUpper _x })
} else {
    +_list
};

private _listCopy = +_list;
{
    private _word = _x;
    private _index = _listUpper findIf {_word in _x};
    while {_index >= 0} do {
        _listUpper deleteAt _index;
        _index = _listUpper findIf {_word in _x};
    };
} forEach _badWords;

_listCopy
