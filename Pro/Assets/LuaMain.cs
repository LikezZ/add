using UnityEngine;
using System.Collections;
using LuaInterface;

public class LuaMain : LuaClient {

    protected override LuaFileUtils InitLoader()
    {
        return new LuaResLoader();
    }

    protected override void LoadLuaFiles()
    {
        AssetBundleManifest abm = AssetBundleManager.AssetBundleManifestObject;
        string[] allAB = abm.GetAllAssetBundles();
        for (int i = 0; i < allAB.Length; i++)
        {
            string ab = allAB[i];
            if (true)
            {

            }
        }
        //ResourceManager.Instance.LoadList();
        OnLoadFinished();
    }

    protected override void OnLoadFinished()
    {
        // 首先从沙盒目录查找读取脚本
        GetMainState().AddSearchPath(Application.persistentDataPath + "/Lua");
#if UNITY_EDITOR
        // 编辑器从外部目录读取脚本
        GetMainState().AddSearchPath(Application.dataPath + "/../Extra/Lua");
#else
        // 设备上从StreamingAssets目录读取脚本
        GetMainState().AddSearchPath(Application.streamingAssetsPath + "/Lua");
#endif

        base.OnLoadFinished();
    }
}
