
-- UI窗口管理器
WindowManager = {};

WindowManager.mWindowList = {};

-- 根据窗口名称得到对应的窗口
function WindowManager:GetWindowByName(windowName)
	return self.mWindowList[windowName];
end

-- 判断指定窗口是否显示
function WindowManager:IsWindowShow(windowName)
	local window = self:GetWindowByName(windowName);
	if window == nil then
		return false;
	end

	return window:IsShow();
end

-- 将所有窗口移到屏幕外
-- 不用Active，效率比较高
function WindowManager:FadeoutAllWindow()
	for name, window in pairs(self.mWindowList) do
		window:Fadeout();
	end
end

-- 将所有窗口移进屏幕内
-- 不用Active，效率比较高
function WindowManager:FadeinAllWindow()
	for name, window in pairs(self.mWindowList) do
		window:Fadein();
	end
end

-- 隐藏所有UI窗口
function WindowManager:HideAllWindow(bDestroyAll)
	for name, window in pairs(self.mWindowList) do
		window:Destroy(bDestroyAll);
	end
end

-- 初始化UI窗口管理器
function WindowManager:Init()
	-- 创建所有窗口
	for i = 1, DataManager.Data.Window:GetDataCount() do
		local item = DataManager.Data.Window:GetDataByIndex(i);
		if (item.ScriptFileName ~= "") then
			local window = import(item.ScriptFileName).new();
			window:SetWindowName(item.WindowName);
			window:SetPrefabName(item.ResourceName);
			window:SetIsUnloadWhenDestroy(item.IsDestroyWhenUnLoad);
			window:Init();
			self.mWindowList[window:GetWindowName()] = window;
		end
	end

	LoggerSystem:Info("Init WindowManager Succeed");
end

-- 逻辑桢更新
function WindowManager:Update(deltaTime)
	--  所有窗口逻辑帧处理
	for name, window in pairs(self.mWindowList) do
		if window:GetWindowState() == _TYPED_WINDOWSTATE_INSTANTIATED_ then
			window:Update();
		end
	end
end

-- 销毁UI窗口管理器
function WindowManager:Destroy()
	-- 销毁所有窗口
	for name, window in pairs(self.mWindowList) do
		if window:GetWindowState() ~= _TYPED_WINDOWSTATE_UNLOAD_ then
			window:Destroy(true);
		end
	end
	self.mWindowList = {};

	LoggerSystem:Info("Destroy WindowManager Succeed");
end
