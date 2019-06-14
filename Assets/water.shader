Shader "Custom/Water" {
    Properties {
		// What color the water will sample when the surface below is shallow.
		_DepthGradientShallow("Depth Gradient Shallow", Color) = (0.325, 0.807, 0.971, 0.725)

		// What color the water will sample when the surface below is at its deepest.
		_DepthGradientDeep("Depth Gradient Deep", Color) = (0.086, 0.407, 1, 0.749)

		// Maximum distance the surface below the water will affect the color gradient.
		_DepthMaxDistance("Depth Maximum Distance", Float) = 1
    }
	
    SubShader {
		Tags { "Queue" = "Transparent" }

        Pass {
			// Transparent "normal" blending.
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off

            CGPROGRAM
			#define SMOOTHSTEP_AA 0.01
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

			float4 _DepthGradientShallow;
			float4 _DepthGradientDeep;
			float _DepthMaxDistance;
			sampler2D _CameraDepthTexture;
			sampler2D _CameraNormalsTexture;

            struct appdata {
                float4 vertex : POSITION;
				float4 uv : TEXCOORD0;
				float3 normal : NORMAL;
            };

            struct v2f {
                float4 vertex : SV_POSITION;	
				float4 screenPosition : TEXCOORD2;
				float3 viewNormal : NORMAL;
            };

            
			v2f vert (appdata v) {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
				o.screenPosition = ComputeScreenPos(o.vertex);
				o.viewNormal = COMPUTE_VIEW_NORMAL;

                return o;
            }

            float4 frag (v2f i) : SV_Target {
				// Retrieve the current depth value of the surface behind the
				// pixel we are currently rendering.
				float existingDepth01 = tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPosition)).r;
				
				// Convert the depth from non-linear 0...1 range to linear
				// depth, in Unity units.
				float existingDepthLinear = LinearEyeDepth(existingDepth01);

				// Difference, in Unity units, between the water's surface and the object behind it.
				float depthDifference = existingDepthLinear - i.screenPosition.w;

				// Calculate the color of the water based on the depth using our two gradient colors.
				float waterDepthDifference01 = saturate(depthDifference / _DepthMaxDistance);
				float4 waterColor = lerp(_DepthGradientShallow, _DepthGradientDeep, waterDepthDifference01);
				
				// Color of sufarce
				return waterColor;
            }
            ENDCG
        }
    }
}
