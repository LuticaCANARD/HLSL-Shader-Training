﻿Shader "Custom/TNPT"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Cube ("cubemap",Cube) = " "{}
        _Alpha ("Alpha", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows vertex:vert alpha:blend
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0
        
        
        samplerCUBE _Cube;

        sampler2D _MainTex;
        struct Input
        {
            float2 uv_MainTex;
            //samplerCUBE _Cube;
            float3 worldRefl;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float _Alpha;


        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)
        float4 Lightingwater(SurfaceOutput s,float3 lightDir,float3 view,float atten)
        {
            float rim = saturate(dot(s.Normal,view));
            rim = pow(1-rim,3);
            return float4(rim,rim,rim,1);
        }
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float4 refl = texCUBE(_Cube,IN.worldRefl);
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Emission = refl.rgb*c.rgb;
            //o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = 0;
            o.Smoothness = _Glossiness;
            o.Alpha = _Alpha;

        }
        void vert(inout appdata_full v)
        {
        if(v.vertex.y > 0 && v.vertex.z>0 )
            v.vertex.y += sin(_Time);
        }


        
        ENDCG
    }
    FallBack "Diffuse"
}
