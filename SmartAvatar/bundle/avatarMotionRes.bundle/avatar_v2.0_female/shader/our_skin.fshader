material {
    name : skin,
    requires : [ uv0, uv1, color ],
    shadingModel : lit,
    blending : masked,
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
          type: bool,
          name: eyesMakeupEnableTexture,
          ls_editor: {
            defaultValue: false,
            label: "眼妆纹理"
          }
        },
        {
          type: sampler2d,
          name: eyesMakeupMap,
          ls_editor: {
            defaultValue: "",
            showIfKey: "eyesMakeupEnableTexture",
            uiType: "file",
            label: " - 贴图",
            fileType: ["ImageData", "PAGFileData", "RenderTarget", "EnvMap_KTX"]
          }
        },
        {
          type: int,
          name: eyesMakeupIndex,
          ls_editor: {
            defaultValue: 0,
            uiType: "enum",
            uiHidden: true,
            showIfKey: "eyesMakeupEnableTexture",
            enum: [{
              label: "UV0",
              value: 0
            }],
            label: " - UV集"
          }
        },
        {
          type: mat3,
          name: eyesMakeupUvMatrix,
          ls_editor: {
            defaultValue: [1, 0, 0, 0, 1, 0, 0, 0, 1],
            uiHidden: true
          }
        },
        {
        	type: bool,
        	name: faceMakeupEnableTexture,
        	ls_editor: {
        		defaultValue: false,
        		label: "面妆纹理"
        	}
        },
        {
        	type: sampler2d,
        	name: faceMakeupMap,
        	ls_editor: {
        		defaultValue: "",
        		showIfKey: "faceMakeupEnableTexture",
        		uiType: "file",
        		label: " - 贴图",
        		fileType: ["ImageData", "PAGFileData", "RenderTarget", "EnvMap_KTX"]
        	}
        },
        {
        	type: int,
        	name: faceMakeupIndex,
        	ls_editor: {
        		defaultValue: 0,
        		uiType: "enum",
        		uiHidden: true,
        		showIfKey: "faceMakeupEnableTexture",
        		enum: [{
        			label: "UV0",
        			value: 0
        		}],
        		label: " - UV集"
        	}
        },
        {
        	type: mat3,
        	name: faceMakeupUvMatrix,
        	ls_editor: {
        		defaultValue: [1, 0, 0, 0, 1, 0, 0, 0, 1],
        		uiHidden: true
        	}
        },
        {
          type: bool,
          name: lipMakeupEnableTexture,
          ls_editor: {
            defaultValue: false,
            label: "唇色纹理"
          }
        },
        {
          type: sampler2d,
          name: lipMakeupMap,
          ls_editor: {
            defaultValue: "",
            showIfKey: "lipMakeupEnableTexture",
            uiType: "file",
            label: " - 贴图",
            fileType: ["ImageData", "PAGFileData", "RenderTarget", "EnvMap_KTX"]
          }
        },
        {
          type: int,
          name: lipMakeupIndex,
          ls_editor: {
            defaultValue: 0,
            uiType: "enum",
            uiHidden: true,
            showIfKey: "lipMakeupEnableTexture",
            enum: [{
              label: "UV0",
              value: 0
            }],
            label: " - UV集"
          }
        },
        {
          type: mat3,
          name: lipMakeupUvMatrix,
          ls_editor: {
            defaultValue: [1, 0, 0, 0, 1, 0, 0, 0, 1],
            uiHidden: true
          }
        },
        {
          type: bool,
          name: baseBeardEnableTexture,
          ls_editor: {
            defaultValue: false,
            label: "胡须纹理"
          }
        },
        {
          type: sampler2d,
          name: baseBeardMap,
          ls_editor: {
            defaultValue: "",
            showIfKey: "baseBeardEnableTexture",
            uiType: "file",
            label: " - 贴图",
            fileType: ["ImageData", "PAGFileData", "RenderTarget", "EnvMap_KTX"]
          }
        },
        {
          type: int,
          name: baseBeardIndex,
          ls_editor: {
            defaultValue: 0,
            uiType: "enum",
            uiHidden: true,
            showIfKey: "baseBeardEnableTexture",
            enum: [{
              label: "UV0",
              value: 0
            }],
            label: " - UV集"
          }
        },
        {
          type: mat3,
          name: baseBeardUvMatrix,
          ls_editor: {
            defaultValue: [1, 0, 0, 0, 1, 0, 0, 0, 1],
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
            type : mat3,
            name : metallicRoughnessUvMatrix,
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
            name : clearCoatFactor,
            ls_editor : {
              defaultValue: 0,
              uiHidden : true
            }
        },
        {
            type : bool,
            name : clearCoatRoughnessEnableTexture,
            ls_editor : {
              defaultValue: false,
              uiHidden : true
            }
        },
        {
            type : int,
            name : clearCoatRoughnessIndex,
            ls_editor : {
              defaultValue: -1,
              uiHidden : true
            }
        },
        {
            type : float,
            name : clearCoatRoughnessFactor,
            ls_editor : {
              defaultValue: 0,
              uiHidden : true
            }
        },
        {
            type : sampler2d,
            name : clearCoatRoughnessMap,
            ls_editor : {
                defaultValue: "",
                uiHidden : true
            }
        },
        {
            type : mat3,
            name : clearCoatRoughnessUvMatrix,
            ls_editor : {
              defaultValue: [1,0,0,0,1,0,0,0,1],
              uiHidden : true
            }
        },
        {
            type : bool,
            name : clearCoatNormalEnableTexture,
            ls_editor : {
              defaultValue: false,
              uiHidden : true
            }
        },
        {
            type : float,
            name : clearCoatNormalScale,
            ls_editor : {
              defaultValue: 1,
              uiHidden : true
            }
        },
        {
            type : int,
            name : clearCoatNormalIndex,
            ls_editor : {
              defaultValue: 0,
              uiHidden : true
            }
        },
        {
            type : sampler2d,
            name : clearCoatNormalMap,
            ls_editor : {
                defaultValue: "",
                uiHidden : true
            }
        },
        {
            type : mat3,
            name : clearCoatNormalUvMatrix,
            ls_editor : {
                defaultValue: [1,0,0,0,1,0,0,0,1],
                uiHidden : true
            }
        }
    ]
}

fragment {
    void material(inout MaterialInputs material) {
        highp float2 uvs[2];
        uvs[0] = getUV0();
        uvs[1] = getUV1();

        if (materialParams.clearCoatNormalEnableTexture) {
            highp float2 uv = uvs[materialParams.clearCoatNormalIndex];
            uv = (vec3(uv, 1.0) * materialParams.clearCoatNormalUvMatrix).xy;
            material.clearCoatNormal = texture(materialParams_clearCoatNormalMap, uv).xyz * 2.0 - 1.0;
            material.clearCoatNormal.xy *= materialParams.clearCoatNormalScale;
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
        if (materialParams.eyesMakeupEnableTexture) {
            highp float2 uv = uvs[materialParams.eyesMakeupIndex];
            uv = (vec3(uv, 1.0) * materialParams.eyesMakeupUvMatrix).xy;
            material.baseColor *= texture(materialParams_eyesMakeupMap, uv);
        }
        if (materialParams.faceMakeupEnableTexture) {
            highp float2 uv = uvs[materialParams.faceMakeupIndex];
            uv = (vec3(uv, 1.0) * materialParams.faceMakeupUvMatrix).xy;
            material.baseColor *= texture(materialParams_faceMakeupMap, uv);
        }
        if (materialParams.lipMakeupEnableTexture) {
            highp float2 uv = uvs[materialParams.lipMakeupIndex];
            uv = (vec3(uv, 1.0) * materialParams.lipMakeupUvMatrix).xy;
            material.baseColor *= texture(materialParams_lipMakeupMap, uv);
        }
        if (materialParams.baseBeardEnableTexture) {
            highp float2 uv = uvs[materialParams.baseBeardIndex];
            uv = (vec3(uv, 1.0) * materialParams.baseBeardUvMatrix).xy;
            material.baseColor *= texture(materialParams_baseBeardMap, uv);
        }

        material.baseColor *= getColor();

        material.roughness = materialParams.roughnessFactor;
        material.metallic = materialParams.metallicFactor;

        // KHR_materials_clearcoat forbids clear coat from
        // being applied in the specular/glossiness model
        material.clearCoat = materialParams.clearCoatFactor;
        material.clearCoatRoughness = materialParams.clearCoatRoughnessFactor;

        if (materialParams.clearCoatRoughnessEnableTexture) {
            highp float2 uv = uvs[materialParams.clearCoatRoughnessIndex];
            uv = (vec3(uv, 1.0) * materialParams.clearCoatRoughnessUvMatrix).xy;
            material.clearCoatRoughness *= texture(materialParams_clearCoatRoughnessMap, uv).g;
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
    }
}