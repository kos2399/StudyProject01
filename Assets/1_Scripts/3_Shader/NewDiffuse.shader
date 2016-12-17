Shader "Custom/NewDiffuse" {
    Properties {
		_Color("Color",Color) = (1.0,1.0,1.0,1.0)
		_MainTex ("Diffuse Texture",2D) = "White"{}
		_AmbientPow("AmbientPow",float) = 0
    }
 //// https://forum.unity3d.com/threads/adding-lighting_coords-makes-unity-3-comment-out-subshader-as-2-x-style.74103///
    SubShader {
 
        Pass {
            Name "ContentBase"
            Tags {"LightMode" = "ForwardBase"}
			
			  LOD 100 
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma multi_compile_fwdbase
                #pragma fragmentoption ARB_precision_hint_fastest
               
                #include "UnityCG.cginc"
                #include "AutoLight.cginc"
               
                struct v2f
                {
                    float4  pos : SV_POSITION;
                    float2  uv : TEXCOORD0;
                    float3  lightDirT : TEXCOORD1;
                    float3  viewDirT : TEXCOORD2;
					float3  mDiffuse: TEXCOORD3;
                    LIGHTING_COORDS(4,5)
                };
 
                v2f vert (appdata_tan v)
                {
                    v2f o;
                    o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                    o.uv = v.texcoord.xy;
					float3 WorldNormal = UnityObjectToWorldNormal(v.normal);

					o.mDiffuse = dot(ObjSpaceLightDir(v.vertex),WorldNormal);
                    TRANSFER_VERTEX_TO_FRAGMENT(o);
                    return o;
                }
               
                sampler2D _MainTex;
             
              uniform float _AmbientPow;
               uniform float4 _Color;
                float4 _LightColor0;
 
                float4 frag(v2f i) : COLOR
                {
              
					float3 diffuse = saturate(i.mDiffuse);
					float3 albedo =  tex2D(_MainTex, i.uv).rgb;
                    float atten = LIGHT_ATTENUATION(i);
					if(diffuse.x <0.5f)
					{
						diffuse += _AmbientPow * albedo.rgb;
						
					}
                    float4 result;
                    result.rgb = albedo*diffuse  * atten * _LightColor0*_Color ;
                    result.a = 0;
                    return result;
                }
            ENDCG
        }
 
        Pass {
            Name "ContentAdd"
            Tags {"LightMode" = "ForwardAdd"}
            Blend One One
			  LOD 100
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma multi_compile_fwdadd
                #pragma fragmentoption ARB_precision_hint_fastest
               
                #include "UnityCG.cginc"
                #include "AutoLight.cginc"
               
          struct v2f
                {
                    float4  pos : SV_POSITION;
                    float2  uv : TEXCOORD0;
                    float3  lightDirT : TEXCOORD1;
                    float3  viewDirT : TEXCOORD2;
					float3  mDiffuse: TEXCOORD3;
                    LIGHTING_COORDS(4,5)
                };
 
                v2f vert (appdata_tan v)
                {
                    v2f o;
                    o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                    o.uv = v.texcoord.xy;
                   // TANGENT_SPACE_ROTATION;
                    //o.lightDirT = mul(rotation, ObjSpaceLightDir(v.vertex));
                    //o.viewDirT = mul(rotation, ObjSpaceViewDir(v.vertex));
					float3 WorldNormal = UnityObjectToWorldNormal(v.normal);

					o.mDiffuse = dot(ObjSpaceLightDir(v.vertex),WorldNormal);
                    TRANSFER_VERTEX_TO_FRAGMENT(o);
                    return o;
                }
               
                sampler2D _MainTex;
             
                uniform float _AmbientPow;
                uniform float4 _Color;
                float4 _LightColor0;
 
                float4 frag(v2f i) : COLOR
                {
              
					float3 diffuse = saturate(i.mDiffuse);
					float3 albedo =  tex2D(_MainTex, i.uv).rgb;
                    float atten = LIGHT_ATTENUATION(i);
					if(diffuse.x <0.5f)
					{
						diffuse += _AmbientPow * albedo.rgb;
						
					}
                    float4 result;
                    result.rgb = albedo*diffuse  * atten * _LightColor0*_Color ;
                    result.a = 0;
                    return result;
                }
            ENDCG
        }
		    Pass
        {
            Tags {"LightMode"="ShadowCaster"}
			LOD 100
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster
            #include "UnityCG.cginc"

            struct vertexOutput { 
                V2F_SHADOW_CASTER;
            };
// Several commonly used vertex structures are defined in UnityCG.cginc include file
//appdata_base : 정점은 위치, 법선 및 한 개의 텍스처 좌표로 구성됩니다.
//appdata_tan : 정점 위치, 접선, 법선 및 한 개의 텍스처 좌표로 구성됩니다.
//appdata_full: 정점은 위치, 접선, 법선, 4개의 텍스처 좌표와 색상으로 구성됩니다.

            vertexOutput vert(appdata_base v)
            {
                vertexOutput o;
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
                return o;
            }

            float4 frag(vertexOutput i) : SV_Target
            {
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
	//  Fallback "Diffuse"
}