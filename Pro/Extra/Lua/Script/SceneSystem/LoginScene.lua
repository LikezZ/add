
-- 场景虚基类
local IScene = import("Script.SceneSystem.IScene")
local LoginScene = class("LoginScene", IScene)
function LoginScene:ctor()
	LoginScene.super.ctor(self);

end

-- 初始化处理
function LoginScene:Init()
	LoginScene.super.Init(self);
end

-- 加载前预处理
function LoginScene:Prepare()
	LoginScene.super.Prepare(self);
	
end

-- 加载处理
function LoginScene:Load()
	LoginScene.super.Load(self);
	
	EventSystem:PushEvent(SysEvent._TYPED_EVENT_LOGINWINDOW_SHOW_);

end

-- 桢更新处理
function LoginScene:Update()
	LoginScene.super.Update(self);
end

-- 销毁处理
function LoginScene:Destroy()
	LoginScene.super.Destroy(self);

	EventSystem:PushEvent(SysEvent._TYPED_EVENT_LOGINWINDOW_HIDE_);
end

return LoginScene
