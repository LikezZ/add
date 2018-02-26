
-- 场景管理器
SceneManager = {};
SceneManager.mSceneList = {};

SceneManager.mNextScene = nil;  -- 下一场景
SceneManager.mCurScene = nil;   -- 当前场景
SceneManager.mSceneName = nil;  -- 要切换的场景名

-- 根据名称得到对应的场景
function SceneManager:GetSceneByName(sceneName)
	return self.mSceneList[sceneName];
end

-- 获取Loading场景
function SceneManager:AddPreload(bundlename, listname)
	local scene = self:GetSceneByName("LoadingScene");
	scene:AddPreload(bundlename, listname);
end

-- 初始化UI窗口管理器
function SceneManager:Init()
	-- 创建所有场景
	for i = 1, DataManager.Data.Scene:GetDataCount() do
		local item = DataManager.Data.Scene:GetDataByIndex(i);
		if (item.ScriptFileName ~= "") then
			local scene = import(item.ScriptFileName).new();
			scene:SetSceneName(item.SceneName);
			scene:SetResourceName(item.ResourceName);
			scene:Init();
			self.mSceneList[scene:GetSceneName()] = scene;
		end
	end

	LoggerSystem:Info("Init SceneManager Succeed");
end

-- 场景切换完成回调
function SceneManager:OnChangeScene(sceneResName)
	if self.mNextScene and self.mNextScene:GetResourceName() == sceneResName then
		if self.mCurScene then
			self.mCurScene:Destroy();
		end
		self.mCurScene = self.mNextScene;
		self.mNextScene = nil;

		-- 卸载对应Bundle资源
		EngineSystem:UnLoadAssetBundle(sceneResName);
		-- 卸载预加载的缓存Bundle资源
		EngineSystem:ClearUnusedAssetBundle();
		self.mCurScene:Load();
	end
end

-- 场景切换（外部调用）
function SceneManager:ChangeScene(sceneName)
	local scene = self.mSceneList[sceneName];
	if scene then
		scene:Prepare();
		self.mSceneName = sceneName;
		-- 显示Loading窗口，之后切换到Loading场景
		EventSystem:PushEvent(SysEvent._TYPED_EVENT_LOADINGWINDOW_SHOW_);
	end
end

-- 加载下一场景（实际加载 资源已经加载完）
function SceneManager:LoadNextScene(sceneName)
	local scene = self.mSceneList[sceneName];
	if scene then
		self.mNextScene = scene;
		EngineSystem:ChangeScene(scene:GetResourceName());
	end
end

-- 逻辑桢更新
function SceneManager:Update(deltaTime)
	--  逻辑帧处理
	if self.mCurScene then
		self.mCurScene:Update();
	end
end

-- 销毁UI窗口管理器
function SceneManager:Destroy()
	-- 销毁所有场景数据
	for name, scene in pairs(self.mSceneList) do
		scene:Destroy();
	end
	self.mSceneList = {};
	self.mNextScene = nil;
	self.mCurScene = nil;
	self.mSceneName = nil;

	LoggerSystem:Info("Destroy SceneManager Succeed");
end
