
-- 定时事件ITEM
local _TIMER_ITEM_ = class("_TIMER_ITEM_")
function _TIMER_ITEM_:ctor()
    self.mIsValid   = true; -- 是否有效(对应这里的链表不删除，只进行标志位的禁用即可)
    self.mIsLoop    = false;-- 是否循环
    self.mInterval  = 0;    -- 定时触发间隔
    self.mFunc      = nil;  -- 回调函数
    self.mTimeDiff  = 0;    -- 当前已经走过的时间差
end
function _TIMER_ITEM_:clear()
    self.mIsValid   = false;
    self.mIsLoop    = false;
    self.mInterval  = 0;
    self.mFunc      = nil;
    self.mTimeDiff  = 0;
end

-- 定时器基类
-- 这里为了防止在定时器内部进行删除等操作，
-- 所以内部的LIST不删除，如果无效则直接设置标志位无效即可
local ITimer = class("ITimer")
function ITimer:ctor()
    self.mIsInTimer = false;
    self.mMyTimerList = import("Script.Common.List").new();
    self.mNewTimerList = import("Script.Common.List").new();
end

-- 注册定时事件
function ITimer:RegisterTimer(loop, interval, func)
    local temp = _TIMER_ITEM_.new();
    temp.mIsLoop = loop;
    temp.mInterval = interval;
    temp.mFunc = func;
    temp.mTimeDiff = interval;

    if (self.mIsInTimer) then
        self.mNewTimerList:Push(temp);
    else
        self.mMyTimerList:Push(temp);
    end
end

-- 取消定时事件
function ITimer:UnRegisterTimer(func)
    local node = self.mMyTimerList:Begin();
    while (node ~= nil) do
        local temp = node;
        node = node.mNext;

        if (temp.mValue.mFunc == func) then
            if (self.mIsInTimer) then
                temp.mValue:clear();
            else
                temp.mValue:clear();
                self.mMyTimerList:Del(temp);
            end
            break;
        end
    end

    node = self.mNewTimerList:Begin();
    while (node ~= nil) do
        local temp = node;
        node = node.mNext;

        if (temp.mValue.mFunc == func) then
            temp.mValue:clear();
            self.mNewTimerList:Del(temp);
            return;
        end
    end
end

-- 取消所有定时事件
function ITimer:ClearAll()
    local temp = self.mMyTimerList:Begin();
    while (temp ~= nil) do
        temp.mValue:clear();
        temp = temp.mNext;
    end
    temp = self.mNewTimerList:Begin();
    while (temp ~= nil) do
        temp.mValue:clear();
        temp = temp.mNext;
    end
    self.mMyTimerList:Clear();
    self.mNewTimerList:Clear();
end

-- 首次加载
function ITimer:Awake()

end

-- 开始
function ITimer:Start()

end

-- 逻辑帧更新
function ITimer:Update()
    -- 遍历所有节点，判断是否到时间了
    self.mIsInTimer = true;
    local diff = UnityEngine.Time.deltaTime;
    local temp = self.mMyTimerList:Begin();
    while (temp ~= nil) do
        local value = temp.mValue;
        if (value.mIsValid) then
            value.mTimeDiff = value.mTimeDiff-diff;
            if (value.mTimeDiff <= 0) then
                value.mFunc(self);

                -- 如果Update中销毁了List，则直接退出
                if (self.mMyTimerList == nil or self.mMyTimerList:Count()<=0) then
                    value = nil;
                    self.mIsInTimer = false;
                    return;
                end

                -- 是否重复处理
                if (value.mIsLoop) then
                    value.mTimeDiff = value.mInterval;
                else
                    value:clear();
                end
            end
        end
        temp = temp.mNext;
    end
    self.mIsInTimer = false;

    -- 如果Update中销毁了List，则直接退出
    if (self.mMyTimerList == nil or self.mMyTimerList:Count()<=0) then
        return;
    end

    -- 删除所有失效的节点
    local node = self.mMyTimerList:Begin();
    while (node ~= nil) do
        local temp = node;
        node = node.mNext;

        if (not temp.mValue.mIsValid) then
            self.mMyTimerList:Del(temp);
        end
    end

    -- 增加新的定时器任务
    node = self.mNewTimerList:Begin();
    while (node ~= nil) do
        local temp = node;
        node = node.mNext;

        self.mMyTimerList:Push(temp.mValue);
        self.mNewTimerList:Del(temp);
    end
end

-- 销毁
function ITimer:Destroy()
    local temp = self.mMyTimerList:Begin();
    while (temp ~= nil) do
        temp.mValue:clear();
        temp = temp.mNext;
    end
    temp = self.mNewTimerList:Begin();
    while (temp ~= nil) do
        temp.mValue:clear();
        temp = temp.mNext;
    end
    self.mMyTimerList:Clear();
    self.mMyTimerList = nil;
    self.mNewTimerList:Clear();
    self.mNewTimerList = nil;
end

return ITimer
