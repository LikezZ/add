-- define ComActiveTransActionGetter
-- %Name[通用变量/是否激活节点对象]%
-- %Describe[设置场景Transform对象是否Active]%
-- %Params[[Shared]Name[mTrans]Type[Transform]Describe[场景对象 设置在共享中的引用名]]%
-- %Params[Name[mActive]Type[Int]Describe[是否激活 1激活0取消]]%

-- 战斗移动指令类
local IActionHandler = import("Script.LogicSystem.Action.IActionHandler")
local ComActiveTransActionGetter = class("ComActiveTransActionGetter", IActionHandler)

function ComActiveTransActionGetter:ctor()
	ComActiveTransActionGetter.super.ctor(self);

end

-- 开始
function ComActiveTransActionGetter:Enter()
	ComActiveTransActionGetter.super.Enter(self);

	local active = self.mActionInfo and self.mActionInfo.mActive;
	local trans = self.mActionInfo and self.mActionInfo.mTrans;
	trans = self.mManager.mSharedBoard[trans];
	if active and active == 1 then
		Helper:SetActive(trans, true);
	else
		Helper:SetActive(trans, false);
	end
	
	self:SetIsEnd(true);
end

-- 逻辑帧处理操作
function ComActiveTransActionGetter:Update()
	ComActiveTransActionGetter.super.Update(self);

end

-- 销毁操作
function ComActiveTransActionGetter:Leave()
	ComActiveTransActionGetter.super.Leave(self);

end

return ComActiveTransActionGetter
