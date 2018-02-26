-- define ComFollowToActionHandler
-- %Name[通用动作/执行跟随目标对象]%
-- %Describe[设置跟随目标对象或手动设置跟随偏移]%
-- %Params[[Shared]Name[mActor]Type[Transform]Describe[执行对象 在共享中的引用名]]%
-- %Params[[Shared]Name[mTarget]Type[Transform]Describe[目标对象 在共享中的引用名]]%
-- %Params[Name[mDuration]Type[Float]Describe[持续时间]]%
-- %Params[Name[mOffsetX]Type[Float]Describe[偏移X坐标]]%
-- %Params[Name[mOffsetY]Type[Float]Describe[偏移Y坐标]]%
-- %Params[Name[mOffsetZ]Type[Float]Describe[偏移Z坐标]]%

-- 战斗移动指令类
local IActionHandler = import("Script.LogicSystem.Action.IActionHandler")
local ComFollowToActionHandler = class("ComFollowToActionHandler", IActionHandler)

function ComFollowToActionHandler:ctor()
	ComFollowToActionHandler.super.ctor(self);

	self.mIsDoing = false;
	self.mActorTrans = nil;
	self.mOffsetPos = nil;
	self.mTarTrans = nil;
end

-- 开始
function ComFollowToActionHandler:Enter()
	ComFollowToActionHandler.super.Enter(self);

	local param = self.mActionInfo and self.mActionInfo.mActor;
	-- 获取执行对象
	self.mActorTrans = self.mManager.mSharedBoard[param];
	local x = self.mActionInfo and self.mActionInfo.mOffsetX;
	local y = self.mActionInfo and self.mActionInfo.mOffsetY;
	local z = self.mActionInfo and self.mActionInfo.mOffsetZ;
	self.mOffsetPos = Vector3.New(x, y, z);
	-- 目标对象
	param = self.mActionInfo and self.mActionInfo.mTarget;
	self.mTarTrans = self.mManager.mSharedBoard[param];
	-- 如果偏移坐标为0表示不是手动设置偏移
	if x == 0 and y == 0 and z == 0 then
		-- 获取相对偏移
		local pos1 = Helper:GetPosition(self.mActorTrans);
		local pos2 = Helper:GetPosition(self.mTarTrans);
		self.mOffsetPos = pos1:Clone():Sub(pos2);
	end
	-- 设置位置
	local pos = Helper:GetPosition(self.mTarTrans);
	Helper:SetPosition(self.mActorTrans, pos:Add(self.mOffsetPos));
	-- 跟随时间
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
function ComFollowToActionHandler:Update()
	ComFollowToActionHandler.super.Update(self);

	if (not self.mIsDoing) then
		return;
	end

    local pos = Helper:GetPosition(self.mTarTrans);
	Helper:SetPosition(self.mActorTrans, pos:Add(self.mOffsetPos));
end

-- 销毁操作
function ComFollowToActionHandler:Leave()
	ComFollowToActionHandler.super.Leave(self);

	self.mIsDoing = false;
	self.mActorTrans = nil;
	self.mOffsetPos = nil;
	self.mTarTrans = nil;
end

return ComFollowToActionHandler
