
-- UI窗口虚基类
local IWindow = import("Script.UISystem.IWindow")
local LoadingWindow = class("LoadingWindow", IWindow)
function LoadingWindow:ctor()
	LoadingWindow.super.ctor(self);

end

-- 初始化处理
function LoadingWindow:Init()
	LoadingWindow.super.Init(self);

	-- 注册窗口事件
	self:RegisterEvent(SysEvent._TYPED_EVENT_LOADINGWINDOW_SHOW_, self.OnShowWindowEventHandler, true);
	self:RegisterEvent(SysEvent._TYPED_EVENT_LOADINGWINDOW_HIDE_, self.OnHideWindowEventHandler);
	self:RegisterEvent(SysEvent._TYPED_EVENT_LOADINGWINDOW_UPDATE_, self.OnUpdateWindowEventHandler);
end

-- 窗口显示事件处理
function LoadingWindow:OnShowWindowEventHandler(paramList)
	self.super.ShowWindow(self, true);
	SceneManager:LoadNextScene("LoadingScene");
end

-- 窗口隐藏事件处理
function LoadingWindow:OnHideWindowEventHandler(paramList)
	self:Destroy(paramList);
end

-- 窗口更新事件处理
function LoadingWindow:OnUpdateWindowEventHandler(paramList)
end

-- 加载处理
function LoadingWindow:Load()
	LoadingWindow.super.Load(self);
end

-- 桢更新处理
function LoadingWindow:Update()
	LoadingWindow.super.Update(self);
end

-- 销毁处理
function LoadingWindow:Destroy(bDestroyAll)
	LoadingWindow.super.Destroy(self, bDestroyAll);

end

return LoadingWindow
