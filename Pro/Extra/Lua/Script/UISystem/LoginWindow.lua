
-- UI窗口虚基类
local IWindow = import("Script.UISystem.IWindow")
local LoginWindow = class("LoginWindow", IWindow)
function LoginWindow:ctor()
	LoginWindow.super.ctor(self);

end

-- 初始化处理
function LoginWindow:Init()
	LoginWindow.super.Init(self);

	-- 注册窗口事件
	self:RegisterEvent(SysEvent._TYPED_EVENT_LOGINWINDOW_SHOW_, self.OnShowWindowEventHandler, true);
	self:RegisterEvent(SysEvent._TYPED_EVENT_LOGINWINDOW_HIDE_, self.OnHideWindowEventHandler);
	self:RegisterEvent(SysEvent._TYPED_EVENT_LOGINWINDOW_UPDATE_, self.OnUpdateWindowEventHandler);
end

-- 窗口显示事件处理
function LoginWindow:OnShowWindowEventHandler(paramList)
	self.super.ShowWindow(self, true);

end

-- 窗口隐藏事件处理
function LoginWindow:OnHideWindowEventHandler(paramList)
	self:Destroy(paramList);
end

-- 窗口更新事件处理
function LoginWindow:OnUpdateWindowEventHandler(paramList)
	
end

-- 加载处理
function LoginWindow:Load()
	LoginWindow.super.Load(self);

	local btn = self:GetChild("Button");
	if btn then
		-- 切换场景
		local function OnChangeScene(obj)
			--SceneManager:ChangeScene("GameScene");
			--SceneManager:ChangeScene("SkyScene");
			--SceneManager:ChangeScene("BallTestScene");
			--SceneManager:ChangeScene("BlockScene");
			StageLogic:StartStage(1);
		end
		UIEventTrigger.Get(btn).onClick = OnChangeScene;
	end
	btn = self:GetChild("Ads");
	if btn then
		-- 切换场景
		local function OnChangeScene(obj)
			StageLogic:StartStage(2);
		end
		UIEventTrigger.Get(btn).onClick = OnChangeScene;
	end
end

-- 桢更新处理
function LoginWindow:Update()
	LoginWindow.super.Update(self);
end

-- 销毁处理
function LoginWindow:Destroy(bDestroyAll)
	LoginWindow.super.Destroy(self, bDestroyAll);

end

return LoginWindow
