using UnityEngine;
using System.Collections.Generic;

public class ComponentTool
{
    public static void Attach(Transform root, Transform child)
    {
        child.transform.parent = root;
        child.localPosition = new Vector3(0, 0, 0);
        child.localScale = new Vector3(1, 1, 1);
        child.localEulerAngles = new Vector3(0, 0, 0);
    }

    public static T FindChildComponent<T>(string objName, GameObject fromParent) where T : UnityEngine.Component
    {
        GameObject obj = FindChild(objName, fromParent);
        if (null != obj)
        {
            return obj.GetComponent<T>();
        }
        else
        {
            Debug.LogWarning("can't load component : " + objName);
            return null;
        }
    }

    public static GameObject FindChild(string objName, GameObject fromParent)
    {
        if (null == fromParent)
        {
            return GameObject.Find(objName);
        }
        GameObject parent = fromParent;
        Transform child = FindChild(parent.transform, objName);
        if (null != child)
        {
            return child.gameObject;
        }
        
        Debug.LogWarning("can't load gameObject : " + objName);
        return null;
    }

    public static List<GameObject> FindAllChild(string objName, GameObject fromParent)
    {
        List<GameObject> res = new List<GameObject>();
        if (null == fromParent)
        {
            var tmpObj = GameObject.Find(objName);
            if (null != tmpObj)
            {
                res.Add(tmpObj);
            }
            return res;
        }
        FindAllChild(fromParent.transform, ref res, objName);

        return res;
    }

    public static void FindAllChildComponents<T>(Transform parent, ref List<T> result) where T : UnityEngine.Component
    {
        T elem = parent.GetComponent<T>();
        if (null != elem)
        {
            result.Add(elem);
        }
        for (int i = 0; i < parent.childCount; ++i)
        {
            FindAllChildComponents<T>(parent.GetChild(i), ref result);
        }
    }

    private static Transform FindChild(Transform parent, string objName)
    {
        if (parent.name == objName)
        {
            return parent;
        }
        else
        {
            foreach (Transform item in parent)
            {
                Transform child = FindChild(item, objName);
                if (null != child)
                {
                    return child;
                }
            }
            return null;
        }
    }

    private static void FindAllChild(Transform parent, ref List<GameObject> res, string objName)
    {
        if (parent.name == objName)
        {
            res.Add(parent.gameObject);
        }
        foreach (Transform item in parent)
        {
            FindAllChild(item, ref res, objName);
        }
    }
}