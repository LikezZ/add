-- define ComFindSceneObjActionGetter
-- %Name[通用变量/查找场景NPC对象]%
-- %Describe[通过NPC的Id查找场景对象 -1表示自己]%
-- %Params[[Shared]Name[mObj]Type[IObject]Describe[场景对象 设置在共享中的引用名]]%
-- %Params[Name[mNPCId]Type[Int]Describe[表中NPCId -1表示自己]]%

-- 指令类
local IActionHandler = import("Script.LogicSystem.Action.IActionHandler")
local ComFindSceneObjActionGetter = class("ComFindSceneObjActionGetter", IActionHandler)

function ComFindSceneObjActionGetter:ctor()
	ComFindSceneObjActionGetter.super.ctor(self);

end

-- 开始
function ComFindSceneObjActionGetter:Enter()
	ComFindSceneObjActionGetter.super.Enter(self);

	local npcId = self.mActionInfo and self.mActionInfo.mNPCId;
	local obj = self.mActionInfo and self.mActionInfo.mObj;
	if npcId then
		local temp;
		if npcId == -1 then
			temp = ObjectManager:GetMyselfPlayer();
		else
			temp = ObjectManager:GetNpcByNpcID(npcId);
		end
		if temp then
			self.mManager.mSharedBoard = self.mManager.mSharedBoard or {};
			self.mManager.mSharedBoard[obj] = temp;
		end
	end

	self:SetIsEnd(true);
end

-- 逻辑帧处理操作
function ComFindSceneObjActionGetter:Update()
	ComFindSceneObjActionGetter.super.Update(self);

end

-- 销毁操作
function ComFindSceneObjActionGetter:Leave()
	ComFindSceneObjActionGetter.super.Leave(self);

end

return ComFindSceneObjActionGetter
