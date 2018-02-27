-- define DoActionDirectActionHandler
-- %Name[系统动作/执行指定Id的动作]%
-- %Describe[直接执行指定Id的动作]%
-- %Params[Name[mActionId]Type[Int]Describe[动作Id]]%

-- 指令类
local IActionHandler = import("Script.LogicSystem.Action.IActionHandler")
local DoActionDirectActionHandler = class("DoActionDirectActionHandler", IActionHandler)

function DoActionDirectActionHandler:ctor()
	DoActionDirectActionHandler.super.ctor(self);

end

-- 开始
function DoActionDirectActionHandler:Enter()
	DoActionDirectActionHandler.super.Enter(self);

	local param = self.mActionInfo and self.mActionInfo.mActionId;
	if param then
		self.mManager:DoAction(param);
	end
	self:SetIsEnd(true);
end

-- 逻辑帧处理操作
function DoActionDirectActionHandler:Update()
	DoActionDirectActionHandler.super.Update(self);

end

-- 销毁操作
function DoActionDirectActionHandler:Leave()
	DoActionDirectActionHandler.super.Leave(self);

end

return DoActionDirectActionHandler
