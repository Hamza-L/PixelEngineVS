#version 450 //use glsl 4.5

layout(location = 0) in vec4 position;
layout(location = 1) in vec4 normal;
layout(location = 2) in vec4 color;
layout(location = 3) in vec2 texUV;

layout(set = 0, binding = 0) uniform UboVP
{
    mat4 V;
    mat4 P;
    vec4 lightPos;
} uboVP;

layout(push_constant) uniform PObj
{
    mat4 M;
    mat4 MinvT;
} pushObj;

// size of the grid
float gridSize = 10.0f;

// minimum number of pixels between cell lines before LOD switch should occur.
const float gridMinPixelsBetweenCells = 2.0;

layout (location=0) out vec2 uv;
layout (location=1) out vec2 out_camPos;
layout (location=2) out float gridSizeFrag;

void main()
{

    vec3 gridPos = position.xyz * gridSize;
    vec3 cameraPos = vec3(uboVP.V[0][3],uboVP.V[1][3],uboVP.V[2][3]);

    gridPos += cameraPos;

    out_camPos = cameraPos.xz;

    gl_Position = uboVP.P * uboVP.V * pushObj.M * vec4(gridPos,1.0f);

    uv = gridPos.xz;

    gridSizeFrag = gridSize;
}