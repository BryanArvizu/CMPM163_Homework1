Shader "Custom/BA_PhongTexture"
{
	Properties
	{
		_Speed("Speed", Float) = 1.0
		_Color("Color", Color) = (1,1,1,1)
		_SpecularColor("Specular Color", Color) = (1, 1, 1, 1)
		_AmbientColor("Ambient Color", Color) = (0.1, 0.1, 0.1, 1)
		_Shininess("Shininess", Float) = 1.0
		_Texture("Texture", 2D) = "white" {}
	}

	SubShader
	{
		pass
		{
		Tags {"LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			
			struct appdata
			{
				float4 vertex: POSITION;
				float3 normal: NORMAL;
				float2 uv: TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex: SV_POSITION;
				float3 normal: NORMAL;
				float3 vertInObjCoords: TEXCOORD1;
				float3 vertInWorldCoords: TEXCOORD2;
				float2 uv: TEXCOORD0;
			};

			float3x3 getRotationMatrixY(float theta) {

				float s = -sin(theta);
				float c = cos(theta);
				return float3x3(c, 0, s, 0, 1, 0, -s, 0, c);
			}

			float _Speed;
			float4 _LightColor0;
			float4 _Color;
			float4 _SpecularColor;
			float4 _AmbientColor;
			float _Shininess;
			sampler2D _Texture;
			float4 _Texture_ST;

			v2f vert(appdata v)
			{
				const float PI = 3.14159;

				v2f o;

				float rad = fmod(_Time.y * _Speed, PI*2.0); // Time%(360deg in Rad)
				float3x3 rotationMatrix = getRotationMatrixY(rad); // Rotate based on Rad

				float3 rotatedVertex = mul(rotationMatrix, v.vertex.xyz);
				float3 rotatedNormals = mul(rotationMatrix, v.normal.xyz);

				float4 xyzVert = float4(rotatedVertex, 1.0);
				float4 xyzNorm = float4(rotatedNormals, 1.0);


				o.vertInObjCoords = xyzVert;
				o.vertInWorldCoords = mul(unity_ObjectToWorld, xyzVert);
				o.vertex = UnityObjectToClipPos(xyzVert);
				o.normal = UnityObjectToWorldNormal(xyzNorm);
				o.uv = TRANSFORM_TEX(v.uv, _Texture);
				return o;
			}

			float4 frag(v2f i) :SV_Target
			{
				// Ambient Component
				float3 Ka = float3(1, 1, 1);
				float3 ambientComponent = Ka * _AmbientColor.rgb;

				// Diffuse Component
				float3 P = i.vertInWorldCoords.xyz;
				float3 N = normalize(i.normal);
				float3 L = normalize(_WorldSpaceLightPos0.xyz - P);
				float3 Kd = _Color.rgb;
				float3 lightColor = _LightColor0.rgb;
				float3 diffuseComponent = Kd * lightColor * max(dot(N, L), 0);

				// Specular Component
				float3 Ks = _SpecularColor.rgb;
				float3 V = normalize(_WorldSpaceCameraPos - P);
				float3 H = normalize(L + V);
				float3 specularComponent = Ks * lightColor * pow(max(dot(N, H), 0), _Shininess);

				float3 finalColor = ambientComponent + diffuseComponent + specularComponent;
				finalColor = float4(finalColor, 1.0) * tex2D(_Texture, i.uv);

				return float4(finalColor, 1.0);
			}

			ENDCG
		}
		
		pass
		{
		Tags {"LightMode" = "ForwardAdd"}
			Blend One One
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex: POSITION;
				float3 normal: NORMAL;
				float2 uv: TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex: SV_POSITION;
				float3 normal: NORMAL;
				float3 vertInObjCoords: TEXCOORD1;
				float3 vertInWorldCoords: TEXCOORD2;
				float2 uv: TEXCOORD0;
			};

			float3x3 getRotationMatrixY(float theta) {

				float s = -sin(theta);
				float c = cos(theta);
				return float3x3(c, 0, s, 0, 1, 0, -s, 0, c);
			}

			float _Speed;
			float4 _LightColor0;
			float4 _Color;
			float4 _SpecularColor;
			float4 _AmbientColor;
			float _Shininess;
			sampler2D _Texture;
			float4 _Texture_ST;

			v2f vert(appdata v)
			{
				const float PI = 3.14159;

				v2f o;

				float rad = fmod(_Time.y * _Speed, PI*2.0); // Time%(360deg in Rad)
				float3x3 rotationMatrix = getRotationMatrixY(rad); // Rotate based on Rad

				float3 rotatedVertex = mul(rotationMatrix, v.vertex.xyz);
				float3 rotatedNormals = mul(rotationMatrix, v.normal.xyz);

				float4 xyzVert = float4(rotatedVertex, 1.0);
				float4 xyzNorm = float4(rotatedNormals, 1.0);


				o.vertInObjCoords = xyzVert;
				o.vertInWorldCoords = mul(unity_ObjectToWorld, xyzVert);
				o.vertex = UnityObjectToClipPos(xyzVert);
				o.normal = UnityObjectToWorldNormal(xyzNorm);
				o.uv = TRANSFORM_TEX(v.uv, _Texture);
				return o;
			}

			float4 frag(v2f i) :SV_Target
			{
				// Diffuse Component
				float3 P = i.vertInWorldCoords.xyz;
				float3 N = normalize(i.normal);
				float3 L = normalize(_WorldSpaceLightPos0.xyz - P);
				float3 Kd = _Color.rgb;
				float3 lightColor = _LightColor0.rgb;
				float3 diffuseComponent = Kd * lightColor * max(dot(N, L), 0);

				float3 finalColor = diffuseComponent;
				finalColor = float4(finalColor, 1.0) * tex2D(_Texture, i.uv);

				return float4(finalColor, 1.0);
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
