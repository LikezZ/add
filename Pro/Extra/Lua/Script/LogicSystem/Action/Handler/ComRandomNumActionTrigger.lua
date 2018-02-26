-- define ComRandomNumActionTrigger
-- %Name[触发器/随机数生成触发]%
-- %Describe[指定数字生成随机数触发事件random:+id:+随机数]%
-- %Params[Name[mTheNum]Type[Int]Describe[设置数字]]%

-- 战斗移动指令类
local IActionHandler = import("Script.LogicSystem.Action.IActionHandler")
local ComRandomNumActionTrigger = class("ComRandomNumActionTrigger", IActionHandler)

function ComRandomNumActionTrigger:ctor()
	ComRandomNumActionTrigger.super.ctor(self);

end

-- 开始
function ComRandomNumActionTrigger:Enter()
	ComRandomNumActionTrigger.super.Enter(self);

	-- 数字
	local num = self.mActionInfo and self.mActionInfo.mTheNum;
	num = math.random(num);

	self.mManager:OnActionEvent("random:"..self.mId..":"..num); 
	self:SetIsEnd(true);
end

-- 逻辑帧处理操作
function ComRandomNumActionTrigger:Update()
	ComRandomNumActionTrigger.super.Update(self);

end

-- 销毁操作
function ComRandomNumActionTrigger:Leave()
	ComRandomNumActionTrigger.super.Leave(self);

end

return ComRandomNumActionTrigger
