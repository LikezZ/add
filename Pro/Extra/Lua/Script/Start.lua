-- 客户端开始入口

-- 添加引用公共脚本
require("Script.Common.Class");
require("Script.Common.List");
require("Script.Common.ITimer");

-- 添加引用客户端脚本
require("Script.LoggerSystem.LoggerSystem");
require("Script.EngineSystem.EngineSystem");
require("Script.DataSystem.DataManager");
require("Script.EventSystem.EventSystem");
require("Script.UISystem.UISystem");
require("Script.UISystem.WindowManager");
require("Script.SceneSystem.SceneManager");
require("Script.LogicSystem.GameLogic");
require("Script.LogicSystem.StageLogic");
require("Script.LogicSystem.Helper");

-- Lua层客户端框架类
App = {}

-- 注册全局定时事件
function App:RegisterTimer(loop, interval, func)
    if (App.mAppTimer == nil) then
        return;
    end

    App.mAppTimer:RegisterTimer(loop, interval, func);
end

-- 取消全局定时事件
function App:UnRegisterTimer(func)
    if (App.mAppTimer == nil) then
        return;
    end

    App.mAppTimer:UnRegisterTimer(func);
end

-- GC释放内存
function App:GC()
    --print(collectgarbage("count"));
    collectgarbage("collect");
    --print(collectgarbage("count"));
end

-- 打印整个Lua脚本的内存详细信息（监控内存使用）
function App:DumpLuaMemory()
    print(collectgarbage("count"));
--[[
    for k,v in pairs(_G) do
        print(string.format("%s => %s\n",k,v))
    end
--]]
    for k,v in pairs(_G) do
        if type(v) == "table" and k ~= "_G" then
            for key in pairs(v) do
                print("  " .. k .. "." .. key) --为了便于阅读，进行了特殊格式化处理
            end
        end
    end
end

-- 初始化游戏管理器
function App:Start()
    -- 初始化随机种子
    math.randomseed(os.time());

    -- 注册全局定时器
    App.mAppTimer = import("Script.Common.ITimer").new();
    UpdateBeat:Add(App.Update);
    FixedUpdateBeat:Add(App.FixedUpdate);

    -- 初始化所有系统
    EngineSystem:Init();
    LoggerSystem:Init();
    DataManager:Init();
    EventSystem:Init();
    SceneManager:Init();
    UISystem:Init();
    StageLogic:Init();

    -- 切换到场景
    SceneManager:ChangeScene("LoginScene");
end

-- 场景切换回调
function App:OnLevelWasLoaded()
    local name = EngineSystem:GetSceneName();
    SceneManager:OnChangeScene(name);
end

-- 逻辑桢处理
function App:Update()
    -- 所有系统逻辑帧更新
    local diff = UnityEngine.Time.deltaTime;
    App.mAppTimer:Update();

    EngineSystem:Update(diff);
    EventSystem:Update(diff);
    SceneManager:Update(diff);
    UISystem:Update(diff);
    StageLogic:Update(diff);
end

-- 逻辑桢处理
function App:FixedUpdate()
end

-- 销毁游戏管理器
function App:Destroy()
    EngineSystem:Destroy();
    LoggerSystem:Destroy();
    DataManager:Destroy();
    EventSystem:Destroy();
    SceneManager:Destroy();
    UISystem:Destroy();
    StageLogic:Destroy();
end
