
-- 队列ITEM
local _LIST_ITEM_ = class("_LIST_ITEM_")
function _LIST_ITEM_:ctor()
    self.mPre   = nil;-- 前置指针
    self.mNext  = nil;-- 后置指针
    self.mValue = nil;-- 数值
end
function _LIST_ITEM_:clear()
    self.mPre   = nil;
    self.mNext  = nil;
    self.mValue = nil;
end

-- LIST通用类
-- 可用于各种需要支持LIST操作的地方
local List = class("List")
function List:ctor()
    self.mCount = 0;  -- 元素个数
    self.mFirst = nil;-- 首位元素
end

-- 得到元素个数
function List:Count()
    return self.mCount;
end

-- 得到第一个有效元素的节点指针
function List:Begin()
    return self.mFirst;
end

-- 得到指定位置的元素
function List:Get(pos)
    -- 无元素返回nil
    if (self.mCount <= 0) then
        return nil;
    end

    -- pos非法返回nil
    if (pos<=0 or pos>self.mCount) then
        return nil;
    end

    -- 挨个遍历
    local temp = nil;
    for i = 1, pos do
        if (temp == nil) then
            temp = self.mFirst;
        else
            temp = temp.mNext;
        end
    end

    return temp;
end

-- 插入
function List:Push(val)
    local temp = _LIST_ITEM_.new();
    temp.mValue = val;
    self.mCount = self.mCount+1;

    if (self.mFirst == nil) then
        self.mFirst = temp;
        return;
    end

    local endNode = self.mFirst;
    while (endNode.mNext ~= nil) do
        endNode = endNode.mNext;
    end

    endNode.mNext = temp;
    temp.mPre = endNode;
end

-- 删除第一个节点
function List:Pop()
    if (self.mCount <= 0) then
        return;
    end

    self:Erase(1);
end

-- 删除
function List:Erase(pos,bDelete)
    if (bDelete == nil) then
        bDelete = true;
    end

    if (self.mFirst == nil) then
        return;
    end

    if (pos == 1) then
        local temp = self.mFirst;
        self.mFirst = self.mFirst.mNext;
        if (self.mFirst ~= nil) then
            self.mFirst.mPre = nil;
        end
        if (bDelete) then
            temp:clear();
        end
        self.mCount = self.mCount-1;
        return;
    end

    local temp = self:Get(pos);
    if (temp == nil) then
        return;
    end

    if (temp.mPre ~= nil) then
        temp.mPre.mNext = temp.mNext;
    end
    if (temp.mNext ~= nil) then
        temp.mNext.mPre = temp.mPre;
    end
    if (bDelete) then
        temp:clear();
    end
    self.mCount = self.mCount-1;
end

-- 删除
function List:Del(temp,bDelete)
    if (bDelete == nil) then
        bDelete = true;
    end

    if (self.mFirst == nil) then
        return;
    end

    if (self.mFirst == temp) then
        local temp = self.mFirst;
        self.mFirst = self.mFirst.mNext;
        if (self.mFirst ~= nil) then
            self.mFirst.mPre = nil;
        end
        if (bDelete) then
            temp:clear();
        end
        self.mCount = self.mCount-1;
        return;
    end

    if (temp.mPre ~= nil) then
        temp.mPre.mNext = temp.mNext;
    end
    if (temp.mNext ~= nil) then
        temp.mNext.mPre = temp.mPre;
    end
    if (bDelete) then
        temp:clear();
    end
    self.mCount = self.mCount-1;
end

-- 全部清除
function List:Clear(datacallback)
    while (self.mFirst ~= nil) do
        local temp = self.mFirst;
        self.mFirst = temp.mNext;

        if (datacallback ~= nil) then
            datacallback(temp.mData);
        end

        temp:clear();
    end

    self.mFirst = nil;
    self.mCount = 0;
end

return List
