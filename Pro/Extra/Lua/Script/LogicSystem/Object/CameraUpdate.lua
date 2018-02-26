
-- 所有逻辑对象基类
local IObject = import("Script.LogicSystem.Object.IObject")
local CameraUpdate = class("CameraUpdate", IObject)
function CameraUpdate:ctor()
	CameraUpdate.super.ctor(self);

	self.mFollowObj = nil;
	self.mXMinOffset = -3;
	self.mXMaxOffset = 3;
	self.mYMinOffset = -5;
	self.mYMaxOffset = -1;
end

-- 脚本运行事件
function CameraUpdate:Start()
	CameraUpdate.super.Start(self);
	
end

-- 脚本更新事件
function CameraUpdate:Update()
	CameraUpdate.super.Update(self);

	if self.mFollowObj and not self.mFollowObj.mIsFalling then
		local pos = self.mRootObject.transform.position:Clone();
		local fol = self.mFollowObj.mRootObject.transform.position;
		local x = fol.x - pos.x;
		local y = fol.y - pos.y;
		if x < self.mXMinOffset then
			pos.x = fol.x - self.mXMinOffset; 
		elseif x > self.mXMaxOffset then
			pos.x = fol.x - self.mXMaxOffset;
		end
		if y < self.mYMinOffset then
			pos.y = fol.y - self.mYMinOffset;
		elseif y > self.mYMaxOffset then
			pos.y = fol.y - self.mYMaxOffset;
		end
		pos = Vector3.Lerp(self.mRootObject.transform.position, pos, 1.0);
		self.mRootObject.transform.position = pos;
	end
end

-- 脚本销毁事件
function CameraUpdate:Destroy()
	CameraUpdate.super.Destroy(self);

	self.mFollowObj = nil;
end

return CameraUpdate