#define COMPONENT main
#define COMPONENT_BEAUTIFIED Main
#include "\z\qte_ace\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_MAIN
  #define DEBUG_MODE_FULL
#endif
#ifdef DEBUG_SETTINGS_MAIN
  #define DEBUG_SETTINGS DEBUG_SETTINGS_MAIN
#endif

#include "\z\qte_ace\addons\main\script_macros.hpp"

#define DYN_GROUP_KEY_VAR BIS_dynamicGroups_key
#define QDYN_GROUP_KEY_VAR QUOTE(DYN_GROUP_KEY_VAR)

#define DIK_F16 0x67
#define DIK_F17 0x68
#define DIK_F18 0x69
#define DIK_F19 0x6A
#define DIK_F20 0x6B
#define DIK_F21 0x6C
#define DIK_F22 0x6D
#define DIK_F23 0x6E
#define DIK_F24 0x76
