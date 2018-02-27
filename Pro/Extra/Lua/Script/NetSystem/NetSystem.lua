-- define net system
require("Script.NetSystem.PacketDefine")
require("Script.NetSystem.PacketFactoryManager")
require("Script.pb.protobuf")

-- 客户端网络系统管理器
NetSystem = {}

-- 是否暂定消息包处理
NetSystem.mIsPausePacketHandle = false;
-- 切换场景时，收到的缓存消息包队列
-- 等切换完场景在进行处理（兼容天龙服务器的模式）
NetSystem.mRecvPacketList = {};

-- 下载HTTP URL
function NetSystem:DownLoadTXT(url, callback)
	Lua_NetSystem.GetInstance():DownLoadTXT(url, callback);
end

-- 下载HTTP URL
function NetSystem:DownLoadExcel(url, callback)
	Lua_NetSystem.GetInstance():DownLoadExcel(url, callback);
end

-- 连接游戏服务器
function NetSystem:ConnectServerByIP(serverIP, serverPort)
	Lua_NetSystem.GetInstance():ConnectToServer(serverIP, serverPort);
end

-- 断开连接
function NetSystem:DisConnect()
	Lua_NetSystem.GetInstance():Disconnect();
end

-- 暂停处理
function NetSystem:Pause(bPause)
	NetSystem.mIsPausePacketHandle = bPause;
	if (not NetSystem.mIsPausePacketHandle) then
		local bAll = true;
		for i = 1, #NetSystem.mRecvPacketList do
			local temp = NetSystem.mRecvPacketList[i];
			if (temp.fac ~= nil) then
				LoggerSystem:Debug("NetSystem: Recv Msg="..temp.desc);
				temp.fac:OnPacketHandler(temp.pak);
				temp.fac = nil;
				temp.pak = nil;
				temp.desc = nil;
				if (NetSystem.mIsPausePacketHandle) then
					bAll = false;
					break;
				end
			end
		end

		if (bAll) then
			NetSystem.mRecvPacketList = {};
		end
	end
end

-- 初始化网络系统管理器
function NetSystem:Init()
	-- 初始化网络消息包管理器
	PacketFactoryManager:Init();

	-- 注册PB文件
	local ret = EngineSystem:ReadFile("Lua/Script/pb/PBMessage.bytes");
	if (not ret) then
		LoggerSystem:Error("NetSystem:	Init NetSystem Failed, Read .PB File Failed");
		return false;
	end
	protobuf.register_buffer(LuaCacheBuffer.data, LuaCacheBuffer.dataLen);
	LuaCacheBuffer.Clear();

	LoggerSystem:Info("NetSystem:	Init NetSystem Succeed");
	return true;
end

-- 网络系统逻辑桢更新
function NetSystem:Update(deltaTime)
end

-- 销毁网络系统管理器
function NetSystem:Destroy()
	PacketFactoryManager:Destroy();
	for i = 1, #NetSystem.mRecvPacketList do
		local temp = NetSystem.mRecvPacketList[i];
		temp.fac = nil;
		temp.pak = nil;
		temp.desc = nil;
	end
	NetSystem.mRecvPacketList = {};
	LoggerSystem:Info("NetSystem:	Destroy NetSystem Succeed");
end

-- 消息包处理流程
function NetSystem:OnPacketHandler(packetType, length, buffer)
	local packetDesc = PacketDescDefine[packetType];
	if (packetDesc == nil) then
		LoggerSystem:Info("NetSystem:	UnRegister Packet, packetType="..packetType);
		return;
	end

	local packet = nil;
	if length~=0 then
		packet = protobuf.decode(packetDesc, buffer, length);
		if (packet==nil or packet==false) then
			LoggerSystem:Info("NetSystem:	Decode Packet Failed, packetType="..packetType..", len="..length);
			return;
		end
	end

	local packetFactory = PacketFactoryManager:GetFactoryByPacketId(packetType);
	if (packetFactory == nil) then
		LoggerSystem:Info("NetSystem:	UnRegister Packet Handler, packetType="..packetType);
		return;
	end

	if (NetSystem.mIsPausePacketHandle) then
		LoggerSystem:Debug("NetSystem: Recv Msg, Pause Handler, msgType="..packetDesc);
		local temp = {
			fac=packetFactory,
			pak=packet;
			desc = packetDesc,
		};
		table.insert(NetSystem.mRecvPacketList, temp);
	else
		-- HEARTBEAT消息太频繁，所以不打印
		if (packetType ~= PacketIdDefine.GC_CONNECTED_HEARTBEATPacketId and packetType ~= PacketIdDefine.GC_MOVEPacketId) then
			LoggerSystem:Debug("NetSystem: Recv Msg="..packetDesc);
		end
		packetFactory:OnPacketHandler(packet);
	end
end

-- 套接字建立连接失败事件处理
function NetSystem:OnSocketConnectFailedEventHandler()
	-- 判断是否为了登陆而建立的网络连接事件
	local bLogin = VariableSystem:GetBoolean(VariableSystem._TYPED_CONFIG_MEM_, "Net", "IsConnectForLogin", true);
	if (bLogin) then
		VariableSystem:SetBoolean(VariableSystem._TYPED_CONFIG_MEM_, "Net", "IsConnectForLogin", false);

		-- 交给登陆流程来处理登陆时的连接失败事件
		LoginProcedure:OnLoginSocketConnectFailed();
		return;
	end
end

-- 套接字建立连接成功事件处理
function NetSystem:OnSocketConnectSucceedEventHandler()
	-- 判断是否为了登陆而建立的网络连接事件
	local bLogin = VariableSystem:GetBoolean(VariableSystem._TYPED_CONFIG_MEM_, "Net", "IsConnectForLogin", true);
	if (bLogin) then
		VariableSystem:SetBoolean(VariableSystem._TYPED_CONFIG_MEM_, "Net", "IsConnectForLogin", false);

		-- 交给登陆流程来处理登陆时的连接成功事件
		LoginProcedure:OnLoginSocketConnectSucceed();
		return;
	end
end

-- 套接字异常事件处理
function NetSystem:OnSocketExceptionEventHandler()
	-- 缓冲的消息清空
	for i = 1, #NetSystem.mRecvPacketList do
		local temp = NetSystem.mRecvPacketList[i];
		temp.fac = nil;
		temp.pak = nil;
		temp.desc = nil;
	end
	NetSystem.mRecvPacketList = {};

	local function DisConnectCallBack()
		EngineSystem:ChangeScene("Login");
	end
	local param ={
		title = SysLangDataManager:GetSysLangById(27);
		okname = nil;
		okcallback = DisConnectCallBack;
	};
	EventSystem:PushEvent(SysEvent._TYPED_EVENT_ALERTWINDOW_SHOW_, param);
	-- 通知目前的流程处理
	if (App.mActiveProcedure ~= nil) then
		App.mActiveProcedure:OnNetNonConnectedEventHandler();
	end
end
