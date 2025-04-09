class GVAR(qteDisplay) {
    idd = -1;
    movingEnable = 0;
    onLoad = QUOTE(uiNamespace setVariable [ARR_2(QUOTE(QGVAR(qteDisplay)),_this select 0)];);
    objects[] = {};

    class controlsBackground {};
};
