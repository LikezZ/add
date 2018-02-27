-- define ComObjectHPActionTrigger
-- %Name[触发器/人物血量触发]%
-- %Describe[设置对象血量大于或小于百分比触发事件hp:+id]%
-- %Params[[Shared]Name[mActor]Type[IObject]Describe[检测对象 在共享中的引用名]]%
-- %Params[Name[mDoType]Type[Int]Describe[触发类型 1大于0小于]]%
-- %Params[Name[mPercent]Type[Int]Describe[设置百分比 比如20]]%

-- 战斗移动指令类
local IActionHandler = import("Script.LogicSystem.Action.IActionHandler")
local ComObjectHPActionTrigger = class("ComObjectHPActionTrigger", IActionHandler)

function ComObjectHPActionTrigger:ctor()
	ComObjectHPActionTrigger.super.ctor(self);

	self.mObj = nil;
	self.mTarNum = 0;
	self.mDoType = 0;
end

-- 开始
function ComObjectHPActionTrigger:Enter()
	ComObjectHPActionTrigger.super.Enter(self);

	local param = self.mActionInfo and self.mActionInfo.mActor;
	-- 获取当前对象
	self.mObj = self.mManager.mSharedBoard[param];
	self.mTarNum = self.mActionInfo and self.mActionInfo.mPercent;
	-- 类型
	self.mDoType = self.mActionInfo and self.mActionInfo.mDoType;
end

-- 逻辑帧处理操作
function ComObjectHPActionTrigger:Update()
	ComObjectHPActionTrigger.super.Update(self);

	local t = false;
	local temp = self.mObj.mMaxHP;
	if not temp or temp == 0 then return; end 
	temp = self.mObj.mCurHP / temp * 100;
	if self.mDoType == 0 then
		if temp <= self.mTarNum then
			t = true;
		end
	elseif self.mDoType == 1 then
		if temp >= self.mTarNum then
			t = true;
		end
	end
	if t then
		self.mManager:OnActionEvent("hp:"..self.mId); 
		self:SetIsEnd(true);
	end
end

-- 销毁操作
function ComObjectHPActionTrigger:Leave()
	ComObjectHPActionTrigger.super.Leave(self);

	self.mObj = nil;
	self.mTarNum = 0;
	self.mDoType = 0;
end

return ComObjectHPActionTrigger
