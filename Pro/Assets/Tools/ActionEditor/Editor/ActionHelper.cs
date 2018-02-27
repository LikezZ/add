/********************************************************************************
 *	文件名：	ActionHelper.cs
 *	创建人：	Like
 *	创建时间：  2016-08-30
 *
 *	功能说明：  静态接口
 *	修改记录：
*********************************************************************************/

using UnityEngine;
#if UNITY_EDITOR
#endif
using System.Collections.Generic;
using System;
using System.IO;

#if UNITY_EDITOR
public static class ActionHelper
{
    static public readonly string DATA_PATH = Application.dataPath + "/../Extra/Lua/Script/LogicSystem/Action/Handler/";
    static public readonly string RESOURCE_PATH = Application.dataPath + "/../Extra/Lua/Script/LogicSystem/Action/Table/";

    #region Get Path
    public static string GetStoryFileDataPath(string fileName)
    {
        return RESOURCE_PATH + fileName;
    }
    #endregion

    #region Get Data
    public static List<FileInfo> GetEditFileList()
    {
        return FileUtils.GetAllFileInDir(RESOURCE_PATH);
    }

    public static ActionInfoData GetEditFileInfoData(string path)
    {
        ActionInfoData data = new ActionInfoData();
        string str = FileUtils.ReadStringFile(path);
        data.ParseData(str);
        return data;
    }

    public static List<ActionFrameItem> GetFrameTemplateList()
    {
        List<ActionFrameItem> m_DataList = new List<ActionFrameItem>();
        List<FileInfo> list = FileUtils.GetAllFileInDir(DATA_PATH);
        foreach (var item in list)
        {
            ActionFrameItem temp = new ActionFrameItem();
            string str = FileUtils.ReadStringFile(item.FullName);
            temp.ParseItem(str, item.Name);
            m_DataList.Add(temp);
        }
        return m_DataList;
    }

    public static void SaveEditFileInfo(ActionInfoData fileData)
    {
        if (null == fileData)
        {
            fileData = new ActionInfoData();
        }
        if (string.IsNullOrEmpty(fileData.m_FileName))
        {
            return;
        }
        string data = fileData.TransformString();
        FileUtils.WriteStringFile(GetStoryFileDataPath(fileData.m_FileName), data);
    }
    #endregion

    #region Time
    public static long GetTimeStamp(DateTime time)
    {
        TimeSpan ts = time - new DateTime(1970, 1, 1, 0, 0, 0, 0);
        return Convert.ToInt64(ts.TotalMilliseconds);
    }

    public static DateTime ConvertTime(long timestamp)
    {
        var start = new DateTime(1970, 1, 1, 0, 0, 0, 0);
        return start.AddMilliseconds(timestamp);
    }

    public static string TimeFormat(DateTime time)
    {
        return time.Year + "年" + time.Month + "月" + time.Day + "日 " + (time.Hour < 10 ? ("0" + time.Hour) : time.Hour.ToString()) + ":" + (time.Minute < 10 ? ("0" + time.Minute) : time.Minute.ToString()) + ":" + (time.Second < 10 ? ("0" + time.Second) : time.Second.ToString());
    }

    public static string TimeFormat(long timestamp)
    {
        return TimeFormat(ConvertTime(timestamp));
    }
    #endregion

    #region Methods
    public static int SortFrameById(ActionNode item1, ActionNode item2)
    {
        if (item1.m_Id < item2.m_Id)
        {
            return -1;
        }
        else if (item1.m_Id > item2.m_Id)
        {
            return 1;
        }

        return 0;
    }
    #endregion
}
#endif

#region ColorDefine
public class ColorDefine
{
    public static Color Cheery
    {
        get { return new Color(227f / 255, 71f / 255f, 108f / 255f); }
    }

    public static Color Pink
    {
        get { return new Color(234f / 255, 83f / 255f, 85f / 255f); }
    }

    public static Color LightGray
    {
        get { return new Color(0.921f, 0.921f, 0.921f); }
    }

    public static Color Gray
    {
        get { return new Color(0.698f, 0.698f, 0.698f); }
    }

    public static Color DarkGray
    {
        get { return new Color(0.353f, 0.353f, 0.353f); }
    }

    public static Color Yellow
    {
        get { return new Color(255f / 255f, 255f / 255f, 0f / 255f); }
    }

    public static Color Orange
    {
        get { return new Color(245f / 255, 166f / 255f, 35f / 255f); }
    }
    public static Color Blue
    {
        get { return new Color(109f / 255, 171f / 255f, 250f / 255f); }
    }
    public static Color LightBlue
    {
        get { return new Color(0f / 255, 255f / 255f, 255f / 255f); }
    }
    public static Color Purple
    {
        get { return new Color(150f / 255, 0f / 255f, 255f / 255f); }
    }
    public static Color Red
    {
        get { return new Color(227f / 255, 71f / 255f, 108f / 255f); }
    }

    public static Color Green
    {
        get { return new Color(78f / 255, 216f / 255f, 122f / 255f); }
    }

    public static Color Black
    {
        get { return new Color(0, 0, 0); }
    }
}
#endregion
