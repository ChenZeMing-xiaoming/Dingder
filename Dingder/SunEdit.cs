
#if UNITY_EDITOR
using UnityEditor;
using UnityEngine;
[CustomEditor(typeof(Sun), true)]
public class SunEdit : Editor
{
    Sun sun;
    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();
        sun = target as Sun;
        if (GUILayout.Button("ÊýÖµË¢ÐÂ"))
        {
            sun.ReSunCam();
        }
    }

}
#endif