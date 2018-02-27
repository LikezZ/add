
-- UI窗口虚基类
local IWindow = import("Script.UISystem.IWindow")
local GameWindow = class("GameWindow", IWindow)
function GameWindow:ctor()
	GameWindow.super.ctor(self);

end

-- 初始化处理
function GameWindow:Init()
	GameWindow.super.Init(self);

	-- 注册窗口事件
	self:RegisterEvent(SysEvent._TYPED_EVENT_GAMEWINDOW_SHOW_, self.OnShowWindowEventHandler, true);
	self:RegisterEvent(SysEvent._TYPED_EVENT_GAMEWINDOW_HIDE_, self.OnHideWindowEventHandler);
	self:RegisterEvent(SysEvent._TYPED_EVENT_GAMEWINDOW_UPDATE_, self.OnUpdateWindowEventHandler);
end

-- 窗口显示事件处理
function GameWindow:OnShowWindowEventHandler(paramList)
	self.super.ShowWindow(self, true);

end

-- 窗口隐藏事件处理
function GameWindow:OnHideWindowEventHandler(paramList)
	self:Destroy(paramList);
end

-- 窗口更新事件处理
function GameWindow:OnUpdateWindowEventHandler(paramList)
	
end

-- 加载处理
function GameWindow:Load()
	GameWindow.super.Load(self);

	local btn = self:GetChild("Button");
	if btn then
		-- 返回按钮
		local function OnBackBtn(obj)
			SceneManager:ChangeScene("LoginScene");
		end
		UIEventTrigger.Get(btn).onClick = OnBackBtn;
	end
	btn = self:GetChild("Control/Tap1");
	if btn then
		-- 按钮
		local function OnTapBtn(obj)
			EventSystem:PushEvent(SysEvent._TYPED_EVENT_LOGIC_TAPROLE_);
		end
		UIEventTrigger.Get(btn).onClick = OnTapBtn;

		local function OnDownBtn(data)
			print("ddddd"..data.position.x)
		end
		UIEventTrigger.Get(btn).onPointerDown = OnDownBtn;
		local function OnUpBtn(data)
			
		end
		UIEventTrigger.Get(btn).onPointerUp = OnUpBtn;
	end
end

-- 桢更新处理
function GameWindow:Update()
	GameWindow.super.Update(self);
end

-- 销毁处理
function GameWindow:Destroy(bDestroyAll)
	GameWindow.super.Destroy(self, bDestroyAll);

end

return GameWindow
