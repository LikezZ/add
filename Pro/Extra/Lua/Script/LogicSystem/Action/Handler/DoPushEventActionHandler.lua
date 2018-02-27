-- define DoPushEventActionHandler
-- %Name[系统动作/触发客户端事件动作]%
-- %Describe[触发指定Id的事件可传参数]%
-- %Params[Name[mEventId]Type[Int]Describe[事件Id]]%
-- %Params[Name[mParam]Type[Custom]Describe[事件参数]]%

-- 战斗移动指令类
local IActionHandler = import("Script.LogicSystem.Action.IActionHandler")
local DoPushEventActionHandler = class("DoPushEventActionHandler", IActionHandler)

function DoPushEventActionHandler:ctor()
	DoPushEventActionHandler.super.ctor(self);

end

-- 开始
function DoPushEventActionHandler:Enter()
	DoPushEventActionHandler.super.Enter(self);

	local param1 = self.mActionInfo and self.mActionInfo.mEventId;
	local param2 = self.mActionInfo and self.mActionInfo.mParam;
	if param1 then
		EventSystem:PushEvent(param1, param2);
	end
	self:SetIsEnd(true);
end

-- 逻辑帧处理操作
function DoPushEventActionHandler:Update()
	DoPushEventActionHandler.super.Update(self);

end

-- 销毁操作
function DoPushEventActionHandler:Leave()
	DoPushEventActionHandler.super.Leave(self);

end

return DoPushEventActionHandler
