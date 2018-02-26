-- define ComMoveToPosActionHandler
-- %Name[通用动作/执行目标移动到坐标]%
-- %Describe[执行对象向目标坐标点的移动]%
-- %Params[[Shared]Name[mActor]Type[Transform]Describe[执行对象 在共享中的引用名]]%
-- %Params[Name[mMoveToTime]Type[Float]Describe[移动时间]]%
-- %Params[Name[mPosType]Type[Int]Describe[坐标系 1本地0世界]]%
-- %Params[Name[mMoveX]Type[Float]Describe[目标点X坐标]]%
-- %Params[Name[mMoveY]Type[Float]Describe[目标点Y坐标]]%
-- %Params[Name[mMoveZ]Type[Float]Describe[目标点Z坐标]]%

-- 战斗移动指令类
local IActionHandler = import("Script.LogicSystem.Action.IActionHandler")
local ComMoveToPosActionHandler = class("ComMoveToPosActionHandler", IActionHandler)

function ComMoveToPosActionHandler:ctor()
	ComMoveToPosActionHandler.super.ctor(self);

	self.mIsMoving = false;
	self.mActorTrans = nil;
	self.mMoveSpeed = nil;
	self.mTarPos = nil;
	self.mPosType = 0;
end

-- 开始
function ComMoveToPosActionHandler:Enter()
	ComMoveToPosActionHandler.super.Enter(self);

	local param = self.mActionInfo and self.mActionInfo.mActor;
	-- 获取当前攻击的玩家
	self.mActorTrans = self.mManager.mSharedBoard[param];
	local x = self.mActionInfo and self.mActionInfo.mMoveX;
	local y = self.mActionInfo and self.mActionInfo.mMoveY;
	local z = self.mActionInfo and self.mActionInfo.mMoveZ;
	self.mTarPos = Vector3.New(x, y, z);
	-- 坐标类型
	self.mPosType = self.mActionInfo and self.mActionInfo.mPosType;
	-- 移动时间
	param = self.mActionInfo and self.mActionInfo.mMoveToTime;
	if param and param > 0 then
	    -- 设置移动步长
	    local startPos = Helper:GetPosition(self.mActorTrans);
		self.mMoveSpeed = self.mTarPos:Clone();
		self.mMoveSpeed = self.mMoveSpeed:Sub(startPos);
		self.mMoveSpeed = self.mMoveSpeed:Div(param);
		self.mIsMoving = true;
	else
		self:SetPosition(self.mActorTrans, self.mTarPos);
		self:OnMoveEndHandler();
	end
end

-- 逻辑帧处理操作
function ComMoveToPosActionHandler:Update()
	ComMoveToPosActionHandler.super.Update(self);

	if (not self.mIsMoving) then
		return;
	end

    local moveDiff = self.mMoveSpeed:Clone();
    moveDiff = moveDiff:Mul(UnityEngine.Time.deltaTime);

	local temp = Helper:GetPosition(self.mActorTrans);
    -- 防止移动出界
	local dis1 = temp:Distance(self.mTarPos);
	temp = temp:Add(moveDiff);
	local dis2 = temp:Distance(self.mTarPos);

	-- 如果直接超了，则直接设置吧
	if (dis1 < dis2) then
		self:SetPosition(self.mActorTrans, self.mTarPos);
		self:OnMoveEndHandler();
	else
		-- 先判断距离是否在移动速度之内
		if (dis1 <= 0.1) then
			self:SetPosition(self.mActorTrans, self.mTarPos);
			self:OnMoveEndHandler();
		else
			self:SetPosition(self.mActorTrans, temp);
		end
	end
end

-- 设置坐标操作
function ComMoveToPosActionHandler:SetPosition(trans, pos)
	if self.mPosType == 1 then
		Helper:SetLocalPosition(trans, pos);
	else
		Helper:SetPosition(trans, pos);
	end
end

-- 获取坐标操作
function ComMoveToPosActionHandler:GetPosition(trans)
	if self.mPosType == 1 then
		return Helper:GetLocalPosition(trans);
	else
		return Helper:GetPosition(trans);
	end
end

-- 销毁操作
function ComMoveToPosActionHandler:Leave()
	ComMoveToPosActionHandler.super.Leave(self);

	self.mIsMoving = false;
	self.mActorTrans = nil;
	self.mMoveSpeed = nil;
	self.mTarPos = nil;
	self.mPosType = 0;
end

-- 移动结束回调处理
function ComMoveToPosActionHandler:OnMoveEndHandler()
	self.mIsMoving = false;
	self:SetIsEnd(true);
end

return ComMoveToPosActionHandler
