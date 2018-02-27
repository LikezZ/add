-- define ComSendPacketActionHandler
-- %Name[通用动作/发送服务器消息]%
-- %Describe[向服务器发送指定消息]%
-- %Params[Name[mName]Type[String]Describe[发送的消息名]]%
-- %Params[Name[mParam]Type[Custom]Describe[发送的消息参数]]%

-- 战斗移动指令类
local IActionHandler = import("Script.LogicSystem.Action.IActionHandler")
local ComSendPacketActionHandler = class("ComSendPacketActionHandler", IActionHandler)

function ComSendPacketActionHandler:ctor()
	ComSendPacketActionHandler.super.ctor(self);

end

-- 开始
function ComSendPacketActionHandler:Enter()
	ComSendPacketActionHandler.super.Enter(self);

	local name = self.mActionInfo and self.mActionInfo.mName;
	local param = self.mActionInfo and self.mActionInfo.mParam;
	-- 发送信息
	local packet = import("Script.NetSystem.Packet."..name).new();
	-- 特殊处理下因为需要获取变量
	-- 进入战斗
	if "CG_REQ_CHALLENGEPacket" == name then
		packet.mPack = {objID = self.mManager.mSharedBoard[param]:GetObjectServerId()};
	else
		packet.mPack = param;
	end
	packet:SendPacket();
	
	self:SetIsEnd(true);
end

-- 逻辑帧处理操作
function ComSendPacketActionHandler:Update()
	ComSendPacketActionHandler.super.Update(self);

end

-- 销毁操作
function ComSendPacketActionHandler:Leave()
	ComSendPacketActionHandler.super.Leave(self);

end

return ComSendPacketActionHandler
