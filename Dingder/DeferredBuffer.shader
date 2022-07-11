Shader "Unlit/DeferredBuffer"
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
               Tags{"LightMode" = "Deferred"}
            CGPROGRAM
// Upgrade NOTE: excluded shader from DX11, OpenGL ES 2.0 because it uses unsized arrays
#pragma exclude_renderers d3d11 gles
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

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
            struct FragmentOutput {
    float4 gBuffer0 : SV_Target0;
    float4 gBuffer1 : SV_Target1;
    float4 gBuffer2 : SV_Target2;
    float4 gBuffer3 : SV_Target3;
};
            sampler2D Glo_Tex0;
            sampler2D Glo_Tex1;
            sampler2D Glo_Tex2;
            sampler2D Glo_Tex3;

            float4 _MainTex_ST;




            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            FragmentOutput frag (v2f i )
            {
                FragmentOutput output;
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                 
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return output;
            }
            ENDCG
        }
    }
}
