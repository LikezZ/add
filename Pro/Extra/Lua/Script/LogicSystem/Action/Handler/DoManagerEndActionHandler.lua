-- define DoManagerEndActionHandler
-- %Name[系统动作/设置动作控制结束]%
-- %Describe[标识动作控制结束，不响应事件等]%

-- 指令类
local IActionHandler = import("Script.LogicSystem.Action.IActionHandler")
local DoManagerEndActionHandler = class("DoManagerEndActionHandler", IActionHandler)

function DoManagerEndActionHandler:ctor()
	DoManagerEndActionHandler.super.ctor(self);

end

-- 开始
function DoManagerEndActionHandler:Enter()
	DoManagerEndActionHandler.super.Enter(self);

	self:SetIsEnd(true);
end

-- 逻辑帧处理操作
function DoManagerEndActionHandler:Update()
	DoManagerEndActionHandler.super.Update(self);

end

-- 销毁操作
function DoManagerEndActionHandler:Leave()
	DoManagerEndActionHandler.super.Leave(self);

	self.mManager.mIsStart = false;
	self.mManager.mIsEnd = true;
end

return DoManagerEndActionHandler
