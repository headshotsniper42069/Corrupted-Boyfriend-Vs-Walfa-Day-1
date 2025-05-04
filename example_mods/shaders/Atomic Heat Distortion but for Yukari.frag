#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

vec2 wobble(vec2 uv, float amplitude, float frequence, float speed)
{
  float offset = amplitude*sin(uv.y*frequence+iTime*speed);
  return vec2(uv.x+offset,uv.y);	
}

void mainImage()
{
	vec2 uv = fragCoord.xy / iResolution.xy;
	float amplitude = 0.0020;
	float frequence = 150.00;
	float speed = 6.0;
	uv = wobble(uv,amplitude,frequence,speed);
	fragColor = texture(iChannel0,uv);
    gl_FragColor.a = flixel_texture2D(bitmap, openfl_TextureCoordv).a;
}