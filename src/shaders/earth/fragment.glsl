varying vec2 vUv;
varying vec3 vNormal;
varying vec3 vPosition;

uniform sampler2D uDayTexture;
uniform sampler2D uNightTexture;
uniform sampler2D uSpecularCloudsTexture;
uniform vec3 uAtmospherDayColor;
uniform vec3 uAtmospherTwilightColor;

uniform vec3 uSunDirection;

void main()
{
    vec3 viewDirection = normalize(vPosition - cameraPosition);
    vec3 normal = normalize(vNormal);
    vec3 color = vec3(vUv, 1.0);
    //sun
   
   float sunOrientation=dot(uSunDirection,normal);
    color=vec3(sunOrientation);

    //day/night texture
    float dayMix=smoothstep(-0.25,0.5,sunOrientation);
    vec3 dayColor=texture(uDayTexture,vUv).rgb;
    vec3 nightColor=texture(uNightTexture,vUv).rgb;
    color=mix(nightColor,dayColor,dayMix);
    //specular Textue
    vec2 specularCloudsColor=texture(uSpecularCloudsTexture,vUv).rg;
    //cloud;
    float cloudMix=smoothstep(0.5,1.0,specularCloudsColor.g);
    cloudMix*=dayMix;
    color=mix(color,vec3(1.0),cloudMix);

    //frenel
    float fresnel=dot(viewDirection,normal)+1.0;
    fresnel=pow(fresnel,2.0);

    //Atmosphere

    float atmosphereDayMix=smoothstep(-0.5,0.1,sunOrientation);
    vec3 atmosphereColor=mix(uAtmospherTwilightColor,uAtmospherDayColor,atmosphereDayMix);
    color=mix(color,atmosphereColor,fresnel*atmosphereDayMix);
    //specular

    vec3 reflection=reflect(-uSunDirection,normal);
    float specular=-dot(reflection,viewDirection);
    specular=max(specular,0.0);
    specular=pow(specular,32.0);
    specular*=specularCloudsColor.r;
    vec3 specularColor=mix(vec3(1.0),atmosphereColor,fresnel);
    color+=specular*specularColor;


    // Final color
    gl_FragColor = vec4(color, 1.0);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}