#version 330 core
out vec4 FragColor;


in vec3 gNormals ;
in vec3 gWorldPos_FS_in ;
in vec2 TexCoords ;
in vec3 FragPos ;

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

float height = FragPos.y/scale;
vec4 green = vec4(0.3, 0.35, 0.15, 0.0) ;
vec4 grey  = vec4(0.5, 0.4, 0.5, 0.0) ;


void main()
{   
    
  
     vec3 viewDir = normalize(viewPos - gWorldPos_FS_in);
	 vec3 norm = normalize(gNormals) ;
	 vec3 ambient = dirLight.ambient * mat.ambient;     
     vec3 lightDir = normalize(-dirLight.direction);
    // diffuse shading
    float diff = max(dot(norm, dirLight.direction), 0.0);
    // specular shading
    vec3 reflectDir = reflect(-dirLight.direction, norm);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), mat.shininess);
    // combine results
   
    vec3 diffuse  = dirLight.diffuse  * (diff * mat.diffuse);
    vec3 specular = dirLight.specular * (spec * mat.specular);
    FragColor = vec4((ambient + diffuse + specular),1.0f);

	
}

