
-- 场景虚基类
local IScene = import("Script.SceneSystem.IScene")
local BlockScene = class("BlockScene", IScene)
function BlockScene:ctor()
	BlockScene.super.ctor(self);

end

-- 初始化处理
function BlockScene:Init()
	BlockScene.super.Init(self);
end

-- 加载前预处理
function BlockScene:Prepare()
	BlockScene.super.Prepare(self);

	SceneManager:AddPreload("Block", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block1", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block2", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block3", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block4", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block5", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block6", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block7", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block8", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block9", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block10", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block11", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block12", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block13", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block14", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block15", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block16", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block17", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block18", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block19", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block20", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block21", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block22", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block23", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block24", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block25", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Block26", EngineSystem._BUNDLE_MODEL_);
	SceneManager:AddPreload("Back", EngineSystem._BUNDLE_MODEL_);
end

-- 加载处理
function BlockScene:Load()
	BlockScene.super.Load(self);
	
	GameLogic:Init();
	-- 游戏窗口
	EventSystem:PushEvent(SysEvent._TYPED_EVENT_BLOCKWINDOW_SHOW_);
end

-- 桢更新处理
function BlockScene:Update()
	BlockScene.super.Update(self);

	GameLogic:Update();
end

-- 销毁处理
function BlockScene:Destroy()
	BlockScene.super.Destroy(self);

	GameLogic:Destroy();
	EventSystem:PushEvent(SysEvent._TYPED_EVENT_BLOCKWINDOW_HIDE_);
end

return BlockScene
