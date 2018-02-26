using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using System;
using System.Text;
using System.Security.Cryptography;


// 为了优化Lua调用效率和便利性，将通用的操作，全部放在这个地方
public class ScriptHelper
{

    // 异或
    public static int XOR(int value1, int value2)
    {
        int ret = value1 ^ value2;
        return ret;
    }

    // 异或
    // Lua里面Number为Double型，如果为Int4294967294传递时会丢失数据导致问题
    // 所以通过字符串传递
    public static int XOR(string value1, string value2)
    {
        uint temp1 = 0;
        uint temp2 = 0;
        if (value1.IndexOf('-') == 0)
            temp1 = (uint)Int32.Parse(value1);
        else
            temp1 = UInt32.Parse(value1);
        if (value2.IndexOf('-') == 0)
            temp2 = (uint)Int32.Parse(value2);
        else
            temp2 = UInt32.Parse(value2);
        uint ret = temp1 ^ temp2;
        return (int)ret;
    }

    // 与运算
    public static int AND(int value1, int value2)
    {
        int ret = value1 & value2;
        return ret;
    }

    // 与运算
    // Lua里面Number为Double型，如果为Int4294967294传递时会丢失数据导致问题
    // 所以通过字符串传递
    public static int AND(string value1, string value2)
    {
        uint temp1 = 0;
        uint temp2 = 0;
        if (value1.IndexOf('-') == 0)
            temp1 = (uint)Int32.Parse(value1);
        else
            temp1 = UInt32.Parse(value1);
        if (value2.IndexOf('-') == 0)
            temp2 = (uint)Int32.Parse(value2);
        else
            temp2 = UInt32.Parse(value2);
        uint ret = temp1 & temp2;
        return (int)ret;
    }

    // 非运算
    public static int NO(int value)
    {
        int ret = ~value;
        return ret;
    }

    // 非运算
    // Lua里面Number为Double型，如果为Int4294967294传递时会丢失数据导致问题
    // 所以通过字符串传递
    public static int NO(string value)
    {
        uint temp = 0;
        if (value.IndexOf('-') == 0)
            temp = (uint)Int32.Parse(value);
        else
            temp = UInt32.Parse(value);
        uint ret = ~temp;
        return (int)ret;
    }

    // 或运算
    public static int OR(int value1, int value2)
    {
        int ret = value1 | value2;
        return ret;
    }

    // 或运算
    // Lua里面Number为Double型，如果为Int4294967294传递时会丢失数据导致问题
    // 所以通过字符串传递
    public static int OR(string value1, string value2)
    {
        uint temp1 = 0;
        uint temp2 = 0;
        if (value1.IndexOf('-') == 0)
            temp1 = (uint)Int32.Parse(value1);
        else
            temp1 = UInt32.Parse(value1);
        if (value2.IndexOf('-') == 0)
            temp2 = (uint)Int32.Parse(value2);
        else
            temp2 = UInt32.Parse(value2);
        uint ret = temp1 | temp2;
        return (int)ret;
    }

    // 向右位移运算
    public static int ShiftR(int value, int num)
    {
        int ret = value >> num;
        return ret;
    }

    // 向右位移运算
    // Lua里面Number为Double型，如果为Int4294967294传递时会丢失数据导致问题
    // 所以通过字符串传递
    public static int ShiftR(string value, string num)
    {
        uint temp1 = 0;
        uint temp2 = 0;
        if (value.IndexOf('-') == 0)
            temp1 = (uint)Int32.Parse(value);
        else
            temp1 = UInt32.Parse(value);
        if (num.IndexOf('-') == 0)
            temp2 = (uint)Int32.Parse(num);
        else
            temp2 = UInt32.Parse(num);
        uint ret = temp1 >> (int)temp2;
        return (int)ret;
    }

    // 向左位移运算
    public static int ShiftL(int value, int num)
    {
        int ret = value << num;
        return ret;
    }

    // 向左位移运算
    // Lua里面Number为Double型，如果为Int4294967294传递时会丢失数据导致问题
    // 所以通过字符串传递
    public static int ShiftL(string value, string num)
    {
        uint temp1 = 0;
        uint temp2 = 0;
        if (value.IndexOf('-') == 0)
            temp1 = (uint)Int32.Parse(value);
        else
            temp1 = UInt32.Parse(value);
        if (num.IndexOf('-') == 0)
            temp2 = (uint)Int32.Parse(num);
        else
            temp2 = UInt32.Parse(num);
        uint ret = temp1 << (int)temp2;
        return (int)ret;
    }

    // UTF8转为Base64
    public static string UTF8ToBase64(string str)
    {
        byte[] bytes = Encoding.UTF8.GetBytes(str);
        return Convert.ToBase64String(bytes);
    }

    // Base64转为UTF8
    public static string Base64ToUTF8(string strBase64)
    {
        byte[] outputb = Convert.FromBase64String(strBase64);
        return Encoding.UTF8.GetString(outputb);
    }

    // 计算String MD5
    public static string GetStringMD5(string str)
    {
        MD5 md5 = MD5.Create();
        byte[] en = md5.ComputeHash(Encoding.UTF8.GetBytes(str));
        StringBuilder sBuilder = new StringBuilder();
        for (int i = 0; i < en.Length; i++)
        {
            sBuilder.Append(en[i].ToString("x"));
        }
        return sBuilder.ToString();
    }

    private static void GetComponentByType<T>(UnityEngine.Object obj, out T target) where T : Component
    {
        if (obj is T)
            target = (obj as T);
        else if (obj is Component)
            target = (obj as Component).gameObject.GetComponent<T>();
        else if (obj is GameObject)
            target = (obj as GameObject).GetComponent<T>();
        else target = null;
    }

    private static void GetObjectTransform(UnityEngine.Object obj, out Transform target)
    {
        if (obj is Transform)
            target = (obj as Transform);
        else if (obj is Component)
            target = (obj as Component).transform;
        else if (obj is GameObject)
            target = (obj as GameObject).transform;
        else target = null;
    }

    // 射线拾取
    public static void RaycastByScreenPoint(int mask, float distance, float x, float y, float z, out GameObject retObject, out float retX, out float retY, out float retZ)
    {
        if (Camera.main == null)
        {
            retObject = null;
            retX = 0;
            retY = 0;
            retZ = 0;
            return;
        }

        RaycastHit ret;
        Ray ray = Camera.main.ScreenPointToRay(new Vector3(x, y, z));
        if (!Physics.Raycast(ray, out ret, distance, mask))
        {
            retObject = null;
            retX = 0;
            retY = 0;
            retZ = 0;
            return;
        }

        retObject = ret.collider.gameObject;
        retX = ret.point.x;
        retY = ret.point.y;
        retZ = ret.point.z;
    }

    // Enable Camera
    public static void EnableOrDisableCamera(UnityEngine.Object obj, bool bEnable)
    {
        Camera component = null;
        GetComponentByType<Camera>(obj, out component);
        if (component == null) return;

        component.enabled = bEnable;
    }

    // 设置对象X位置
    public static void SetPositionX(UnityEngine.Object obj, float x)
    {
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return;

        Vector3 now = trans.position;
        trans.position = new Vector3(x, now.y, now.z);
    }

    // 设置对象Y位置
    public static void SetPositionY(UnityEngine.Object obj, float y)
    {
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return;

        Vector3 now = trans.position;
        trans.position = new Vector3(now.x, y, now.z);
    }

    // 设置对象Z位置
    public static void SetPositionZ(UnityEngine.Object obj, float z)
    {
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return;

        Vector3 now = trans.position;
        trans.position = new Vector3(now.x, now.y, z);
    }

    // 设置对象X,Y,X位置
    public static void SetPosition(UnityEngine.Object obj, float x, float y, float z)
    {
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return;

        Vector3 now = trans.position;
        trans.position = new Vector3(x, y, z);
    }

    // 获取对象X,Y,X位置
    public static void GetPosition(UnityEngine.Object obj, out float x, out float y, out float z)
    {
        x = 0;
        y = 0;
        z = 0;
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return;

        Vector3 now = trans.position;
        x = now.x;
        y = now.y;
        z = now.z;
    }

    // 设置对象X位置
    public static void SetLocalPositionX(UnityEngine.Object obj, float x)
    {
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return;

        Vector3 now = trans.localPosition;
        trans.localPosition = new Vector3(x, now.y, now.z);
    }

    // 设置对象Y位置
    public static void SetLocalPositionY(UnityEngine.Object obj, float y)
    {
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return;

        Vector3 now = trans.localPosition;
        trans.localPosition = new Vector3(now.x, y, now.z);
    }

    // 设置对象Z位置
    public static void SetLocalPositionZ(UnityEngine.Object obj, float z)
    {
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return;

        Vector3 now = trans.localPosition;
        trans.localPosition = new Vector3(now.x, now.y, z);
    }

    // 设置对象X,Y,X位置
    public static void SetLocalPosition(UnityEngine.Object obj, float x, float y, float z)
    {
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return;

        Vector3 now = trans.localPosition;
        trans.localPosition = new Vector3(x, y, z);
    }

    // 获取对象X,Y,X位置
    public static void GetLocalPosition(UnityEngine.Object obj, out float x, out float y, out float z)
    {
        x = 0;
        y = 0;
        z = 0;
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return;

        Vector3 now = trans.localPosition;
        x = now.x;
        y = now.y;
        z = now.z;
    }

    // 设置对象的层级
    public static void SetGameObjectLayer(UnityEngine.Object obj, int layermask)
    {
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return;

        trans.gameObject.layer = layermask;
        int childCount = trans.childCount;
        for (int i = 0; i < childCount; i++)
        {
            Transform child = trans.GetChild(i);
            child.gameObject.layer = layermask;
            SetGameObjectLayer(child.gameObject, layermask);
        }
    }

    // 设置对象是否可见
    public static void SetObjectActive(UnityEngine.Object obj, int active)
    {
        bool bActive = (active == 0 ? false : true);
        if (obj is Component)
        {
            Component c = (obj as Component);
            if (c.gameObject.activeSelf != bActive)
            {
                c.gameObject.SetActive(bActive);
            }
        }
        else if (obj is GameObject)
        {
            UnityEngine.GameObject o = (obj as GameObject);
            if (o.activeSelf != bActive)
            {
                o.SetActive(bActive);
            }
        }
    }

    // 获取对象旋转
    public static Quaternion GetRotation(UnityEngine.Object obj)
    {
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return Quaternion.identity;
        return trans.rotation;
    }

    // 设置对象旋转
    public static void SetRotation(UnityEngine.Object obj, Quaternion rotation)
    {
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return;
        trans.rotation = rotation;
    }

    // 设置对象旋转
    public static void SetRotationXYZ(UnityEngine.Object obj, float x, float y, float z)
    {
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return;
        trans.localRotation = Quaternion.Euler(x, y, z);
    }

    // 获取对象旋转
    public static Quaternion GetLocalRotation(UnityEngine.Object obj)
    {
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return Quaternion.identity;
        return trans.localRotation;
    }

    // 设置对象旋转
    public static void SetLocalRotation(UnityEngine.Object obj, Quaternion rotation)
    {
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return;
        trans.localRotation = rotation;
    }

    // 设置对象旋转
    public static void SetLocalRotationXYZ(UnityEngine.Object obj, float x, float y, float z)
    {
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return;
        trans.localRotation = Quaternion.Euler(x, y, z);
    }

    // 查找对像
    public static Transform FindTransform(UnityEngine.Object obj, string path)
    {
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return null;
        return trans.Find(path);
    }

    // 查找对像
    public static GameObject GetChild(UnityEngine.Object obj, int index)
    {
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return null;
        Transform child = trans.GetChild(index);
        if (child == null) return null;
        return child.gameObject; 
    }

    // 查找对像
    public static int ChildCount(UnityEngine.Object obj)
    {
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return 0;
        return trans.childCount;
    }

    // Look At目标对象
    public static void LookAt(UnityEngine.Object obj, UnityEngine.Object target)
    {
        Transform trans1, trans2;
        GetObjectTransform(obj, out trans1);
        if (trans1 == null) return;
        GetObjectTransform(target, out trans2);
        if (trans2 == null) return;
        trans1.LookAt(trans2);
    }

    // Look At目标对象
    public static void LookAt(UnityEngine.Object obj, float x, float y, float z)
    {
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return;
        trans.LookAt(new Vector3(x, y, z));
    }

    // 设置对象X,Y,X大小缩放
    public static void SetScale(UnityEngine.Object obj, float x, float y, float z)
    {
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return;

        Vector3 now = trans.localScale;
        trans.localScale = new Vector3(x, y, z);
    }

    public static void GetScale(UnityEngine.Object obj, out float x, out float y, out float z)
    {
        x = 1;
        y = 1;
        z = 1;
        Transform trans;
        GetObjectTransform(obj, out trans);
        if (trans == null) return;

        Vector3 now = trans.localScale;
        x = now.x;
        y = now.y;
        z = now.z;
    }

    // 设置父节点
    public static void SetParent(UnityEngine.Object obj, UnityEngine.Object parent, int stay)
    {
        Transform trans1, trans2;
        GetObjectTransform(obj, out trans1);
        if (trans1 == null) return;
        GetObjectTransform(parent, out trans2);
        if (trans2 == null) return;
        trans1.SetParent(trans2, stay == 0 ? false : true);
    }

    // 设置对象名称
    public static void SetName(UnityEngine.Object obj, string name)
    {
        obj.name = name;
    }

    // 设置文本
    public static void SetText(UnityEngine.Object obj, string text)
    {
        Text temp;
        GetComponentByType(obj, out temp);
        if (temp != null) temp.text = text; 
    }

    // 设置shader属性
    public static void SetShaderParam(UnityEngine.Object obj, string shadername, string key, int value)
    {
        GameObject target = null;
        if (obj is Transform)
            target = (obj as Transform).gameObject;
        else if (obj is Component)
            target = (obj as Component).gameObject;
        else if (obj is GameObject)
            target = (obj as GameObject).gameObject;
        if (target == null)
            return;

        Renderer[] rl = target.GetComponentsInChildren<Renderer>();
        int count = rl.Length;
        for (int i = 0; i < count; i++)
        {
            Material[] materials = rl[i].materials;
            int len = materials.Length;
            for (int j = 0; j < len; j++)
            {
                if (materials[j].shader.name == shadername)
                {
                    materials[j].SetInt(key, value);
                }
            }
        }
    }

    // 设置shader属性
    public static void SetShaderParam(UnityEngine.Object obj, string shadername, string key, float value)
    {
        GameObject target = null;
        if (obj is Transform)
            target = (obj as Transform).gameObject;
        else if (obj is Component)
            target = (obj as Component).gameObject;
        else if (obj is GameObject)
            target = (obj as GameObject).gameObject;
        if (target == null)
            return;

        Renderer[] rl = target.GetComponentsInChildren<Renderer>();
        int count = rl.Length;
        for (int i = 0; i < count; i++)
        {
            Material[] materials = rl[i].materials;
            int len = materials.Length;
            for (int j = 0; j < len; j++)
            {
                if (materials[j].shader.name == shadername)
                {
                    materials[j].SetFloat(key, value);
                }
            }
        }
    }

    // 设置shader属性
    public static void SetShaderParam(UnityEngine.Object obj, string shadername, string key, int r, int g, int b, int a)
    {
        GameObject target = null;
        if (obj is Transform)
            target = (obj as Transform).gameObject;
        else if (obj is Component)
            target = (obj as Component).gameObject;
        else if (obj is GameObject)
            target = (obj as GameObject).gameObject;
        if (target == null)
            return;

        Renderer[] rl = target.GetComponentsInChildren<Renderer>();
        int count = rl.Length;
        for (int i = 0; i < count; i++)
        {
            Material[] materials = rl[i].materials;
            int len = materials.Length;
            for (int j = 0; j < len; j++)
            {
                if (materials[j].shader.name == shadername)
                {
                    materials[j].SetColor(key, new Color(r / 255.0f, g / 255.0f, b / 255.0f, a / 255.0f));
                }
            }
        }
    }

    // 设置shader属性
    public static void SetShaderParam(UnityEngine.Object obj, string shadername, string key, Texture value)
    {
        GameObject target = null;
        if (obj is Transform)
            target = (obj as Transform).gameObject;
        else if (obj is Component)
            target = (obj as Component).gameObject;
        else if (obj is GameObject)
            target = (obj as GameObject).gameObject;
        if (target == null)
            return;

        Renderer[] rl = target.GetComponentsInChildren<Renderer>();
        int count = rl.Length;
        for (int i = 0; i < count; i++)
        {
            Material[] materials = rl[i].materials;
            int len = materials.Length;
            for (int j = 0; j < len; j++)
            {
                if (materials[j].shader.name == shadername)
                {
                    materials[j].SetTexture(key, value);
                }
            }
        }
    }

    /// <summary>
    /// 获取父节点到当前节点的路径，例如AAA/BBB/CCC  
    /// 这里self指的是CCC自己  则调用如下 GetPathFromParentToSelf("AAA",selfTransForm); 
    /// 返回结果是BBB/CCC 注意不包含AAA目录 
    /// </summary>
    /// <param name="parentName">需要找到的上层路径名称</param>
    /// <param name="self">目标自己的Transform</param>
    /// <returns></returns>
    public static string GetPathFromParentToSelf(string parentName, Transform self)
    {
        string path = self.name;
        Transform temp = self;
        while (temp.parent != null)
        {
            if (temp.parent.name != parentName)
            {
                path = temp.parent.name + "/" + path;
                temp = temp.parent;
            }
            else
            {
                break;
            }
        }
        return path;
    }

    // 强制去掉富文本的文字信息
    // [b][u][s][url][i][s][sub]
    // [/b][/u][/s][/url][/i][/s][/sub]
    public static string CheckRichText(string text)
    {
        string ret = text;
        ret = text.Replace("[b]", "");
        ret = text.Replace("[/b]", "");
        ret = text.Replace("[u]", "");
        ret = text.Replace("[/u]", "");
        ret = text.Replace("[s]", "");
        ret = text.Replace("[/s]", "");
        ret = text.Replace("[url]", "");
        ret = text.Replace("[/url]", "");
        ret = text.Replace("[i]", "");
        ret = text.Replace("[/i]", "");
        ret = text.Replace("[s]", "");
        ret = text.Replace("[/s]", "");
        ret = text.Replace("[sub]", "");
        ret = text.Replace("[/sub]", "");
        return ret;
    }
}
