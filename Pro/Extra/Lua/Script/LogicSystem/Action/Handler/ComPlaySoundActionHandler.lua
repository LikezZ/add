-- define ComPlaySoundActionHandler
-- %Name[通用动作/播放指定音乐]%
-- %Describe[设置播放指定Id的音效]%
-- %Params[Name[mSoundId]Type[Int]Describe[音效表soundId]]%

-- 战斗移动指令类
local IActionHandler = import("Script.LogicSystem.Action.IActionHandler")
local ComPlaySoundActionHandler = class("ComPlaySoundActionHandler", IActionHandler)

function ComPlaySoundActionHandler:ctor()
	ComPlaySoundActionHandler.super.ctor(self);

end

-- 开始
function ComPlaySoundActionHandler:Enter()
	ComPlaySoundActionHandler.super.Enter(self);

	local param = self.mActionInfo and self.mActionInfo.mSoundId;
	if param then SoundSystem:PlaySound(param); end
	self:SetIsEnd(true);
end

-- 逻辑帧处理操作
function ComPlaySoundActionHandler:Update()
	ComPlaySoundActionHandler.super.Update(self);

end

-- 销毁操作
function ComPlaySoundActionHandler:Leave()
	ComPlaySoundActionHandler.super.Leave(self);

end

return ComPlaySoundActionHandler
