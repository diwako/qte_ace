#define DEBUG_SYNCHRONOUS
#include "\x\cba\addons\main\script_macros_common.hpp"
#include "\x\cba\addons\xeh\script_xeh.hpp"

// Default versioning level
#define DEFAULT_VERSIONING_LEVEL 2

#define DGVAR(varName)    if(isNil "ACE_DEBUG_NAMESPACE") then { ACE_DEBUG_NAMESPACE = []; }; if(!(QUOTE(GVAR(varName)) in ACE_DEBUG_NAMESPACE)) then { PUSH(ACE_DEBUG_NAMESPACE, QUOTE(GVAR(varName))); }; GVAR(varName)
#define DVAR(varName)     if(isNil "ACE_DEBUG_NAMESPACE") then { ACE_DEBUG_NAMESPACE = []; }; if(!(QUOTE(varName) in ACE_DEBUG_NAMESPACE)) then { PUSH(ACE_DEBUG_NAMESPACE, QUOTE(varName)); }; varName
#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)
#define DEFUNC(var1,var2) TRIPLES(DOUBLES(PREFIX,var1),fnc,var2)

#undef QFUNC
#undef QEFUNC
#define QFUNC(var1) QUOTE(DFUNC(var1))
#define QEFUNC(var1,var2) QUOTE(DEFUNC(var1,var2))

#define GETVAR_SYS(var1,var2) getVariable [ARR_2(QUOTE(var1),var2)]
#define SETVAR_SYS(var1,var2) setVariable [ARR_2(QUOTE(var1),var2)]
#define SETPVAR_SYS(var1,var2) setVariable [ARR_3(QUOTE(var1),var2,true)]

#undef GETVAR
#define GETVAR(var1,var2,var3) (var1 GETVAR_SYS(var2,var3))
#define GETMVAR(var1,var2) (missionNamespace GETVAR_SYS(var1,var2))
#define GETUVAR(var1,var2) (uiNamespace GETVAR_SYS(var1,var2))
#define GETPRVAR(var1,var2) (profileNamespace GETVAR_SYS(var1,var2))
#define GETPAVAR(var1,var2) (parsingNamespace GETVAR_SYS(var1,var2))

#undef SETVAR
#define SETVAR(var1,var2,var3) var1 SETVAR_SYS(var2,var3)
#define SETPVAR(var1,var2,var3) var1 SETPVAR_SYS(var2,var3)
#define SETMVAR(var1,var2) missionNamespace SETVAR_SYS(var1,var2)
#define SETUVAR(var1,var2) uiNamespace SETVAR_SYS(var1,var2)
#define SETPRVAR(var1,var2) profileNamespace SETVAR_SYS(var1,var2)
#define SETPAVAR(var1,var2) parsingNamespace SETVAR_SYS(var1,var2)

#define GETGVAR(var1,var2) GETMVAR(GVAR(var1),var2)
#define GETEGVAR(var1,var2,var3) GETMVAR(EGVAR(var1,var2),var3)

#define ARR_SELECT(ARRAY,INDEX,DEFAULT) (if (count ARRAY > INDEX) then {ARRAY select INDEX} else {DEFAULT})
#define ANY_OF(ARRAY,CONDITION) (ARRAY findIf {CONDITION} != -1)

// ACEX Merge
#define ACEX_PREFIX acex
#define XADDON DOUBLES(ACEX_PREFIX,COMPONENT)
#define XGVAR(var) DOUBLES(XADDON,var)
#define EXGVAR(var1,var2) TRIPLES(ACEX_PREFIX,var1,var2)
#define QXGVAR(var) QUOTE(XGVAR(var))
#define QEXGVAR(var1,var2) QUOTE(EXGVAR(var1,var2))
#define QQXGVAR(var) QUOTE(QXGVAR(var))
#define QQEXGVAR(var1,var2) QUOTE(QEXGVAR(var1,var2))
#define ACEX_PREP(func) PREP(func); TRIPLES(XADDON,fnc,func) = DFUNC(func)

#ifdef DISABLE_COMPILE_CACHE
    #undef PREP
    #define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
#else
    #undef PREP
    #define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

#define PREP_MODULE(folder) [] call compile preprocessFileLineNumbers QPATHTOF(folder\__PREP__.sqf)

#define ACE_isHC (!hasInterface && !isDedicated)

#define IDC_STAMINA_BAR 193

#define ACE_DEPRECATED(arg1,arg2,arg3) WARNING_3("%1 is deprecated. Support will be dropped in version %2. Replaced by: %3",arg1,arg2,arg3)

#define PFORMAT_10(MESSAGE,A,B,C,D,E,F,G,H,I,J) \
    format ['%1: A=%2, B=%3, C=%4, D=%5, E=%6, F=%7, G=%8, H=%9, I=%10 J=%11', MESSAGE, RETNIL(A), RETNIL(B), RETNIL(C), RETNIL(D), RETNIL(E), RETNIL(F), RETNIL(G), RETNIL(H), RETNIL(I), RETNIL(J)]
#ifdef DEBUG_MODE_FULL
#define TRACE_10(MESSAGE,A,B,C,D,E,F,G,H,I,J) LOG_SYS_FILELINENUMBERS('TRACE',PFORMAT_10(str diag_frameNo + ' ' + (MESSAGE),A,B,C,D,E,F,G,H,I,J))
#else
   #define TRACE_10(MESSAGE,A,B,C,D,E,F,G,H,I,J) /* disabled */
#endif

#define GRAVITY 9.8066

#define SD_TO_MIN_MAX(d) ((d) * 3.371) // Standard deviation -> min / max of random [min, mid, max]

// Angular unit conversion
// Conversion factor: 54 / (5 * PI)
#define MRAD_TO_MOA(d) ((d) * 3.43774677)
// Conversion factor: (5 * PI) / 54
#define MOA_TO_MRAD(d) ((d) * 0.29088821)
// Conversion factor: 60
#define DEG_TO_MOA(d) ((d) * 60)
// Conversion factor: 1 / 60
#define MOA_TO_DEG(d) ((d) / 60)
// Conversion factor: (50 * PI) / 9
#define DEG_TO_MRAD(d) ((d) * 17.45329252)
// Conversion factor: 9 / (50 * PI)
#define MRAD_TO_DEG(d) ((d) / 17.45329252)
// Conversion factor: PI / 10800
#define MOA_TO_RAD(d) ((d) * 0.00029088)

#define ZEUS_ACTION_CONDITION ([_target, {QUOTE(QUOTE(ADDON)) in curatorAddons _this}, missionNamespace, QUOTE(QGVAR(zeusCheck)), 1E11, 'ace_interactMenuClosed'] call EFUNC(common,cachedCall))

#define SUBSKILLS ["aimingAccuracy", "aimingShake", "aimingSpeed", "spotDistance", "spotTime", "courage", "reloadSpeed", "commanding", "general"]

// macro add a dummy cfgPatch and notLoaded entry
#define ACE_PATCH_NOT_LOADED(NAME,CAUSE) \
class CfgPatches { \
    class DOUBLES(NAME,notLoaded) { \
        units[] = {}; \
        weapons[] = {}; \
        requiredVersion = REQUIRED_VERSION; \
        requiredAddons[] = {"ace_main"}; \
        VERSION_CONFIG; \
    }; \
}; \
class ace_notLoaded { \
    NAME = CAUSE; \
};
