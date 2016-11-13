Shader "Custom/DiffuseLight" {
	Properties
	{
	_Color("Color",Color) = (1.0,1.0,1.0,1.0)
	_MainTex ("Diffuse Texture",2D) = "White"{}
	_SpecColor("Specular Color", Color) = (1.0,1.0,1.0,1.0)
	_Shininess("Shininess",float) =1
	}
		SubShader{
			Pass{
				Tags{"LightMode" = "ForwardBase"}
				LOD 200
				CGPROGRAM
			//pragmas
			#pragma vertex vert  //뒤에 vert 마음대로 바꿀수있다.
			#pragma fragment frag
			#pragma exclude_renderers flash

			uniform sampler2D _MainTex;

			uniform float4 _Color;
			uniform float4 _SpecColor;
			uniform float _Shininess;
			//unity defined variables
			uniform float4 _LightColor0;


			//base input structs
				struct vertexInput
				{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
	
				};
				struct vertexOutput {
						float4 pos : SV_POSITION;
						float4 tex : TEXCOORD0;
						float4 posWorld : TEXCOORD1;
						float3 normalDir : TEXCOORD2;

				};
						//vertex function
				vertexOutput vert(vertexInput v)
				{
					vertexOutput o;
					o.posWorld = mul(_Object2World,v.vertex);
					o.normalDir = normalize(mul(float4(v.normal,0.0),_World2Object).xyz);
					o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
					o.tex = v.texcoord;
					return o;
	
				}
			//fragment function

				float4 frag(vertexOutput i) :COLOR
				{
			
				float3 normalDirection = i.normalDir;
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
				float3 lightDirection;

				//texture Maps
					float4 albedo = tex2D(_MainTex, i.tex.xy);

				float atten;
		
					lightDirection = normalize(_WorldSpaceLightPos0.xyz);
					//기본 자연광은  Atten으로 강도 조절을 하지 않지만
					//그 이외은 빛은 Atten으로 거리에 따라 강도 조절을 하게 된다. 
					if(_WorldSpaceLightPos0.w == 0.0) //drectionalLights
					{
					atten = 1.0;

					lightDirection = normalize(_WorldSpaceLightPos0.xyz);
					
					}
					else  // Other Lights  _WorldSpaceLightPos0.w = =1 이면 다른 라이트다. 
					{
						float3 fragmentToLightSource = _WorldSpaceLightPos0.xyz- i.posWorld.xyz;
						float Lightdistance = length(fragmentToLightSource);
						atten = 1/Lightdistance;
						lightDirection = normalize(fragmentToLightSource);
					}

				
					//light
					float3 diffuseReflection = atten* _LightColor0.xyz * saturate(dot(normalDirection,lightDirection));
					float3 specularReflection =  diffuseReflection *_SpecColor.xyz
							* pow(saturate(dot(reflect(-lightDirection, normalDirection), viewDirection)),_Shininess);


					// 엠비언트 라이트는 텍스쳐랑 계산 전에 들어가야한다. 
					float3 ambient = float3(0.4f , 0.4f ,0.4f) * albedo.rgb;
					float3 lightFinal =albedo +  diffuseReflection  + specularReflection+ UNITY_LIGHTMODEL_AMBIENT.rgb;
					
					

				

					return float4 (ambient.xyz*lightFinal*_Color.xyz,1.0);
	
				}

			ENDCG
		}

				Pass{
				Tags{"LightMode" = "ForwardAdd"}
				LOD 200
				Blend One One 
				CGPROGRAM
			//pragmas
			#pragma vertex vert  //뒤에 vert 마음대로 바꿀수있다.
			#pragma fragment frag
			#pragma exclude_renderers flash

			uniform sampler2D _MainTex;

			uniform float4 _Color;
			uniform float4 _SpecColor;
			uniform float _Shininess;
			//unity defined variables
			uniform float4 _LightColor0;


			//base input structs
				struct vertexInput
				{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
	
				};
				struct vertexOutput {
						float4 pos : SV_POSITION;
						float4 tex : TEXCOORD0;
						float4 posWorld : TEXCOORD1;
						float3 normalDir : TEXCOORD2;

				};
						//vertex function
				vertexOutput vert(vertexInput v)
				{
					vertexOutput o;
					o.posWorld = mul(_Object2World,v.vertex);
					o.normalDir = normalize(mul(float4(v.normal,0.0),_World2Object).xyz);
					o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
					o.tex = v.texcoord;
					return o;
	
				}
			//fragment function

				float4 frag(vertexOutput i) :COLOR
				{
			
				float3 normalDirection = i.normalDir;
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
				float3 lightDirection;

				//texture Maps
					float4 albedo = tex2D(_MainTex, i.tex.xy);

				float atten;
		
					lightDirection = normalize(_WorldSpaceLightPos0.xyz);
					//기본 자연광은  Atten으로 강도 조절을 하지 않지만
					//그 이외은 빛은 Atten으로 거리에 따라 강도 조절을 하게 된다. 
					if(_WorldSpaceLightPos0.w == 0.0) //drectionalLights
					{
					atten = 1.0;

					lightDirection = normalize(_WorldSpaceLightPos0.xyz);
					
					}
					else  // Other Lights  _WorldSpaceLightPos0.w = =1 이면 다른 라이트다. 
					{
						float3 fragmentToLightSource = _WorldSpaceLightPos0.xyz- i.posWorld.xyz;
						float Lightdistance = length(fragmentToLightSource);
						atten = 1/Lightdistance;
						lightDirection = normalize(fragmentToLightSource);
					}

				
					//light
					float3 diffuseReflection = atten* _LightColor0.xyz * saturate(dot(normalDirection,lightDirection));
				


					// 엠비언트 라이트는 텍스쳐랑 계산 전에 들어가야한다. 
					float3 ambient = float3(0.4f , 0.4f ,0.4f) * albedo.rgb;
					float3 lightFinal =albedo +  diffuseReflection ;
					
					

					return float4 (ambient*diffuseReflection,1.0);
	
				}

			ENDCG
		}
		//Fallback commented out during development
		//Fallback "Diffuse"
		} 
    Fallback "Diffuse"
}
