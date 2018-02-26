-- define IActionManager

-- 动作节点ITEM
local _ACTION_ITEM_ = class("_ACTION_ITEM_")
function _ACTION_ITEM_:ctor(info)
	local temp = info;
	self.mId = temp.mId;             -- action Id 唯一1.2.3...
	self.mTrigger = temp.mTrigger;   -- 触发器{mType = "time", mTime = 10} 或 {mType = "event", mEvent = "finish:1"}
	self.mParams = temp.mParams;     -- 参数列表 {p = 1, x = 2}
	self.mHandler = import("Script.LogicSystem.Action.Handler."..temp.mHandler).new();   -- action 执行类
end

function _ACTION_ITEM_:clear()
	self.mId = 0;
	self.mTrigger = nil;
	self.mParams = nil;
	self.mHandler = nil;
end

function _ACTION_ITEM_:Enter(manager)
	if (self.mHandler == nil) then return; end
	self.mHandler.mId = self.mId;
	self.mHandler.mManager = manager;
	self.mHandler.mActionInfo = self.mParams;
	self.mHandler:Start();
end

-- 动作指令管理器虚基类
local ITimer = import("Script.Framework.ITimer")
local IActionManager = class("IActionManager", ITimer)

function IActionManager:ctor()
	IActionManager.super.ctor(self);

	-- 动作指令队列 Node
	self.mActionList = import("Script.Framework.List").new();
	-- Update ActionHandler队列
	self.mUpdateList = import("Script.Framework.List").new();
	-- 是否开始执行
	self.mIsStart = false;
	-- 是否结束
	self.mIsEnd = false;
	-- 共享参数黑板
	self.mSharedBoard = {};
end

-- 添加队列
function IActionManager:AddAction(action)
	self.mActionList:Push(action);
end

-- 添加队列表
function IActionManager:SetActionTable(table)
	for i=1,#table do
		self:AddAction(_ACTION_ITEM_.new(table[i]));
	end
end

-- 是否结束
function IActionManager:IsEnd()
	return self.mIsEnd;
end

-- 开始
function IActionManager:Start()
	local node = self.mActionList:Begin();
	while (node ~= nil) do
		local temp = node;
		node = node.mNext;
		-- 初始化
		-- 如果是时间触发 设置定时器
		if (temp.mValue.mTrigger.mType == "time") then
			local function onEnter()
				local value = clone(temp.mValue);
				value:Enter(self);
				self.mUpdateList:Push(value.mHandler);
				value:clear();
			end
			if (temp.mValue.mTrigger.mTime > 0) then
				self:RegisterTimer(false, temp.mValue.mTrigger.mTime, onEnter);
			else
				onEnter();
			end
		end
	end
	-- 开始动作
	self.mIsStart = true;
	self.mIsEnd = false;
end

-- 逻辑帧处理操作
function IActionManager:Update()
	IActionManager.super.Update(self);

	if (not self.mIsStart) then return; end
	local node = self.mUpdateList:Begin();
	while (node ~= nil) do
		local temp = node;
		node = node.mNext;
		-- 刷新
		if (temp.mValue:IsEnd()) then
			temp.mValue:Leave();
			self:OnActionEvent("finish:"..temp.mValue.mId);
			temp.mValue:clear();
			self.mUpdateList:Del(temp);
			temp:clear();
		else
			temp.mValue:Update();
		end
	end

	-- 是否结束 改为脚本控制
	--local count = self.mUpdateList:Count();
	--if (count <= 0) then
	--	self.mIsStart = false;
	--	self.mIsEnd = true;
	--end
end

-- 销毁操作
function IActionManager:Destroy()
	IActionManager.super.Destroy(self);

	self.mIsStart = false;
	self.mIsEnd = false;
	self.mActionList:Clear();
	self.mUpdateList:Clear();
	self.mActionList = nil;
	self.mUpdateList = nil;
	self.mSharedBoard = nil;
end

-- 复位数据
function IActionManager:Reset()
	self:ClearAll();
	self.mIsStart = false;
	self.mIsEnd = false;
	self.mActionList:Clear();
	self.mUpdateList:Clear();
	self.mSharedBoard = {};
end

-- Handler中触发事件
function IActionManager:OnActionEvent(event)
	if (not self.mIsStart) then return; end
	local node = self.mActionList:Begin();
	while (node ~= nil) do
		local temp = node;
		node = node.mNext;
		-- 如果是事件触发
		if (temp.mValue.mTrigger.mType == "event") then
			if (temp.mValue.mTrigger.mEvent == event) then
				local value = clone(temp.mValue);
				value:Enter(self);
				self.mUpdateList:Push(value.mHandler);
				value:clear();
			end
		end
	end
end

-- 执行指定Id动作
function IActionManager:DoAction(id)
	if (not self.mIsStart) then return; end
	local node = self.mActionList:Begin();
	while (node ~= nil) do
		local temp = node;
		node = node.mNext;
		-- 如果是指定Id
		if (temp.mValue.mId == id) then
			local value = clone(temp.mValue);
			value:Enter(self);
			self.mUpdateList:Push(value.mHandler);
			value:clear();
		end
	end
end

-- 结束指定Id动作
function IActionManager:EndAction(id)
	if (not self.mIsStart) then return; end
	local node = self.mUpdateList:Begin();
	while (node ~= nil) do
		local temp = node;
		node = node.mNext;
		-- 比较
		if (temp.mValue.mId == id) then
			temp.mValue:SetIsEnd(true);
		end
	end
end

return IActionManager
