#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
uniform float Size = 8.0; // BLUR SIZE (Radius)
uniform float Quality = 4.0; // BLUR QUALITY (Default 4.0 - More is better but slower)
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

// https://www.shadertoy.com/view/Xltfzj

void mainImage()
{
    float Pi = 6.28318530718; // Pi*2
    
    // GAUSSIAN BLUR SETTINGS {{{
    float Directions = 18.0; // BLUR DIRECTIONS (Default 16.0 - More is better but slower)
    // GAUSSIAN BLUR SETTINGS }}}
   
    vec2 Radius = Size/iResolution.xy;
    
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    // Pixel colour
    vec4 Color = texture(iChannel0, uv);
    
    // Blur calculations
    for( float d=0.0; d<Pi; d+=Pi/Directions)
    {
		for(float i=1.0/Quality; i<=1.0; i+=1.0/Quality)
        {
			Color += texture( iChannel0, uv+vec2(cos(d),sin(d))*Radius*i);		
        }
    }
    
    // Output to screen 
    Color /= Quality * Directions + 1.0;
    gl_FragColor =  Color;
}