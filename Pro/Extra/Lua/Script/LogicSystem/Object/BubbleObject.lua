
-- 逻辑对象基类
local BaseObject = import("Script.LogicSystem.Object.BaseObject")
local BubbleObject = class("BubbleObject", BaseObject)
function BubbleObject:ctor()
	BubbleObject.super.ctor(self);

	self.mMainType = ObjectMainType.Bubble;
	self.mSecondaryType = ObjectSecondaryType.None;

	self.mRow = 0;         -- 所在行
	self.mColumn = 0;      -- 所在列
	self.mStop = false;    -- 标记碰撞
end

-- 脚本运行事件
function BubbleObject:Start()
	BubbleObject.super.Start(self);
end

-- 脚本更新事件
function BubbleObject:Update()
	BubbleObject.super.Update(self);

end

-- 脚本销毁事件
function BubbleObject:Destroy()
	BubbleObject.super.Destroy(self);

	self.mRow = 0;       
	self.mColumn = 0; 
	self.mStop = false;
end

-- 脚本主动碰撞回调
function BubbleObject:RaycastHitFunc(hitObject)
	BubbleObject.super.RaycastHitFunc(self, hitObject);

	self.mStop = true;
end

-- 脚本被动碰撞回调
function BubbleObject:CollisionFunc(hitObject)
	BubbleObject.super.CollisionFunc(self, hitObject);
	return true;
end

-- 移动 dir 
function BubbleObject:Move(dir)
	local can, vec, row, column = self:CanMove(dir);
	if can then
		local pos = self.mRootObject.transform.localPosition:Clone();
		self.mRootObject.transform.localPosition = pos:Add(vec);
		self.mRow = row;
		self.mColumn = column;
	end
end

-- 是否可移动 dir 
function BubbleObject:CanMove(dir)
	self.mStop = false;
	local row, column = self.mRow, self.mColumn;
	local vec3 = Vector3.New(0, 0, 0);
	if LogicDefine.Dir.Up == dir then
		vec3.y = LogicDefine.Cell;
		row = self.mRow + 1;
	elseif LogicDefine.Dir.Left == dir then
		vec3.x = - LogicDefine.Cell;
		column = self.mColumn - 1;
	elseif LogicDefine.Dir.Right == dir then
		vec3.x = LogicDefine.Cell;
		column = self.mColumn + 1;
	else
		self.mStop = true;
		return false;
	end

	-- 判断是否出界
	if row < 1 or row > LogicDefine.Rows or column < 1 or column > LogicDefine.Columns then
		self.mStop = true;
		return false;
	end

	-- 碰撞检测
	local move = vec3:Clone();
	move = EngineSystem:CheckCollision(self.mRootObject.transform, 1, move);
	if not self.mStop then
		return true, vec3, row, column;
	else
		return false;
	end
end

return BubbleObject