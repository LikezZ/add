/********************************************************************************
 *	文件名：	AbstractFrameEdit.cs
 *	创建人：	Like
 *	创建时间：  
 *
 *	功能说明：  节点编辑窗口 基类
 *	修改记录：
*********************************************************************************/

using UnityEditor;
using UnityEngine;
using System.Collections.Generic;

public class AbstractFrameEdit : EditorWindow
{
    #region Property
    protected readonly float WINDOW_SPACE = 10f;
    #endregion

    #region Field
    //Data
    private Dictionary<ActionNode.TriggerType, string> m_mapFrameEventNameDict;
    private string[] m_szFrameEventName;
    private ActionNode.TriggerType m_eFrameEventType = ActionNode.TriggerType.Time;

    public ActionFrameItem m_FrameItem;
    public ActionNode m_ActionNode; 
    #endregion

    #region System Functions
    public virtual void OpenWindow(ActionFrameItem item, ActionNode node)
    {
        m_FrameItem = item;

        if (node == null)
        {
            m_ActionNode = new ActionNode();
            m_ActionNode.m_Id = ActionEditorWindow.Instance.GetFrameMaxID();
        }
        else
        {
            m_ActionNode = node;
        }

        // 修正参数表
        foreach (var param in m_FrameItem.m_Params)
        {
            if (!m_ActionNode.m_Params.ContainsKey(param.m_Name))
            {
                m_ActionNode.m_Params.Add(param.m_Name, "");
            }
        }
    }

    // 按照枚举顺序添加
    public static void InitFrameEventName(Dictionary<ActionNode.TriggerType, string> m_mapFrameEventNameDict)
    {
        m_mapFrameEventNameDict.Add(ActionNode.TriggerType.Time, "时间");
        m_mapFrameEventNameDict.Add(ActionNode.TriggerType.Event, "事件");
    }

    protected void SetBaseInfo(ActionFrameItem item, ActionNode node)
    {

        this.Focus();
    }

    protected virtual void Init()
    {
        m_mapFrameEventNameDict = new Dictionary<ActionNode.TriggerType, string>();
        InitFrameEventName(m_mapFrameEventNameDict);
        m_szFrameEventName = new string[m_mapFrameEventNameDict.Count];
        foreach (KeyValuePair<ActionNode.TriggerType, string> pair in m_mapFrameEventNameDict)
        {
            if (m_szFrameEventName[(int)pair.Key] == null)
            {
                m_szFrameEventName[(int)pair.Key] = pair.Value;
            }
            else
            {
                Debug.LogError(pair.Key.ToString() + "Has Same Values !!!!");
            }
        }
    }

    protected virtual void OnGUI()
    {
        DrawBaseInfo();
    }

    protected virtual void DrawBaseInfo()
    {
        // 名称
        GUILayout.Space(WINDOW_SPACE);
        EditorGUILayout.BeginHorizontal();
        {
            EditorGUILayout.LabelField("名称:", GUILayout.Width(60f));
            EditorGUILayout.LabelField(m_FrameItem.m_Name, GUILayout.Width(120f));
        }
        EditorGUILayout.EndHorizontal();
        // 描述
        GUILayout.Space(WINDOW_SPACE);
        EditorGUILayout.BeginHorizontal();
        {
            EditorGUILayout.LabelField("描述:", GUILayout.Width(60f));
            EditorGUILayout.LabelField(m_FrameItem.m_Describe, GUILayout.Width(300f));
        }
        EditorGUILayout.EndHorizontal();
        // 唯一Id
        GUILayout.Space(WINDOW_SPACE);
        EditorGUILayout.BeginHorizontal();
        {
            EditorGUILayout.LabelField("唯一ID:", GUILayout.Width(60f));
            m_ActionNode.m_Id = EditorGUILayout.IntField(m_ActionNode.m_Id, GUILayout.Width(120f));

            GUILayout.Space(WINDOW_SPACE);
            if (GUILayout.Button("保存", GUILayout.Width(100f)))
            {
                OnSaveBase();
            }
        }
        EditorGUILayout.EndHorizontal();

        #region 事件类型
        GUILayout.Space(WINDOW_SPACE);
        EditorGUILayout.BeginHorizontal();
        {
            EditorGUILayout.LabelField("触发类型:", GUILayout.Width(60f));
            GUILayout.Space(WINDOW_SPACE);
            m_eFrameEventType = m_ActionNode.m_Trigger.m_Type;
            m_eFrameEventType = (ActionNode.TriggerType)EditorGUILayout.Popup((int)m_eFrameEventType, m_szFrameEventName, GUILayout.Width(150f));
            m_ActionNode.m_Trigger.m_Type = m_eFrameEventType;
            switch (m_eFrameEventType)
            {
                case ActionNode.TriggerType.Time:
                    GUILayout.Space(WINDOW_SPACE);
                    EditorGUILayout.LabelField("触发时间:", GUILayout.Width(60f));
                    float time = 0;
                    float.TryParse(m_ActionNode.m_Trigger.m_Param, out time);
                    time = EditorGUILayout.FloatField(time, GUILayout.Width(120f));
                    m_ActionNode.m_Trigger.m_Param = time.ToString("f2");
                    break;
                case ActionNode.TriggerType.Event:
                    GUILayout.Space(WINDOW_SPACE);
                    EditorGUILayout.LabelField("触发事件:", GUILayout.Width(60f));
                    m_ActionNode.m_Trigger.m_Param = EditorGUILayout.TextField(m_ActionNode.m_Trigger.m_Param, GUILayout.Width(120f));
                    break;
                default:
                    break;
            }
        }
        EditorGUILayout.EndHorizontal();
        #endregion

        GUILayout.Space(WINDOW_SPACE);
    }

    private void OnSaveBase()
    {
        m_ActionNode.m_Handler = m_FrameItem.m_FileName;

        OnSave();
    }
   
    protected virtual void OnSave()
    {
    }
    #endregion
}

