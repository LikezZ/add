
-- 场景虚基类
local IScene = import("Script.SceneSystem.IScene")
local BallTestScene = class("BallTestScene", IScene)
function BallTestScene:ctor()
	BallTestScene.super.ctor(self);

end

-- 初始化处理
function BallTestScene:Init()
	BallTestScene.super.Init(self);
end

-- 加载前预处理
function BallTestScene:Prepare()
	BallTestScene.super.Prepare(self);

	--SceneManager:AddPreload("Role", EngineSystem._BUNDLE_MODEL_);
end

-- 加载处理
function BallTestScene:Load()
	BallTestScene.super.Load(self);
	
	EventSystem:PushEvent(SysEvent._TYPED_EVENT_BALLTESTWINDOW_SHOW_);

	--GameLogic:Init();
end

-- 桢更新处理
function BallTestScene:Update()
	BallTestScene.super.Update(self);

	--GameLogic:Update();
end

-- 销毁处理
function BallTestScene:Destroy()
	BallTestScene.super.Destroy(self);

	--GameLogic:Destroy();
	EventSystem:PushEvent(SysEvent._TYPED_EVENT_BALLTESTWINDOW_HIDE_);
end

return BallTestScene
