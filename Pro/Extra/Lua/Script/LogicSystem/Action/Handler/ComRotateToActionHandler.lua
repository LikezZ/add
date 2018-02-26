-- define ComRotateToActionHandler
-- %Name[通用动作/执行目标旋转到角度]%
-- %Describe[执行目标对象旋转或设置角度]%
-- %Params[[Shared]Name[mActor]Type[Transform]Describe[执行对象 在共享中的引用名]]%
-- %Params[Name[mDoType]Type[Int]Describe[操作类型 1设置0旋转]]%
-- %Params[Name[mRotateTime]Type[Float]Describe[旋转时间]]%
-- %Params[Name[mRotateX]Type[Float]Describe[X旋转角度]]%
-- %Params[Name[mRotateY]Type[Float]Describe[Y旋转角度]]%
-- %Params[Name[mRotateZ]Type[Float]Describe[Z旋转角度]]%

-- 战斗移动指令类
local IActionHandler = import("Script.LogicSystem.Action.IActionHandler")
local ComRotateToActionHandler = class("ComRotateToActionHandler", IActionHandler)

function ComRotateToActionHandler:ctor()
	ComRotateToActionHandler.super.ctor(self);

	self.mIsDoing = false;
	self.mActorTrans = nil;
	self.mRotateSpeed = nil;
	self.mTarAngle = nil;
	self.mDoType = 0;
end

-- 开始
function ComRotateToActionHandler:Enter()
	ComRotateToActionHandler.super.Enter(self);

	local param = self.mActionInfo and self.mActionInfo.mActor;
	-- 获取当前对象
	self.mActorTrans = self.mManager.mSharedBoard[param];
	local x = self.mActionInfo and self.mActionInfo.mRotateX;
	local y = self.mActionInfo and self.mActionInfo.mRotateY;
	local z = self.mActionInfo and self.mActionInfo.mRotateZ;
	self.mTarAngle = Vector3.New(x, y, z);
	-- 操作类型
	self.mDoType = self.mActionInfo and self.mActionInfo.mDoType;
	if self.mDoType == 1 then
		self.mActorTrans.localEulerAngles = self.mTarAngle;
		self:SetIsEnd(true);
		return;
	end
	-- 时间
	param = self.mActionInfo and self.mActionInfo.mRotateTime;
	if param and param > 0 then
	    -- 设置旋转步长
		self.mRotateSpeed = self.mTarAngle:Clone();
		self.mRotateSpeed = self.mRotateSpeed:Div(param);
		
		local function OnTimer()
			self.mIsDoing = false;
			self:SetIsEnd(true);
		end
	    self:RegisterTimer(false, param, OnTimer);
		self.mIsDoing = true;
	else
		self.mActorTrans:Rotate(self.mTarAngle);
		self:SetIsEnd(true);
	end
end

-- 逻辑帧处理操作
function ComRotateToActionHandler:Update()
	ComRotateToActionHandler.super.Update(self);

	if (not self.mIsDoing) then
		return;
	end

    local rotDiff = self.mRotateSpeed:Clone();
    rotDiff = rotDiff:Mul(UnityEngine.Time.deltaTime);
    self.mActorTrans:Rotate(rotDiff);
end

-- 销毁操作
function ComRotateToActionHandler:Leave()
	ComRotateToActionHandler.super.Leave(self);

	self.mIsDoing = false;
	self.mActorTrans = nil;
	self.mRotateSpeed = nil;
	self.mTarAngle = nil;
	self.mDoType = 0;
end

return ComRotateToActionHandler
