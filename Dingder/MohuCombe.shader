Shader "Unlit/MohuCombe"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Scene_tex ("_Scene_tex", 2D) = "white" {}
        _Qiangdu("_Qiangdu",float)=0.1

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work

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
            sampler2D _Scene_tex;
            float4 _Scene_tex_ST;
            float _Qiangdu;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 Scene_col = tex2D(_Scene_tex, i.uv);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return Scene_col+col*_Qiangdu;
            }
            ENDCG
        }
    }
}
