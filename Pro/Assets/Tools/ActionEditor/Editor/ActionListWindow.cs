/********************************************************************************
 *	文件名：	ActionListWindow.cs
 *	创建人：	Like
 *	创建时间：  2016-08-30
 *
 *	功能说明：  列表窗口
 *	修改记录：
*********************************************************************************/

using UnityEditor;
using UnityEngine;
using System.Collections.Generic;
using System.IO;

class ActionListWindow : EditorWindow
{
    #region Property
    static public ActionListWindow Instance
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
    #endregion

    #region Field
    private static ActionListWindow m_Instance;
    private List<FileInfo> m_DataList;
    private Vector2 m_EventScorllPos;
    #endregion

    #region MonoBehavior
    private void OnGUI()
    {
        if (null == m_DataList)
        {
            return;
        }

        GUILayout.Space(5);
        m_EventScorllPos = EditorGUILayout.BeginScrollView(m_EventScorllPos);
        {
            for (int i = 0; i < m_DataList.Count; ++i)
            {
                EditorGUILayout.BeginHorizontal();
                {
                    EditorGUILayout.LabelField("名称: " + m_DataList[i].Name);
                    string time = ActionHelper.TimeFormat(m_DataList[i].LastWriteTime);
                    EditorGUILayout.LabelField("修改时间: " + time);

                    if (GUILayout.Button("选择", GUILayout.Width(100f)))
                    {
                        ChoiseMap(m_DataList[i]);
                    }
                    if (GUILayout.Button("复制", GUILayout.Width(100f)))
                    {
                        Copy(m_DataList[i]);
                    }
                    if (GUILayout.Button("删除", GUILayout.Width(100f)))
                    {
                        var option = EditorUtility.DisplayDialog("确定要删除方案吗？",
                                                                                   "确定吗？确定吗？确定吗？确定吗？确定吗？",
                                                                                   "确定", "取消");
                        if (option)
                        {
                            Delete(m_DataList[i]);
                            break;
                        }
                    }
                }
                EditorGUILayout.EndHorizontal();
                GUILayout.Box("", new GUILayoutOption[] { GUILayout.ExpandWidth(true), GUILayout.Height(1) }); //draw line
            }
        }
        EditorGUILayout.EndScrollView();
    }
    #endregion

    #region Public Interface
    public void OpenWindow()
    {
        m_DataList = ActionHelper.GetEditFileList();
        Repaint();
    }

    public static void CloseWindow()
    {
        if (null == m_Instance)
        {
            return;
        }
        m_Instance.Close();
        m_Instance = null;
    }
    #endregion

    #region System Functions
    static void CreateWindow()
    {
        m_Instance = EditorWindow.GetWindow<ActionListWindow>(false, "方案列表", true);
    }

    private void ChoiseMap(FileInfo info)
    {
        m_Instance.Close();
        m_Instance = null;
        ActionInfoData data = ActionHelper.GetEditFileInfoData(info.FullName);
        data.m_FileName = info.Name;
        ActionEditorWindow.Instance.OpenStory(data);
    }

    private void Copy(FileInfo info)
    {
        
        Repaint();
    }

    private void Delete(FileInfo info)
    {
        File.Delete(info.FullName);
        m_DataList.Remove(info);
        Repaint();
    }
    #endregion

}

