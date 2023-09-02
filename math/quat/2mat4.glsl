#include "type.glsl"
#include "2mat3.glsl"
#include "../toMat4.glsl"

#ifndef FNC_QUAT2MAT4
#define FNC_QUAT2MAT4

mat4 quat2mat4(QUAT q) {
    return toMat4(quat2mat3(q));
}

#endif