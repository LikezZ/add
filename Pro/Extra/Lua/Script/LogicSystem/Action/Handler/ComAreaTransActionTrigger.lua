-- define ComAreaTransActionTrigger
-- %Name[触发器/对象区域触发]%
-- %Describe[设置对象进入或离开指定对象半径区域触发事件area:+id]%
-- %Params[[Shared]Name[mActor]Type[Transform]Describe[检测对象 在共享中的引用名]]%
-- %Params[[Shared]Name[mTarget]Type[Transform]Describe[目标对象 在共享中的引用名]]%
-- %Params[Name[mDoType]Type[Int]Describe[触发类型 1离开0进入]]%
-- %Params[Name[mRadius]Type[Float]Describe[区域半径]]%

-- 战斗移动指令类
local IActionHandler = import("Script.LogicSystem.Action.IActionHandler")
local ComAreaTransActionTrigger = class("ComAreaTransActionTrigger", IActionHandler)

function ComAreaTransActionTrigger:ctor()
	ComAreaTransActionTrigger.super.ctor(self);

	self.mTrans = nil;
	self.mTarget = nil;
	self.mRadius = 0;
	self.mDoType = 0;
end

-- 开始
function ComAreaTransActionTrigger:Enter()
	ComAreaTransActionTrigger.super.Enter(self);

	local param = self.mActionInfo and self.mActionInfo.mActor;
	-- 获取当前对象
	self.mTrans = self.mManager.mSharedBoard[param];
	param = self.mActionInfo and self.mActionInfo.mTarget;
	self.mTarget = self.mManager.mSharedBoard[param];

	self.mRadius = self.mActionInfo and self.mActionInfo.mRadius;
	-- 类型
	self.mDoType = self.mActionInfo and self.mActionInfo.mDoType;
end

-- 逻辑帧处理操作
function ComAreaTransActionTrigger:Update()
	ComAreaTransActionTrigger.super.Update(self);

	local t = false;
	local temp = Helper:GetPosition(self.mTrans);
	local tar = Helper:GetPosition(self.mTarget);
	temp = temp:Sub(tar);
	temp = temp.x^2 + temp.z^2;
	tar = self.mRadius^2;
	if self.mDoType == 0 then
		if temp < tar then
			t = true;
		end
	elseif self.mDoType == 1 then
		if temp > tar then
			t = true;
		end
	end
	if t then
		self.mManager:OnActionEvent("area:"..self.mId); 
		self:SetIsEnd(true);
	end
end

-- 销毁操作
function ComAreaTransActionTrigger:Leave()
	ComAreaTransActionTrigger.super.Leave(self);

	self.mTrans = nil;
	self.mTarget = nil;
	self.mRadius = 0;
	self.mDoType = 0;
end

return ComAreaTransActionTrigger
