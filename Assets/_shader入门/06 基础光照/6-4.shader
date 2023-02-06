// 实现漫反射光照模型
Shader "Unity Shaders Book/Chapter 6/6-4"
{
    Properties
    {
        // 材质漫反射颜色
        _Diffuse("Diffuse",Color) = (1.0,1.0,1.0,1.0)
    }

    SubShader
    {
        Pass
        {
            Tags
            {
                //                "LightMode" = "ForwardBase"
            }
            CGPROGRAM
            #include "Lighting.cginc"
            #pragma vertex vert
            #pragma fragment frag


            fixed4 _Diffuse;

            struct a2v
            {
                float4 vertex:POSITION;
                float3 normal:NORMAL;
            };

            struct v2f
            {
                float4 pos:SV_POSITION;
                // fixed3 color:COLOR;
                float3 worldNormal:TEXCOORD0;
            };

            // 逐顶点光照
            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                // // 得到环境光
                // fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                // // 计算漫反射光照
                // // 法线方向，统一使用世界坐标系下的，v.normal是裁剪空间下的
                // fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
                // // _WorldSpaceLightPos0：光源方向（有且只有一个平行光的情况下）
                // fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
                // // _LightColor0：用于访问改Pass处光源的颜色和强度信息
                // fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));

                o.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
                return o;
            }

            fixed4 frag(v2f i):SV_Target
            {
                  // 得到环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                
                // 计算漫反射光照
                // 法线方向，统一使用世界坐标系下的，v.normal是裁剪空间下的
                fixed3 worldNormal = i.worldNormal;
                // _WorldSpaceLightPos0：光源方向（有且只有一个平行光的情况下）
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
                // _LightColor0：用于访问改Pass处光源的颜色和强度信息
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));

                fixed3 color = ambient + diffuse;
                return fixed4(color, 1.0);
                // return fixed4(1.0, 1.0, 1.0, 1.0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}