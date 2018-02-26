
-- 游戏对象类型
ObjectMainType = {
	None = 0,
	Player = 1,
};

-- 次级类型
ObjectSecondaryType = {
	None = 0,
	ItemR = 1,	
};

-- 游戏逻辑对象基类
local IObject = import("Script.LogicSystem.Object.IObject")
local ColliderObject = class("ColliderObject", IObject)
function ColliderObject:ctor()
	ColliderObject.super.ctor(self);

	self.mMainType = ObjectMainType.None;
	self.mSecondaryType = ObjectSecondaryType.None;
end

-- 脚本运行事件
function ColliderObject:Start()
	ColliderObject.super.Start(self);
end

-- 脚本更新事件
function ColliderObject:Update()
	ColliderObject.super.Update(self);

end

-- 脚本销毁事件
function ColliderObject:Destroy()
	ColliderObject.super.Destroy(self);

	self.mMainType = ObjectMainType.None;
	self.mSecondaryType = ObjectSecondaryType.None;
end

function ColliderObject:OnCollisionEnter(collision)
end

function ColliderObject:OnCollisionExit(collision)
end

function ColliderObject:OnCollisionStay(collision)
end

function ColliderObject:OnTriggerEnter(collider)
end

function ColliderObject:OnTriggerExit(collider)
end

function ColliderObject:OnTriggerStay(collider)
end

return ColliderObject