using UnityEngine;
using System.Collections;
using System.IO;
using System;
using LuaInterface;
using System.Collections.Generic;

// 客户端引擎Lua封装系统
public static class LuaEngineSystem
{

    // 删除目录
    public static void DeleteDir(string path)
    {
        if (!Directory.Exists(path))
            return;

        try
        {
            Directory.Delete(path, true);
        }
        catch (Exception e)
        {
            Debug.Log(e.ToString());
        }
    }

    // 创建目录
    public static void CreateDir(string path)
    {
        try
        {
            Directory.CreateDirectory(path);
        }
        catch (Exception e)
        {
            Debug.Log(e.ToString());
        }
    }

    // 判断文件是否存在
    public static bool IsFileExsit(string fileName)
    {
        if (!File.Exists(fileName))
            return false;

        return true;
    }

    // 删除文件
    public static void DeleteFile(string fileName)
    {
        if (!IsFileExsit(fileName))
            return;

        try
        {
            File.Delete(fileName);
        }
        catch (Exception e)
        {
            Debug.Log(e.ToString());
        }
    }

    // 清空缓存
    public static void FreeMemory()
    {
        GC.Collect();
    }

    // 切换场景
    public static void ChangeScene(string name)
    {
        int pos = name.LastIndexOf('/');
        if (pos >= 0)
            name = name.Substring(pos + 1);

        UnityEngine.SceneManagement.SceneManager.LoadScene(name);
    }

    // 获取当前场景名
    public static string GetSceneName()
    {
        string name = "";
        UnityEngine.SceneManagement.Scene scene = UnityEngine.SceneManagement.SceneManager.GetActiveScene();
        if (scene != null)
        {
            name = scene.name;
        }
        return name;
    }

    // 切换场景
    public static AsyncOperation ChangeSceneAsync(string name)
    {
        int pos = name.LastIndexOf('/');
        if (pos >= 0)
            name = name.Substring(pos + 1);

        return UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(name);
    }

    // 加载资源asset
    public static void LoadAssetBundle(string bundleName, string assetName, Type type, LuaFunction func, object param)
    {
        ResourceManager.Instance.LoadAsset(bundleName, assetName, type, delegate (UnityEngine.Object obj) {
            if (func != null)
            {
                func.Call(obj, param);
            }
            // 减引用计数
            AssetBundleManager.UnloadAssetBundle(bundleName, false);
        });
    }

    // 加载资源bundle  常驻内存不减引用计数
    public static void LoadCommonBundle(string bundleName, LuaFunction func, object param)
    {
        ResourceManager.Instance.LoadAsset(bundleName, "", typeof(UnityEngine.Object), delegate (UnityEngine.Object obj) {
            if (func != null)
            {
                func.Call(param);
            }
        });
    }

    // 卸载指定资源Bundle
    public static void UnLoadAssetBundle(string bundleName)
    {
        AssetBundleManager.UnloadAssetBundle(bundleName, true);
    }

    // 卸载没用的资源
    public static void ClearUnusedAssetBundle()
    {
        AssetBundleManager.ClearUnusedAssetBundle();
    }

    // 卸载所有加载的资源
    public static void ClearAllAssetBundle()
    {
        AssetBundleManager.ClearAllAssetBundle();
    }

    public static string LoadDataFile(string fileName)
    {
        string buffer = null;
        string path = "Data/" + fileName;

        string file = FileUtils.LoadDataPath + path;
        if (!file.EndsWith(".txt"))
        {
            file += ".txt";
        }
        if (File.Exists(file))
        {
            return FileUtils.ReadStringFile(file);
        }

        file = FileUtils.LoadStreamingPath + path;
        if (!file.EndsWith(".txt"))
        {
            file += ".txt";
        }
        if (File.Exists(file))
        {
            return FileUtils.ReadStringFile(file);
        }

        TextAsset text = Resources.Load(path, typeof(TextAsset)) as TextAsset;
        if (text != null)
        {
            buffer = text.text;
            Resources.UnloadAsset(text);
        }

        return buffer;
    }

    public static GameObject GetGameObject(GameObject target, string name)
    {
        return ComponentTool.FindChild(name, target);
    }

    public static Vector3 CheckCollision(Transform transform, int checkLayer, Vector3 moves)
    {
        return L.CollisionManager.Instance.CheckCollision(transform, checkLayer, moves);
    }
}
