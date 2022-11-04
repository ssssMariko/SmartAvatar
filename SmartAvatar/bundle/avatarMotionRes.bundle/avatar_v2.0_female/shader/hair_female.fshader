material {
    name : hair,
    requires : [ uv0, uv1, color,tangents ],
    shadingModel : lit,
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
            type : bool,
            name : metallicRoughnessEnableTexture,
            ls_editor : {
              defaultValue: false,
              label: "金属度粗糙度纹理"
            }
        },
        {
            type : sampler2d,
            name : metallicRoughnessMap,
            ls_editor : {
              defaultValue: "",
              showIfKey: "metallicRoughnessEnableTexture",
              uiType: "file",
              label:" - 贴图",
              fileType: ["ImageData", "PAGFileData", "RenderTarget", "EnvMap_KTX"]
            }
        },
        {
            type : int,
            name : metallicRoughnessIndex,
            ls_editor : {
              defaultValue: 0,
              showIfKey: "metallicRoughnessEnableTexture",
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
            type : int,
            name : metallicSamplingChannel,
            ls_editor : {
              defaultValue: 2,
              showIfKey: "metallicRoughnessEnableTexture",
              uiType: "enum",
              enum: [
                  {
                      label:"r",
                      value: 0
                  },{
                      label:"g",
                      value: 1
                  },{
                      label:"b",
                      value: 2
                  }],
              label:" - 金属度通道",
            }
        },

        {
            type : int,
            name : roughnessSamplingChannel,
            ls_editor : {
              defaultValue: 1,
              showIfKey: "metallicRoughnessEnableTexture",
              uiType: "enum",
              enum: [
                  {
                      label:"r",
                      value: 0
                  },{
                      label:"g",
                      value: 1
                  },{
                      label:"b",
                      value: 2
                  }],
              label:" - 粗糙度通道",
            }
        },

        {
            type : mat3,
            name : metallicRoughnessUvMatrix,
            ls_editor : {
                defaultValue: [1,0,0,0,1,0,0,0,1],
                uiHidden : true
            }
        },
        {
            type : bool,
            name : aoEnableTexture,
            ls_editor : {
              defaultValue: false,
              label: "AO纹理"
            }
        },
        {
            type : sampler2d,
            name : occlusionMap,
            ls_editor : {
              defaultValue: "",
              showIfKey: "aoEnableTexture",
              uiType: "file",
              label:" - 贴图",
              fileType: ["ImageData", "PAGFileData", "RenderTarget", "EnvMap_KTX"]
            }
        },
        {
            type : int,
            name : aoIndex,
            ls_editor : {
              defaultValue: 0,
              showIfKey: "aoEnableTexture",
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
            type : int,
            name : aoSamplingChannel,
            ls_editor : {
              defaultValue: 0,
              showIfKey: "aoEnableTexture",
              uiType: "enum",
              enum: [
                  {
                      label:"r",
                      value: 0
                  },{
                      label:"g",
                      value: 1
                  },{
                      label:"b",
                      value: 2
                  }],
              label:" - Channel"
            }
        },
        {
            type : float,
            name : aoStrength,
            ls_editor : {
              defaultValue: 1,
              showIfKey: "aoEnableTexture",
              numberStep: 0.01,
              numberRangeFrom: 0,
              numberRangeTo: 1,
              label: " - 强度"
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
            name : anisotropy,
            ls_editor : {
              defaultValue: 0,
              uiType:"float",
              label: "各向异性强度",
              numberStep: 0.01,
              numberRangeFrom: 0,
              numberRangeTo: 1
            }
        },
        {
            type : sampler2d,
            name : noiseMap,
            ls_editor : {
              defaultValue : "",
              uiType: "file",
              label:" - 噪声贴图",
              fileType: ["ImageData", "PAGFileData", "RenderTarget", "EnvMap_KTX"]
            }
        },

        {
            type : float,
            name : Jitter,
            ls_editor : {
              defaultValue: 0.05,
              label: " - Jitter",
              uiType: "float",
              numberStep: 0.01,
              numberRangeFrom: 0,
              numberRangeTo: 1
            }
        },


        {
            type : float3,
            name : lightdir,
            ls_editor : {
              defaultValue: [1,1,1],
              uiType: "float3",
              label:"light direction"
            }
        },

        {
            type : float,
            name : highlightA_offset,
            ls_editor : {
              defaultValue: 0.05,
              label: " - highlightA_offset",
              uiType: "float",
              numberStep: 0.01,
              numberRangeFrom: -5,
              numberRangeTo: 5
            }
        },

        {
            type : float,
            name : highlightA_shininess,
            ls_editor : {
              defaultValue: 0.01,
              label: " - highlightA_shininess",
              uiType: "float",
              numberStep: 0.01,
              numberRangeFrom: 0.01,
              numberRangeTo: 0.5
            }
        },


      {
            type : float,
            name : highlightA_Strength,
            ls_editor : {
              defaultValue: 20,
              label: " - highlightA_Strength",
              uiType: "float",
              numberStep: 0.01,
              numberRangeFrom: 0,
              numberRangeTo: 0.2
            }
        },


         {
            type : float,
            name : highlightB_offset,
            ls_editor : {
              defaultValue: 0.05,
              label: " - highlightB_offset",
              uiType: "float",
              numberStep: 0.01,
              numberRangeFrom: -5,
              numberRangeTo: 5
            }
        },

        {
            type : float,
            name : highlightB_shininess,
            ls_editor : {
              defaultValue: 0.01,
              label: " - highlightB_shininess",
              uiType: "float",
              numberStep: 0.01,
              numberRangeFrom: 0.01,
              numberRangeTo: 0.5
            }
        },


      {
            type : float,
            name : highlightB_Strength,
            ls_editor : {
              defaultValue: 20,
              label: " - highlightB_Strength",
              uiType: "float",
              numberStep: 0.01,
              numberRangeFrom: 0,
              numberRangeTo: 0.2
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

        if (materialParams.metallicRoughnessEnableTexture) {
            highp float2 uv = uvs[materialParams.metallicRoughnessIndex];
            uv = (vec3(uv, 1.0) * materialParams.metallicRoughnessUvMatrix).xy;

            vec4 mr = texture(materialParams_metallicRoughnessMap, uv);
            material.roughness *= mr[materialParams.roughnessSamplingChannel];
            material.metallic *= mr[materialParams.metallicSamplingChannel];
        }

        if (materialParams.aoEnableTexture) {
            highp float2 uv = uvs[materialParams.aoIndex];
            uv = (vec3(uv, 1.0) * materialParams.occlusionUvMatrix).xy;
            material.ambientOcclusion = texture(materialParams_occlusionMap, uv)[materialParams.aoSamplingChannel] * materialParams.aoStrength;
        }

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

        material.anisotropy =materialParams.anisotropy;
        //rim
        float3 rimcolor = pow5(1.0 - saturate(0.1 + getNdotV())) * 0.3 * float3(0.3,0.4,1.0);
        material.baseColor += float4(rimcolor,1.0);
        float jitter = texture(materialParams_noiseMap,float2(uvs[0].x,0)).r;
        jitter = materialParams.Jitter + ((-materialParams.Jitter)  - materialParams.Jitter) * jitter;

        //direction
        float3 binormal = getWorldTangentFrame()[1];
        float3 tangent = getWorldTangentFrame()[0];
        float3 H = normalize(normalize(materialParams.lightdir) + getWorldViewVector());
        float NdotH = dot(material.normal,H);
        float TdotH = dot(tangent,H);

        //Specular A
        float3 binormalA = normalize(binormal + (material.normal * jitter + materialParams.highlightA_offset));
        float BdotHA = dot(H,binormalA) / materialParams.highlightA_shininess;
        float specA =exp(-( TdotH * TdotH + BdotHA * BdotHA) / (1.0 + NdotH) )* materialParams.highlightA_Strength;
           // material.baseColor += specA;

        //Specular B
        float3 binormalB = normalize(binormal + (material.normal * jitter + materialParams.highlightB_offset));
        float BdotHB = dot(H,binormalB) / materialParams.highlightB_shininess;
        float specB =exp(-( TdotH * TdotH + BdotHB * BdotHB) / (1.0 + NdotH) )* materialParams.highlightB_Strength;
        material.baseColor = specA + specB + material.baseColor;

    }
}