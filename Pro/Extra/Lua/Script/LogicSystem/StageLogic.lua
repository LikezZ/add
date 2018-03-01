
-- 全局lua
StageLogic = {};
StageLogic.mOnTimer = nil;

-- 当前场景布局信息
StageLogic.mStageInfo = nil;
-- 当前片段逻辑信息
StageLogic.mPartInfo = nil;

-- 步数记录
StageLogic.mSteps = 1;
-- 消除个数记录
StageLogic.mCount = 0;

-- 数据表的id索引
StageLogic.mBlockIndex = 1;
-- 数据表的id统计数
StageLogic.mBlockCount = 1;

-- 初始化lua 
function StageLogic:Init()
	
	-- self.mOnTimer = function ()
	-- 	self:OnTimerFunc();
	-- end
	-- App:RegisterTimer(true, 0.8, self.mOnTimer);
end

-- 更新
function StageLogic:Update()
	
end

-- 销毁
function StageLogic:Destroy()
	--App:UnRegisterTimer(self.mOnTimer);
end

-- 定时
function StageLogic:OnTimerFunc()
	
end

-- 切换场景布局信息
function StageLogic:StartStage(index)
	-- 初始步数1
	self.mSteps = 1;
	self.mCount = 0;
	self:ChangePart(index);
end

-- 切换场景布局信息
function StageLogic:ChangePart(index)
	local item = DataManager.Data.Stage:GetDataByKey(index);
	if item then
		self.mBlockIndex = 1;
		self.mBlockCount = 1;
		self.mStageInfo = item;
		self.mPartInfo = DataManager:GetData(item.DataName);
		SceneManager:ChangeScene(item.SceneName);
	end
end

-- 切换下一个或者结束
function StageLogic:DoNextOrDone()
	if self.mStageInfo and self.mStageInfo.NextIndex > -1 then
		self:ChangePart(self.mStageInfo.NextIndex);
	else
		-- 结算游戏
		-- 临时
		self.mSteps = 1;
		self.mCount = 0;
		SceneManager:ChangeScene("LoginScene");
	end
end

-- 获取方块布局数据
function StageLogic:GetPartBlock(index)
	if self.mPartInfo then
		return self.mPartInfo:GetDataByKey(index);
	end
	return nil;
end

-- 添加消除个数计算步数
function StageLogic:AddCount()
	-- 每消除三个增加一步
	self.mCount = self.mCount + 1;
	if self.mCount == 3 then
		self.mSteps = self.mSteps + 1;
		self.mCount = 0;
		-- 事件
		EventSystem:PushEvent(SysEvent._TYPED_EVENT_BLOCKWINDOW_UPDATE_);
	end
end

-- 减步数
function StageLogic:SubSteps()
	if self.mSteps > 0 then
		self.mSteps = self.mSteps - 1;
		-- 事件
		EventSystem:PushEvent(SysEvent._TYPED_EVENT_BLOCKWINDOW_UPDATE_);
		return true;
	end
end

-- 获取数据表对象
function StageLogic:GetIndexBlock(row, column)
	local item = self:GetPartBlock(self.mBlockIndex);
	if self.mBlockIndex ~= self.mBlockCount then
		local temp = self:GetPartBlock(self.mBlockCount);
		if temp then 
			self.mBlockIndex = self.mBlockCount;
			item = temp; 
		end
	end
	self.mBlockIndex = self.mBlockIndex + 1;
	self.mBlockCount = self.mBlockCount + 1;
	if item then
		if item.JumpIndex > 0 then
			self.mBlockIndex = item.JumpIndex;
		end
		local temp, utype = nil, -1;
		if item.UnderRandom == -1 then
			utype = item.UnderType;
		elseif item.UnderRandom == 1 then
			local str = Helper:SplitString(item.UnderPool, '|');
			utype = tonumber(str[math.random(#str)]);
		end
		if item.RandomType == -1 then
			temp = GameLogic:CreateBlock(item.SecondaryType, row, column, utype);
		elseif item.RandomType == 0 then
			temp = GameLogic:GetRandomBlock(row, column, utype);
		elseif item.RandomType == 1 then
			local str = Helper:SplitString(item.RandomPool, '|');
			temp = GameLogic:CreateBlock(tonumber(str[math.random(#str)]), row, column, utype);
		end
		return temp;
	end
end
