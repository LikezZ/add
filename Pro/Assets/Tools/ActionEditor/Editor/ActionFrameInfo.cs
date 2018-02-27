/********************************************************************************
 *	文件名：	ActionFrameInfo.cs
 *	创建人：	Like
 *	创建时间：  
 *
 *	功能说明：  节点编辑窗口 基类
 *	修改记录：
*********************************************************************************/

using UnityEditor;
using UnityEngine;
using System.Collections.Generic;
using System.Text.RegularExpressions;

public class ActionParam
{
    public string m_Name;
    public string m_Describe;
    public string m_Type;
    public bool m_IsShared;

    public ActionParam()
    {
        m_Name = "";
        m_Describe = "";
        m_Type = "";
        m_IsShared = false;
    }
}

public class ActionFrameItem
{
    public string m_Name;
    public string m_Describe;
    public List<ActionParam> m_Params;
    public string m_FileName;

    public ActionFrameItem()
    {
        m_Name = "";
        m_Describe = "";
        m_FileName = "";
        m_Params = new List<ActionParam>();
    }

    public void ParseItem(string str, string fileName)
    {
        m_FileName = fileName.Substring(0, fileName.Length - 4);

        Match match = Regex.Match(str, @"%Name\[.*\]%");
        if (match.Success)
        {
            int len = match.Value.Length - 8;
            m_Name = match.Value.Substring(6, len);
        }
        match = Regex.Match(str, @"%Describe\[.*\]%");
        if (match.Success)
        {
            int len = match.Value.Length - 12;
            m_Describe = match.Value.Substring(10, len);
        }
        MatchCollection matchs = Regex.Matches(str, @"%Params\[.*\]%");
        foreach (Match item in matchs)
        {
            ActionParam param = new ActionParam();
            int len = item.Value.Length - 10;
            string temp = item.Value.Substring(8, len);
            if (temp.Contains("[Shared]"))
            {
                param.m_IsShared = true;
            }
            match = Regex.Match(temp, @"Name\[[^\]]*\]{1}");
            if (match.Success)
            {
                len = match.Value.Length - 6;
                param.m_Name = match.Value.Substring(5, len);
            }
            match = Regex.Match(temp, @"Type\[[^\]]*\]{1}");
            if (match.Success)
            {
                len = match.Value.Length - 6;
                param.m_Type = match.Value.Substring(5, len);
            }
            match = Regex.Match(temp, @"Describe\[[^\]]*\]{1}");
            if (match.Success)
            {
                len = match.Value.Length - 10;
                param.m_Describe = match.Value.Substring(9, len);
            }
            m_Params.Add(param);
        }
        // 添加默认延时参数
        ActionParam delay = new ActionParam();
        delay.m_IsShared = false;
        delay.m_Name = "mDelay";
        delay.m_Type = "Float";
        delay.m_Describe = "延时执行参数";
        m_Params.Add(delay);
    }
}

public class ActionNode
{
    public enum TriggerType
    {
        Time = 0,
        Event = 1,
    }

    public class Trigger
    {
        public TriggerType m_Type;
        public string m_Param;

        public Trigger()
        {
            m_Type = TriggerType.Time;
            m_Param = "";
        }
    }

    public int m_Id;
    public Trigger m_Trigger;
    public Dictionary<string, string> m_Params;
    public string m_Handler;

    public ActionNode()
    {
        m_Id = 1;
        m_Trigger = new Trigger();
        m_Params = new Dictionary<string, string>();
        m_Handler = "";
    }

    public string TransformString()
    {
        string data = "";
        data += "\t{\r\n\t\t";
        data += "mId = " + m_Id.ToString() + ",\r\n\t\t";
        string temp = "";
        if (m_Trigger.m_Type == TriggerType.Time)
        {
            temp = "\"time\"";
            data += "mTrigger = {mType = " + temp + ", mTime = " + m_Trigger.m_Param + "},\r\n\t\t";
        }
        else if (m_Trigger.m_Type == TriggerType.Event)
        {
            temp = "\"event\"";
            data += "mTrigger = {mType = " + temp + ", mEvent = \"" + m_Trigger.m_Param + "\"},\r\n\t\t";
        }
        data += "mParams = {";
        int num = 0;
        foreach (var item in m_Params)
        {
            num++;
            data += item.Key + " = " + item.Value;
            if (num < m_Params.Count)
            {
                data += ", ";
            }
        }
        data += "},\r\n\t\t";
        data += "mHandler = \"" + m_Handler + "\"\r\n\t},\r\n";

        return data;
    }

    public void ParseNode(string str)
    {
        Match match = Regex.Match(str, @"\t\tmId = \d*,");
        if (match.Success)
        {
            int len = match.Value.Length - 9;
            string temp = match.Value.Substring(8, len);
            int.TryParse(temp, out m_Id);
        }
        match = Regex.Match(str, @"\t\tmTrigger = {.*},");
        if (match.Success)
        {
            int len = match.Value.Length - 16;
            string temp = match.Value.Substring(14, len);
            string[] temps = Regex.Split(temp, ", ");
            if (temps.Length == 2)
            {
                temp = temps[0];
                len = temp.Length - 10;
                temp = temp.Substring(9, len);
                if (temp == "event")
                {
                    m_Trigger.m_Type = TriggerType.Event;

                    temp = temps[1];
                    len = temp.Length - 11;
                    temp = temp.Substring(10, len);
                    if (temp.IndexOf("\"") != -1)
                    {
                        temp = temp.Substring(1, temp.Length - 2);
                    }
                    m_Trigger.m_Param = temp;
                }
                else if (temp == "time")
                {
                    m_Trigger.m_Type = TriggerType.Time;

                    temp = temps[1];
                    len = temp.Length - 8;
                    temp = temp.Substring(8, len);
                    m_Trigger.m_Param = temp;
                }
            }
        }
        match = Regex.Match(str, @"\t\tmParams = {.*},");
        if (match.Success)
        {
            int len = match.Value.Length - 15;
            string temp = match.Value.Substring(13, len);
            string[] temps = Regex.Split(temp, ", ");
            foreach (var item in temps)
            {
                string[] p = Regex.Split(item, " = ");
                if (p.Length == 2)
                {
                    string key = p[0];
                    string value = p[1];
                    m_Params.Add(key, value);
                }
            }
        }
        match = Regex.Match(str, @"\t\tmHandler = "".*""");
        if (match.Success)
        {
            int len = match.Value.Length - 15;
            string temp = match.Value.Substring(14, len);
            m_Handler = temp;
        }
    }
}

public class ActionInfoData
{
    public string m_Name;
    public string m_Describe;
    public string m_FileName;
    public List<ActionNode> m_Nodes;

    public ActionInfoData()
    {
        m_Name = "";
        m_Describe = "";
        m_FileName = "";
        m_Nodes = new List<ActionNode>();
    }

    public string TransformString()
    {
        string data = "";
        data += "-- define " + m_FileName.Substring(0, m_FileName.Length - 4) + "\r\n";
        data += "-- %Name[" + m_Name + "]%\r\n";
        data += "-- %Describe[" + m_Describe + "]%\r\n\r\n";
        data += "local " + m_FileName.Substring(0, m_FileName.Length - 4) + " = {\r\n";
        foreach (var item in m_Nodes)
        {
            data += item.TransformString();
        }
        data += "};\r\nreturn " + m_FileName.Substring(0, m_FileName.Length - 4) + "\r\n";

        return data;
    }

    public void ParseData(string str)
    {
        Match match = Regex.Match(str, @"%Name\[.*\]%");
        if (match.Success)
        {
            int len = match.Value.Length - 8;
            m_Name = match.Value.Substring(6, len);
        }
        match = Regex.Match(str, @"%Describe\[.*\]%");
        if (match.Success)
        {
            int len = match.Value.Length - 12;
            m_Describe = match.Value.Substring(10, len);
        }
        string[] items = Regex.Split(str, @"},\r\n\t{");
        foreach (var item in items)
        {
            ActionNode node = new ActionNode();
            node.ParseNode(item);
            if (string.IsNullOrEmpty(node.m_Handler))
                continue;
            m_Nodes.Add(node);
        }
    }
}