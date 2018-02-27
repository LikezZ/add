-- define ComPlayEffectActionHandler
-- %Name[通用动作/执行播放特效]%
-- %Describe[在指定节点下播放指定id的特效]%
-- %Params[[Shared]Name[mTarget]Type[Transform]Describe[父节点 在共享中的引用名]]%
-- %Params[Name[mEffectId]Type[Int]Describe[指定特效Id]]%

-- 战斗移动指令类
local IActionHandler = import("Script.LogicSystem.Action.IActionHandler")
local ComPlayEffectActionHandler = class("ComPlayEffectActionHandler", IActionHandler)

function ComPlayEffectActionHandler:ctor()
	ComPlayEffectActionHandler.super.ctor(self);

end

-- 开始
function ComPlayEffectActionHandler:Enter()
	ComPlayEffectActionHandler.super.Enter(self);

	local param = self.mActionInfo and self.mActionInfo.mTarget;
	local trans = self.mManager.mSharedBoard[param];
	-- 特效id
	param = self.mActionInfo and self.mActionInfo.mEffectId;
	if param and param > 0 then
		SceneManager:PlayEffectCommon(param, trans);
	end
	self:SetIsEnd(true);
end

-- 逻辑帧处理操作
function ComPlayEffectActionHandler:Update()
	ComPlayEffectActionHandler.super.Update(self);

end

-- 销毁操作
function ComPlayEffectActionHandler:Leave()
	ComPlayEffectActionHandler.super.Leave(self);

end

return ComPlayEffectActionHandler
