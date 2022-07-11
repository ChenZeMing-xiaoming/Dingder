Shader "Unlit/Mohu"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _dis("_dis",float) = 0.001
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
            float _dis;

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
                i.uv.x+=_dis;
                 col += tex2D(_MainTex, i.uv);
                i.uv.x-=_dis;
                 col += tex2D(_MainTex, i.uv);
                i.uv.y+=_dis;
                 col += tex2D(_MainTex, i.uv);
                i.uv.y-=_dis;
                 col += tex2D(_MainTex, i.uv);
                i.uv.xy+=_dis;
                 col += tex2D(_MainTex, i.uv);
                i.uv.xy-=_dis;
                 col += tex2D(_MainTex, i.uv);
                i.uv.x+=_dis;
                i.uv.y-=_dis;
                 col += tex2D(_MainTex, i.uv);
                i.uv.x-=_dis;
                i.uv.y+=_dis;
                 col += tex2D(_MainTex, i.uv);
                return col/9;
            }
            ENDCG
        }
    }
}
