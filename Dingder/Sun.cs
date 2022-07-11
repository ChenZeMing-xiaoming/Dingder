using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Sun : MonoBehaviour
{
    [HideInInspector]
    public Camera cam = null;
    [HideInInspector]
    public RenderTexture colorRT;
    [HideInInspector]
    public RenderTexture depthRT;

    public GameObject cam_obj;

    public Shader SunShader;

    public Cam Cam;
    // Use this for initialization
    void Start()
    {
        cam = this.GetComponent<Camera>();
        colorRT = new RenderTexture(Screen.width, Screen.height, 24, RenderTextureFormat.Default);
        depthRT = new RenderTexture(Screen.width, Screen.height, 0, RenderTextureFormat.Depth);
        cam.SetReplacementShader(SunShader, "");
        CreatMesh();
        Cam = GameObject.FindObjectOfType<Cam>();
        Cam.Sun_mat.SetMatrix("df12", cam.worldToCameraMatrix);
        Cam.Sun_mat.SetFloat("s123", cam.farClipPlane);
        Cam.Sun_mat.SetMatrix("dfc12", GL.GetGPUProjectionMatrix(cam.projectionMatrix, false));
    }
    private void OnPreRender()
    {
        cam.SetTargetBuffers(colorRT.colorBuffer, depthRT.depthBuffer);
    }
    public void ReSunCam()
    {
        Cam.Sun_mat.SetMatrix("df12", cam.worldToCameraMatrix);
        Cam.Sun_mat.SetFloat("s123", cam.farClipPlane);
        Cam.Sun_mat.SetMatrix("dfc12", GL.GetGPUProjectionMatrix(cam.projectionMatrix, false));
    }
    void CreatMesh()
    {
        GetPos();
        Mesh mesh = new Mesh();
        List<Vector3> pos = new List<Vector3>();
        pos.AddRange(cam_poss);
        mesh.Clear();
        List<int> tri = new List<int>();
        tri.Add(0); tri.Add(1); tri.Add(2); tri.Add(0); tri.Add(2); tri.Add(3); tri.Add(3); tri.Add(2); tri.Add(6); tri.Add(3); tri.Add(6); tri.Add(7); 
        tri.Add(1); tri.Add(5); tri.Add(6); tri.Add(1); tri.Add(6); tri.Add(2); tri.Add(0); tri.Add(4); tri.Add(5); tri.Add(0); tri.Add(5); tri.Add(1);
        tri.Add(0); tri.Add(7); tri.Add(4); tri.Add(0); tri.Add(3); tri.Add(7); tri.Add(4); tri.Add(6); tri.Add(5); tri.Add(4); tri.Add(7); tri.Add(6);
        mesh.vertices = cam_poss;
        mesh.triangles = tri.ToArray();
        mesh.RecalculateNormals();
        cam_obj.GetComponent<MeshFilter>().mesh = mesh;

    }
    Vector3[] cam_poss = new Vector3[8];
    void GetPos()
    {
        float angle = cam.fieldOfView / 2;
        float z = cam.nearClipPlane;
        float  height = Mathf.Tan((angle * (Mathf.PI)) / 180) * z;
        float wight = height * ((Screen.width + 0.0f)/Screen.height );
        cam_poss[0] =new Vector3(-wight, -height, z) ;
        cam_poss[1] = new Vector3(-wight, height, z);
        cam_poss[2] = new Vector3(wight, height, z);
        cam_poss[3] = new Vector3(wight, -height, z);

        z = cam.farClipPlane;
         height = Mathf.Tan((angle * (Mathf.PI)) / 180) * z;
         wight = wight = height * ((Screen.width + 0.0f) / Screen.height);
        cam_poss[4] = new Vector3(-wight, -height, z);
        cam_poss[5] = new Vector3(-wight, height, z);
        cam_poss[6] = new Vector3(wight, height, z);
        cam_poss[7] = new Vector3(wight, -height, z);
    }

}
