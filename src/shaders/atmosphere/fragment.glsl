
varying vec3 vNormal;
varying vec3 vPosition;


uniform vec3 uAtmospherDayColor;
uniform vec3 uAtmospherTwilightColor;
uniform vec3 uSunDirection;

void main()
{
    vec3 viewDirection = normalize(vPosition - cameraPosition);
    vec3 normal = normalize(vNormal);

    //sun
   
   float sunOrientation=dot(uSunDirection,normal);
    vec3 color=vec3(sunOrientation);

  
    //Atmosphere

    float atmosphereDayMix=smoothstep(-0.5,0.1,sunOrientation);
    vec3 atmosphereColor=mix(uAtmospherTwilightColor,uAtmospherDayColor,atmosphereDayMix);
    color=+atmosphereColor;
    //alpha
    float edgeAlpha=dot(viewDirection,normal);
    edgeAlpha=smoothstep(0.0,0.5,edgeAlpha);

    float dayAlpha=smoothstep(-0.5,0.0,sunOrientation);

    float alpha=edgeAlpha*dayAlpha;

    // Final color
    gl_FragColor = vec4(color, alpha);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}