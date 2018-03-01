
-- 关卡逻辑基类
local IStage = import("Script.LogicSystem.Stage.IStage")
local ExploreStage = class("ExploreStage", IStage)
function ExploreStage:ctor()
	ExploreStage.super.ctor(self);

end

-- 脚本挂载事件
function ExploreStage:Awake()
	ExploreStage.super.Awake(self);
end

-- 脚本运行事件
function ExploreStage:Start()
	ExploreStage.super.Start(self);
end

-- 脚本更新事件
function ExploreStage:Update()
	ExploreStage.super.Update(self);

end

-- 脚本销毁事件
function ExploreStage:Destroy()
	ExploreStage.super.Destroy(self);

end

-- 检测结束处理（子类继承）
function ExploreStage:EndCheck()
	ExploreStage.super.EndCheck(self);

	-- 添加空缺方块
	if self:CheckLack() then
		GameLogic:CheckMove();
	end
end

-- 是否可点击处理（子类继承）
function ExploreStage:AbleClick()
	ExploreStage.super.AbleClick(self);

	if StageLogic.mSteps > 0 then
		return true
	end
	return false;
end

-- 检测空缺方块 返回是否有缺少
function ExploreStage:CheckLack()
	-- 是否有缺少
	local lack = false;
	-- 刷新二维数组（移动停止时已经刷新）
	--self:CheckArray();
	local list = {};
	-- 根据方向检测缺少
	if GameLogic.mMoveDir == LogicDefine.Dir.Up then
		for i=1,LogicDefine.Columns do
			local k = 1;
			for j=1,LogicDefine.Rows do
				local temp = GameLogic:GetBlock(j, i);
				-- 遍历到第一个不为空
				if temp then
					break;
				else
					-- 记录缺少
					k = k - 1;
					table.insert(list, {k, i});
				end
			end
		end
	elseif GameLogic.mMoveDir == LogicDefine.Dir.Down then
		for i=1,LogicDefine.Columns do
			local k = LogicDefine.Rows;
			for j=LogicDefine.Rows,1,-1 do
				local temp = GameLogic:GetBlock(j, i);
				if temp then
					break;
				else
					k = k + 1;
					table.insert(list, {k, i});
				end
			end
		end
	elseif GameLogic.mMoveDir == LogicDefine.Dir.Left then
		for i=1,LogicDefine.Rows do
			local k = LogicDefine.Columns;
			for j=LogicDefine.Columns,1,-1 do
				local temp = GameLogic:GetBlock(i, j);
				if temp then
					break;
				else
					k = k + 1;
					table.insert(list, {i, k});
				end
			end
		end
	elseif GameLogic.mMoveDir == LogicDefine.Dir.Right then
		for i=1,LogicDefine.Rows do
			local k = 1;
			for j=1,LogicDefine.Columns do
				local temp = GameLogic:GetBlock(i, j);
				if temp then
					break;
				else
					k = k - 1;
					table.insert(list, {i, k});
				end
			end
		end
	end
	for i=1,#list do
		local row, column = list[i][1], list[i][2];
		local temp = StageLogic:GetIndexBlock(row, column);
		lack = true;
	end
	return lack;
end

return ExploreStage