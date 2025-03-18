#include "..\script_component.hpp"
params [["_length", 0, [0]]];

private _code = [];

for "_i" from 1 to _length do {
    _code pushBack (selectRandom ["↑", "↓", "→", "←"]);
};

_code
