/*
original_author: Patricio Gonzalez Vivo
description: Returns a flower shaped SDF
use: flowerSDF(<vec2> st, <int> n_sides)
options:
    - CENTER_2D : vec2, defaults to vec2(.5)
*/

#ifndef FNC_FLOWERSDF
#define FNC_FLOWERSDF
float flowerSDF(vec2 st, int N) {
#ifdef CENTER_2D
    st -= CENTER_2D;
#else
    st -= 0.5;
#endif
    st *= 4.0;
    float r = length(st) * 2.0;
    float a = atan(st.y, st.x);
    float v = float(N) * 0.5;
    return 1.0 - (abs(cos(a * v)) *  0.5 + 0.5) / r;
}
#endif