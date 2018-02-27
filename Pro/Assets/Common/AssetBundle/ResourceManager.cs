using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System;

public class ResourceManager : MonoBehaviour
{
    private static ResourceManager s_Instance = null;

    public static ResourceManager Instance
    {
        get
        {
            return s_Instance;
        }
    }

    public ResourceManager()
    {
        if (s_Instance == null)
        {
            s_Instance = this;
        }
    }

    private Action<int> _onInitDone;

    public void Init(Action<int> onInitDone, Action<int> onPercent = null)
    {
        _onInitDone = onInitDone;
        StartCoroutine(Initialize());
    }

    public void LoadLevel(string abname, string assetname, Action func)
    {
        if (string.IsNullOrEmpty(abname) || string.IsNullOrEmpty(assetname))
        {
            Debug.LogError("错误的场景资源");
            return;
        }

        StartCoroutine(OnLoadLevel(abname, assetname, func));
    }

    private Dictionary<string, List<Action<UnityEngine.Object>>> dicFuncAsset = new Dictionary<string, List<Action<UnityEngine.Object>>>();

    // 加载单个资源(同步，保证之前AB包已经异步加载过)
    public T LoadAssetSync<T>(string abname, string assetname) where T : UnityEngine.Object
    {
        if (string.IsNullOrEmpty(abname) || string.IsNullOrEmpty(assetname))
        {
            Debug.LogError("错误的资源名:" + abname + "|" + assetname);
            return default(T);
        }

        try
        {
            string error;
            LoadedAssetBundle bundle = AssetBundleManager.LoadAssetSync(abname, out error);
            T asset = bundle.m_AssetBundle.LoadAsset<T>(assetname);
            return asset;
        }
        catch (System.Exception ex)
        {
            Debug.LogError("load asset sync failure, bundle name: " + abname + ", asset name: " + assetname);
            throw ex;
        }
    }

    // 基础加载资源方法
    public void LoadAsset<T>(string abname, string assetname, Action<UnityEngine.Object> func) where T : UnityEngine.Object
    {
        if (dicFuncAsset.ContainsKey(assetname))
        {
            dicFuncAsset[assetname].Add(func);
        }
        else
        {
            dicFuncAsset[assetname] = new List<Action<UnityEngine.Object>>();
            dicFuncAsset[assetname].Add(func);
            StartCoroutine(OnLoadAsset(abname, assetname, typeof(T)));
        }
    }

    // 基础加载资源方法
    public void LoadAsset(string abname, string assetname, Type type, Action<UnityEngine.Object> func)
    {
        if (dicFuncAsset.ContainsKey(assetname))
        {
            dicFuncAsset[assetname].Add(func);
        }
        else
        {
            dicFuncAsset[assetname] = new List<Action<UnityEngine.Object>>();
            dicFuncAsset[assetname].Add(func);
            StartCoroutine(OnLoadAsset(abname, assetname, type));
        }
    }

    public T LoadBuildInResource<T>(string resname) where T : UnityEngine.Object
    {
        return Resources.Load<T>(resname);
    }

    //public up private down---------------------------------------------------------
    //-------------------------------------------------------------------------------
    private IEnumerator Initialize()
    {
        string platformFolderForAssetBundles = FileUtils.GetPlatformFolderForAssetBundles(Application.platform);
        bool modeLocal = true;
        if (modeLocal)
            AssetBundleManager.BaseLoadingPath = FileUtils.LoadStreamingPath + "AssetBundles/" + platformFolderForAssetBundles + "/";
        else
            AssetBundleManager.BaseLoadingPath = FileUtils.LoadDataPath + "AssetBundles/" + platformFolderForAssetBundles + "/";

        AssetBundleManager.Variants = new string[] { "data" };
        // Initialize AssetBundleManifest which loads the AssetBundleManifest object.
        var request = AssetBundleManager.Initialize(platformFolderForAssetBundles, this.gameObject);
        if (request != null)
            yield return StartCoroutine(request);
        _onInitDone(1);
    }

    private IEnumerator OnLoadAsset(string abname, string assetName, Type type)
    {
        AssetBundleLoadAssetOperation request = AssetBundleManager.LoadAssetAsync(abname, assetName, type);
        if (request == null) yield break;
        yield return StartCoroutine(request);

        if (dicFuncAsset.ContainsKey(assetName))
        {
            for (int i = 0; i < dicFuncAsset[assetName].Count; i++)
            {
                dicFuncAsset[assetName][i](request.GetAsset());
            }
            dicFuncAsset.Remove(assetName);
        }
    }

    private IEnumerator OnLoadLevel(string abname, string levelName, Action func)
    {
        Debug.Log("Start to load scene " + levelName + " at frame " + Time.frameCount);
        AssetBundleLoadOperation request = AssetBundleManager.LoadLevelAsync(abname, levelName, false);
        if (request == null) yield break;
        yield return StartCoroutine(request);
        func();
        Debug.Log("Finish loading scene " + levelName + " at frame " + Time.frameCount);
    }
}