using UnityEngine;
using System.Collections;

public class Main : MonoBehaviour {

	// Use this for initialization
	void Start () {
        DontDestroyOnLoad(gameObject);
        // init TODO
        // 初始化资源加载器
        gameObject.AddComponent<ResourceManager>();
        // 在这之前应该有更新文件系统 TODO
        ResourceManager.Instance.Init(OnInitDone);
    }

    private void OnInitDone(int flag)
    {
        // 资源加载器初始化完成
        // 初始化 Lua 环境
        gameObject.AddComponent<LuaMain>();
    }

    // Update is called once per frame
    void Update () {
        
	}

    void OnApplicationQuit()
    {
        
    }
}
