-- define ComAreaBlockActionTrigger
-- %Name[触发器/方块区域触发]%
-- %Describe[设置对象进入或离开区域触发事件area:+id]%
-- %Params[[Shared]Name[mActor]Type[Transform]Describe[检测对象 在共享中的引用名]]%
-- %Params[Name[mDoType]Type[Int]Describe[触发类型 1离开0进入]]%
-- %Params[Name[mAreaX]Type[Float]Describe[区域X宽度]]%
-- %Params[Name[mAreaZ]Type[Float]Describe[区域Z宽度]]%
-- %Params[Name[mCenterX]Type[Float]Describe[中心点X坐标]]%
-- %Params[Name[mCenterZ]Type[Float]Describe[中心点Z坐标]]%

-- 战斗移动指令类
local IActionHandler = import("Script.LogicSystem.Action.IActionHandler")
local ComAreaBlockActionTrigger = class("ComAreaBlockActionTrigger", IActionHandler)

function ComAreaBlockActionTrigger:ctor()
	ComAreaBlockActionTrigger.super.ctor(self);

	self.mTrans = nil;
	self.mTarSize = nil;
	self.mTarPos = nil;
	self.mDoType = 0;
end

-- 开始
function ComAreaBlockActionTrigger:Enter()
	ComAreaBlockActionTrigger.super.Enter(self);

	local param = self.mActionInfo and self.mActionInfo.mActor;
	-- 获取当前对象
	self.mTrans = self.mManager.mSharedBoard[param];
	local x = self.mActionInfo and self.mActionInfo.mCenterX;
	local z = self.mActionInfo and self.mActionInfo.mCenterZ;
	self.mTarPos = Vector3.New(x, 0, z);
	x = self.mActionInfo and self.mActionInfo.mAreaX;
	z = self.mActionInfo and self.mActionInfo.mAreaZ;
	self.mTarSize = Vector3.New(x/2, 0, z/2);
	-- 坐标类型
	self.mDoType = self.mActionInfo and self.mActionInfo.mDoType;
	--if not self.mTrans then
		--self:SetIsEnd(true);
		--return;
	--end
end

-- 逻辑帧处理操作
function ComAreaBlockActionTrigger:Update()
	ComAreaBlockActionTrigger.super.Update(self);

	local t = false;
	local temp = Helper:GetPosition(self.mTrans);
	if self.mDoType == 0 then
		if temp.x > self.mTarPos.x - self.mTarSize.x and temp.x < self.mTarPos.x + self.mTarSize.x and
			temp.z > self.mTarPos.z - self.mTarSize.z and temp.z < self.mTarPos.z + self.mTarSize.z then
			t = true;
		end
	elseif self.mDoType == 1 then
		if temp.x < self.mTarPos.x - self.mTarSize.x and temp.x > self.mTarPos.x + self.mTarSize.x and
			temp.z < self.mTarPos.z - self.mTarSize.z and temp.z > self.mTarPos.z + self.mTarSize.z then
			t = true;
		end
	end
	if t then
		self.mManager:OnActionEvent("area:"..self.mId); 
		self:SetIsEnd(true);
	end
end

-- 销毁操作
function ComAreaBlockActionTrigger:Leave()
	ComAreaBlockActionTrigger.super.Leave(self);

	self.mTrans = nil;
	self.mTarSize = nil;
	self.mTarPos = nil;
	self.mDoType = 0;
end

return ComAreaBlockActionTrigger
