-- define ComLookAtActionHandler
-- %Name[通用动作/执行朝向目标对象]%
-- %Describe[朝向目标对象 当目标对象为空时朝向坐标]%
-- %Params[[Shared]Name[mActor]Type[Transform]Describe[执行对象 在共享中的引用名]]%
-- %Params[[Shared]Name[mTarget]Type[Transform]Describe[目标对象 在共享中的引用名]]%
-- %Params[Name[mDuration]Type[Float]Describe[持续时间]]%
-- %Params[Name[mOffsetX]Type[Float]Describe[偏移目标点X坐标]]%
-- %Params[Name[mOffsetY]Type[Float]Describe[偏移目标点Y坐标]]%
-- %Params[Name[mOffsetZ]Type[Float]Describe[偏移目标点Z坐标]]%

-- 战斗移动指令类
local IActionHandler = import("Script.LogicSystem.Action.IActionHandler")
local ComLookAtActionHandler = class("ComLookAtActionHandler", IActionHandler)

function ComLookAtActionHandler:ctor()
	ComLookAtActionHandler.super.ctor(self);

	self.mIsDoing = false;
	self.mActorTrans = nil;
	self.mOffsetPos = nil;
	self.mTarTrans = nil;
end

-- 开始
function ComLookAtActionHandler:Enter()
	ComLookAtActionHandler.super.Enter(self);

	local param = self.mActionInfo and self.mActionInfo.mActor;
	-- 获取当前攻击的玩家
	self.mActorTrans = self.mManager.mSharedBoard[param];
	local x = self.mActionInfo and self.mActionInfo.mOffsetX;
	local y = self.mActionInfo and self.mActionInfo.mOffsetY;
	local z = self.mActionInfo and self.mActionInfo.mOffsetZ;
	self.mOffsetPos = Vector3.New(x, y, z);
	-- 目标对象
	param = self.mActionInfo and self.mActionInfo.mTarget;
	self.mTarTrans = self.mManager.mSharedBoard[param];
	if self.mTarTrans then
		local pos = Helper:GetPosition(self.mTarTrans);
		pos = pos:Add(self.mOffsetPos);
		Helper:LookAtPos(self.mActorTrans, pos);
	else
		Helper:LookAtPos(self.mActorTrans, self.mOffsetPos);
	end
	-- 移动时间
	param = self.mActionInfo and self.mActionInfo.mDuration;
	if param and param > 0 then
		local function OnTimer()
			self.mIsDoing = false;
			self:SetIsEnd(true);
		end
	    self:RegisterTimer(false, param, OnTimer);
		self.mIsDoing = true;
	else
		self:SetIsEnd(true);
	end
end

-- 逻辑帧处理操作
function ComLookAtActionHandler:Update()
	ComLookAtActionHandler.super.Update(self);

	if (not self.mIsDoing) then
		return;
	end

    if self.mTarTrans then
		local pos = Helper:GetPosition(self.mTarTrans);
		pos = pos:Add(self.mOffsetPos);
		Helper:LookAtPos(self.mActorTrans, pos);
	else
		Helper:LookAtPos(self.mActorTrans, self.mOffsetPos);
	end
end

-- 销毁操作
function ComLookAtActionHandler:Leave()
	ComLookAtActionHandler.super.Leave(self);

	self.mIsDoing = false;
	self.mActorTrans = nil;
	self.mOffsetPos = nil;
	self.mTarTrans = nil;
end

return ComLookAtActionHandler
