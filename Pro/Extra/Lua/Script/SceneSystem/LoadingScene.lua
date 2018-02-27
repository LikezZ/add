
-- 场景虚基类
local IScene = import("Script.SceneSystem.IScene")
local LoadingScene = class("LoadingScene", IScene)
function LoadingScene:ctor()
	LoadingScene.super.ctor(self);

	self.mAsyncLoadedResNumber= 0;  -- 异步加载的资源个数
	self.mAsyncLoadingResList = {}; -- 异步资源加载队列
end

-- 初始化处理
function LoadingScene:Init()
	LoadingScene.super.Init(self);
end

-- 加载前预处理
function LoadingScene:Prepare()
	LoadingScene.super.Prepare(self);
	
end

-- 预加载资源相关
-- 添加待加载的资源
-- res格式 {bundlename = , listname = }
function LoadingScene:AddPreload(bundlename, listname)
	local res = {bundlename = bundlename, listname = listname};
	table.insert(self.mAsyncLoadingResList, res);
end

-- 开始异步加载附加资源
function LoadingScene:AsyncLoadResource()
	if (#self.mAsyncLoadingResList == 0) then
		-- 没有待加载的资源
		self:AsyncLoadScene();
	end

	local function OnLoadingSceneResLoaded()
		-- body
		local num = self.mAsyncLoadedResNumber + 1;
		if (num < #self.mAsyncLoadingResList) then
	        self.mAsyncLoadedResNumber = num;
			return;
		end

		-- 预加载资源完成
		-- 加载场景
		self:AsyncLoadScene();
	end

	-- 开始加载
	for i=1,#self.mAsyncLoadingResList do
		local item = self.mAsyncLoadingResList[i];
	    if (item ~= nil) then
	        if (item.listname == EngineSystem._BUNDLE_MODEL_) then
	            EngineSystem:LoadModel(item.bundlename, OnLoadingSceneResLoaded);
	        elseif (item.listname == EngineSystem._BUNDLE_EFFECT_) then
	            EngineSystem:LoadEffect(item.bundlename, OnLoadingSceneResLoaded);
	        elseif (item.listname == EngineSystem._BUNDLE_SOUND_) then
	            EngineSystem:LoadSound(item.bundlename, OnLoadingSceneResLoaded);
	        end
	    end
	end
end

-- 开始异步加载场景
function LoadingScene:AsyncLoadScene()
	-- 场景资源加载完毕
	local function OnLoadingSceneLoadScene(param)
		-- 加载场景
		SceneManager:LoadNextScene(SceneManager.mSceneName);
	end
	local sceneInfo = DataManager.Data.Scene:GetDataByKey(SceneManager.mSceneName);
	if sceneInfo ~= nil then
		EngineSystem:LoadCommonBundle(sceneInfo.ResourceName, OnLoadingSceneLoadScene, nil);
	end
end

-- 加载处理
function LoadingScene:Load()
	LoadingScene.super.Load(self);
	
	-- 先卸载之前缓存的资源
	EngineSystem:FreeAllAssetBundle();
	-- 先异步加载附加资源
	self:AsyncLoadResource();
end

-- 桢更新处理
function LoadingScene:Update()
	LoadingScene.super.Update(self);
end

-- 销毁处理
function LoadingScene:Destroy()
	LoadingScene.super.Destroy(self);

	self.mAsyncLoadedResNumber= 0;
	self.mAsyncLoadingResList = {};
	EventSystem:PushEvent(SysEvent._TYPED_EVENT_LOADINGWINDOW_HIDE_);
end

return LoadingScene
