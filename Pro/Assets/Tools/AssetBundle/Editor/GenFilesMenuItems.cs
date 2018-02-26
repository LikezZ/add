using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;

public class GenFilesMenuItems
{

    #region 新打包策略代码
    // 从这里是新加打包策略（资源文件和UI界面纹理资源分开打包）
    // 所有要打包的资源相对于Assets的路径（所有要打包的资源都要放在这个目录下）
    // 如果改成别的路径直接修改这个，别的不用改
    static string dataPathName = "/Data/";
    // 所有要打包的资源的完整路径
    static string abDataPath = AppDataPath + dataPathName;
    // 筛选资源文件时使用
    static string excDataPath = "Assets" + dataPathName;

    // 重要！！！UI界面纹理资源不能放在Resources文件夹下面，此文件夹下的资源将不会被打入图集
    // UI界面纹理资源相对于Assets的路径
    // 如果改成别的路径直接修改这个，别的不用改
    static string UIPathName = "/UGUI/";
    // 排除UI界面的纹理资源的路径，单独处理PackingTag和AB包命名
    static string excUIPath = "Assets" + UIPathName;
    // UI界面资源的完整路径
    static string abUIPath = AppDataPath + UIPathName;

    // 单独打包的文件夹（不涉及到依赖）
    static string PackPathName = "/Pack/";
    // 排除Pack资源的路径
    static string excPackPath = "Assets" + PackPathName;
    // Pack资源的完整路径
    static string abPackPath = AppDataPath + PackPathName;

    // AB包扩展名
    static string abExtName = "data";

    // 需要打包的文件列表
    static List<string> abDataList;
    // 查文件名是否有重复
    static List<string> abNameList;
    // 资源引用计数统计
    static Dictionary<string, int> abDepsNumList;
    #endregion

    static string AppDataPath {
		get { return Application.dataPath; }
	}

    [MenuItem("资源打包/清理资源")]
    static public void ClearStreamingasset()
    {
        if (EditorUtility.DisplayDialog("警告", "确定要执行此操作？", "确定", "取消"))
        {
            string assetPath = Application.dataPath.ToLower() + "/StreamingAssets/AssetBundles/";
            assetPath = assetPath + BuildScript.GetPlatformFolderForAssetBundles(EditorUserBuildSettings.activeBuildTarget);
            if (Directory.Exists(assetPath))
            {
                Directory.Delete(assetPath, true);
            }
        }
    }

    [MenuItem ("资源打包/导出所有资源包")]
	static public void BuildAssetBundles ()
	{
        AutoSetAllBundleName();
        AutoRenameUIFileName();
        AutoSetUIBundleName();
        AutoSetPackBundleName();
        AssetDatabase.SaveAssets();

        BuildScript.BuildAssetBundles();
	}

    [MenuItem("资源打包/导出三平台资源包")]
    static public void BuildPlatformAssetBundles()
    {
        AutoSetAllBundleName();
        AutoRenameUIFileName();
        AutoSetUIBundleName();
        AutoSetPackBundleName();
        AssetDatabase.SaveAssets();

        BuildScript.BuildAssetBundles();
        List<BuildTarget> p = new List<BuildTarget>() {BuildTarget.iOS, BuildTarget.Android, BuildTarget.StandaloneWindows64 };
        p.Remove(EditorUserBuildSettings.activeBuildTarget);
        EditorUserBuildSettings.activeBuildTargetChanged = delegate ()
        {
            BuildScript.BuildAssetBundles();
        };
        foreach (var item in p)
        {
            EditorUserBuildSettings.SwitchActiveBuildTarget(item);
        }
    }

    #region 新打包策略代码
    // 自动设置指定文件夹下的文件的ab包名字
    // 重要！！！！场景unity文件不能和资源文件打在一个包里（报错） 需要单独处理
    // 重要！！！！UI界面用到的图片纹理也要单独处理，每个UI文件夹（图片的PackingTag相同合并一张大图）是一个AB包

    // 自动设置文件夹下所有需要打包的文件的ab包名字
    // 这个函数根据文件依赖层数智能合并命名文件夹下所有需要打包的文件
    public static void AutoSetAllBundleName()
    {
        abDataList = new List<string>();
        abNameList = new List<string>();
        abDepsNumList = new Dictionary<string, int>();

        if (Directory.Exists(abDataPath))
        {
            string tmp;
            var exitLen = abDataPath.Length - excDataPath.Length;
            var dir = new DirectoryInfo(abDataPath);
            var files = dir.GetFiles("*", SearchOption.AllDirectories);
            for (var i = 0; i < files.Length; ++i)
            {
                var fileInfo = files[i];
                // 统计不是以meta结尾的文件，以后可能还要排除别的文件再添加
                if (!fileInfo.Name.EndsWith(".meta") && !fileInfo.Name.EndsWith(".cs"))
                {
                    //Debug.Log(fileInfo.FullName);

                    // 这还要查重名，因为文件名就是包名
                    tmp = fileInfo.Name.Split('.')[0];
                    if (abNameList.Contains(tmp))
                    {
                        Debug.LogError("错误！！！ 相同文件名" + tmp);
                        return;
                    }
                    else
                    {
                        abNameList.Add(tmp);
                        abDataList.Add(fileInfo.FullName.Replace('\\', '/').Substring(exitLen));
                        //Debug.Log(tmp + "   file   " + fileInfo.FullName.Replace('\\', '/').Substring(exitLen));
                    }
                }
            }

            // 统计所有引用计数（输入的路径数组的格式应该是这样Assets/Data/Scene/test.unity）
            GetFilesAllDepsNum();

            // 先把文件夹下所有需要单独命名的资源处理
            SetSingleBundleName();

            // 处理剩下的所有文件设置AB包名
            SetBundleNameByDepsLevel();
        }
        else
        {
            Debug.LogError("错误！！！ 不存在需要打包的路径！！！");
            return;
        }
    }

    // 单独处理UI文件夹下的资源（设置同一文件夹下文件相同的PackingTag和ab包名字）
    // 同一文件夹下相同PackingTag可以合并一张大图，使显示优化
    // 文件夹的名字就是PackingTag和AB包名，所以别重复
    public static void AutoSetUIBundleName()
    {
        if (Directory.Exists(abUIPath))
        {
            var exitLen = abUIPath.Length - excUIPath.Length;
            var dir = new DirectoryInfo(abUIPath);
            SetUIBundleName(dir, exitLen);
            var allDirs = dir.GetDirectories("*", SearchOption.AllDirectories);
            for (var i = 0; i < allDirs.Length; ++i)
            {
                SetUIBundleName(allDirs[i], exitLen);
            }
        }
    }

    // 先重命名UI文件，标示BundleName
    public static void AutoRenameUIFileName()
    {
        if (Directory.Exists(abUIPath))
        {
            var exitLen = abUIPath.Length - excUIPath.Length;
            var dir = new DirectoryInfo(abUIPath);
            SetUIFileName(dir, exitLen);
            var allDirs = dir.GetDirectories("*", SearchOption.AllDirectories);
            for (var i = 0; i < allDirs.Length; ++i)
            {
                SetUIFileName(allDirs[i], exitLen);
            }
        }
    }

    // 单独处理Pack文件夹下的资源（设置同一文件夹下文件相同的ab包名字）
    public static void AutoSetPackBundleName()
    {
        if (Directory.Exists(abPackPath))
        {
            var exitLen = abPackPath.Length - excPackPath.Length;
            var dir = new DirectoryInfo(abPackPath);
            var allDirs = dir.GetDirectories("*", SearchOption.AllDirectories);
            for (var i = 0; i < allDirs.Length; ++i)
            {
                var name = allDirs[i].Name;
                var allFiles = allDirs[i].GetFiles("*", SearchOption.TopDirectoryOnly);
                for (int j = 0; j < allFiles.Length; j++)
                {
                    var fileInfo = allFiles[j];
                    // 统计不是以meta结尾的文件，以后可能还要排除别的文件再添加
                    if (!fileInfo.Name.EndsWith(".meta"))
                    {
                        var path = fileInfo.FullName.Replace('\\', '/').Substring(exitLen);
                        if (path.Length > 0 && !path.Contains(".cs"))
                        {
                            var importer = AssetImporter.GetAtPath(path);
                            if (importer && name.Length > 0)
                            {
                                importer.assetBundleName = name;
                                importer.assetBundleVariant = abExtName;
                                //importer.SaveAndReimport();
                            }
                        }
                    }
                }
            }
        }
    }

    // 设置路径下UI纹理文件AB包名等信息
    public static void SetUIBundleName(DirectoryInfo dirInfo, int exitLen)
    {
        var name = dirInfo.Name.ToLower();
        var allFiles = dirInfo.GetFiles("*", SearchOption.TopDirectoryOnly);
        for (int j = 0; j < allFiles.Length; j++)
        {
            var fileInfo = allFiles[j];
            // 统计不是以meta结尾的文件，以后可能还要排除别的文件再添加
            if (!fileInfo.Name.EndsWith(".meta"))
            {
                var path = fileInfo.FullName.Replace('\\', '/').Substring(exitLen);
                if (path.Length > 0 && !path.Contains(".cs"))
                {
                    var importer = TextureImporter.GetAtPath(path) as TextureImporter;
                    if (importer && name.Length > 0 && importer.assetBundleName != name)
                    {
                        importer.spritePackingTag = name;
                        importer.textureType = TextureImporterType.Sprite;
                        importer.textureFormat = TextureImporterFormat.AutomaticTruecolor;
                        importer.maxTextureSize = 1024;
                        importer.mipmapEnabled = false;
                        importer.filterMode = FilterMode.Trilinear;
                        
                        importer.assetBundleName = name;
                        importer.assetBundleVariant = abExtName;
                        importer.SaveAndReimport();
                    }
                }
            }
        }
    }

    // 重命名路径下UI纹理文件
    public static void SetUIFileName(DirectoryInfo dirInfo, int exitLen)
    {
        var name = dirInfo.Name;
        name = name.ToLower();
        var allFiles = dirInfo.GetFiles("*", SearchOption.TopDirectoryOnly);
        for (int j = 0; j < allFiles.Length; j++)
        {
            var fileInfo = allFiles[j];
            // 统计不是以meta结尾的文件，以后可能还要排除别的文件再添加
            if (!fileInfo.Name.EndsWith(".meta"))
            {
                var path = fileInfo.FullName.Replace('\\', '/').Substring(exitLen);
                if (path.Length > 0 && !path.Contains(".cs"))
                {
                    // 如果没有重命名UI 附带Bundle名
                    if (!fileInfo.Name.Contains("@"))
                    {
                        string[] bn = fileInfo.Name.Split('.');
                        if (AssetDatabase.RenameAsset(path, bn[0] + "@" + name).Length > 0)
                        {
                            Debug.LogError("Rename UI " + fileInfo.Name + "Error ！！！");
                        }
                    }
                }
            }
        }
    }

    // 这个函数只有SetSingleBundleName() 会调用
    public static void ReccurSetSingleBundleName(string path, string name)
    {
        // 获取自身引用计数
        int tmp = 0;
        if (abDepsNumList.ContainsKey(path))
        {
            tmp = abDepsNumList[path];
        }
        else return;

        // 只获取直接依赖(不包括自身) 然后递归每一层
        var deps = AssetDatabase.GetDependencies(path, false);
        for (int j = 0; j < deps.Length; j++)
        {
            // 这个列表中的项单独打包，所以如果被依赖跳过
            if (abDataList.Contains(deps[j]))
            {
                continue;
            }

            // 如果不包含可能是已经命名了
            if (abDepsNumList.ContainsKey(deps[j]))
            {
                if (abDepsNumList[deps[j]] == tmp + 1)   // 重点！如果等于引用加一合并打包
                {
                    if (SetBundleName(deps[j], name))
                    {
                        ReccurSetSingleBundleName(deps[j], name);
                        abDepsNumList.Remove(deps[j]);
                    }
                    else
                    {
                        Debug.LogError("错误！！！ 设置文件AB包名出错 ：" + deps[j]);
                        return;
                    }
                }
            }
        }
    }

    // 处理此文件夹下的每个资源单独命名
    public static void SetSingleBundleName()
    {
        for (int i = 0; i < abDataList.Count; i++)
        {
            if (!abDepsNumList.ContainsKey(abDataList[i]))
            {
                continue;
            }

            var path = abDataList[i];
            var str = path.Split('/');
            var name = str[str.Length - 1].Split('.')[0];  // 分解路径字符串只取文件名不包括扩展名

            // 设置自身AB包名
            if (SetBundleName(abDataList[i], name))
            {
                // 如果是场景unity文件 需要单独处理一下
                if (abDataList[i].EndsWith(".unity"))
                {
                    // 因为场景文件不能和依赖的资源打在一个包里（报错）
                    // 所以把所有只归属此场景的资源单独命名
                    name = name + "unity";
                }

                // 递归设置依赖文件包名
                ReccurSetSingleBundleName(abDataList[i], name);
                abDepsNumList.Remove(abDataList[i]);
            }
            else
            {
                Debug.LogError("错误！！！ 设置文件AB包名出错 ：" + abDataList[i]);
                return;
            }
        }
    }

    // 智能命名文件AB包名 
    // 优化：如果资源A和B的引用计数分别是3和4，A依赖于B，这种情况其实都是A在引用B
    //（A自身和其他两个引用，B自身以及A的引用还有其他两个引用），可以把A和B打在一个包
    // 再优化：递归每一层的依赖如果引用计数想对于上一层加一，都是可以合并的
    // 应该根据拥有依赖的层数排序，从层数多的开始，因为层数多的可能包含层数少的
    public static void SetBundleNameByDepsLevel()
    {
        Dictionary<string, int> levelNumList = new Dictionary<string, int>();
        foreach (var item in abDepsNumList)
        {
            levelNumList.Add(item.Key, GetBundleLevelNum(item.Key));
        }

        // 排序操作
        List<KeyValuePair<string, int>> myList = new List<KeyValuePair<string, int>>(levelNumList);
        myList.Sort(delegate (KeyValuePair<string, int> s1, KeyValuePair<string, int> s2)
        {
            return s2.Value.CompareTo(s1.Value);
        });
        levelNumList.Clear();
        foreach (KeyValuePair<string, int> pair in myList)
        {
            levelNumList.Add(pair.Key, pair.Value);
        }

        abNameList.Clear();  // 清空复用，记录剩余的所有资源路径
        foreach (var item in levelNumList)
        {
            abNameList.Add(item.Key);
        }

        // 设置所有文件包名
        for (int i = 0; i < abNameList.Count; i++)
        {
            // 如果为空或者不包含则是已经处理过的跳过
            if (abNameList[i] == "" || !abDepsNumList.ContainsKey(abNameList[i]))
            {
                continue;
            }

            var path = abNameList[i];
            var str = path.Split('/');
            var name = str[str.Length - 1].Split('.')[0];  // 分解路径字符串只取文件名不包括扩展名

            // 设置自身AB包名
            if (SetBundleName(abNameList[i], name))
            {
                // 如果是场景unity文件 需要单独处理一下
                if (abNameList[i].EndsWith(".unity"))
                {
                    // 因为场景文件不能和依赖的资源打在一个包里（报错）
                    // 所以把所有只归属此场景的资源单独命名
                    name = name + "unity";
                }

                // 递归设置依赖文件包名
                ReccurSetBundleName(abNameList[i], name);
                abDepsNumList.Remove(abNameList[i]);
            }
            else
            {
                Debug.LogError("错误！！！ 设置文件AB包名出错 ：" + abNameList[i]);
                return;
            }
        }
    }

    //统计所有引用计数（输入的路径数组的格式应该是这样Assets/Data/Scene/test.unity）
    public static void GetFilesAllDepsNum()
    {
        // 返回的所有依赖路径的格式是这样的 Assets/Data/Scene/test.unity
        var allDeps = AssetDatabase.GetDependencies(abDataList.ToArray());
        for (int i = 0; i < allDeps.Length; i++)
        {
            //Debug.Log(allDeps[i]);

            //if (!IsValid(allDeps[i]))
            //{
            //    Debug.LogError("错误！！！ 文件名中含有空格" + allDeps[i]);
            //}
            var deps = AssetDatabase.GetDependencies(allDeps[i]);
            for (int j = 0; j < deps.Length; j++)
            {
                // 排除UI路径的资源（单独处理）
                if (deps[j].Contains(excUIPath))
                {
                    continue;
                }

                if (abDepsNumList.ContainsKey(deps[j]))
                {
                    abDepsNumList[deps[j]]++;
                }
                else
                {
                    abDepsNumList.Add(deps[j], 1);
                }
            }
        }
    }

    // 设置资源的AB包名字
    public static bool SetBundleName(string path, string name)
    {
        // 这有个坑不知道为什么会包含cs文件
        if (path.Contains(".cs"))
        {
            return true;
        }
        if (path.Length > 0)
        {
            var importer = AssetImporter.GetAtPath(path);
            if (importer && name.Length > 0)
            {
                importer.assetBundleName = name;
                importer.assetBundleVariant = abExtName;
                //importer.SaveAndReimport();
                return true;
            }
        }

        return false;
    }

    // 设置AB包名 递归每一层依赖如果引用计数相对于上一层加一则用一个包名
    public static void ReccurSetBundleName(string path, string name)
    {
        // 获取自身引用计数
        int tmp = 0;
        if (abDepsNumList.ContainsKey(path))
        {
            tmp = abDepsNumList[path];
        }
        else return;

        // 只获取直接依赖(不包括自身) 然后递归每一层
        var deps = AssetDatabase.GetDependencies(path, false);
        for (int j = 0; j < deps.Length; j++)
        {
            // 如果不包含可能是已经命名了
            if (abDepsNumList.ContainsKey(deps[j]))
            {
                if (abDepsNumList[deps[j]] == tmp + 1)   // 重点！如果等于引用加一合并打包
                {
                    if (SetBundleName(deps[j], name))
                    {
                        ReccurSetBundleName(deps[j], name);
                        abDepsNumList.Remove(deps[j]);

                        // 在abNameList表里置空排除，因为已经命名处理了
                        var id = abNameList.IndexOf(deps[j]);
                        if (id != -1)
                        {
                            abNameList[id] = "";
                        }
                    }
                    else
                    {
                        Debug.LogError("错误！！！ 设置文件AB包名出错 ：" + deps[j]);
                        return;
                    }
                }
            }
        }
    }

    // 获取资源文件的依赖最大层数（关键步骤求树的高度）
    public static int GetBundleLevelNum(string path)
    {
        // 只取直接依赖
        int num = -1;
        var deps = AssetDatabase.GetDependencies(path, false);
        if (deps.Length == 0)
        {
            return 1;
        }
        for (int j = 0; j < deps.Length; j++)
        {
            int tmp = GetBundleLevelNum(deps[j]);
            if (tmp > num)
            {
                num = tmp;
            }
        }

        return num + 1;
    }
    #endregion

    [MenuItem("资源打包/重置所有文件包名")]
    static public void ResetAllBundleName()
    {
        if (Directory.Exists(AppDataPath))
        {
            var dir = new DirectoryInfo(AppDataPath);
            var files = dir.GetFiles("*", SearchOption.AllDirectories);
            for (var i = 0; i < files.Length; ++i)
            {
                var fileInfo = files[i];
                // 统计不是以meta结尾的文件，以后可能还要排除别的文件再添加
                if (!fileInfo.Name.EndsWith(".meta") && !fileInfo.Name.EndsWith(".cs"))
                {
                    //Debug.Log(fileInfo.FullName);
                    var fullName = fileInfo.FullName.Replace('\\', '/');
                    var index = fullName.IndexOf("Assets/");
                    if (index != -1)
                    {
                        var path = fullName.Substring(index);
                        AssetImporter tmp = AssetImporter.GetAtPath(path);
                        if (tmp != null)
                        {
                            tmp.assetBundleName = null;
                            tmp.assetBundleVariant = null;
                            //tmp.SaveAndReimport();
                        }
                    }
                }
            }
        }
    }

    // 是否有效（不能包含空格）
    static bool IsValid(string str)
    {
        if (str.Length <= 0)
        {
            return false;
        }
        var tmpList = str.Split('/');
        if (tmpList.Length > 0)
        {
            str = tmpList[tmpList.Length - 1];
        }
        //Debug.Log("check name " + str);
        var res = str.Split(' ');
        return res.Length <= 1;
    }
}
