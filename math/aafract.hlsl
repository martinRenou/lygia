#include "map.hlsl"

/*
contributors: dahart (https://www.shadertoy.com/user/dahart)
description: |
    Anti-aliasing fract function. It clamp except for a 2-pixel wide gradient along the edge
    Based on this example https://www.shadertoy.com/view/4l2BRD
use: <float> aafract(<float> x)
option:
    AA_EDGE: in the absence of derivatives you can specify the antialiasing factor
*/

#ifndef FNC_AAFRACT
#define FNC_AAFRACT

float aafract(float x) {
#if defined(AA_EDGE)
    float afwidth = AA_EDGE;
#else 
    float afwidth = 2.0 * fwidth(x);
#endif
    float fx = frac(x);
    float idx = 1. - afwidth;
    return (fx < idx) ? fx : map(fx, idx, 1., fx, 0.);
}

float2 aafract(float2 v) { return float2(aafract(v.x), aafract(v.y)); }

#endif