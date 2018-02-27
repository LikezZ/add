
-- 主角逻辑对象基类
local ColliderObject = import("Script.LogicSystem.Object.ColliderObject")
local PlayerObject = class("PlayerObject", ColliderObject)
function PlayerObject:ctor()
	PlayerObject.super.ctor(self);

	self.mMainType = ObjectMainType.Player;
	self.mSecondaryType = ObjectSecondaryType.None;

	self.mEventFunc = nil;  -- 事件函数
	self.mRigidbody = nil;  -- 刚体
	self.mContact = 0;      -- 接触计数
	self.mJumpCount = 0;    -- 跳跃计数 二段
end

-- 脚本运行事件
function PlayerObject:Start()
	PlayerObject.super.Start(self);

	self.mEventFunc = function (eventType, owerData, paramList)
    	self:OnTapEvent(paramList)
	end
	EventSystem:RegisterEventHandler(SysEvent._TYPED_EVENT_LOGIC_TAPROLE_, self.mEventFunc);
	self.mRigidbody = self.mRootObject:GetComponent("Rigidbody");
end

-- 脚本更新事件
function PlayerObject:Update()
	PlayerObject.super.Update(self);

end

-- 脚本更新事件
function PlayerObject:FixedUpdate()
	PlayerObject.super.FixedUpdate(self);
	--print("ggggg"..self.mRigidbody.position.x)
	-- 判断速度
	local v = self.mRigidbody.velocity;
	if v.y > 1 and v.y < 3.6 then
		self.mRigidbody.velocity = Vector3.New(v.x, -1, 0);
	end
end

-- 脚本销毁事件
function PlayerObject:Destroy()
	PlayerObject.super.Destroy(self);

	EventSystem:UnRegisterEventHandler(SysEvent._TYPED_EVENT_LOGIC_TAPROLE_, self.mEventFunc);
	self.mEventFunc = nil;
	self.mRigidbody = nil;
	self.mContact = 0;
	self.mJumpCount = 0;
end

function PlayerObject:OnCollisionEnter(collision)
	PlayerObject.super.OnCollisionEnter(self, collision);

	self.mJumpCount = 0;
	self.mContact = self.mContact + 1;
end

function PlayerObject:OnCollisionExit(collision)
	PlayerObject.super.OnCollisionExit(self, collision);

	self.mContact = self.mContact - 1;
end

function PlayerObject:OnCollisionStay(collision)
	PlayerObject.super.OnCollisionStay(self, collision);
end

function PlayerObject:OnTriggerEnter(collider)
	PlayerObject.super.OnTriggerEnter(self, collider);
end

function PlayerObject:OnTriggerExit(collider)
	PlayerObject.super.OnTriggerExit(self, collider);
end

function PlayerObject:OnTriggerStay(collider)
	PlayerObject.super.OnTriggerStay(self, collider);
end

-- 脚本事件处理
function PlayerObject:OnTapEvent(param)
	if self.mContact > 0 then
		self.mJumpCount = 1;
	elseif self.mJumpCount < 2 then
		self.mJumpCount = self.mJumpCount + 1;
	else 
		--return;
	end
	-- 设置速度
	--self.mRigidbody.velocity = Vector3.New(param * 3.6, 6, 0);
	self.mRigidbody.velocity = Vector3.New(0, 0, 0);
	--self.mRigidbody:AddForce(Vector3.New(180 * param, 300, 0));
	self.mRigidbody:AddForce(Vector3.New(220 * param, 400, 0));
end

return PlayerObject