/********************************************************************************
 *	文件名：	ActionEditorWindow.cs
 *	创建人：	Like
 *	创建时间：  2016-08-30
 *
 *	功能说明：  编辑窗口
 *	修改记录：
*********************************************************************************/

using UnityEngine;
using System.Collections;
using UnityEditor;
using System.Collections.Generic;

public class ActionEditorWindow : EditorWindow
{

    #region Field
    //readonly
    private readonly int WINDOW_TITLE_FONTSIZE = 20;
    private readonly float WINDOW_SPACE = 15f;
    private readonly float WINDOW_MIN_WIDTH = 800f;
    private readonly float WINDOW_MIN_HIEGHT = 600f;
    private readonly float WINDOW_MAX_WIDTH = 900f;
    private readonly float WINDOW_MAX_HIEGHT = 700f;
    private readonly float WINDOW_VETICAL_SPACE = 20f;

    private static ActionEditorWindow m_MainWnd;
    private GUIStyle titleStyle;

    private int m_eActionFrameType = 0;
    private int m_eActionFrameMaxType = 0;
    public string[] m_szActionFrameName;
    private string[] m_szFrameEventName;

    private Vector2 m_EventScorllPos;
    private bool m_bIsCreateNew;
    private ActionInfoData m_FileData;
    private List<ActionFrameItem> m_TemplateList;
    private string m_CurrentName;
    private string m_CurrentDescribe;
    private string m_CurrentFileName;
    #endregion

    [MenuItem("Window/Action Editor")]
    private static void CreateWindow()
    {
        if (!CheckScene())
        {
            return;
        }
        m_MainWnd = EditorWindow.GetWindow<ActionEditorWindow>(false, "动作编辑器", true);
        m_MainWnd.Init();
    }

    private static bool CheckScene()
    {
        return true;
    }

    static public ActionEditorWindow Instance
    {
        get
        {
            if (null == m_MainWnd)
            {
                CreateWindow();
            }

            return m_MainWnd;
        }
    }

    private void Init()
    {
        // SetUp Window
        m_MainWnd.minSize = new Vector2(WINDOW_MIN_WIDTH, WINDOW_MIN_HIEGHT);
        m_MainWnd.maxSize = new Vector2(WINDOW_MAX_WIDTH, WINDOW_MAX_HIEGHT);
        titleStyle = new GUIStyle();
        titleStyle.fontSize = WINDOW_TITLE_FONTSIZE;
        titleStyle.normal.textColor = Color.white;

        m_TemplateList = ActionHelper.GetFrameTemplateList();

        m_szActionFrameName = new string[m_TemplateList.Count + 1];
        for (int i = 0; i < m_TemplateList.Count; i++)
        {
            if (m_szActionFrameName[i] == null)
            {
                m_szActionFrameName[i] = m_TemplateList[i].m_Name;
            }
            else
            {
                Debug.LogError(i.ToString() + "Has Same Values !!!!");
            }
        }
        m_szActionFrameName[m_TemplateList.Count] = "全部";
        m_eActionFrameMaxType = m_TemplateList.Count;
        m_eActionFrameType = m_eActionFrameMaxType;
    }

    private ActionFrameItem GetTemplateFrame(string name)
    {
        foreach (var item in m_TemplateList)
        {
            if (item.m_FileName.Contains(name))
            {
                return item;
            }
        }
        return null;
    }

    private Color GetFrameTypeColor(string framename)
    {
        string type = framename;

        if (type.Contains("UI"))
        {
            return ColorDefine.Blue;
        }
        else if (type.Contains("逻辑"))
        {
            return ColorDefine.Yellow;
        }
        else if (type.Contains("物体"))
        {
            return ColorDefine.Orange;
        }
        else if (type.Contains("对象"))
        {
            return ColorDefine.LightGray;
        }
        else if (type.Contains("ActionGetter"))
        {
            return ColorDefine.Red;
        }
        else if (type.Contains("功能"))
        {
            return ColorDefine.Green;
        }
        else if (type.Contains("ActionHandler"))
        {
            return ColorDefine.LightBlue;
        }
        else if (type.Contains("动作"))
        {
            return ColorDefine.Gray;
        }

        return Color.white;
    }

    private void ClearData()
    {
        m_bIsCreateNew = false;
        m_FileData = null;

        // Data
        m_CurrentName = "";
        m_CurrentDescribe = "";
        m_CurrentFileName = "";

        ActionListWindow.CloseWindow();
    }

    public void OpenStory(ActionInfoData data)
    {
        ClearData();

        // Data
        m_CurrentName = data.m_Name;
        m_CurrentDescribe = data.m_Describe;
        m_CurrentFileName = data.m_FileName;

        // Data
        m_FileData = data;

        //Editor Data
        m_bIsCreateNew = true;

        Repaint();
    }

    public void OnSave()
    {
        // Data
        if (m_FileData == null)
        {
            m_FileData = new ActionInfoData();
        }
        m_FileData.m_Name = m_CurrentName;
        m_FileData.m_Describe = m_CurrentDescribe;
        m_FileData.m_FileName = m_CurrentFileName;

        ActionHelper.SaveEditFileInfo(m_FileData);
        EditorUtility.DisplayDialog("保存成功", "保存成功", "确定");
    }

    #region Public Interface
    public void InsertFrame(string handler, ActionNode node)
    {
        ActionFrameItem item = GetTemplateFrame(handler);
        if (item != null)
        {
            CustomActionFrameEdit.Instance.OpenWindow(item, node);
        }
    }

    public int GetFrameMaxID()
    {
        int max = 0;
        if (m_FileData.m_Nodes != null)
        {
            for (int i = 0; i < m_FileData.m_Nodes.Count; ++i)
            {
                if (m_FileData.m_Nodes[i].m_Id > max)
                {
                    max = m_FileData.m_Nodes[i].m_Id;
                }
            }
        }
        ++max;

        return max;
    }

    public void AddFrame(ActionNode node)
    {
        if (null == m_FileData)
        {
            return;
        }
        if (m_FileData.m_Nodes.Contains(node))
        {
            return;
        }
        m_FileData.m_Nodes.Add(node);
    }

    public void DelFrame(ActionNode node)
    {
        if (null == m_FileData)
        {
            return;
        }

        m_FileData.m_Nodes.Remove(node);
    }
    #endregion

    private void OnGUI()
    {
        GUILayout.Space(WINDOW_SPACE);
        EditorGUILayout.LabelField("<color=#00FFFF>方案:</color>", titleStyle);

        #region 方案
        GUILayout.Space(WINDOW_SPACE);
        EditorGUILayout.BeginHorizontal();
        {
            GUILayout.Space(WINDOW_SPACE);
            if (GUILayout.Button("选择方案", GUILayout.Width(100f)))
            {
                ActionListWindow.Instance.OpenWindow();
            }
            GUILayout.Space(WINDOW_SPACE);
            if (GUILayout.Button("创建方案", GUILayout.Width(100f)))
            {
                if (m_bIsCreateNew == false)
                {
                    m_bIsCreateNew = true;
                    m_FileData = new ActionInfoData();
                }
            }
            GUILayout.Space(WINDOW_SPACE);
            if (GUILayout.Button("重置面板", GUILayout.Width(100f)))
            {
                var option = EditorUtility.DisplayDialog("警告", "重置面板将清除本地数据", "确定", "取消");
                if (option)
                {
                    ClearData();
                    Repaint();
                }
            }
        }
        EditorGUILayout.EndHorizontal();
        #endregion

        if (m_bIsCreateNew)
        {
            GUILayout.Space(WINDOW_VETICAL_SPACE);
            EditorGUILayout.LabelField("动作:", titleStyle);
            #region 动作
            GUILayout.Space(WINDOW_SPACE);
            EditorGUILayout.BeginHorizontal();
            {
                GUILayout.Space(WINDOW_SPACE);
                EditorGUILayout.LabelField("文件名:", GUILayout.Width(60f));
                m_CurrentFileName = EditorGUILayout.TextField(m_CurrentFileName, GUILayout.Width(200f));

                GUILayout.Space(WINDOW_SPACE);
                if (GUILayout.Button("保存数据", GUILayout.Width(100f)))
                {
                    if (string.IsNullOrEmpty(m_CurrentFileName))
                    {
                        EditorUtility.DisplayDialog("警告", "文件名不能为空", "确定");
                    }
                    else
                    {
                        OnSave();
                    }
                }
            }
            EditorGUILayout.EndHorizontal();

            GUILayout.Space(WINDOW_SPACE);
            EditorGUILayout.BeginHorizontal();
            {
                GUILayout.Space(WINDOW_SPACE);
                EditorGUILayout.LabelField("动作名称:", GUILayout.Width(60f));
                m_CurrentName = EditorGUILayout.TextField(m_CurrentName, GUILayout.Width(120f));

                GUILayout.Space(WINDOW_SPACE);
                EditorGUILayout.LabelField("动作描述:", GUILayout.Width(60f));
                m_CurrentDescribe = EditorGUILayout.TextField(m_CurrentDescribe, GUILayout.Width(300f));
            }
            EditorGUILayout.EndHorizontal();
            #endregion

            GUILayout.Space(WINDOW_VETICAL_SPACE);
            EditorGUILayout.LabelField("<color=#00FFFF>节点:</color>", titleStyle);

            #region 创建节点
            GUILayout.Space(WINDOW_SPACE);
            EditorGUILayout.BeginHorizontal();
            {
                GUILayout.Space(WINDOW_SPACE);
                m_eActionFrameType = EditorGUILayout.Popup(m_eActionFrameType, m_szActionFrameName, GUILayout.Width(150f));
                if (m_eActionFrameType != m_eActionFrameMaxType)
                {
                    GUILayout.Space(WINDOW_SPACE);
                    if (GUILayout.Button("创建节点", GUILayout.Width(100f)))
                    {
                        if (Event.current.button == 0)
                        {
                            InsertFrame(m_TemplateList[m_eActionFrameType].m_FileName, null);
                        }
                    }
                }
                
            }
            EditorGUILayout.EndHorizontal();
            #endregion
            //EditorGUILayout.LabelField("节点列表:", titleStyle);
            #region 节点列表
            GUILayout.Space(WINDOW_SPACE);
            GUILayout.Box("", new GUILayoutOption[] { GUILayout.ExpandWidth(true), GUILayout.Height(1) }); //draw line
            m_EventScorllPos = EditorGUILayout.BeginScrollView(m_EventScorllPos);
            {
                if (m_FileData != null && m_FileData.m_Nodes != null)
                {
                    List<ActionNode> lstTemp = m_FileData.m_Nodes;
                    GUILayout.Box("", new GUILayoutOption[] { GUILayout.ExpandWidth(true), GUILayout.Height(1) }); //draw line
                    
                    for (int i = 0; i < lstTemp.Count; i++)
                    {
                        if (null == lstTemp[i])
                        {
                            continue;
                        }
                        if (m_eActionFrameType != m_eActionFrameMaxType)
                        {
                            if (!m_TemplateList[m_eActionFrameType].m_FileName.Contains(lstTemp[i].m_Handler))
                            {
                                continue;
                            }
                        }
                        GUILayout.Space(5);
                        EditorGUILayout.BeginHorizontal();
                        {
                            GUIStyle textColor = new GUIStyle();
                            textColor.normal.textColor = GetFrameTypeColor(GetTemplateFrame(lstTemp[i].m_Handler).m_FileName);
                            textColor.alignment = TextAnchor.MiddleLeft;

                            GUILayout.Space(WINDOW_SPACE);
                            if (GUILayout.Button("X", GUILayout.Width(20f)))
                            {
                                var option = EditorUtility.DisplayDialog("确定要删除节点吗？",
                                                                            "确定吗？确定吗？确定吗？确定吗？确定吗？",
                                                                            "确定", "取消");
                                if (option)
                                {
                                    DelFrame(lstTemp[i]);
                                    Repaint();
                                    break;
                                }
                            }

                            GUILayout.Space(WINDOW_SPACE);
                            if (GUILayout.Button("编辑节点", GUILayout.Width(100f)))
                            {
                                InsertFrame(lstTemp[i].m_Handler, lstTemp[i]);
                                break;
                            }

                            GUILayout.Space(WINDOW_SPACE);
                            if (GUILayout.Button(lstTemp[i].m_Id.ToString() + ". 类型: " + GetTemplateFrame(lstTemp[i].m_Handler).m_Name, textColor, GUILayout.Width(220f), GUILayout.Height(20f)))
                            {
                                if (Event.current.button == 0)
                                {
                                    
                                }
                            }

                            GUILayout.Space(WINDOW_SPACE);
                            if (GUILayout.Button("触发: " + lstTemp[i].m_Trigger.m_Type.ToString(), textColor, GUILayout.Width(70f), GUILayout.Height(20f)))
                            {
                                if (Event.current.button == 0)
                                {

                                }
                            }

                            GUILayout.Space(WINDOW_SPACE);
                            switch (lstTemp[i].m_Trigger.m_Type)
                            {
                                case ActionNode.TriggerType.Time:
                                    EditorGUILayout.LabelField("触发时间: " + lstTemp[i].m_Trigger.m_Param, textColor, GUILayout.Width(120f));
                                    break;
                                case ActionNode.TriggerType.Event:
                                    EditorGUILayout.LabelField("触发事件: " + lstTemp[i].m_Trigger.m_Param, textColor, GUILayout.Width(120f));
                                    break;
                                default:
                                    break;
                            }

                            GUILayout.FlexibleSpace();
                        }
                        EditorGUILayout.EndHorizontal();
                        GUILayout.Space(5);
                        GUILayout.Box("", new GUILayoutOption[] { GUILayout.ExpandWidth(true), GUILayout.Height(1) }); //draw line
                    }
                }
            }
            EditorGUILayout.EndScrollView();
            #endregion
        }
    }
}
