-- define ComShowTalkActionHandler
-- %Name[通用动作/显示对话气泡]%
-- %Describe[显示或者隐藏对话的气泡]%
-- %Params[[Shared]Name[mActor]Type[IObject]Describe[说话的对象 在共享中的引用名]]%
-- %Params[Name[mShow]Type[Int]Describe[是否显示 1显示0隐藏]]%
-- %Params[Name[mSyslangId]Type[Int]Describe[文本Id Syslang表里]]%
-- %Params[Name[mDuration]Type[Float]Describe[持续时间后自动隐藏 0不隐藏]]%

-- 战斗移动指令类
local IActionHandler = import("Script.LogicSystem.Action.IActionHandler")
local ComShowTalkActionHandler = class("ComShowTalkActionHandler", IActionHandler)

function ComShowTalkActionHandler:ctor()
	ComShowTalkActionHandler.super.ctor(self);

end

-- 开始
function ComShowTalkActionHandler:Enter()
	ComShowTalkActionHandler.super.Enter(self);

	local name = self.mActionInfo and self.mActionInfo.mActor;
	local show = self.mActionInfo and self.mActionInfo.mShow;
	local id = self.mActionInfo and self.mActionInfo.mSyslangId;
	local dur = self.mActionInfo and self.mActionInfo.mDuration;
	local actor = self.mManager.mSharedBoard[name];
	if not actor then 
		self:SetIsEnd(true);
		return;
	end 
	if show == 1 then
		actor:ShowTalk(true, id);
		local function OnTimer()
			actor:ShowTalk(false, id);
			self:SetIsEnd(true);
		end
		if dur > 0 then
			self:RegisterTimer(false, dur, OnTimer);
		end
	else
		actor:ShowTalk(false, id);
		self:SetIsEnd(true);
	end
end

-- 逻辑帧处理操作
function ComShowTalkActionHandler:Update()
	ComShowTalkActionHandler.super.Update(self);

end

-- 销毁操作
function ComShowTalkActionHandler:Leave()
	ComShowTalkActionHandler.super.Leave(self);

end

return ComShowTalkActionHandler
