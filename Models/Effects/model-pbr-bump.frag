// -*- mode: C; -*-
$FG_GLSL_VERSION

in VS_OUT {
    float flogz;
    vec2 texcoord;
    vec3 vertex_normal;
    vec3 view_vector;
} fs_in;

uniform sampler2D base_color_tex;
uniform sampler2D normal_tex;
uniform sampler2D orm_tex;
uniform sampler2D emissive_tex;

uniform vec4 base_color_factor;
uniform float metallic_factor;
uniform float roughness_factor;
uniform vec3 emissive_factor;

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
mat3 cotangent_frame(vec3 N, vec3 p, vec2 uv);
vec3 perturb_normal(vec3 N, vec3 V, vec2 texcoord, sampler2D tex);
vec3 perturb_normal_from_height_factor(vec3 N, vec3 V, float height, float factor);
// logarithmic_depth.glsl
float logdepth_encode(float z);

const ivec3 off = ivec3(-1,0,1);
const vec2 size = vec2(2.0,0.0);
const float scale = 5.0;
float height(vec3 color)
{
    return scale*color.g;
}

void main()
{
    vec4 base_color_texel = texture(base_color_tex, fs_in.texcoord);
    vec3 base_color = eotf_inverse_sRGB(base_color_texel.rgb) * base_color_factor.rgb;
    // Ignore alpha in base color. We assume this is a completely opaque object

    vec3 orm = texture(orm_tex, fs_in.texcoord).rgb;
    float occlusion = orm.r;
    float roughness = orm.g * roughness_factor;
    float metallic = orm.b * metallic_factor;

    vec3 emissive_texel = texture(emissive_tex, fs_in.texcoord).rgb;
    vec3 emissive = eotf_inverse_sRGB(emissive_texel) * emissive_factor;

    vec3 N = normalize(fs_in.vertex_normal);
    //N = perturb_normal_from_height_factor(N, fs_in.view_vector, base_color_texel.g, 0.05);
            float s11 = height(base_color_texel.rgb);
            float s01 = height(textureOffset(base_color_tex, fs_in.texcoord, off.xy).rgb);
            float s21 = height(textureOffset(base_color_tex, fs_in.texcoord, off.zy).rgb);
            float s10 = height(textureOffset(base_color_tex, fs_in.texcoord, off.yx).rgb);
            float s12 = height(textureOffset(base_color_tex, fs_in.texcoord, off.yz).rgb);

            vec3 va = normalize(vec3(size.xy,s21-s01));
            vec3 vb = normalize(vec3(size.yx,s12-s10));
            vec3 normal = vec4(cross(va,vb), s11).xyz;
            //texel.rgb = mix(vec3(1.0), sat_texel.rgb, 4.0*max(normal.r, normal.g));

            mat3 TBN = cotangent_frame(N, fs_in.view_vector, fs_in.texcoord);
            N = normalize(TBN * normal);

    gbuffer_pack_pbr_opaque(N, base_color, metallic, roughness, occlusion, emissive);
    gl_FragDepth = logdepth_encode(fs_in.flogz);
}
