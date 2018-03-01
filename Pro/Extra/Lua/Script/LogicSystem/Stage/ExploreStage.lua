
-- 关卡逻辑基类
local IStage = import("Script.LogicSystem.Stage.IStage")
local ExploreStage = class("ExploreStage", IStage)
function ExploreStage:ctor()
	ExploreStage.super.ctor(self);

	self.mMaxRow = 0;    -- 记录最大行数
end

-- 脚本挂载事件
function ExploreStage:Awake()
	ExploreStage.super.Awake(self);

	self.mMaxRow = LogicDefine.Rows;
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
	self:CheckLack();
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
	-- 检测是否缺少行数
	local function check_row(row)
		for i=1,LogicDefine.Columns do
			local temp = GameLogic:GetBlock(row, i);
			if temp then return false; end
		end
		return true;
	end
	local row = self.mMaxRow;
	for i=self.mMaxRow,self.mMaxRow-LogicDefine.Rows,-1 do
		if not check_row(i) then
			row = i;
			break;
		end
	end
	if row < self.mMaxRow then
		lack = true;
		local num = self.mMaxRow - row;
		-- 设置阻挡位移
		local pos = Helper:GetLocalPosition(GameLogic.mObst[LogicDefine.Dir.Up]);
		pos.y = pos.y - num;
		Helper:SetLocalPosition(GameLogic.mObst[LogicDefine.Dir.Up], pos);
		local camera = UnityEngine.GameObject.FindWithTag("MainCamera");
		pos = Helper:GetLocalPosition(camera);
		pos.y = pos.y - num;
		Helper:SetLocalPosition(camera, pos);
		for i=1,num do
			for j=1,LogicDefine.Columns do
				table.insert(list, {self.mMaxRow-LogicDefine.Rows-i+1, j});		
			end
		end
		
		self.mMaxRow = row;
	end
	for i=1,#list do
		local row, column = list[i][1], list[i][2];
		local temp = StageLogic:GetIndexBlock(row, column);
	end
	return lack;
end

return ExploreStage