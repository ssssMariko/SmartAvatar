material {
    name : eye,
    requires : [ uv0, color ],
    shadingModel : lit,
    blending : opaque,
    depthWrite : true,
    doubleSided : false,
    flipUV : false,
    specularAmbientOcclusion: simple,
    parameters : [
        
        

       

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
            name : normalMap,
            ls_editor : {
              defaultValue: "",
              uiType: "file",
              label:"法线贴图",
              fileType: ["ImageData", "PAGFileData", "RenderTarget", "EnvMap_KTX"]
            }
        },

        {
            type : float,
            name : normalScale,
            ls_editor : {
              defaultValue: 1,
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
              label: " - G通道反转"
            }
        },

         {
            type : float,
            name : IrisUVRadius,
            ls_editor : {
              defaultValue: 0.13,
              label: "Iris UV Radius",
              uiType: "float",
              numberStep: 0.01,
              numberRangeFrom: 0.0,
              numberRangeTo: 0.5
            }
        },

        {
            type : float,
            name : ScaleByCenter,
            ls_editor : {
              defaultValue: 2.0,
              label:"Scale By Center",
              numberStep: 0.01,
              numberRangeFrom: 0,
              numberRangeTo: 5
            }
        },
        {
            type : sampler2d,
            name : EyeDirectionWorld,
            ls_editor : {
              defaultValue: "",
              uiType: "file",
              label:"Eye Direction World",
              fileType: ["ImageData", "PAGFileData", "RenderTarget", "EnvMap_KTX"]
            }
        },

         {
            type : float,
            name : LimbusUVWidthColor,
            ls_editor : {
              defaultValue: 0.015,
              label:"LimbusUVWidthColor",
              numberStep: 0.01,
              numberRangeFrom: 0,
              numberRangeTo: 1
            }
        },

         {
            type : float,
            name : LimbusUVWidthShading,
            ls_editor : {
              defaultValue: 0.3,
              label:"LimbusUVWidthShading",
              numberStep: 0.01,
              numberRangeFrom: 0,
              numberRangeTo: 1
            }
        },

       {
            type : float,
            name : DepthScale,
            ls_editor : {
              defaultValue: 1.2,
              label:"DepthScale",
              numberStep: 0.01,
              numberRangeFrom: 0,
              numberRangeTo: 2
            }
        },

        {
            type : float,
            name : PupilScale,
            ls_editor : {
              defaultValue: 0.81,
              label:"PupilScale",
              numberStep: 0.01,
              numberRangeFrom: 0,
              numberRangeTo: 2
            }
        },

        {
            type : sampler2d,
            name : IrisColor,
            ls_editor : {
              defaultValue: "",
              uiType: "file",
              label:"IrisColor",
              fileType: ["ImageData", "PAGFileData", "RenderTarget", "EnvMap_KTX"]
            }
        },

         {
            type : float4,
            name : ScleraTint,
            ls_editor : {
              defaultValue: [1,1,1,1],
              uiType: "color",
              label:"ScleraTint"
            }
        },
        {
            type : sampler2d,
            name : Gradient,
            ls_editor : {
              defaultValue: "",
              uiType: "file",
              label:"Gradient",
              fileType: ["ImageData", "PAGFileData", "RenderTarget", "EnvMap_KTX"]
            }
        },
         {
            type : float4,
            name : GradientScaleAndOffset,
            ls_editor : {
              defaultValue: [1,1,1,1],
              uiType: "float4",
              label:"GradientScaleAndOffset"
            }
        },

        {
            type : sampler2d,
            name : FakeSpecColor,
            ls_editor : {
              defaultValue: "",
              uiType: "file",
              label:"FakeSpecColor",
              fileType: ["ImageData", "PAGFileData", "RenderTarget", "EnvMap_KTX"]
            }
        },

        {
            type : float4,
            name : FakeSpecScaleAndOffset,
            ls_editor : {
              defaultValue: [0.5,0.5,0,0.25],
              uiType: "float4",
              label:"FakeSpecScaleAndOffset"
            }
        }
        
    ]
}

fragment {

    void material(inout MaterialInputs material) {
        highp float2 uvs[1];
        uvs[0] = getUV0();

      
        material.normal = texture(materialParams_normalMap, uvs[0]).xyz * 2.0 - 1.0;
        if (materialParams.normalEnableGReverse){
              material.normal.y = 1.0 - material.normal.y;
        }

        material.normal.xy *= materialParams.normalScale;
        prepareMaterial(material);



        //float depthplaneoffset = texture(materialParams_MidPlaneDisplaceMap,float2(materialParams.IrisUVRadius * materialParams.ScaleByCenter + 0.5 ,0.5)).r;
        float2 depthplaneoffsetUV = ((uvs[0] / materialParams.GradientScaleAndOffset.xy )+ float2(0.5,0.5)) - ( float2(0.5,0.5) / materialParams.GradientScaleAndOffset.xy) + materialParams.GradientScaleAndOffset.zw;
        float3 depthplaneoffset = texture(materialParams_Gradient,depthplaneoffsetUV).xyz;
        depthplaneoffset = depthplaneoffset * ( abs(getWorldViewVector().x) - abs(getWorldViewVector().y));

        float3 EyeDirectionWorld = texture(materialParams_EyeDirectionWorld,uvs[0]).xyz * 2.0 - 1.0;
        EyeDirectionWorld =  float3(dot(EyeDirectionWorld,getWorldTangentFrame()[0]) ,dot(EyeDirectionWorld,getWorldTangentFrame()[1]), dot(EyeDirectionWorld,getWorldTangentFrame()[2]));
        
        //scale uv by center
        float2 UVs = ((uvs[0] / materialParams.ScaleByCenter )+ float2(0.5,0.5)) - ( float2(0.5,0.5) / materialParams.ScaleByCenter);

        // Iris Mask with Limbus Ring falloff
        float2 UV = UVs - float2(0.5, 0.5);
        float2 r = (length(UV) - (materialParams.IrisUVRadius - float2(materialParams.LimbusUVWidthColor,materialParams.LimbusUVWidthShading) ) ) / float2(materialParams.LimbusUVWidthColor,materialParams.LimbusUVWidthShading);
        float2 IrisMask = saturate(1.0 - r);
        IrisMask = smoothstep(0.0, 1.0, IrisMask);
        
        float dot_result1 = pow(dot(getWorldViewVector(), EyeDirectionWorld), 2.0);
        float lerp_result1 = 0.325 + 0.675 * dot_result1;
        //float3 heightW =(max(texture(materialParams_MidPlaneDisplaceMap,uvs[0]).xyz - depthplaneoffset,0.0) * materialParams.DepthScale) / lerp_result1;
        float3 heightW =(depthplaneoffset* ( materialParams.DepthScale)) / lerp_result1;


        //Refraction Direction
        float airIoR = 1.00029;
        float n = airIoR / 1.336;
        float facing = getNdotV();
        float w = n * facing;
        float k = sqrt(1.0+(w-n)*(w+n));
        float3 t;
        t = (w - k)*getWorldNormalVector() - n*getWorldViewVector();
        t = normalize(t);
        float3 rd = -t;
        float3 ScaleRefracted = rd * heightW;

        float3 tangentbias = float3(dot(float3(1.0,0.0,0.0),getWorldTangentFrame()[0]) ,dot(float3(1.0,0.0,0.0),getWorldTangentFrame()[1]), dot(float3(1.0,0.0,0.0),getWorldTangentFrame()[2]));
        float3 nor_re = normalize(tangentbias - dot(tangentbias,EyeDirectionWorld) * EyeDirectionWorld);


        float2 RefractedUVOffset = float2(dot(nor_re, ScaleRefracted) , dot( cross(nor_re,EyeDirectionWorld), ScaleRefracted) );

        float2 RefractedUV = RefractedUVOffset * float2(-1.0,1.0) * materialParams.IrisUVRadius +  UVs;
        RefractedUV = UVs + ( RefractedUV - UVs) * IrisMask.x;

        float2 ScalePupilsUV = (RefractedUV - float2(0.5, 0.5)) / (2.0 * materialParams.IrisUVRadius) + float2(0.5, 0.5);


        // Scale UVs from from unit circle in or out from center
        // float2 UV, float PupilScale

        float2 UVcentered = ScalePupilsUV - float2(0.5, 0.5);
        float UVlength = length(UVcentered);
        // UV on circle at distance 0.5 from the center, in direction of original UV
        float2 UVmax = normalize(UVcentered)*0.5;

        float2 UVscaled = UVmax + (- UVmax)*saturate((1.0 - UVlength*2.0)*materialParams.PupilScale);
        UVscaled += float2(0.5, 0.5);

        float3 IrisColor = texture(materialParams_IrisColor,UVscaled).xyz;
        IrisColor = materialParams.ScleraTint.xyz +(IrisColor - materialParams.ScleraTint.xyz) * IrisMask.x;

        //fake spec
        float2 fakespecUVs = ((uvs[0] / materialParams.FakeSpecScaleAndOffset.xy )+ float2(0.5,0.5)) - ( float2(0.5,0.5) / materialParams.FakeSpecScaleAndOffset.xy) + materialParams.FakeSpecScaleAndOffset.zw;
        float3 fakespecColor = texture(materialParams_FakeSpecColor,fakespecUVs).xyz * 0.8;



        material.baseColor = float4(IrisColor + fakespecColor,1.0);
        material.roughness = materialParams.roughnessFactor;
        material.metallic = materialParams.metallicFactor;





    }
}