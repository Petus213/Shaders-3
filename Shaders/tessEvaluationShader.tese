#version 450 core

// reading in a triangle, split tesselated triangels evenly in a counter-clockwise direction (ccw)
layout(triangles, equal_spacing, ccw) in;

// forward declare functions to perfrom interpolation with the barycentric coordinates from the Primitive Generator
vec2 interpolate2D(vec2 v0, vec2 v1, vec2 v2) ;
vec3 interpolate3D(vec3 v0, vec3 v1, vec3 v2) ;


// unifrom matrices to perform transformations
// previously this would have been done in vertex shader
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;
uniform float Scale = 50.0f;
uniform sampler2D heightMap;
uniform float Density = 0.005f;
uniform float distMod = 1.2;

uniform vec3 eyePos;

// read in vector arrays from previous shader
in vec3 posTC[] ;
in vec3 normTC[] ;
in vec2 texCoordsTC[] ;
// pass along the interpolated values
out vec3 normES ;
out vec3 posES ;
out vec2 texCoordsES ;
out float visibility;

void main()
{
    // interpolate the normal and xyz position using the linear interpolation function
    // use 3D because they are in three dimensions; 2D also included for uv texture coordinates

   
   posES = interpolate3D(posTC[0], posTC[1], posTC[2]) ;
   texCoordsES = interpolate2D(texCoordsTC[0], texCoordsTC[1], texCoordsTC[2]) ;


  float height = (texture(heightMap, texCoordsES).x) * Scale;
  posES.y = height;

  float right = (textureOffset(heightMap, texCoordsES, ivec2(1,0)).r)*Scale;
  float left = (textureOffset(heightMap, texCoordsES, ivec2(-1,0)).r)*Scale;
  float up = (textureOffset(heightMap, texCoordsES, ivec2(0,1)).r)*Scale;
  float down = (textureOffset(heightMap, texCoordsES, ivec2(0,-1)).r)*Scale;

  normES = normalize(vec3(left-right, 2.0f, up-down));

  //fog

  float dist = distance(eyePos, posES);
  visibility = exp(-pow(dist*Density, distMod));
  visibility = clamp(visibility, 0.0, 1.0);






   // transform vertex to clip space  - NOTE: WE NEED TO DO IT HERE NOW and not in vertex shader
   gl_Position = projection * view * model * vec4(posES, 1.0);







} 


//basic linear interpolation
vec2 interpolate2D(vec2 v0, vec2 v1, vec2 v2)
{
   	return vec2(gl_TessCoord.x) * v0 + vec2(gl_TessCoord.y) * v1 + vec2(gl_TessCoord.z) * v2;
}

vec3 interpolate3D(vec3 v0, vec3 v1, vec3 v2)
{
   	return vec3(gl_TessCoord.x) * v0 + vec3(gl_TessCoord.y) * v1 + vec3(gl_TessCoord.z) * v2;
}

