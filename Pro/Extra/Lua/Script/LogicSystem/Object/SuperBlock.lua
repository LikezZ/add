
-- 游戏逻辑对象基类
local BlockObject = import("Script.LogicSystem.Object.BlockObject")
local SuperBlock = class("SuperBlock", BlockObject)
function SuperBlock:ctor()
	SuperBlock.super.ctor(self);

end

-- 脚本运行事件
function SuperBlock:Start()
	SuperBlock.super.Start(self);

end

-- 脚本更新事件
function SuperBlock:Update()
	SuperBlock.super.Update(self);

end

-- 脚本更新事件
function SuperBlock:FixedUpdate()
	SuperBlock.super.FixedUpdate(self);

end

-- 被点击处理 
function SuperBlock:OnClick()
	-- 消除3X3
	self:OnExplode();
	-- 扣减步数
	GameLogic:SubSteps();
end

-- 被消除处理 
function SuperBlock:OnEliminate()
	-- 清除消除标记
	self.mIsSign = false;
	-- 消除3X3
	self:OnExplode();
	-- 获取步数
	GameLogic:AddCount();
end

-- 旁边消除被影响处理 
function SuperBlock:OnAffect()
	
end

-- 脚本复位事件 
function SuperBlock:Reset()
	SuperBlock.super.Reset(self);

end

-- 脚本销毁事件
function SuperBlock:Destroy()
	SuperBlock.super.Destroy(self);

end

-- 消除3X3的方块（爆炸）
function SuperBlock:OnExplode()
	self.mIsValid = false;

	-- 超级方块 清3x3的方块
	-- 消除代码暂时写在这
	for i=-1,1 do
		for j=-1,1 do
			local temp = GameLogic:GetBlock(self.mRow + i, self.mColumn + j);
			if temp and temp.mIsValid and not temp.mIsSign then
				temp:OnEliminate();
			end
		end
	end

	-- 显示隐藏
	self:OnUnder();
	-- 设置方块无效
	GameLogic:RecycleBlock(self);
end

return SuperBlock