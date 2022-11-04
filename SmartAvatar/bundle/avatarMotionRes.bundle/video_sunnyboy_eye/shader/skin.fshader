material {
    name : skin,
    requires : [ uv0, uv1, color,tangents ],
    shadingModel : subsurface,
    blending : opaque,
    depthWrite : true,
    doubleSided : false,
    flipUV : false,
    specularAmbientOcclusion: simple,
    parameters : [
        {
            type : float4,
            name : baseColorFactor,
            ls_editor : {
              defaultValue: [1,1,1,1],
              uiType: "color",
              label:"颜色"
            }
        },
        {
            type : bool,
            name : baseColorEnableTexture,
            ls_editor : {
              defaultValue: false,
              label:"颜色纹理"
            }
        },
        {
            type : sampler2d,
            name : baseColorMap,
            ls_editor : {
              defaultValue: "",
              showIfKey: "baseColorEnableTexture",
              uiType: "file",
              label:" - 贴图",
              fileType: ["ImageData", "PAGFileData", "RenderTarget", "EnvMap_KTX"]
            }
        },
        {
            type : int,
            name : baseColorIndex,
            ls_editor : {
              defaultValue: 0,
              uiType: "enum",
              showIfKey: "baseColorEnableTexture",
              enum: [{
                  label:"UV0",
                  value: 0
              },{
                  label:"UV1",
                  value: 1
              }],
              label:" - UV集"
            }
        },
        {
            type : bool,
            name : baseColorTexturePremultiplied,
            ls_editor : {
              defaultValue: false,
              showIfKey: "baseColorEnableTexture",
              label:" - 已预乘",
            }
        },
        {
            type : mat3,
            name : baseColorUvMatrix,
            ls_editor : {
              defaultValue: [1,0,0,0,1,0,0,0,1],
              uiHidden: true
            }
        },

        {
            type : float,
            name : metallicFactor,
            ls_editor : {
              defaultValue: 0,
              uiType:"float",
              label: "金属度",
              numberStep: 0.01,
              numberRangeFrom: 0,
              numberRangeTo: 1
            }
        },
        {
            type : float,
            name : roughnessFactor,
            ls_editor : {
              defaultValue: 0,
              label:"粗糙度",
              numberStep: 0.01,
              numberRangeFrom: 0,
              numberRangeTo: 1
            }
        },
        
        {
            type : sampler2d,
            name : RACMap,
            ls_editor : {
              defaultValue: "",
              uiType: "file",
              label:" RAC贴图",
              fileType: ["ImageData", "PAGFileData", "RenderTarget", "EnvMap_KTX"]
            }
        },
        {
            type : int,
            name : RoughnessIndex,
            ls_editor : {
              defaultValue: 0,
              uiType: "enum",
              enum: [{
                  label:"UV0",
                  value: 0
              },{
                  label:"UV1",
                  value: 1
              }],
              label:" - UV集"
            }
        },


        {
            type : mat3,
            name : RoughnessUvMatrix,
            ls_editor : {
                defaultValue: [1,0,0,0,1,0,0,0,1],
                uiHidden : true
            }
        },
        
        {
            type : float,
            name : aoStrength,
            ls_editor : {
              defaultValue: 1,
              numberStep: 0.01,
              numberRangeFrom: 0,
              numberRangeTo: 1,
              label: " - AO强度"
            }
        },
        {
            type : mat3,
            name : occlusionUvMatrix,
            ls_editor : {
                defaultValue: [1,0,0,0,1,0,0,0,1],
                uiHidden : true
            }
        },

        {
            type : bool,
            name : normalEnableTexture,
            ls_editor : {
              defaultValue: false,
              label: "法线纹理"
            }
        },
        {
            type : sampler2d,
            name : normalMap,
            ls_editor : {
              defaultValue: "",
              showIfKey: "normalEnableTexture",
              uiType: "file",
              label:" - 贴图",
              fileType: ["ImageData", "PAGFileData", "RenderTarget", "EnvMap_KTX"]
            }
        },
        {
            type : int,
            name : normalIndex,
            ls_editor : {
              defaultValue: -1,
              showIfKey: "normalEnableTexture",
              label: " - UV集",
              uiType: "enum",
              enum: [{
                  label:"UV0",
                  value: 0
              },{
                  label:"UV1",
                  value: 1
              }]
            }
        },
        {
            type : float,
            name : normalScale,
            ls_editor : {
              defaultValue: 1,
              showIfKey: "normalEnableTexture",
              label: " - Scale",
              uiType: "float",
              numberStep: 0.01,
              numberRangeFrom: 0,
              numberRangeTo: 1
            }
        },
        {
            type : bool,
            name : normalEnableGReverse,
            ls_editor : {
              defaultValue: false,
              showIfKey: "normalEnableTexture",
              label: " - G通道反转"
            }
        },

        {
            type : mat3,
            name : normalUvMatrix,
            ls_editor : {
                defaultValue: [1,0,0,0,1,0,0,0,1],
                uiHidden : true
            }
        },
        {
            type : float4,
            name : emissiveFactor,
            ls_editor : {
              defaultValue: [0,0,0,1],
              uiType: "color",
              label: "自发光"
            }
        },
        {
            type : bool,
            name : emissiveEnableTexture,
            ls_editor : {
              defaultValue: false,
              label: "自发光纹理"
            }
        },
        {
            type : sampler2d,
            name : emissiveMap,
            ls_editor : {
              defaultValue : "",
              showIfKey: "emissiveEnableTexture",
              uiType: "file",
              label:" - 贴图",
              fileType: ["ImageData", "PAGFileData", "RenderTarget", "EnvMap_KTX"]
            }
        },
        {
            type : int,
            name : emissiveIndex,
            ls_editor : {
              defaultValue: -1,
              showIfKey: "emissiveEnableTexture",
              label: " - UV集",
              uiType: "enum",
              enum: [{
                  label:"UV0",
                  value: 0
              },{
                  label:"UV1",
                  value: 1
              }]
            }
        },
        {
            type : float,
            name : emissiveStrength,
            ls_editor : {
              defaultValue: 1,
              label: " - 强度",
              uiType: "float",
              numberStep: 1,
              numberRangeFrom: 0,
              numberRangeTo: 255
            }
        },
        {
            type : mat3,
            name : emissiveUvMatrix,
            ls_editor : {
                defaultValue: [1,0,0,0,1,0,0,0,1],
                uiHidden : true
            }
        },
        {
            type : bool,
            name : emissiveEnableTextureColorMultiply,
            ls_editor : {
              defaultValue: true,
              showIfKey: "emissiveEnableTexture",
              label: " - 预乘"
            }
        },

        {
            type : float,
            name : sssPower,
            ls_editor : {
              defaultValue: 12.234,
              label: " sssPower",
              uiType: "float",
              numberStep: 0.01,
              numberRangeFrom: 0,
              numberRangeTo: 20
            }
        },

        {
            type : float4,
            name : sssColor,
            ls_editor : {
              defaultValue: [1.0,1.0,1.0,1.0],
              uiType: "color",
              label: "sssColor"
            }
        },

      
        
      {
            type : float,
            name : sssThickness,
            ls_editor : {
              defaultValue: 1,
              label: " sssThickness",
              uiType: "float",
              numberStep: 0.01,
              numberRangeFrom: -5,
              numberRangeTo: 5
            }
        }
    ]
}

fragment {

    void material(inout MaterialInputs material) {
        highp float2 uvs[2];
        uvs[0] = getUV0();
        uvs[1] = getUV1();

        if (materialParams.normalEnableTexture) {
            highp float2 uv = uvs[materialParams.normalIndex];
            uv = (vec3(uv, 1.0) * materialParams.normalUvMatrix).xy;
            material.normal = texture(materialParams_normalMap, uv).xyz * 2.0 - 1.0;
            if (materialParams.normalEnableGReverse){
              material.normal.y = 1.0 - material.normal.y;
            }
            material.normal.xy *= materialParams.normalScale;
        }

        prepareMaterial(material);
        material.baseColor = materialParams.baseColorFactor;

        if (materialParams.baseColorEnableTexture) {
            highp float2 uv = uvs[materialParams.baseColorIndex];
            uv = (vec3(uv, 1.0) * materialParams.baseColorUvMatrix).xy;
            material.baseColor *= texture(materialParams_baseColorMap, uv);
        }
        #if defined(BLEND_MODE_TRANSPARENT)
        if (!materialParams.baseColorTexturePremultiplied) {
            material.baseColor.rgb *= material.baseColor.a;
        }
        #endif
        material.baseColor *= getColor();

        material.roughness = materialParams.roughnessFactor;
        material.metallic = materialParams.metallicFactor;

        // KHR_materials_clearcoat forbids clear coat from
        // being applied in the specular/glossiness model
        vec4 rac = texture(materialParams_RACMap, uvs[0]);
        material.roughness *= rac.r;

        material.ambientOcclusion =rac.g * materialParams.aoStrength;

        material.emissive = vec4(materialParams.emissiveFactor.rgb * materialParams.emissiveStrength, 0.0);
        if (materialParams.emissiveEnableTexture) {
            highp float2 uv = uvs[materialParams.emissiveIndex];
            uv = (vec3(uv, 1.0) * materialParams.emissiveUvMatrix).xy;
            if (materialParams.emissiveEnableTextureColorMultiply) {
              material.emissive.rgb *= texture(materialParams_emissiveMap, uv).rgb;
            } else {
              material.emissive.rgb = materialParams.emissiveStrength * texture(materialParams_emissiveMap, uv).rgb;
            }
        }
        material.subsurfacePower =materialParams.sssPower;
        material.subsurfaceColor = materialParams.sssColor.rgb;
        //material.subsurfaceColor = float3(1.0,0.0,0.0);
        material.thickness = materialParams.sssThickness * rac.b;
    }

        
           

    }