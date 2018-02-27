-- define DoActionEndActionHandler
-- %Name[系统动作/结束指定Id的动作]%
-- %Describe[结束正在执行中的指定Id的动作]%
-- %Params[Name[mActionId]Type[Int]Describe[动作Id]]%

-- 指令类
local IActionHandler = import("Script.LogicSystem.Action.IActionHandler")
local DoActionEndActionHandler = class("DoActionEndActionHandler", IActionHandler)

function DoActionEndActionHandler:ctor()
	DoActionEndActionHandler.super.ctor(self);

end

-- 开始
function DoActionEndActionHandler:Enter()
	DoActionEndActionHandler.super.Enter(self);

	local param = self.mActionInfo and self.mActionInfo.mActionId;
	if param then
		self.mManager:EndAction(param);
	end
	self:SetIsEnd(true);
end

-- 逻辑帧处理操作
function DoActionEndActionHandler:Update()
	DoActionEndActionHandler.super.Update(self);

end

-- 销毁操作
function DoActionEndActionHandler:Leave()
	DoActionEndActionHandler.super.Leave(self);

end

return DoActionEndActionHandler
