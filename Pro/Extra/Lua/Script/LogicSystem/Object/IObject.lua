
-- 所有逻辑对象基类
local ITimer = import("Script.Common.ITimer")
local IObject = class("IObject", ITimer)
function IObject:ctor()
	IObject.super.ctor(self);

	self.mUniqueId = 0;         -- 唯一id标识
	self.mMainType = -1;        -- 对象主类型
	self.mSecondaryType = -1;   -- 第二类型
	self.mIsValid = false;      -- 是否是有效的

	self.mMonoBehaviour = nil;  -- 对应的LuaMonoBehaviour对象
	self.mRootObject = nil;     -- 对应的Gameobject对象
end

-- 得到对象对应的MonoBehaviour粘合剂对象
function IObject:GetBehaviour()
	return self.mMonoBehaviour;
end

-- 设置对象对应的MonoBehaviour粘合剂对象
function IObject:SetBehaviour(behaviour)
	self.mMonoBehaviour = behaviour;
end

-- 推送Event事件
function IObject:PushEvent(eventType, paramList)
	EventSystem:PushEvent(eventType, paramList)
end

-- 逻辑指令处理操作
function IObject:PushCommand(commandId, param)
	
end

-- 脚本挂载事件
function IObject:Awake(gameObject)
	IObject.super.Awake(self);
	self.mRootObject = gameObject;
end

-- 脚本运行事件
function IObject:Start()
	IObject.super.Start(self);
end

-- 脚本更新事件
function IObject:Update()
	IObject.super.Update(self);

end

-- 脚本更新事件
function IObject:FixedUpdate()
	
end

-- 脚本销毁事件
function IObject:Destroy()
	IObject.super.Destroy(self);

	self.mUniqueId = 0;
	self.mMainType = -1;
	self.mSecondaryType = -1;
	self.mIsValid = false;

	self.mMonoBehaviour = nil;
	self.mRootObject = nil;
end

-- 获取子控件
function IObject:GetChild(path)
	return Helper:FindTransform(self.mRootObject, path);
end

return IObject