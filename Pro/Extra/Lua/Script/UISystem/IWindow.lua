
-- 窗口加载状态
_TYPED_WINDOWSTATE_UNLOAD_       = 1;-- 未加载
_TYPED_WINDOWSTATE_LOADING_      = 2;-- 加载中
_TYPED_WINDOWSTATE_LOADED_       = 3;-- 已加载
_TYPED_WINDOWSTATE_INSTANTIATED_ = 4;-- 已实体化

-- UI窗口虚基类
local TempWindowEventItem = class("_TEMP_WINDOWEVENT_ITEM_")
function TempWindowEventItem:ctor()
	self.mEventId = 0;   -- 窗口事件ID
	self.mParam   = nil; -- 窗口事件参数
end

-- UI窗口虚基类
local ITimer = import("Script.Common.ITimer")
local IWindow = class("IWindow", ITimer)
function IWindow:ctor()
	IWindow.super.ctor(self);

	self.mWindowName                = ""; -- 窗口名称
	self.mWindowPrefabName          = ""; -- 窗口对应prefab资源名称
	self.mIsUnloadWhenDestroy       = false; -- 卸载时是否主动释放AB包
	
	self.mWindowState               = _TYPED_WINDOWSTATE_UNLOAD_; -- 窗口当前状态
	self.mIsWindowShow              = false; -- 窗口是否显示

	self.mWindowObject              = nil; -- 窗口根节点
	self.mWindowPrefabObject        = nil; -- 窗口对应的AB资源包对象

	self.TempWindowEventList        = {}; -- 窗口缓存事件队列
	self.mWindowEventHandlerList    = {}; -- 窗口事件处理注册队列
	self.mWindowDataList            = {}; -- 窗口内部数据
    self.mWindowBehaviour           = nil; -- 窗口LuaWindowBehaviour组件
end

-- 得到当前窗口的名称
function IWindow:GetWindowName()
	return self.mWindowName;
end

-- 设置当前窗口的名称
function IWindow:SetWindowName(name)
	self.mWindowName = name;
end

-- 得到当前窗口对应Prefab的名称
function IWindow:GetPrefabName()
	return self.mWindowPrefabName;
end

-- 设置当前窗口对应Prefab的名称
function IWindow:SetPrefabName(name)
	self.mWindowPrefabName = name;
end

-- 设置销毁时是否自动卸载对应的窗口资源
function IWindow:SetIsUnloadWhenDestroy(unload)
	self.mIsUnloadWhenDestroy = unload;
end

-- 获取窗口加载状态
function IWindow:GetWindowState()
	return self.mWindowState;
end

-- 设置窗口加载状态
function IWindow:SetWindowState(state)
	self.mWindowState = state;
end

-- 设置窗口Prefab资源对象
function IWindow:SetPrefabObject(obj)
	self.mWindowPrefabObject = obj;
end

--返回窗口LuaUIWindowMonoBehaviour组件的引用
function IWindow:GetWindowBehaviour()
    return self.mWindowBehaviour;
end

-- 是否在显示中
function IWindow:IsShow()
	return self.mIsWindowShow;
end

-- 设置窗口指定索引的数据
function IWindow:SetWindowData(key, value)
	self.mWindowDataList[key] = value;
end

-- 得到窗口指定索引的数据
function IWindow:GetWindowData(key)
	return self.mWindowDataList[key];
end

-- 设置窗口显示/隐藏
function IWindow:ShowWindow(show)
	if self.mWindowState ~= _TYPED_WINDOWSTATE_INSTANTIATED_ then
		return;
	end

	if self.mIsWindowShow == show then
		return;
	end

	self.mIsWindowShow = show;
	if show==true then
		self.mWindowObject:SetActive(true);
	else
		self.mWindowObject:SetActive(false);
	end
end

-- 插入临时的窗口缓存事件（当前窗口正在加载中，需等待加载完毕在处理）
function IWindow:AddTempWindowEvent(eventId, param)
	local item = TempWindowEventItem.new();
	item.mEventId = eventId;
	item.mParam = param;
	table.insert(self.TempWindowEventList, item);
end

-- 获取子控件
function IWindow:GetChild(path)
	--return self.mWindowObject.transform:Find(path).gameObject;
	return Helper:FindTransform(self.mWindowObject, path);
end

-- 注册UI绑定事件
function IWindow:RegisterEvent(eventType)
	self:RegisterEvent(eventType, false);
end

-- 注册UI绑定事件
function IWindow:RegisterEvent(eventType, handler, bNotifyOnlyWhenVisible)
	if (eventType==nil) then
		print("Register Event Type Error, WindowName="..self.mWindowName);
	end
	if (handler==nil) then
		print("Register Event Handler Error, WindowName="..self.mWindowName);
	end

	self.mWindowEventHandlerList[eventType] = handler;
	if bNotifyOnlyWhenVisible==true then
		UISystem:RegisterUIEvent(eventType, self.mWindowName);
	else
		-- 为false或者nil都按照false处理
		UISystem:RegisterUIEvent2(eventType, self.mWindowName);
	end
end

-- 分发事件
function IWindow:PushEvent(eventType, params)
	UISystem:PushEvent(eventType, params);
end

-- 消息事件响应处理
function IWindow:OnEventHandler(eventType, paramList)
	local handler = self.mWindowEventHandlerList[eventType];
	if (handler ~= nil) then
		handler(self, paramList);
	end
end

-- 窗口移出屏幕处理（不显示，效率比较高）
function IWindow:Fadeout()
	-- 没有实例化，则不处理
	if self.mWindowState ~= _TYPED_WINDOWSTATE_INSTANTIATED_ then
		return;
	end

	-- 设置到无限远处
	self.mWindowObject.transform.localPosition = Vector3.New(-10000, -10000, -10000);
end

-- 窗口移进屏幕处理（显示，效率比较高）
function IWindow:Fadein()
	-- 没有实例化，则不处理
	if self.mWindowState ~= _TYPED_WINDOWSTATE_INSTANTIATED_ then
		return;
	end

	-- 位置归零
	self.mWindowObject.transform.localPosition = Vector3.zero;
end

-- 初始化处理
function IWindow:Init()
	-- init window property
	print("Init UI Window, WindowName=" .. self.mWindowName);
end

-- 加载处理
function IWindow:Load()
	-- 没有正在加载中或者已经加载，则不处理
	if self.mWindowState ~= _TYPED_WINDOWSTATE_LOADING_ and self.mWindowState ~= _TYPED_WINDOWSTATE_LOADED_ then
		return;
	end

	-- 设置已经加载标志
	self.mWindowState = _TYPED_WINDOWSTATE_LOADED_;

	-- 实例化窗口实体对象
	local parent = UISystem:GetUIRoot();
	if parent then
		self.mWindowObject = UnityEngine.Object.Instantiate(self.mWindowPrefabObject);
		self.mWindowObject.transform:SetParent(parent.transform);
		self.mWindowObject.transform.localPosition = Vector3.zero;
		self.mWindowObject.transform.localScale = Vector3.one;
	else
		print("Load UI Window, WindowName=" .. self.mWindowName..", Failed, Not Found WindowParent");
		return;
	end

	-- 设置已经实例化标志
	self.mWindowState = _TYPED_WINDOWSTATE_INSTANTIATED_;
    if self.mWindowObject ~= nil then
    	self.mWindowObject:AddComponent(typeof(UIResize));
        --self.mWindowBehaviour = self.mWindowObject:GetComponent("LuaWindowBehaviour");
		--if (self.mWindowBehaviour ~= nil) then
		--	self.mWindowBehaviour:SetLuaObject(self);
		--end
    end
	print("Load UI Window, WindowName=" .. self.mWindowName);
end

-- 桢更新处理
function IWindow:Update()
	IWindow.super.Update(self);
end

-- 销毁处理
function IWindow:Destroy(bDestroyAll)
	IWindow.super.ClearAll(self);

	-- 如果没有加载，则不处理
	if self.mWindowState == _TYPED_WINDOWSTATE_UNLOAD_ then
		return;
	end

	if bDestroyAll == true then
		-- 直接退出
		if self.mWindowObject then
			UnityEngine.Object.DestroyImmediate(self.mWindowObject, true);
			self.mWindowObject = nil;
            self.mWindowBehaviour = nil;
		end

		if self.mWindowPrefabObject then
			UnityEngine.Object.DestroyImmediate(self.mWindowPrefabObject, true);
			self.mWindowPrefabObject = nil;
		end
		self.mWindowState = _TYPED_WINDOWSTATE_UNLOAD_;
	else
		-- 直接退出
		if self.mWindowObject then
			UnityEngine.Object.DestroyImmediate(self.mWindowObject, true);
			self.mWindowObject = nil;
            self.mWindowBehaviour = nil;
		end

		if self.mIsUnloadWhenDestroy==true and self.mWindowPrefabObject then
			UnityEngine.Object.DestroyImmediate(self.mWindowPrefabObject, true);
			self.mWindowPrefabObject = nil;
			self.mWindowState = _TYPED_WINDOWSTATE_UNLOAD_;
		else
			self.mWindowState = _TYPED_WINDOWSTATE_LOADED_;
		end
	end

	self.mTempWindowEventList = {};
	self.mIsWindowShow= false;
	print("Destroy UI Window, WindowName=" .. self.mWindowName);
end

function IWindow:OnTempWindowEventHandler()
	for i = 1, #self.TempWindowEventList do
		local value = self.TempWindowEventList[i];
		self:OnEventHandler(value.mEventId, value.mParam);
	end
	self.TempWindowEventList = {};
end

return IWindow
