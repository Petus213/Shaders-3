#version 330 core
out vec4 FragColor ;


in vec2 TexCoords ;
in vec3 FragPos ;

float height = FragPos.y/scale;
vec4 green = vec4(0.3, 0.35, 0.15, 0.0) ;
vec4 grey  = vec4(0.5, 0.4, 0.5, 0.0) ;


void main()
{
    if(height > 0.6)
	{
		Fragcolor = vec3(mix(green, grey, smoothstep(0.3, 1.0, height)).rgb);
	}
	else if(height > 0.4)
	{
		Fragcolor = vec3(mix(green, grey, smoothstep(0.5, 1.2, height)).rgb);
	}
	
	
}
	