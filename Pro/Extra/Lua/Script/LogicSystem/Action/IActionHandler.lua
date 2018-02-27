-- define IActionHandler

-- 动作指令虚基类
local ITimer = import("Script.Framework.ITimer")
local IActionHandler = class("IActionHandler", ITimer)

function IActionHandler:ctor()
	IActionHandler.super.ctor(self);

	-- 是否动作结束
	self.mIsActionEnd = false;
	-- 动作本身需要的信息
	-- 包含的参数mDelay延迟执行，nil瞬时
	-- 以及其他自定义参数
	-- {mDelay = 0.5, .......}
	self.mActionInfo = nil;
	-- 动作管理器引用
	self.mManager = nil;
	-- id 唯一标示
	self.mId = 0;
end

function IActionHandler:clear()
	self.mIsActionEnd = true;
	self.mActionInfo = nil;
	self.mManager = nil;
	self.mId = 0;
end

-- 是否结束
function IActionHandler:IsEnd()
	return self.mIsActionEnd;
end

-- 设置是否结束
function IActionHandler:SetIsEnd(isEnd)
	self.mIsActionEnd = isEnd;
end

function IActionHandler:OnDelay()
	self:Enter();
end

-- 开始初始化
function IActionHandler:Start()
	if (self.mActionInfo and self.mActionInfo.mDelay and self.mActionInfo.mDelay > 0) then
		self:RegisterTimer(false, self.mActionInfo.mDelay, self.OnDelay);
	else
		self:OnDelay();
	end
end

-- 执行动作（子类）
function IActionHandler:Enter()
	
end

-- 逻辑帧处理操作
function IActionHandler:Update()
	IActionHandler.super.Update(self);
end

-- 销毁操作
function IActionHandler:Leave()
	IActionHandler.super.Destroy(self);

end

return IActionHandler
