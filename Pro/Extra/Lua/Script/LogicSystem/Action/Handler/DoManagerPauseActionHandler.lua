-- define DoManagerPauseActionHandler
-- %Name[系统动作/设置动作控制暂停]%
-- %Describe[标识动作控制暂停，不响应事件等]%
-- %Params[Name[mPause]Type[Int]Describe[是否暂停 1暂停0运行]]%

-- 指令类
local IActionHandler = import("Script.LogicSystem.Action.IActionHandler")
local DoManagerPauseActionHandler = class("DoManagerPauseActionHandler", IActionHandler)

function DoManagerPauseActionHandler:ctor()
	DoManagerPauseActionHandler.super.ctor(self);

	self.mIsPause = false;
end

-- 开始
function DoManagerPauseActionHandler:Enter()
	DoManagerPauseActionHandler.super.Enter(self);

	local param = self.mActionInfo and self.mActionInfo.mPause;
	if param then self.mIsPause = param; end
	self:SetIsEnd(true);
end

-- 逻辑帧处理操作
function DoManagerPauseActionHandler:Update()
	DoManagerPauseActionHandler.super.Update(self);

end

-- 销毁操作
function DoManagerPauseActionHandler:Leave()
	DoManagerPauseActionHandler.super.Leave(self);

	self.mManager.mIsStart = self.mIsPause;
end

return DoManagerPauseActionHandler
