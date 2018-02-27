
-- 场景虚基类
local IScene = import("Script.SceneSystem.IScene")
local GameScene = class("GameScene", IScene)
function GameScene:ctor()
	GameScene.super.ctor(self);

end

-- 初始化处理
function GameScene:Init()
	GameScene.super.Init(self);
end

-- 加载前预处理
function GameScene:Prepare()
	GameScene.super.Prepare(self);

	--SceneManager:AddPreload("Role", EngineSystem._BUNDLE_MODEL_);
	--SceneManager:AddPreload("Wheel", EngineSystem._BUNDLE_MODEL_);
	--SceneManager:AddPreload("HM_Model", EngineSystem._BUNDLE_MODEL_);
	--SceneManager:AddPreload("TZ_Model", EngineSystem._BUNDLE_MODEL_);
	--SceneManager:AddPreload("XT_Model", EngineSystem._BUNDLE_MODEL_);
	--SceneManager:AddPreload("HX_Model", EngineSystem._BUNDLE_MODEL_);
	--SceneManager:AddPreload("DD_Model", EngineSystem._BUNDLE_MODEL_);
end

-- 加载处理
function GameScene:Load()
	GameScene.super.Load(self);
	
	EventSystem:PushEvent(SysEvent._TYPED_EVENT_GAMEWINDOW_SHOW_);

	--GameLogic:Init();
end

-- 桢更新处理
function GameScene:Update()
	GameScene.super.Update(self);

	--GameLogic:Update();
end

-- 销毁处理
function GameScene:Destroy()
	GameScene.super.Destroy(self);

	--GameLogic:Destroy();
	EventSystem:PushEvent(SysEvent._TYPED_EVENT_GAMEWINDOW_HIDE_);
end

return GameScene
