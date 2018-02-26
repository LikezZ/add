
-- 游戏逻辑对象基类
local BlockObject = import("Script.LogicSystem.Object.BlockObject")
local KeyBlock = class("KeyBlock", BlockObject)
function KeyBlock:ctor()
	KeyBlock.super.ctor(self);

end

-- 脚本运行事件
function KeyBlock:Start()
	KeyBlock.super.Start(self);

end

-- 脚本更新事件
function KeyBlock:Update()
	KeyBlock.super.Update(self);

end

-- 脚本更新事件
function KeyBlock:FixedUpdate()
	KeyBlock.super.FixedUpdate(self);

end

-- 被点击处理 
function KeyBlock:OnClick()
	local item = DataManager.Data.Object:GetDataByKey(self.mSecondaryType);
	if item then
		local temp = GameLogic:FindBlock(item.Param1);
		-- 查找对应的门
		if temp then
			-- 扣减步数
			GameLogic:SubSteps();
			-- 跳转或结算
			StageLogic:DoNextOrDone();
		end
	end
end

-- 被消除处理 
function KeyBlock:OnEliminate()
	-- 可消除 不能被炸等
	if self.mIsSign then
		-- 调用基类
		KeyBlock.super.OnEliminate(self);
	end
end

-- 旁边消除被影响处理 
function KeyBlock:OnAffect()
	
end

-- 脚本复位事件 
function KeyBlock:Reset()
	KeyBlock.super.Reset(self);

end

-- 脚本销毁事件
function KeyBlock:Destroy()
	KeyBlock.super.Destroy(self);

end

return KeyBlock