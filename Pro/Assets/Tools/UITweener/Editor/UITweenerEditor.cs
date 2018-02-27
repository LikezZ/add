
using UnityEngine;
using UnityEditor;
using DG.Tweening;

[CustomEditor(typeof(UITweener), true)]
public class UITweenerEditor : Editor
{
	public override void OnInspectorGUI ()
	{
		GUILayout.Space(6f);
		UIEditorTools.SetLabelWidth(110f);
		base.OnInspectorGUI();
		DrawCommonProperties();
	}

	protected void DrawCommonProperties ()
	{
		UITweener tw = target as UITweener;

		if (UIEditorTools.DrawHeader("Tweener"))
		{
			UIEditorTools.BeginContents();
			UIEditorTools.SetLabelWidth(110f);
			GUI.changed = false;

			//AnimationCurve curve = EditorGUILayout.CurveField("Animation Curve", tw.animationCurve, GUILayout.Width(170f), GUILayout.Height(62f));
			Ease method = (Ease)EditorGUILayout.EnumPopup("Play Method", tw.method);

			GUILayout.BeginHorizontal();
			float dur = EditorGUILayout.FloatField("Duration", tw.duration, GUILayout.Width(170f));
			GUILayout.Label("seconds");
			GUILayout.EndHorizontal();

			GUILayout.BeginHorizontal();
			float del = EditorGUILayout.FloatField("Start Delay", tw.delay, GUILayout.Width(170f));
			GUILayout.Label("seconds");
			GUILayout.EndHorizontal();

            bool tl = EditorGUILayout.Toggle("Tween Loop", tw.isLoop);
            LoopType style = LoopType.Restart;
            int lc = -1;
            if (tl)
            {
                style = (LoopType)EditorGUILayout.EnumPopup("Loop Style", tw.style);
                lc = EditorGUILayout.IntField("Loop Count", tw.loopCount, GUILayout.Width(170f));
            }

            int tg = EditorGUILayout.IntField("Tween Group", tw.tweenGroup, GUILayout.Width(170f));
			bool ts = EditorGUILayout.Toggle("Ignore TimeScale", tw.ignoreTimeScale);

			if (GUI.changed)
			{
				UIEditorTools.RegisterUndo("Tween Change", tw);
				//tw.animationCurve = curve;
				tw.method = method;
                tw.isLoop = tl;
                tw.loopCount = lc;
				tw.style = style;
				tw.ignoreTimeScale = ts;
				tw.tweenGroup = tg;
				tw.duration = dur;
				tw.delay = del;
                UnityEditor.EditorUtility.SetDirty(tw);
			}
			UIEditorTools.EndContents();
		}

		UIEditorTools.SetLabelWidth(80f);
	}
}
