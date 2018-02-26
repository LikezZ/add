
-- 游戏逻辑对象基类
local BlockObject = import("Script.LogicSystem.Object.BlockObject")
local DoorBlock = class("DoorBlock", BlockObject)
function DoorBlock:ctor()
	DoorBlock.super.ctor(self);

end

-- 脚本运行事件
function DoorBlock:Start()
	DoorBlock.super.Start(self);

end

-- 脚本更新事件
function DoorBlock:Update()
	DoorBlock.super.Update(self);

end

-- 脚本更新事件
function DoorBlock:FixedUpdate()
	DoorBlock.super.FixedUpdate(self);

end

-- 被点击处理 
function DoorBlock:OnClick()
	local item = DataManager.Data.Object:GetDataByKey(self.mSecondaryType);
	if item then
		local temp = GameLogic:FindBlock(item.Param1);
		-- 查找对应的钥匙
		if temp then
			-- 扣减步数
			GameLogic:SubSteps();
			-- 跳转或结算
			StageLogic:DoNextOrDone();
		end
	end
end

-- 被消除处理 
function DoorBlock:OnEliminate()
	-- 可消除 不能被炸等
	if self.mIsSign then
		-- 调用基类
		DoorBlock.super.OnEliminate(self);
	end
end

-- 旁边消除被影响处理 
function DoorBlock:OnAffect()
	
end

-- 脚本复位事件 
function DoorBlock:Reset()
	DoorBlock.super.Reset(self);

end

-- 脚本销毁事件
function DoorBlock:Destroy()
	DoorBlock.super.Destroy(self);

end

return DoorBlock