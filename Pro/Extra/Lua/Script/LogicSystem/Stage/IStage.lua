
-- 关卡逻辑基类
local ITimer = import("Script.Common.ITimer")
local IStage = class("IStage", ITimer)
function IStage:ctor()
	IStage.super.ctor(self);

end

-- 脚本挂载事件
function IStage:Awake()
	IStage.super.Awake(self);
end

-- 脚本运行事件
function IStage:Start()
	IStage.super.Start(self);
end

-- 脚本更新事件
function IStage:Update()
	IStage.super.Update(self);

end

-- 脚本销毁事件
function IStage:Destroy()
	IStage.super.Destroy(self);

end

-- 检测结束处理（子类继承）
function IStage:EndCheck()
	
end

-- 是否可点击处理（子类继承）
function IStage:AbleClick()
	return true;
end

return IStage