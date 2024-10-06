// -*- mode: C; -*-
#version 330 core

in VS_OUT {
    float flogz;
    vec2 texcoord;
    vec3 vertex_normal;
    vec3 view_vector;
} fs_in;

uniform sampler2D color_tex;

uniform vec3 emissive_color;
uniform float emissive_factor;
uniform float emissive_offset;

// gbuffer_pack.glsl
void gbuffer_pack_pbr_opaque(vec3 normal,
                             vec3 base_color,
                             float metallic,
                             float roughness,
                             float occlusion,
                             vec3 emissive);
// color.glsl
vec3 eotf_inverse_sRGB(vec3 srgb);
// normalmap.glsl
vec3 perturb_normal(vec3 N, vec3 V, vec2 texcoord);
// logarithmic_depth.glsl
float logdepth_encode(float z);

void main()
{
    vec3 texel = texture(color_tex, fs_in.texcoord).rgb;
    vec3 color = eotf_inverse_sRGB(texel);
    vec3 N = normalize(fs_in.vertex_normal);
    vec3 emissive = 7.0 * emissive_factor * emissive_color * (color + vec3(emissive_offset));

    gbuffer_pack_pbr_opaque(N, color, 0.0, 1.0, 1.0, emissive);
    gl_FragDepth = logdepth_encode(fs_in.flogz);
}
