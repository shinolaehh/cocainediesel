#include "include/uniforms.glsl"
#include "include/common.glsl"
#include "include/fog.glsl"

layout( std140 ) uniform u_Outline {
	vec4 u_OutlineColor;
};

#if MSAA
uniform sampler2DMS u_DepthTexture;
uniform usampler2DMS u_MaskTexture;
#else
uniform sampler2D u_DepthTexture;
uniform usampler2D u_MaskTexture;
#endif

#if VERTEX_SHADER

in vec4 a_Position;

void main() {
	gl_Position = a_Position;
}

#else

out vec4 f_Albedo;

float edgeDetect( float center, float up, float down_left, float down_right, float epsilon ) {
	float delta = 4.0 * center - 2.0 * up - down_left - down_right;
	return smoothstep( 0.0, epsilon, abs( delta ) );
}

const uint MASK_CURVED = 1u;

void main() {
	ivec2 p = ivec2( gl_FragCoord.xy );
	ivec3 pixel = ivec3( 0, 1, -1 );
	float edgeness = 0.0;
	float avg_depth = 0.0;
#if MSAA
	for( int i = 0; i < u_Samples; i++ )
#else
	const int i = 0;
#endif
	{
		float depth =            texelFetch( u_DepthTexture, p, i ).r;
		float depth_up =         texelFetch( u_DepthTexture, p + pixel.xz, i ).r;
		float depth_down_left =  texelFetch( u_DepthTexture, p + pixel.yy, i ).r;
		float depth_down_right = texelFetch( u_DepthTexture, p + pixel.zy, i ).r;

		uint mask = texelFetch( u_MaskTexture, p, i ).r;
		float epsilon = ( mask & MASK_CURVED ) == MASK_CURVED ? 0.005 : 0.00001;
		edgeness += edgeDetect( depth, depth_up, depth_down_left, depth_down_right, epsilon );
		avg_depth += depth + depth_up + depth_down_left + depth_down_right;
	}
#if MSAA
	edgeness /= u_Samples;
	avg_depth /= u_Samples * 4.0;
#else
	avg_depth /= 4.0;
#endif
	vec2 clamping = clamp( u_ViewportSize - abs( u_ViewportSize - gl_FragCoord.xy * 2.0 ), 1.0, 2.0 ) - 1.0;
	edgeness *= min( clamping.x, clamping.y );
	if( edgeness < 0.1 ) {
		discard;
	}
	edgeness = FogAlpha( edgeness, LinearizeDepth( avg_depth ) );
	edgeness = VoidFogAlpha( edgeness, gl_FragCoord.xy, avg_depth );
	f_Albedo = edgeness * u_OutlineColor;
}

#endif
