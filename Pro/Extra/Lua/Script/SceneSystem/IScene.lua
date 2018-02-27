
-- 场景虚基类
local ITimer = import("Script.Common.ITimer")
local IScene = class("IScene", ITimer)
function IScene:ctor()
	IScene.super.ctor(self);

	self.mSceneName = "";     -- 场景名称
	self.mResourceName = "";  -- 场景资源名称
end

-- 得到当前的名称
function IScene:GetSceneName()
	return self.mSceneName;
end

-- 设置当前的名称
function IScene:SetSceneName(name)
	self.mSceneName = name;
end

-- 得到当前的名称
function IScene:GetResourceName()
	return self.mResourceName;
end

-- 设置当前的名称
function IScene:SetResourceName(name)
	self.mResourceName = name;
end

-- 初始化处理
function IScene:Init()
	-- init property
	print("Init Scene, SceneName=" .. self.mSceneName);
end

-- 加载前预处理
function IScene:Prepare()
	-- prepare
	print("Prepare Scene, SceneName=" .. self.mSceneName);
end

-- 加载处理
function IScene:Load()
	print("Load Scene, SceneName=" .. self.mSceneName);
end

-- 桢更新处理
function IScene:Update()
	IScene.super.Update(self);
end

-- 销毁处理
function IScene:Destroy()
	IScene.super.ClearAll(self);

	print("Destroy Scene, SceneName=" .. self.mSceneName);
end

return IScene
