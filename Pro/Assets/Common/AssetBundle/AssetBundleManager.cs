﻿using UnityEngine;
#if UNITY_EDITOR	
using UnityEditor;
#endif
using System.Collections;
using System.Collections.Generic;

/*
 	In this demo, we demonstrate:
	1.	Automatic asset bundle dependency resolving & loading.
		It shows how to use the manifest assetbundle like how to get the dependencies etc.
	2.	Automatic unloading of asset bundles (When an asset bundle or a dependency thereof is no longer needed, the asset bundle is unloaded)
	3.	Editor simulation. A bool defines if we load asset bundles from the project or are actually using asset bundles(doesn't work with assetbundle variants for now.)
		With this, you can player in editor mode without actually building the assetBundles.
	4.	Optional setup where to download all asset bundles
	5.	Build pipeline build postprocessor, integration so that building a player builds the asset bundles and puts them into the player data (Default implmenetation for loading assetbundles from disk on any platform)
	6.	Use WWW.LoadFromCacheOrDownload and feed 128 bit hash to it when downloading via web
		You can get the hash from the manifest assetbundle.
	7.	AssetBundle variants. A prioritized list of variants that should be used if the asset bundle with that variant exists, first variant in the list is the most preferred etc.
*/

// Loaded assetBundle contains the references count which can be used to unload dependent assetBundles automatically.
public class LoadedAssetBundle
{
    public AssetBundle m_AssetBundle;
    public int m_ReferencedCount;

    public LoadedAssetBundle(AssetBundle assetBundle)
    {
        m_AssetBundle = assetBundle;
        m_ReferencedCount = 1;
    }
}

// Class takes care of loading assetBundle and its dependencies automatically, loading variants automatically.
public class AssetBundleManager : MonoBehaviour
{
    static string m_BaseLoadingPath = "";
    static string[] m_Variants = { };
    static AssetBundleManifest m_AssetBundleManifest = null;

    static Dictionary<string, LoadedAssetBundle> m_LoadedAssetBundles = new Dictionary<string, LoadedAssetBundle>();
    static Dictionary<string, AssetBundleCreateRequest> m_LoadingRequests = new Dictionary<string, AssetBundleCreateRequest>();
    static Dictionary<string, string> m_LoadingErrors = new Dictionary<string, string>();
    static List<AssetBundleLoadOperation> m_InProgressOperations = new List<AssetBundleLoadOperation>();
    static Dictionary<string, string[]> m_Dependencies = new Dictionary<string, string[]>();

    // The base downloading url which is used to generate the full downloading url with the assetBundle names.
    public static string BaseLoadingPath
    {
        get { return m_BaseLoadingPath; }
        set { m_BaseLoadingPath = value; }
    }

    // Variants which is used to define the active variants.
    public static string[] Variants
    {
        get { return m_Variants; }
        set { m_Variants = value; }
    }

    // AssetBundleManifest object which can be used to load the dependecies and check suitable assetBundle variants.
    public static AssetBundleManifest AssetBundleManifestObject
    {
        set { m_AssetBundleManifest = value; }
        get { return m_AssetBundleManifest; }
    }

    // Get loaded AssetBundle, only return vaild object when all the dependencies are downloaded successfully.
    static public LoadedAssetBundle GetLoadedAssetBundle(string assetBundleName, out string error)
    {
        if (m_LoadingErrors.TryGetValue(assetBundleName, out error))
            return null;

        LoadedAssetBundle bundle = null;
        m_LoadedAssetBundles.TryGetValue(assetBundleName, out bundle);
        if (bundle == null)
            return null;

        // No dependencies are recorded, only the bundle itself is required.
        string[] dependencies = null;
        if (!m_Dependencies.TryGetValue(assetBundleName, out dependencies))
            return bundle;

        // Make sure all dependencies are loaded
        foreach (var dependency in dependencies)
        {
            if (m_LoadingErrors.TryGetValue(assetBundleName, out error))
                return bundle;
            // Wait all the dependent assetBundles being loaded.
            LoadedAssetBundle dependentBundle;
            m_LoadedAssetBundles.TryGetValue(dependency, out dependentBundle);
            if (dependentBundle == null)
            {
                // 缺少依赖资源
                //Debug.LogWarning("Error: " + assetBundleName + " lost dependency: " + dependency  + "!!!");
                return null;
            }
        }
        return bundle;
    }

    // Load AssetBundleManifest.
    static public AssetBundleLoadManifestOperation Initialize(string manifestAssetBundleName, GameObject go)
    {
        go.AddComponent<AssetBundleManager>();
        LoadAssetBundle(manifestAssetBundleName, true);
        var operation = new AssetBundleLoadManifestOperation(manifestAssetBundleName, "AssetBundleManifest", typeof(AssetBundleManifest));
        m_InProgressOperations.Add(operation);
        return operation;
    }

    // Load AssetBundle and its dependencies.
    static protected void LoadAssetBundle(string assetBundleName, bool isLoadingAssetBundleManifest = false)
    {
        // Check if the assetBundle has already been processed.
        bool isAlreadyProcessed = LoadAssetBundleInternal(assetBundleName, isLoadingAssetBundleManifest);

        // I think should allways check the dependencies  ：by Like 
        if (!isLoadingAssetBundleManifest)
            LoadDependencies(assetBundleName);
    }

    // Remaps the asset bundle name to the best fitting asset bundle variant.
    static protected string RemapVariantName(string assetBundleName)
    {
        // BundleName is Lower 
        assetBundleName = assetBundleName.ToLower();
        string[] bundlesWithVariant = m_AssetBundleManifest.GetAllAssetBundlesWithVariant();
        string[] split = assetBundleName.Split('.');
        int bestFit = int.MaxValue;
        int bestFitIndex = -1;
        // Loop all the assetBundles with variant to find the best fit variant assetBundle.
        for (int i = 0; i < bundlesWithVariant.Length; i++)
        {
            string[] curSplit = bundlesWithVariant[i].Split('.');
            if (curSplit[0] != split[0])
                continue;

            int found = System.Array.IndexOf(m_Variants, curSplit[1]);
            if (found != -1 && found < bestFit)
            {
                bestFit = found;
                bestFitIndex = i;
            }
        }
        if (bestFitIndex != -1)
            return bundlesWithVariant[bestFitIndex];
        else
            return assetBundleName;
    }

    // Where we actuall call WWW to download the assetBundle.
    static protected bool LoadAssetBundleInternal(string assetBundleName, bool isLoadingAssetBundleManifest)
    {
        // Already loaded.
        LoadedAssetBundle bundle = null;
        m_LoadedAssetBundles.TryGetValue(assetBundleName, out bundle);
        if (bundle != null)
        {
            bundle.m_ReferencedCount++;
            return true;
        }
        // @TODO: Do we need to consider the referenced count of Requests?
        if (m_LoadingRequests.ContainsKey(assetBundleName))
            return true;

        string path = m_BaseLoadingPath + assetBundleName;
        // For manifest assetbundle, always download it as we don't have hash for it.
        AssetBundleCreateRequest request = AssetBundle.LoadFromFileAsync(path);
        m_LoadingRequests.Add(assetBundleName, request);
        return false;
    }

    // Where we get all the dependencies and load them all.
    static protected void LoadDependencies(string assetBundleName)
    {
        if (m_AssetBundleManifest == null)
        {
            Debug.LogError("Please initialize AssetBundleManifest by calling AssetBundleManager.Initialize()");
            return;
        }

        // Get dependecies from the AssetBundleManifest object..
        string[] dependencies = null;
        if (!m_Dependencies.TryGetValue(assetBundleName, out dependencies))
        {
            dependencies = m_AssetBundleManifest.GetAllDependencies(assetBundleName);
            if (dependencies.Length == 0)
                return;

            for (int i = 0; i < dependencies.Length; i++)
                dependencies[i] = RemapVariantName(dependencies[i]);

            // Record and load all dependencies.
            m_Dependencies.Add(assetBundleName, dependencies);
        }

        for (int i = 0; i < dependencies.Length; i++)
            LoadAssetBundleInternal(dependencies[i], false);
    }

    // clear all assetbundle 
    static public void ClearAllAssetBundle()
    {
        foreach (var item in m_LoadedAssetBundles)
        {
            item.Value.m_AssetBundle.Unload(false);
        }

        m_LoadedAssetBundles.Clear();
        m_Dependencies.Clear();
        Resources.UnloadUnusedAssets();
    }

    // clear assetbundle depend reference
    static public void ClearUnusedAssetBundle()
    {
        List<string> clear = new List<string>();
        foreach (var item in m_LoadedAssetBundles)
        {
            if (item.Value.m_ReferencedCount <= 0)
            {
                clear.Add(item.Key);
            }
        }
        for (int i = 0; i < clear.Count; i++)
        {
            m_LoadedAssetBundles[clear[i]].m_AssetBundle.Unload(false);
            m_LoadedAssetBundles.Remove(clear[i]);
            m_Dependencies.Remove(clear[i]);

            Debug.Log("Unload " + clear[i] + " at frame " + Time.frameCount);
        }
        Resources.UnloadUnusedAssets();
    }

    // Unload assetbundle and its dependencies.
    static public void UnloadAssetBundle(string assetBundleName, bool unload = false)
    {
        //Debug.Log(m_LoadedAssetBundles.Count + " assetbundle(s) in memory before unloading " + assetBundleName);
        assetBundleName = RemapVariantName(assetBundleName);
        UnloadBundleInternal(assetBundleName, unload);
        UnloadDependencies(assetBundleName, unload);
        //Debug.Log(m_LoadedAssetBundles.Count + " assetbundle(s) in memory after unloading " + assetBundleName);
    }

    static protected void UnloadDependencies(string assetBundleName, bool unload)
    {
        string[] dependencies = null;
        if (!m_Dependencies.TryGetValue(assetBundleName, out dependencies))
            return;

        // Loop dependencies.
        foreach (var dependency in dependencies)
        {
            UnloadBundleInternal(dependency, unload);
        }
    }

    static protected void UnloadBundleInternal(string assetBundleName, bool unload)
    {
        string error;
        LoadedAssetBundle bundle = GetLoadedAssetBundle(assetBundleName, out error);
        if (bundle == null)
            return;

        if (--bundle.m_ReferencedCount <= 0)
        {
            if (unload)
            {
                bundle.m_AssetBundle.Unload(false);
                m_LoadedAssetBundles.Remove(assetBundleName);
            }
            //Debug.Log("AssetBundle " + assetBundleName + " has been unloaded successfully");
        }
    }

    void Update()
    {
        // Collect all the finished Requests.
        var keysToRemove = new List<string>();
        foreach (var keyValue in m_LoadingRequests)
        {
            AssetBundleCreateRequest load = keyValue.Value;
            // If downloading succeeds.
            if (load.isDone)
            {
                // If loading fails.
                if (load.assetBundle == null)
                {
                    Debug.LogError("Loading " + keyValue.Key + " Error !");
                    if (m_LoadingErrors.ContainsKey(keyValue.Key) == false)
                    { 
                        m_LoadingErrors.Add(keyValue.Key, "Error");
                    }
                    keysToRemove.Add(keyValue.Key);
                    continue;
                }
                Debug.Log("Loading " + keyValue.Key + " is done at frame " + Time.frameCount);
                m_LoadedAssetBundles.Add(keyValue.Key, new LoadedAssetBundle(load.assetBundle));
                keysToRemove.Add(keyValue.Key);
            }
        }
        // Remove the finished WWWs.
        foreach (var key in keysToRemove)
        {
            m_LoadingRequests.Remove(key);
        }
        // Update all in progress operations
        for (int i = 0; i < m_InProgressOperations.Count;)
        {
            if (!m_InProgressOperations[i].Update())
            {
                m_InProgressOperations.RemoveAt(i);
            }
            else
                i++;
        }
    }

    // Load asset from the given assetBundle. (同步加载，保证资源已经加载在内存中)
    static public LoadedAssetBundle LoadAssetSync(string assetBundleName, out string error)
    {
        assetBundleName = RemapVariantName(assetBundleName);
        if (m_LoadingErrors.TryGetValue(assetBundleName, out error))
            return null;
        LoadedAssetBundle bundle = null;
        m_LoadedAssetBundles.TryGetValue(assetBundleName, out bundle);
        if (bundle == null)
            return null;
        bundle.m_ReferencedCount++;
        // No dependencies are recorded, only the bundle itself is required.
        string[] dependencies = null;
        if (!m_Dependencies.TryGetValue(assetBundleName, out dependencies))
            return bundle;
        // Make sure all dependencies are loaded
        foreach (var dependency in dependencies)
        {
            if (m_LoadingErrors.TryGetValue(assetBundleName, out error))
                return bundle;
            // Wait all the dependent assetBundles being loaded.
            LoadedAssetBundle dependentBundle;
            m_LoadedAssetBundles.TryGetValue(dependency, out dependentBundle);
            if (dependentBundle == null)
            {
                // 缺少依赖资源
                Debug.LogWarning("Error: " + assetBundleName + " lost dependency: " + dependency + "!!!");
                return null;
            }
            dependentBundle.m_ReferencedCount++;
        }
        return bundle;
    }

    // Load asset from the given assetBundle.
    static public AssetBundleLoadAssetOperation LoadAssetAsync(string assetBundleName, string assetName, System.Type type)
    {
        AssetBundleLoadAssetOperation operation = null;
        {
            assetBundleName = RemapVariantName(assetBundleName);
            LoadAssetBundle(assetBundleName);
            operation = new AssetBundleLoadAssetOperationFull(assetBundleName, assetName, type);

            m_InProgressOperations.Add(operation);
        }
        return operation;
    }

    // Load asset from the given assetBundle.
    static public Object LoadAsset(string assetBundleName, string assetName, System.Type type)
    {
        assetBundleName = RemapVariantName(assetBundleName);
        string path = m_BaseLoadingPath + assetBundleName;
        // For manifest assetbundle, always download it as we don't have hash for it.
        AssetBundle bundle = AssetBundle.LoadFromFile(path);
        return bundle.LoadAsset(assetName, type);
    }

    // Load level from the given assetBundle.
    static public AssetBundleLoadOperation LoadLevelAsync(string assetBundleName, string levelName, bool isAdditive)
    {
        AssetBundleLoadOperation operation = null;
        {
            assetBundleName = RemapVariantName(assetBundleName);
            LoadAssetBundle(assetBundleName);
            operation = new AssetBundleLoadLevelOperation(assetBundleName, levelName, isAdditive);

            m_InProgressOperations.Add(operation);
        }

        return operation;
    }
} // End of AssetBundleManager.