using UnityEngine;
using UnityEditor;
using UnityEditor.Callbacks;
using System.Collections;
using System.Collections.Generic;
using System.IO;

public class BuildScript
{
    public static void BuildAssetBundles()
    {
        // Choose the output path according to the build target.
        string outputPath = Application.dataPath.ToLower() + "/StreamingAssets/AssetBundles/" + GetPlatformFolderForAssetBundles(EditorUserBuildSettings.activeBuildTarget);

        // 每次都是重新生成 防止历史遗留冗余 （先注释）
        if (Directory.Exists(outputPath))
        {
            //FileUtil.DeleteFileOrDirectory(outputPath);
            //Directory.CreateDirectory(outputPath);
        }
        else
        {
            Directory.CreateDirectory(outputPath);
        }

        //SetVersionDirAssetName ("Resources");
        BuildPipeline.BuildAssetBundles(outputPath, BuildAssetBundleOptions.ChunkBasedCompression | BuildAssetBundleOptions.DeterministicAssetBundle, EditorUserBuildSettings.activeBuildTarget);
        // Finish
        EditorUtility.DisplayDialog("提示", "打包资源成功", "确定");
    }

#if UNITY_EDITOR
    public static string GetPlatformFolderForAssetBundles(BuildTarget target)
    {
        switch (target)
        {
            case BuildTarget.Android:
                return "Android";
            case BuildTarget.iOS:
                return "iOS";
            case BuildTarget.StandaloneWindows:
            case BuildTarget.StandaloneWindows64:
                return "Windows";
            case BuildTarget.StandaloneOSXIntel:
            case BuildTarget.StandaloneOSXIntel64:
            case BuildTarget.StandaloneOSXUniversal:
                return "OSX";
            // Add more build targets for your own.
            // If you add more targets, don't forget to add the same platforms to GetPlatformFolderForAssetBundles(RuntimePlatform) function.
            default:
                return null;
        }
    }
#endif

    public static string GetBuildTargetName(BuildTarget target)
    {
        switch (target)
        {
            case BuildTarget.Android:
                return "/test.apk";
            case BuildTarget.StandaloneWindows:
            case BuildTarget.StandaloneWindows64:
                return "/test.exe";
            case BuildTarget.StandaloneOSXIntel:
            case BuildTarget.StandaloneOSXIntel64:
            case BuildTarget.StandaloneOSXUniversal:
                return "/test.app";
            // Add more build targets for your own.
            default:
                Debug.Log("Target not implemented.");
                return null;
        }
    }
}
