#version 330 core
out vec4 FragColor;


in vec3 gNormals ;
in vec3 gWorldPos_FS_in ;
in float fogFS;


struct Material {
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;    
    float shininess;
};                                                                        


struct DirLight {
    vec3 direction;
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
}; 

//uniform sampler2D texture1;
uniform DirLight dirLight;
uniform Material mat ;
uniform vec3 viewPos ;
uniform float Scale ;



void main()
{   
    vec3 colour ;
    vec4 white = vec4(1.0f, 1.0f, 1.0f, 1.0f);
    vec4 green = vec4(0.0f, 0.6f, 0.1f, 1.0f);
    vec4 brown = vec4(0.5f, 0.4f, 0.3f, 1.0f);

    float height = gWorldPos_FS_in.y/Scale;
    if(height > 0.6) colour = mix(brown, white, smoothstep(0.6, 1.0, height)).rgb;
    else if (height > 0.3) colour = mix(green, brown, smoothstep(0.3, 0.4, height)).rgb;
    else colour = green.rgb;

     vec3 viewDir = normalize(viewPos - gWorldPos_FS_in);
	 vec3 norm = normalize(gNormals) ;
	 vec3 ambient = colour * dirLight.ambient * mat.ambient ;     
     vec3 lightDir = normalize(-dirLight.direction);
    // diffuse shading
    float diff = max(dot(norm, dirLight.direction), 0.0);
    // specular shading
    vec3 reflectDir = reflect(-dirLight.direction, norm);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), mat.shininess);
    // combine results
   
    vec3 diffuse  = colour * dirLight.diffuse  * (diff * mat.diffuse);
    vec3 specular = colour * dirLight.specular * (spec * mat.specular) ;
    FragColor = vec4((ambient + diffuse + specular),1.0f);
    FragColor = mix(vec4(0.5, 0.7, 0.9, 1.0), FragColor, fogFS);
	
}

