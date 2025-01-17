/*
contributors: Patricio Gonzalez Vivo
description: Raymarching template where it needs to define a float4 raymarchMSap( in float3 pos )
use: <float4> raymarch(<float3> camera, <float2> st)
options:
    - LIGHT_POSITION: in glslViewer is u_light
    - LIGHT_DIRECTION
    - LIGHT_COLOR: in glslViewer is u_lightColor
    - RAYMARCH_AMBIENT: defualt float3(1.0)
    - RAYMARCH_MULTISAMPLE: null
    - RAYMARCH_BACKGROUND: default float3(0.0)
    - RAYMARCH_CAMERA_MATRIX_FNC(RO, TA): default raymarchCamera(RO, TA)
    - RAYMARCH_RENDER_FNC(RO, RD): default raymarchDefaultRender(RO, RD)
license:
    - Copyright (c) 2021 Patricio Gonzalez Vivo under Prosperity License - https://prosperitylicense.com/versions/3.0.0
    - Copyright (c) 2021 Patricio Gonzalez Vivo under Patron License - https://lygia.xyz/license
*/

#ifndef RAYMARCH_CAMERA_MATRIX_FNC
#define RAYMARCH_CAMERA_MATRIX_FNC raymarchCamera
#endif

#ifndef RAYMARCH_RENDER_FNC
#define RAYMARCH_RENDER_FNC raymarchDefaultRender
#endif

#ifndef RESOLUTION
#define RESOLUTION _ScreenParams.xy
#endif

#ifndef RAYMARCH_CAMERA_FOV
#define RAYMARCH_CAMERA_FOV 60.0
#endif

#include "../math/const.hlsl"
#include "../space/rotate.hlsl"
#include "raymarch/render.hlsl"
#include "raymarch/camera.hlsl"

#ifndef ENG_RAYMARCH
#define ENG_RAYMARCH

float4 raymarch(float3 camera, float3 ta, float2 st) {
    float3x3 ca = RAYMARCH_CAMERA_MATRIX_FNC(camera, ta);
    float fov = 1.0/tan(RAYMARCH_CAMERA_FOV*PI/180.0/2.0);
    st.x = 1.0 - st.x;
    
#if defined(RAYMARCH_MULTISAMPLE)
    float4 color = float4(0.0, 0.0, 0.0, 0.0);
    float2 pixel = 1.0/ RESOLUTION;
    float2 offset = rotate( float2(0.5, 0.0), HALF_PI/4.);

    for (int i = 0; i < RAYMARCH_MULTISAMPLE; i++) {    
        float3 rd = mul(ca, normalize(float3( (st + offset * pixel)*2.0-1.0, fov)) );
        color += RAYMARCH_RENDER_FNC( camera, rd);
        offset = rotate(offset, HALF_PI);
    }
    return color/float(RAYMARCH_MULTISAMPLE);
#else
    float3 rd = mul(ca, normalize(float3(st * 2.0 - 1.0, fov)));
    return RAYMARCH_RENDER_FNC(camera, rd);
#endif
}

float4 raymarch(float3 camera, float2 st) {
    return raymarch(camera, float3(0.0, 0.0, 0.0), st);
}

#endif