#version 330 core

layout(location = 0) out vec4 fragColor;

in VS_OUT {
    float flogz;
    vec2 texcoord;
    vec3 vertex_normal;
    vec3 view_vector;
    vec4 ap_color;
} fs_in;

uniform sampler2D base_color_tex;
uniform sampler2D normal_tex;
uniform sampler2D orm_tex;
uniform sampler2D emissive_tex;

uniform vec4 base_color_factor;
uniform float metallic_factor;
uniform float roughness_factor;
uniform vec3 emissive_factor;
uniform float alpha_cutoff;

uniform mat4 osg_ViewMatrixInverse;
uniform mat4 osg_ProjectionMatrix;
uniform vec4 fg_Viewport;

// color.glsl
vec3 eotf_inverse_sRGB(vec3 srgb);
// shading_transparent.glsl
vec3 eval_lights_transparent(vec3 base_color,
                             float metallic,
                             float roughness,
                             float occlusion,
                             vec3 emissive,
                             vec3 P, vec3 N, vec3 V,
                             vec4 ap,
                             mat4 view_matrix_inverse);
// normalmap.glsl
vec3 perturb_normal(vec3 N, vec3 V, vec2 texcoord, sampler2D tex);
// logarithmic_depth.glsl
float logdepth_encode(float z);

void main()
{
    vec4 base_color_texel = texture(base_color_tex, fs_in.texcoord);
    vec4 base_color = vec4(eotf_inverse_sRGB(base_color_texel.rgb), base_color_texel.a)
        * base_color_factor;
    if (base_color.a < alpha_cutoff)
        discard;

    vec3 orm = texture(orm_tex, fs_in.texcoord).rgb;
    float occlusion = orm.r;
    float roughness = orm.g * roughness_factor;
    float metallic = orm.b * metallic_factor;

    vec3 emissive_texel = texture(emissive_tex, fs_in.texcoord).rgb;
    vec3 emissive = vec3(0.0);

    if(emissive_factor.r < 0.0) {
        if(base_color.b > 0.0) {
            discard;
        }
        else {
            emissive = -emissive_factor.r*base_color.rgb;
        }
    }
    else {
        emissive = eotf_inverse_sRGB(emissive_texel) * emissive_factor;
    }

    vec3 V = normalize(-fs_in.view_vector);

    vec3 N = normalize(fs_in.vertex_normal);
    N = perturb_normal(N, fs_in.view_vector, fs_in.texcoord, normal_tex);

    vec3 color = eval_lights_transparent(base_color.rgb,
                                         metallic,
                                         roughness,
                                         occlusion,
                                         emissive,
                                         fs_in.view_vector, N, V,
                                         fs_in.ap_color,
                                         osg_ViewMatrixInverse);

    fragColor = vec4(color, base_color.a);
    gl_FragDepth = logdepth_encode(fs_in.flogz);
}
