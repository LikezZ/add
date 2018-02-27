require("Script.EventSystem.EventSystem")
require("Script.UISystem.WindowManager")

-- 客户端UI系统管理器
UISystem = {};

-- UI系统根节点
UISystem.mUIRoot = nil;

-- 得到UI系统根节点
function UISystem:GetUIRoot()
	return self.mUIRoot;
end

-- 注册UI系统事件(UI窗口绑定事件，必须回调到指定的窗口)
function UISystem:RegisterUIEvent(eventType, windowName)
	local function handler(eventType, windowName, paramList)
		self:OnUISystemEventHandler(eventType, windowName, paramList);
	end
	EventSystem:RegisterEventHandler(eventType, handler, windowName);
end

-- 注册UI系统事件(UI窗口绑定事件，必须回调到指定的窗口)
function UISystem:RegisterUIEvent2(eventType, windowName)
	local function handler(eventType, windowName, paramList)
		self:OnUISystemEventHandler2(eventType, windowName, paramList);
	end
	EventSystem:RegisterEventHandler(eventType, handler, windowName);
end

-- 分发事件
function UISystem:PushEvent(eventType, paramList)
	EventSystem:PushEvent(eventType, paramList);
end

-- 初始化UI管理系统
function UISystem:InitAllWindow()
	self.mUIRoot = UnityEngine.GameObject.Find("MainUI");
	if self.mUIRoot == nil then
		return false;
	end

end

-- 销毁所有UI
function UISystem:DestroyAllWindow()
	-- 销毁所有已经加载的窗口
	for name, window in pairs(WindowManager.mWindowList) do
		if window:GetWindowState() ~= _TYPED_WINDOWSTATE_UNLOAD_ then
			window:Destroy(true);
		end
	end
	self.mUIRoot = nil;
end

-- 初始化UI管理系统
function UISystem:Init()
	WindowManager:Init();
	self:InitAllWindow();
	LoggerSystem:Info("Init UISystem Succeed");
	return true;
end

-- 逻辑桢更新
function UISystem:Update(deltaTime)
	-- 窗口管理器逻辑帧更新
	WindowManager:Update(deltaTime);
end

-- 销毁UI管理系统
function UISystem:Destroy()
	-- 销毁窗口管理器
	WindowManager:Destroy();
	self.mUIRoot = nil;

	LoggerSystem:Info("Destroy UISystem Succeed");
end

-- UI系统窗口Prefab动态加载完毕回调
local function OnUISystemLoadCallback(object, windowName)
	-- 没有找到当前窗口，则退出
	local window = WindowManager:GetWindowByName(windowName);
	if window == nil then
		return;
	end

	-- 加载失败了
	if object == nil then
		LoggerSystem:Info("Load UIWindow=" .. window:GetWindowName() .. " Failed");
		return;
	end

	if window:GetWindowState() == _TYPED_STATE_UNLOAD_ then
		-- 如果窗口在初始化过程中已经被卸载了，则直接销毁资源
		Object.DestroyImmediate(object, true);
		object = nil;
		LoggerSystem:Info("Load UIWindow=" .. window:GetWindowName() .. ", But Has UnLoaded");
	elseif window:GetWindowState() == _TYPED_WINDOWSTATE_LOADED_ then
		-- 如果窗口在初始化过程中已经销毁，但是对应资源并没有被释放
		window:SetPrefabObject(object);
		LoggerSystem:Info("Load UIWindow=" .. window:GetWindowName() .. ", But Has Loaded");
	elseif window:GetWindowState() == _TYPED_WINDOWSTATE_LOADING_ then
		-- 设置窗口信息
		window:SetPrefabObject(object);
		-- 加载
		window:Load();
		LoggerSystem:Info("Load UIWindow=" .. window:GetWindowName() .. " Succeed");
		-- 缓冲事件处理
		window:OnTempWindowEventHandler();
	else
		Object.DestroyImmediate(object, true);
		object = nil;
		LoggerSystem:Info("Load UIWindow=" .. window:GetWindowName() .. " Failed, Unkown WindowState");
	end
end

-- UI系统事件响应处理函数
function UISystem:OnUISystemEventHandler(eventType, windowName, paramList)
	local window = WindowManager:GetWindowByName(windowName);
	if window == nil then
		return;
	end

	-- 如果正在加载中，则不处理
	if window:GetWindowState() == _TYPED_WINDOWSTATE_LOADING_ then
		window:AddTempWindowEvent(eventType, paramList);
		return;
	end

	if window:GetWindowState() == _TYPED_WINDOWSTATE_UNLOAD_ then
		-- 如果没有加载，则开始加载
		window:SetWindowState(_TYPED_WINDOWSTATE_LOADING_);
		LoggerSystem:Info("Loading UIWindow=" .. window:GetWindowName());

		-- 先加载资源
		window:AddTempWindowEvent(eventType, paramList);
		EngineSystem:LoadAssetBundle(window:GetPrefabName(), typeof(UnityEngine.GameObject), OnUISystemLoadCallback, window:GetWindowName());
		return;
	elseif window:GetWindowState() == _TYPED_WINDOWSTATE_LOADED_ then
		-- 如果已经加载了，则直接初始化实例
		window:Load();
	end

	-- 事件响应处理
	window:OnEventHandler(eventType, paramList);
end

-- UI系统事件响应处理函数
function UISystem:OnUISystemEventHandler2(eventType, windowName, paramList)
	local window = WindowManager:GetWindowByName(windowName);
	if window == nil then
		return;
	end

	-- 如果没有加载，则退出
	if window:GetWindowState() == _TYPED_WINDOWSTATE_UNLOAD_ then
		return;
	end

	-- 如果正在加载中，则先缓存一下
	if window:GetWindowState() == _TYPED_WINDOWSTATE_LOADING_ then
		window:AddTempWindowEvent(eventType, paramList);
		return;
	end

	-- 要不要判断是否隐藏呢？暂时先留着吧

	-- 只有在确保加载并且构建了对应实例之后，在进行事件处理
	if window:GetWindowState() == _TYPED_WINDOWSTATE_INSTANTIATED_ then
		window:OnEventHandler(eventType, paramList)
	end
end
