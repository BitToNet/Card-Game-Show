// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 5/5-2"
{
    Properties
    {
        _Color("Color Tint",Color) = (1.0,1.0,1.0,1.0)
    }
    SubShader
    {
        // 表面着色器被定义在SubShader语义块中的CGPROGRAM和ENDCG之间
        Pass
        {
            CGPROGRAM
            // 编译指令 #pragma vertex name，代表哪个函数包含了顶点着色器代码
            #pragma vertex vert
            #pragma fragment frag

            uniform fixed4 _Color;

            struct a2v
            {
                //顶点坐标
                float4 vertex:POSITION;
                //法线向量
                float3 normal:NORMAL;
                //第一套纹理坐标
                float4 texcoord:TEXCOORD0;
            };

            struct v2f
            {
                float4 pos:SV_POSITION;
                fixed3 color:COLOR0;
            };

            // float4 v:POSITION -> 告诉unity把模型的顶点坐标传入到输入参数v中
            // SV_POSITION -> 顶点着色器的输出是我们裁剪空间中的顶点坐标，然后会输出到我们的片元着色器中
            v2f vert(a2v v)
            {
                // return UnityObjectToClipPos(v);
                // return UnityObjectToClipPos(v.vertex);
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.color = v.normal * 0.5 + fixed3(0.5, 0.5, 0.5);
                return o;
            }

            // 片元着色器并没有使用任何输入，代表顶点着色器输出的内容不会给到任何东西
            // SV_Target -> 代表把用户的输出颜色存储到一个渲染目标
            fixed4 frag(v2f i):SV_Target
            {
                fixed3 c = i.color;
                c *= _Color.rgb;
                // 片元着色器中直接把颜色输出到渲染目标中
                return fixed4(c, 1.0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}