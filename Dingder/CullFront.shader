Shader "Unlit/CullFront"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Cull Back
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
    #pragma enable_d3d11_debug_symbols

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D ScreenCopyTexture;
            float4 ScreenCopyTexture_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, ScreenCopyTexture);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                return fixed4( Linear01Depth(i.vertex.z),tex2D(ScreenCopyTexture, i.vertex.xy/_ScreenParams.xy).r,0,0);
            }
            ENDCG
        }
    }
}
