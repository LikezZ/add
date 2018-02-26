require("Script.EventSystem.EventTyper")

-- 客户端事件通知系统
EventSystem ={}

-- 事件计数器
EventSystem.mEventCounter     = 0;
-- 当前注册事件集合
EventSystem.mEventHandlerList = {};
-- 延迟一帧执行的事件列表
EventSystem.mDelayEventList   = {};

-- 注册事件
function EventSystem:RegisterEventHandler(eventType, eventHandler, owerData)
	if (owerData == nil) then
		owerData = "";
	end

	if EventSystem.mEventHandlerList[eventType] == nil then
		EventSystem.mEventHandlerList[eventType] = {};
	end

	local temp = {handler=eventHandler, data=owerData};
	EventSystem.mEventCounter = EventSystem.mEventCounter+1;
	EventSystem.mEventHandlerList[eventType][EventSystem.mEventCounter] = temp;
end

-- 取消注册
function EventSystem:UnRegisterEventHandler(eventType, eventHandler, owerData)
	if EventSystem.mEventHandlerList[eventType] == nil then
		return;
	end

	for counter, temp in pairs(EventSystem.mEventHandlerList[eventType]) do
		if (owerData == nil) then
			if temp.handler==eventHandler then
				EventSystem.mEventHandlerList[eventType][counter] = nil;
			end
		else
			if temp.handler==eventHandler and temp.data==owerData then
				EventSystem.mEventHandlerList[eventType][counter] = nil;
			end
		end
	end
end

-- 插入事件（立即执行）
function EventSystem:PushEvent(eventType, paramList)
	if EventSystem.mEventHandlerList[eventType] == nil then
		return;
	end

	for counter, temp in pairs(EventSystem.mEventHandlerList[eventType]) do
		temp.handler(eventType, temp.data, paramList);
	end
end

-- 插入事件（下一帧执行）
function EventSystem:PushEvent2(eventType, paramList)
	local temp = {type=eventType, data=paramList};
	EventSystem.mEventCounter = EventSystem.mEventCounter+1;
	EventSystem.mDelayEventList[EventSystem.mEventCounter] = temp;
end

-- 初始化事件响应处理系统
function EventSystem:Init()
	LoggerSystem:Info("Init EventSystem Succeed");
	return true;
end

-- 事件响应处理系统桢更新
function EventSystem:Update(deltaTime)
	for counter, temp in pairs(EventSystem.mDelayEventList) do
		EventSystem:PushEvent(temp.type, temp.data);
	end
	EventSystem.mDelayEventList = {};
end

-- 销毁事件响应处理系统
function EventSystem:Destroy()
	EventSystem.mEventHandlerList = {};
	EventSystem.mDelayEventList   = {};

	LoggerSystem:Info("Destroy EventSystem Succeed");
end
