using UnityEngine;
using System.Collections;
using UnityEditor;

public class CustomActionFrameEdit : AbstractFrameEdit {

    private static CustomActionFrameEdit m_Instance;
    static public CustomActionFrameEdit Instance
    {
        get
        {
            if (null == m_Instance)
            {
                CreateWindow();
            }

            return m_Instance;
        }
    }

    private static void CreateWindow()
    {
        m_Instance = EditorWindow.GetWindow<CustomActionFrameEdit>(false, "编辑窗口", true);
    }

    protected override void Init()
    {
        base.Init();

    }

    public override void OpenWindow(ActionFrameItem item, ActionNode node)
    {
        base.OpenWindow(item, node);

        m_Instance.SetBaseInfo(item, node);
        m_Instance.Init();

        Repaint();
    }

    private Vector2 m_EventScorllPos;

    protected override void OnGUI()
    {
        base.OnGUI();

        // 以下为参数列表
        m_EventScorllPos = EditorGUILayout.BeginScrollView(m_EventScorllPos);
        {
            for (int i = 0; i < m_FrameItem.m_Params.Count; ++i)
            {
                // 参数描述
                GUILayout.Space(WINDOW_SPACE);
                EditorGUILayout.BeginHorizontal();
                {
                    EditorGUILayout.LabelField("参数描述:", GUILayout.Width(60f));
                    EditorGUILayout.LabelField(m_FrameItem.m_Params[i].m_Describe, GUILayout.Width(300f));
                }
                EditorGUILayout.EndHorizontal();
                // 名称
                GUILayout.Space(WINDOW_SPACE);
                EditorGUILayout.BeginHorizontal();
                {
                    EditorGUILayout.LabelField("名称:", GUILayout.Width(40f));
                    EditorGUILayout.LabelField(m_FrameItem.m_Params[i].m_Name, GUILayout.Width(100f));
                    GUILayout.Space(WINDOW_SPACE);

                    string param = m_ActionNode.m_Params[m_FrameItem.m_Params[i].m_Name];
                    if (m_FrameItem.m_Params[i].m_Type.Contains("Int"))
                    {
                        int temp = 0;
                        int.TryParse(param, out temp);
                        temp = EditorGUILayout.IntField(temp, GUILayout.Width(120f));
                        m_ActionNode.m_Params[m_FrameItem.m_Params[i].m_Name] = temp.ToString();
                    }
                    else if (m_FrameItem.m_Params[i].m_Type.Contains("Float"))
                    {
                        float temp = 0;
                        float.TryParse(param, out temp);
                        temp = EditorGUILayout.FloatField(temp, GUILayout.Width(120f));
                        m_ActionNode.m_Params[m_FrameItem.m_Params[i].m_Name] = temp.ToString("f2");
                    }
                    else if (m_FrameItem.m_Params[i].m_Type.Contains("Custom"))
                    {
                        param = EditorGUILayout.TextField(param, GUILayout.Width(120f));
                        m_ActionNode.m_Params[m_FrameItem.m_Params[i].m_Name] = param;
                    }
                    else // 除了int和float的类型之外暂时都按string处理
                    {
                        if (param.IndexOf("\"") != -1)
                        {
                            param = param.Substring(1, param.Length - 2);
                        }
                        param= EditorGUILayout.TextField(param, GUILayout.Width(120f));
                        param = "\"" + param + "\"";
                        m_ActionNode.m_Params[m_FrameItem.m_Params[i].m_Name] = param;
                    }

                    GUILayout.Space(WINDOW_SPACE);
                    EditorGUILayout.LabelField("类型:", GUILayout.Width(40f));
                    EditorGUILayout.LabelField(m_FrameItem.m_Params[i].m_Type, GUILayout.Width(80f));
                    if (m_FrameItem.m_Params[i].m_IsShared)
                    {
                        GUILayout.Space(WINDOW_SPACE);
                        EditorGUILayout.LabelField("共享", GUILayout.Width(40f));
                    }
                }
                EditorGUILayout.EndHorizontal();

                GUILayout.Box("", new GUILayoutOption[] { GUILayout.ExpandWidth(true), GUILayout.Height(1) }); //draw line
            }
        }
        EditorGUILayout.EndScrollView();
    }

    protected override void OnSave()
    {
        base.OnSave();

        ActionEditorWindow.Instance.AddFrame(m_ActionNode);
        ActionEditorWindow.Instance.OnSave();
        m_Instance.Close();
    }
}
