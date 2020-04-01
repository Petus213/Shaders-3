// first step of tesselation shader
// tesselation control shader add/deletes control points and determines the tesselatation level
// patch has three control points here (three vertices for each triangle)


#version 450 core
layout (vertices =3) out;


// vectors stored as arrays - each patch has three vertices, each with an xyz pos and xyz norm value 
//posVS = position from Vertex Shader, posTC = position from this Tesselation Control shader

in vec3 posVS[] ;
in vec3 normVS[] ;
in vec2 texCoords[] ;


out vec3 posTC[] ;
out vec3 normTC[] ;
out vec2 texCoordsTC[] ;

uniform vec3 eyePos;



float GetTessLevel(float dist1, float dist2)
	{
	
        float tessLevel = 1;
		float avgDist = (dist1 + dist2)/2 ;

        tessLevel = -(pow(avgDist, 2) / 250) + 50;
		if (tessLevel < 1) tessLevel = 1;


        return tessLevel;


	}

void main()
{

	if (gl_InvocationID == 0)
	{
		float eyeToVertexDist0 = distance(eyePos, posVS[0]);
		float eyeToVertexDist1 = distance(eyePos, posVS[1]);
		float eyeToVertexDist2 = distance(eyePos, posVS[2]);

		//calculate tessellation levels

		gl_TessLevelOuter[0] = GetTessLevel(eyeToVertexDist1, eyeToVertexDist2);
		gl_TessLevelOuter[1] = GetTessLevel(eyeToVertexDist2, eyeToVertexDist0);
		gl_TessLevelOuter[2] = GetTessLevel(eyeToVertexDist0, eyeToVertexDist1);
		gl_TessLevelInner[0] = gl_TessLevelOuter[2];
	}

   // pass through position and normal information
   posTC[gl_InvocationID]  = posVS[gl_InvocationID] ;
   normTC[gl_InvocationID] = normVS[gl_InvocationID] ;
   texCoordsTC[gl_InvocationID] = texCoords[gl_InvocationID] ;
   

}
