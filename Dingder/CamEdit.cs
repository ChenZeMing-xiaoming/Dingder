#if UNITY_EDITOR
using UnityEditor;
using UnityEngine;
[CustomEditor(typeof(Cam), true)]
public class CamEdit : Editor
{
    Cam cam;
    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();
        cam = target as Cam;
        if (GUILayout.Button("ÊýÖµË¢ÐÂ"))
        {
            cam.ReSetValue();
        }
    }

}
#endif