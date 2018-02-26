
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(TweenScale))]
public class TweenScaleEditor : UITweenerEditor
{
	public override void OnInspectorGUI ()
	{
		GUILayout.Space(6f);
		UIEditorTools.SetLabelWidth(120f);

		TweenScale tw = target as TweenScale;
		GUI.changed = false;

		Vector3 to = EditorGUILayout.Vector3Field("To", tw.to);

		if (GUI.changed)
		{
			UIEditorTools.RegisterUndo("Tween Change", tw);
			tw.to = to;
            UnityEditor.EditorUtility.SetDirty(tw);
        }

		DrawCommonProperties();
	}
}
