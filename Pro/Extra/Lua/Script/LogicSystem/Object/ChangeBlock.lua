
-- 游戏逻辑对象基类
local BlockObject = import("Script.LogicSystem.Object.BlockObject")
local ChangeBlock = class("ChangeBlock", BlockObject)
function ChangeBlock:ctor()
	ChangeBlock.super.ctor(self);

end

-- 脚本运行事件
function ChangeBlock:Start()
	ChangeBlock.super.Start(self);

end

-- 脚本更新事件
function ChangeBlock:Update()
	ChangeBlock.super.Update(self);

end

-- 脚本更新事件
function ChangeBlock:FixedUpdate()
	ChangeBlock.super.FixedUpdate(self);

end

-- 被点击处理 
function ChangeBlock:OnClick()
	-- 消除变身
	--self:OnChange();
	-- 扣减步数
	GameLogic:SubSteps();

	GameLogic:CheckEliminate(self);
end

-- 被消除处理 
function ChangeBlock:OnEliminate()
	-- 清除消除标记
	self.mIsSign = false;
	-- 消除变身
	self:OnChange();
end

-- 旁边消除被影响处理 
function ChangeBlock:OnAffect()
	-- 消除变身
	--self:OnChange();
end

-- 生成超级方块 
function ChangeBlock:OnSuper()
	local item = DataManager.Data.Object:GetDataByKey(self.mSecondaryType);
	-- 超级类型是否有效 -1无效
	if item and item.SuperType > -1 then 
		ChangeBlock.super.OnSuper(self);
		-- 设置方块无效
		GameLogic:RecycleBlock(self);
	end
end

-- 脚本复位事件 
function ChangeBlock:Reset()
	ChangeBlock.super.Reset(self);

end

-- 脚本销毁事件
function ChangeBlock:Destroy()
	ChangeBlock.super.Destroy(self);

end

-- 消除变身
function ChangeBlock:OnChange()
	self.mIsValid = false;

	local item = DataManager.Data.Object:GetDataByKey(self.mSecondaryType);
	-- 消除变身
	-- 变身类型是否有效 -1无效
	if item and item.ChangeType > -1 then 
		local temp = GameLogic:CreateBlock(item.ChangeType, self.mRow, self.mColumn, self.mUnderType);
	end

	-- 设置方块无效
	GameLogic:RecycleBlock(self);
end

return ChangeBlock