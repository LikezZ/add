
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(TweenPosition))]
public class TweenPositionEditor : UITweenerEditor
{
	public override void OnInspectorGUI ()
	{
		GUILayout.Space(6f);
		UIEditorTools.SetLabelWidth(120f);

		TweenPosition tw = target as TweenPosition;
		GUI.changed = false;

		Vector3 to = EditorGUILayout.Vector3Field("To", tw.to);
        bool ws = EditorGUILayout.Toggle("World Space", tw.worldSpace);

        if (GUI.changed)
		{
			UIEditorTools.RegisterUndo("Tween Change", tw);
			tw.to = to;
            tw.worldSpace = ws;
            UnityEditor.EditorUtility.SetDirty(tw);
        }

		DrawCommonProperties();
	}
}
