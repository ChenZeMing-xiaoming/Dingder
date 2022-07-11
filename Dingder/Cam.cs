using System.Collections;
using UnityEngine;
using UnityEngine.Rendering;
/// <summary>
/// Pieken 2020
/// </summary>
public class Cam : MonoBehaviour
{

	public Sun Sun;
	Camera cam = null;
	[HideInInspector]
	public RenderTexture depthRT_sun_globle;

	[HideInInspector]
	public RenderTexture depthRT_huancun;
	[HideInInspector]
	public RenderTexture colorRT;
	[HideInInspector]
	public RenderTexture depthRT;
	[HideInInspector]
	public RenderTexture depthRT_sun;
	[HideInInspector]
	public RenderTexture MohuRt;

	public Material MohuComB;
	public Material Sun_mat;

	public MeshRenderer MeshRenderer;

	public Material CullFront;
	public Material CullBack;
	// Use this for initialization
	public Material Mohu;
	[HideInInspector]
	public RenderTexture MohuRt1;

	public Color Light_Color = Color.white;
	public float Light_SuaiJian = 0.01f;
	public float Light_Qiangdu = 0.7f;
	public float Light_mohu_dis = 0.001f;
	public int max_times = 60;

	void Start()
	{
		cam = this.GetComponent<Camera>();

		colorRT =  RenderTexture.GetTemporary(Screen.width, Screen.height, 0, RenderTextureFormat.Default);
		depthRT =  RenderTexture.GetTemporary(Screen.width, Screen.height, 24, RenderTextureFormat.Depth);
		MohuRt = RenderTexture.GetTemporary(Screen.width, Screen.height, 0, RenderTextureFormat.Default);
		MohuRt1 = RenderTexture.GetTemporary(Screen.width, Screen.height, 0, RenderTextureFormat.Default);

		depthRT_sun = RenderTexture.GetTemporary(Screen.width, Screen.height, 0, RenderTextureFormat.RG32);
		depthRT_sun_globle = RenderTexture.GetTemporary(Screen.width, Screen.height, 0, RenderTextureFormat.RG32);
		depthRT_huancun = RenderTexture.GetTemporary(Screen.width, Screen.height, 0, RenderTextureFormat.RG32);

		Init();
		Shader.SetGlobalTexture("ScreenCopyTexture", depthRT_sun_globle);

		Sun_mat.SetTexture("a12", depthRT);
		Sun_mat.SetTexture("a1", Sun.depthRT);
		Sun_mat.SetTexture("a13", depthRT_sun);
		MohuComB.SetTexture("_Scene_tex", colorRT);
		StartCoroutine(start());
	}
	IEnumerator start()
    {
		yield return new WaitForSeconds(2);
		Sun.ReSunCam();
		ReSetValue();
    }
	public void Init()
    {
		//获取太阳深度图
		CommandBuffer commandBuffer = new CommandBuffer();
		commandBuffer.SetRenderTarget(depthRT_sun); 
		commandBuffer.ClearRenderTarget(false,true,Color.black);
		commandBuffer.DrawRenderer(MeshRenderer, CullBack);
		commandBuffer.SetRenderTarget(depthRT_huancun);
		commandBuffer.Blit(depthRT_sun, depthRT_sun_globle);
		commandBuffer.SetRenderTarget(depthRT_sun);
		commandBuffer.DrawRenderer(MeshRenderer, CullFront);
		cam.AddCommandBuffer(CameraEvent.AfterSkybox, commandBuffer);

	}
    private void OnPreRender()
	{
		cam.SetTargetBuffers(colorRT.colorBuffer, depthRT.depthBuffer);
	}

	private void OnRenderImage(RenderTexture src, RenderTexture dest)
	{
		Sun.ReSunCam();
		ReSetValue();
		Graphics.Blit(MohuRt, MohuRt1, Sun_mat);
		Graphics.Blit(MohuRt1, MohuRt, Mohu);
		Graphics.Blit(MohuRt, MohuRt1, Mohu);
		Graphics.Blit(MohuRt1, MohuRt, Mohu);
		Graphics.Blit(MohuRt, MohuRt1, Mohu);
		Graphics.Blit(MohuRt1, MohuRt, Mohu);
		Graphics.Blit(MohuRt, dest, MohuComB);
		MohuRt.Release();
		MohuRt1.Release();
	}

	public void ReSetValue()
    {
		Sun_mat.SetColor("a121", Light_Color);
		Sun_mat.SetFloat("b121", Light_SuaiJian);
		Sun_mat.SetFloat("b12", max_times);

		Mohu.SetFloat("_dis", Light_mohu_dis);
		MohuComB.SetFloat("_Qiangdu", Light_Qiangdu);

		Sun_mat.SetTexture("a12", depthRT);
		Sun_mat.SetTexture("a1", Sun.depthRT);
		Sun_mat.SetTexture("a13", depthRT_sun);
		MohuComB.SetTexture("_Scene_tex", colorRT);

	}
	void OnDisable()
    {

		colorRT .Release();
		depthRT.Release();
		MohuRt.Release();
		MohuRt1.Release();

		depthRT_sun.Release();
		depthRT_sun_globle.Release();
		depthRT_huancun.Release();
	}
}