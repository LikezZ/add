-- define ComFindTransformActionGetter
-- %Name[通用变量/查找获取节点对象]%
-- %Describe[通过全路径查找获取场景Transform对象]%
-- %Params[[Shared]Name[mTrans]Type[Transform]Describe[场景对象 设置在共享中的引用名]]%
-- %Params[Name[mPath]Type[String]Describe[查找节点的全路径]]%

-- 战斗移动指令类
local IActionHandler = import("Script.LogicSystem.Action.IActionHandler")
local ComFindTransformActionGetter = class("ComFindTransformActionGetter", IActionHandler)

function ComFindTransformActionGetter:ctor()
	ComFindTransformActionGetter.super.ctor(self);

end

-- 开始
function ComFindTransformActionGetter:Enter()
	ComFindTransformActionGetter.super.Enter(self);

	local path = self.mActionInfo and self.mActionInfo.mPath;
	local trans = self.mActionInfo and self.mActionInfo.mTrans;
	if path then
		-- 因为GameObject.Find只能查找活动的对象，所以假设目标对象可能不活动
		-- 所以使用GameObject.Find查找父节点，然后transform.Find查找子节点
		local temp;
		local s, e = string.find(path, "/", -1);
		if s and e then
			local s1 = string.sub(1, s-1);
			local s2 = string.sub(e+1);
			temp = GameObject.Find(s1);
			temp = Helper:FindTransform(temp, s2);
		else
			temp = GameObject.Find(path).transform;	
		end
		if temp then
			self.mManager.mSharedBoard = self.mManager.mSharedBoard or {};
			self.mManager.mSharedBoard[trans] = temp;
		end
	end

	self:SetIsEnd(true);
end

-- 逻辑帧处理操作
function ComFindTransformActionGetter:Update()
	ComFindTransformActionGetter.super.Update(self);

end

-- 销毁操作
function ComFindTransformActionGetter:Leave()
	ComFindTransformActionGetter.super.Leave(self);

end

return ComFindTransformActionGetter
