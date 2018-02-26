
-- 游戏逻辑对象基类
local BlockObject = import("Script.LogicSystem.Object.BlockObject")
local CoinBlock = class("CoinBlock", BlockObject)
function CoinBlock:ctor()
	CoinBlock.super.ctor(self);

end

-- 脚本运行事件
function CoinBlock:Start()
	CoinBlock.super.Start(self);

end

-- 脚本更新事件
function CoinBlock:Update()
	CoinBlock.super.Update(self);

end

-- 脚本更新事件
function CoinBlock:FixedUpdate()
	CoinBlock.super.FixedUpdate(self);

end

-- 重写检测移动
function CoinBlock:CheckMove()
	self.mIsValid = false;
	local tweenPos = self.mRootObject:GetComponent(typeof(TweenPosition));
	if tweenPos==nil then
		tweenPos = self.mRootObject:AddComponent(typeof(TweenPosition));
		tweenPos.to = Vector3.New(3.5, 14, -2);
		tweenPos.delay = 0.1;
		tweenPos.worldSpace = true;
		tweenPos.ignoreTimeScale = false;
		tweenPos.duration = 0.8;
		local function tween_finish()
			-- 设置方块无效
			GameLogic:RecycleBlock(self);
		end
		tweenPos.callBack = tween_finish;
	end
	if tweenPos then
		tweenPos:UpdateTweener();
		tweenPos:PlayForward();
	end
	local tweenScale = self.mRootObject:GetComponent(typeof(TweenScale));
	if tweenScale==nil then
		tweenScale = self.mRootObject:AddComponent(typeof(TweenScale));
		tweenScale.to = Vector3.New(0.5, 0.5, 0.5);
		tweenScale.delay = 0.1;
		tweenScale.ignoreTimeScale = false;
		tweenScale.duration = 0.8;
		local function tween_finish()
			tweenScale:RewindTweener();
		end
		tweenScale.callBack = tween_finish;
	end
	if tweenScale then
		tweenScale:PlayForward();
	end
end

-- 被点击处理 
function CoinBlock:OnClick()
	
end

-- 被消除处理 
function CoinBlock:OnEliminate()
	-- 清除消除标记
	self.mIsSign = false;
end

-- 旁边消除被影响处理 
function CoinBlock:OnAffect()
	
end

-- 脚本复位事件 
function CoinBlock:Reset()
	CoinBlock.super.Reset(self);

end

-- 脚本销毁事件
function CoinBlock:Destroy()
	CoinBlock.super.Destroy(self);

end

return CoinBlock