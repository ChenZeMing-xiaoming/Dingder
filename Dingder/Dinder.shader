Shader "Dinder" 
{  
    Properties
    {
        _MainTex ("_MainTex", 2D) = "white" {}

        a12 ("a12", 2D) = "white" {}
        a1 ("a1", 2D) = "white" {}


        a13 ("a13", 2D) = "white" {}

        a121("a121",Color)=(1,1,1,1)

        b121("b121",float)=1

        b12("b12",int )=60
    }
 SubShader {  
  Pass{  
   CGPROGRAM  
   #pragma vertex vert  
   #pragma fragment frag  
   #include "UnityCG.cginc"  
    #pragma enable_d3d11_debug_symbols
   sampler2D _CameraDepthTexture; 
    struct appdata
     {
        float4 vertex : POSITION;
         float2 uv : TEXCOORD0;
      };

   struct v2f 
   {  

      float4 pos : SV_POSITION;  
      float2 uv : TEXCOORD0;
      float4 scrPos:TEXCOORD1;  
   };  
    sampler2D _MainTex;
    float4 _MainTex_ST;


    sampler2D a12;
    float4 _DepthMap_ST;

    sampler2D a1;
    sampler2D a13;
    float4 a121;
   float b121;
    float4x4  df12;
    float4x4 dfc12;

    float s123;
    int b12;
   v2f vert (appdata v)
   {  
      v2f f;      
      f.pos = UnityObjectToClipPos (v.vertex);  
      f.scrPos=ComputeScreenPos(f.pos);  
      f.uv = TRANSFORM_TEX(v.uv, _MainTex);
      return f;  
   }  

   float4 Glc(float2 c12,float2 uv){
         float gf2=_ProjectionParams.y+(_ProjectionParams.z-_ProjectionParams.y)*c12;
         float cw3 = 2 * gf2 / unity_CameraProjection._m11;                 
         float cc1 = _ScreenParams.x / _ScreenParams.y * cw3;
         float a2315 = cc1 * uv.x - cc1 / 2;  
         float a231 = cw3 * uv.y - cw3 / 2; 
         float4 cwe=float4(a2315,a231,gf2,1);
         float4 csd = mul(unity_CameraToWorld, cwe);  
         return csd;
   }

   fixed4 frag (v2f f) : SV_Target
   {  
     float c12 = SAMPLE_DEPTH_TEXTURE(a12, f.uv);
     float c1=Linear01Depth(c12);

     float4 c41 = tex2D(a13, f.uv);
     float d41=min(c41.g,c41.r) ;
     float w12= clamp(c1,d41,max(c41.g,c41.r));
     float3 o12 =Glc(d41,f.uv).xyz;
     float4 i1 =Glc(w12,f.uv);
     i1.w = 1;
     float3 i14 = (i1.xyz- o12)/60;
     fixed u11=step( step(w12, d41),0);


      
      float4 u15 =float4(0,0,0,0);

      float4 u234 =float4(0,0,0,0);

      float4 y12 =float4(0,0,0,0);

      float3 y1 =float3(0,0,0);

      float y145 =0;

      float a312=0;

      fixed c196=0;

      fixed3 c112=tex2D(_MainTex, f.uv).rgb;

      fixed3 c114=a121.rgb;

     fixed3 d114= c112;

    float4 e114=float4(0,0,0,0);

     float f13=0;

     float2 h13=float2(0,0);

     float g13=0;

     float a174=0;

     float2 a111=float2(0,0);

       u15 =mul(df12,i1);

       u234 =mul(dfc12,u15);

       y12 =u234/u234.w;
    
       y1 =y12/2+0.5;

       a312=(Linear01Depth(y12.z));



       i1.rgb = o12; 

       e114 =mul(df12,i1);
       g13=(u15.z -e114.z)/60;

       u234 =mul(dfc12,e114);

       y12 =u234/u234.w;
    
       h13 =y12/2+0.5;
       a111=(y1-h13)/60;

       f13=Linear01Depth(y12.z);
       a174= (a312-f13)/60;


       int a118=0;

    if(u11!=0){
        [unroll(60)]
      for(int i=1;i<=60;i++){

       y145 =Linear01Depth(SAMPLE_DEPTH_TEXTURE(a1,y1.xy-i*a111));

       c196 =step(a312-i*a174,y145);

       c114=c196*a121.rgb*step(a118,b12);

       c114+=step(c196,0)*d114;

       d114= d114+(c114-d114)*b121*clamp((s123 + u15.z - i*g13 + 20)/s123,0,0.75);

       a118+=c196;
     }
    }

      return fixed4(d114,1);

   }  
   ENDCG  
  }  
 }  
 FallBack "Diffuse"  
}
