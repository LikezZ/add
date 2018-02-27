
-- 游戏逻辑对象基类
local IObject = import("Script.LogicSystem.Object.IObject")
local BlockObject = class("BlockObject", IObject)
function BlockObject:ctor()
	BlockObject.super.ctor(self);

	self.mUnderType = -1;                     -- 隐藏类型
	self.mRow = 0;                            -- 所在行
	self.mColumn = 0;                         -- 所在列

	self.mCollider = nil;                     -- 碰撞器
	self.mMoveDir = LogicDefine.Dir.Down;     -- 运动逻辑方向
	self.mVec3Dir = Vector3.down;             -- vec3运动方向
	self.mVelocity = nil;                     -- 移动速度
	self.mIsCheck = false;                    -- 是否检测移动
	self.mIsMove = false;                     -- 是否移动
	self.mMoveFrame = 0;                      -- 移动检测帧数记录

	self.mIsSign = false;                     -- 是否被标记消除
end

-- 脚本运行事件
function BlockObject:Start()
	BlockObject.super.Start(self);

	self.mCollider = self.mRootObject:GetComponent("SphereCollider");
end

-- 脚本更新事件
function BlockObject:Update()
	BlockObject.super.Update(self);

end

-- 脚本更新事件
function BlockObject:FixedUpdate()
	BlockObject.super.FixedUpdate(self);

	if not self.mIsValid then return; end
	if self.mIsCheck then
		local pos = Helper:GetPosition(self.mRootObject);
		local dis = UnityEngine.Time.fixedDeltaTime * LogicDefine.Velocity;
		local is, hit = UnityEngine.Physics.SphereCast(pos, 0.49, self.mVec3Dir, nil, dis);
		if is then
			self.mIsMove = false;
		elseif not self.mIsMove then
			self.mIsMove = true;
			self.mMoveFrame = 0;
		end
		if self.mIsMove then
			local move = self.mVelocity:Clone():Mul(UnityEngine.Time.fixedDeltaTime);
			Helper:SetPosition(self.mRootObject, move:Add(pos));
		else
			self.mMoveFrame = self.mMoveFrame + 1;
			if self.mMoveFrame > LogicDefine.MoveFrame then
				self.mIsMove = false;
				self.mIsCheck = false;
				self.mMoveFrame = 0;
				self:CheckPos();
			end
		end
	end
end

-- 检测移动
function BlockObject:CheckMove()
	self.mIsCheck = true;
	self.mVelocity = self.mVec3Dir:Clone():Mul(LogicDefine.Velocity);
end

-- 检测位置 转换行列数
-- 默认左下角开始行列数(1,1)
-- 默认左下角开始坐标(0,0)(local坐标)
function BlockObject:CheckPos()
	local pos = Helper:GetLocalPosition(self.mRootObject);
	-- 向下取整
	local minX, minY = math.floor(pos.x), math.floor(pos.y);  
	-- 向上取整
	local maxX, maxY = math.ceil(pos.x), math.ceil(pos.y);
	-- 获取最接近的实际值
	local theX, theY = 0, 0;
	if maxX - pos.x > pos.x - minX then
		theX = minX;
	else
		theX = maxX;
	end
	if maxY - pos.y > pos.y - minY then
		theY = minY;
	else
		theY = maxY;
	end
	pos.x = theX;
	pos.y = theY;
	Helper:SetLocalPosition(self.mRootObject, pos);
	-- 换算行列数
	self.mRow = theY + 1;
	self.mColumn = theX + 1; 
end

-- 是否在移动
function BlockObject:IsMove()
	if not self.mIsCheck and not self.mIsMove then
		return false;
	end
	return true;
end

-- 设置移动方向
function BlockObject:SetDir(dir)
	self.mMoveDir = dir;
	if dir == LogicDefine.Dir.Down then
		self.mVec3Dir = Vector3.down;
	elseif dir == LogicDefine.Dir.Up then
		self.mVec3Dir = Vector3.up;
	elseif dir == LogicDefine.Dir.Left then
		self.mVec3Dir = Vector3.left;
	elseif dir == LogicDefine.Dir.Right then
		self.mVec3Dir = Vector3.right;
	end
end

-- 被点击处理 （子类继承）
function BlockObject:OnClick()
	-- 显示隐藏
	--self:OnUnder();
	-- 设置方块无效
	--GameLogic:RecycleBlock(self);
	-- 扣减步数
	--GameLogic:SubSteps();

	GameLogic:CheckEliminate(self);
end

-- 被消除处理 （子类继承）
function BlockObject:OnEliminate()
	self.mIsValid = false;
	
	-- 如果被标记消除并且可消除 四方向邻近影响
	if self.mIsSign then
		local temp = GameLogic:GetBlock(self.mRow, self.mColumn + 1);
		if temp and temp.mIsValid and not temp.mIsSign then
			temp:OnAffect();
		end
		temp = GameLogic:GetBlock(self.mRow, self.mColumn - 1);
		if temp and temp.mIsValid and not temp.mIsSign then
			temp:OnAffect();
		end
		temp = GameLogic:GetBlock(self.mRow + 1, self.mColumn);
		if temp and temp.mIsValid and not temp.mIsSign then
			temp:OnAffect();
		end
		temp = GameLogic:GetBlock(self.mRow - 1, self.mColumn);
		if temp and temp.mIsValid and not temp.mIsSign then
			temp:OnAffect();
		end
	end

	-- 显示隐藏
	self:OnUnder();
	-- 设置方块无效
	GameLogic:RecycleBlock(self);
	-- 获取步数
	GameLogic:AddCount();
end

-- 旁边消除被影响处理 （子类继承）
function BlockObject:OnAffect()
	
end

-- 生成超级方块 （子类继承）
function BlockObject:OnSuper()
	local item = DataManager.Data.Object:GetDataByKey(self.mSecondaryType);
	-- 超级类型是否有效 -1无效
	if item and item.SuperType > -1 then 
		local temp = GameLogic:CreateBlock(item.SuperType, self.mRow, self.mColumn, self.mUnderType);	
		self.mUnderType = -1; 
	end
end

-- 显示隐藏 （子类继承）
function BlockObject:OnUnder()
	-- 隐藏类型是否有效 -1无效
	if self.mUnderType > -1 then 
		local temp = GameLogic:CreateBlock(self.mUnderType, self.mRow, self.mColumn, -1);	
	end
end

-- 脚本复位事件 （子类继承）
function BlockObject:Reset()
	-- 清除定时器
	BlockObject.super.ClearAll(self);

	-- 参数重新初始化
	self.mUnderType = -1; 
	self.mRow = 0; 
	self.mColumn = 0;
	self.mMoveDir = LogicDefine.Dir.Down;
	self.mVec3Dir = Vector3.down; 
	self.mVelocity = nil; 
	self.mIsCheck = false;
	self.mIsMove = false; 
	self.mMoveFrame = 0;
	self.mIsSign = false;
end

-- 脚本销毁事件
function BlockObject:Destroy()
	BlockObject.super.Destroy(self);

	self.mUnderType = -1; 
	self.mRow = 0; 
	self.mColumn = 0;
	self.mCollider = nil;
	self.mMoveDir = LogicDefine.Dir.Down;
	self.mVec3Dir = Vector3.down; 
	self.mVelocity = nil; 
	self.mIsCheck = false;
	self.mIsMove = false; 
	self.mMoveFrame = 0;
	self.mIsSign = false;
end

return BlockObject