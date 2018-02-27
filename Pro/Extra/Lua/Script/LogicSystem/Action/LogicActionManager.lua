-- define LogicActionManager

-- 客户端动作指令管理器类
local IActionManager = import("Script.LogicSystem.Action.IActionManager")
local LogicActionManager = class("LogicActionManager", IActionManager)

function LogicActionManager:ctor()
	LogicActionManager.super.ctor(self);

	self.mEventHandler = nil;
end

-- 开始
function LogicActionManager:Start()
	LogicActionManager.super.Start(self);
	-- 注册响应事件
	local function OnEvent(eventType, ownerData, paramList)
		-- 触发事件
		self:OnActionEvent(paramList);
	end
	self.mEventHandler = OnEvent;
	EventSystem:RegisterEventHandler(SysEvent._TYPED_EVENT_ACTION_ON_EVENT_, self.mEventHandler);
end

-- 逻辑帧处理操作
function LogicActionManager:Update()
	LogicActionManager.super.Update(self);

end

-- 销毁操作
function LogicActionManager:Destroy()
	LogicActionManager.super.Destroy(self);

	-- 注销响应事件
	EventSystem:UnRegisterEventHandler(SysEvent._TYPED_EVENT_ACTION_ON_EVENT_, self.mEventHandler);
	self.mEventHandler = nil;
end

return LogicActionManager
