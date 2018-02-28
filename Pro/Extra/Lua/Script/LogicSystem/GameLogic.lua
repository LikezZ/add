-- define GameLogic
require("Script.LogicSystem.LogicDefine");

-- 全局lua
GameLogic = {};
GameLogic.mUniqueId = 0;
GameLogic.mOnTimer = nil;

-- 有效的方块数组
GameLogic.mBlockList = {};
-- 方块转换的二维数组
GameLogic.mBlockArray = {};
-- 无效的方块暂存数组
GameLogic.mUnusedList = {};

-- 是否检测移动
GameLogic.mIsCheck = false;
-- 是否逻辑检测
GameLogic.mIsLogic = false;
-- 移动方向记录
GameLogic.mMoveDir = LogicDefine.Dir.Down;

-- 场景根节点对象
GameLogic.mRoot = nil;
-- 阻挡节点数组
GameLogic.mObst = {};

-- 初始化lua 
function GameLogic:Init()
	-- 设置摄像机视口
	local camera = UnityEngine.GameObject.FindWithTag("MainCamera");
	camera = camera:GetComponent("Camera");
	-- 以680宽为基准 80像素每单位
	local height = 680 * UnityEngine.Screen.height / UnityEngine.Screen.width
	camera.orthographicSize = height / 80 / 2;

	-- 查找节点
	self.mRoot = UnityEngine.GameObject.Find("Root");
	-- 转换阻挡节点
	self.mObst[LogicDefine.Dir.Up] = Helper:FindTransform(self.mRoot, "Obst/Down");
	self.mObst[LogicDefine.Dir.Down] = Helper:FindTransform(self.mRoot, "Obst/Up");
	self.mObst[LogicDefine.Dir.Right] = Helper:FindTransform(self.mRoot, "Obst/Left");
	self.mObst[LogicDefine.Dir.Left] = Helper:FindTransform(self.mRoot, "Obst/Right");

	-- 初始化方块
	local count = LogicDefine.Rows * LogicDefine.Columns;
	for i=1,count do
		-- 换算方块坐标
		local x = (i - 1) % LogicDefine.Columns;
		local y = math.floor((i - 1) / LogicDefine.Columns);
		-- 换算方块行列 Row = y + 1, Column = x + 1
		local row, column = y + 1, x + 1;
		local temp = self:GetIndexBlock(row, column)--self:GetRandomBlock(row, column);
		-- 创建方块背景
		self:CreateObject("Back", function (obj)
			Helper:SetLocalPositionXYZ(obj, x, y, 1);
		end);
	end
	-- 初始方向
	self:SetDir(LogicDefine.Dir.Down);
	-- 检测消除
	self:CheckMove();

	-- self.mOnTimer = function ()
	-- 	self:OnTimerFunc();
	-- end
	-- App:RegisterTimer(true, 0.8, self.mOnTimer);
end

-- 设置移动方向 初始默认向下
function GameLogic:SetDir(dir)
	-- 设置阻挡节点
	Helper:SetActive(self.mObst[LogicDefine.Dir.Up], true);
	Helper:SetActive(self.mObst[LogicDefine.Dir.Down], true);
	Helper:SetActive(self.mObst[LogicDefine.Dir.Right], true);
	Helper:SetActive(self.mObst[LogicDefine.Dir.Left], true);
	Helper:SetActive(self.mObst[dir], false);
	-- 设置方块方向逻辑
	GameLogic.mMoveDir = dir;
	for k,v in pairs(self.mBlockList) do
		if v and v.mIsValid then
			v:SetDir(dir);
		end
	end
end

-- 检测移动
function GameLogic:CheckMove()
	self.mIsCheck = true;
	for k,v in pairs(self.mBlockList) do
		if v and v.mIsValid then
			v:CheckMove();
		end
	end
end

-- 检测空缺方块 返回是否有缺少
function GameLogic:CheckLack()
	-- 是否有缺少
	local lack = false;
	-- 刷新二维数组（移动停止时已经刷新）
	--self:CheckArray();
	local list = {};
	-- 根据方向检测缺少
	if self.mMoveDir == LogicDefine.Dir.Up then
		for i=1,LogicDefine.Columns do
			local k = 1;
			for j=1,LogicDefine.Rows do
				local temp = self:GetBlock(j, i);
				-- 遍历到第一个不为空
				if temp then
					break;
				else
					-- 记录缺少
					k = k - 1;
					table.insert(list, {k, i});
				end
			end
		end
	elseif self.mMoveDir == LogicDefine.Dir.Down then
		for i=1,LogicDefine.Columns do
			local k = LogicDefine.Rows;
			for j=LogicDefine.Rows,1,-1 do
				local temp = self:GetBlock(j, i);
				if temp then
					break;
				else
					k = k + 1;
					table.insert(list, {k, i});
				end
			end
		end
	elseif self.mMoveDir == LogicDefine.Dir.Left then
		for i=1,LogicDefine.Rows do
			local k = LogicDefine.Columns;
			for j=LogicDefine.Columns,1,-1 do
				local temp = self:GetBlock(i, j);
				if temp then
					break;
				else
					k = k + 1;
					table.insert(list, {i, k});
				end
			end
		end
	elseif self.mMoveDir == LogicDefine.Dir.Right then
		for i=1,LogicDefine.Rows do
			local k = 1;
			for j=1,LogicDefine.Columns do
				local temp = self:GetBlock(i, j);
				if temp then
					break;
				else
					k = k - 1;
					table.insert(list, {i, k});
				end
			end
		end
	end
	for i=1,#list do
		local row, column = list[i][1], list[i][2];
		local temp = self:GetIndexBlock(row, column)--self:GetRandomBlock(row, column);
		lack = true;
	end
	return lack;
end

-- 检测消除算法
function GameLogic:CheckEliminate(obj)
	-- 刷新二维数组（移动停止时已经刷新）
	--self:CheckArray();
	-- 所有可消除列表
	local list = {};
	-- 是否有可消除
	local todo = false;
	-- 递归检测相邻是否相同
	-- r 行的变化量 c 列的变化量
	local function check_same(obj, r, c, record)
		local temp = self:GetBlock(obj.mRow + r, obj.mColumn + c);
		if temp and temp.mIsValid and temp.mMainType == obj.mMainType then
			if not record.list[temp.mUniqueId] then
				return temp;
			end
		end
		return nil;
	end
	-- 检测所有相邻方块
	local function check_all(obj, record)
		record.list = record.list or {};
		record.count = record.count or 0;
		record.count = record.count + 1;
		record.list[obj.mUniqueId] = obj;
		-- 先横向
		local temp = check_same(obj, 0, -1, record);
		if temp then check_all(temp, record); end
		temp = check_same(obj, 0, 1, record);
		if temp then check_all(temp, record); end
		-- 然后竖向
		temp = check_same(obj, -1, 0, record);
		if temp then check_all(temp, record); end
		temp = check_same(obj, 1, 0, record);
		if temp then check_all(temp, record); end
	end
	-- 开始遍历
	local record = {};
	check_all(obj, record);
	if record.count and record.count > 1 then
		todo = true;
		list = record.list;
		if record.count > 4 then
			-- 暂定五连生成超级方块
			obj:OnSuper();
		end
	end
	-- 如果可以消除
	if todo then
		-- 遍历可消除列表（消除优先级最高 如果在消除列表排除被炸等）
		for k,v in pairs(list) do
			if v and v.mIsValid then
				v:OnEliminate();
			end
		end
	end
	self:CheckMove();
	return todo;
end

-- 转换二维数组 检测消除时使用
function GameLogic:CheckArray()
	self.mBlockArray = {};
	for k,v in pairs(self.mBlockList) do
		if v and v.mIsValid then
			self.mBlockArray[v.mRow] = self.mBlockArray[v.mRow] or {};
			self.mBlockArray[v.mRow][v.mColumn] = v;
		end
	end
end

-- 从二维数组获取指定行列方块 先CheckArray最新
function GameLogic:GetBlock(row, column)
	local temp = self.mBlockArray[row];
	if temp then
		return temp[column];
	end
	return temp;
end

-- 查找指定次类型方块
function GameLogic:FindBlock(stype)
	for k,v in pairs(self.mBlockList) do
		if v and v.mIsValid and v.mSecondaryType == stype then
			return v;
		end
	end
	return nil;
end

-- 设置复位回收
function GameLogic:RecycleBlock(obj)
	obj.mIsValid = false;
	obj:Reset();
	self.mUnusedList[obj.mUniqueId] = obj;
	self.mBlockList[obj.mUniqueId] = nil;
	-- 移动到无限远
	Helper:SetLocalPositionXYZ(obj.mRootObject, 10000, 10000, 0);
end

-- 更新
function GameLogic:Update()
	-- 开始检测是否停止移动
	if self.mIsCheck then
		local done = true;
		for k,v in pairs(self.mBlockList) do
			if v and v.mIsValid and v:IsMove() then
				done = false;
				break;
			end
		end
		-- 所有方块停止移动
		if done then
			-- 设置停止检测
			self.mIsCheck = false;
			-- 刷新二维数组
			self:CheckArray();
		end
		-- 检测碰撞等
		if not self.mIsCheck then
			--self:CheckEliminate();

			-- 添加空缺方块
			if self:CheckLack() then
				self:CheckMove();
			end
		end
		-- TODO 其他逻辑

	end
end

-- 销毁
function GameLogic:Destroy()
	App:UnRegisterTimer(self.mOnTimer);

	self.mUniqueId = 0;
	self.mOnTimer = nil;
	self.mBlockList = {};
	self.mBlockArray = {};
	self.mUnusedList = {};
	self.mIsCheck = false;
	self.mIsLogic = false;
	self.mRoot = nil;
	self.mObst = {};

	self.mBlockIndex = 1;
	self.mBlockCount = 1;
end

-- 定时
function GameLogic:OnTimerFunc()
	
end

-- 添加消除个数计算步数
function GameLogic:AddCount()
	StageLogic:AddCount();
end

-- 减步数
function GameLogic:SubSteps()
	StageLogic:SubSteps();
end

-- 得到唯一id标识
function GameLogic:GetUniqueId()
	self.mUniqueId = self.mUniqueId + 1;
	return self.mUniqueId;
end

-- 获取随机基础类型方块
function GameLogic:GetRandomBlock(row, column, utype)
	local stype = math.random(6) - 1;
	return self:CreateBlock(stype, row, column, utype);
end

-- 创建指定的方块
function GameLogic:CreateBlock(stype, row, column, utype)
	local temp = self:GetUnusedBlock(stype);
	temp.mIsValid = true;
	temp:SetDir(self.mMoveDir);
	self.mBlockList[temp.mUniqueId] = temp;
	temp.mRow = row;
	temp.mColumn = column;
	temp.mUnderType = utype;
	Helper:SetLocalPositionXYZ(temp.mRootObject, temp.mColumn - 1, temp.mRow - 1, 0);
	return temp;	
end

-- 获取闲置无效的方块
function GameLogic:GetUnusedBlock(stype)
	for k,v in pairs(self.mUnusedList) do
		if v and v.mSecondaryType == stype then
			self.mUnusedList[v.mUniqueId] = nil;
			return v;
		end
	end
	local item = DataManager.Data.Object:GetDataByKey(stype);
	if not item then return; end

	local temp = self:CreateLogicObject(item.FileName, item.ScriptName);
	temp.mMainType = item.MainType;
	temp.mSecondaryType = stype;
	return temp;
end

-- 创建逻辑对象
function GameLogic:CreateLogicObject(asset, script)
	local temp = import("Script.LogicSystem.Object."..script).new();
	temp.mUniqueId = self:GetUniqueId();
	local function OnGameLogicResourceLoaded(obj)
    	local com = obj:AddComponent(typeof(LuaMonoBehaviour));
		com:SetLuaObject(temp);
		temp:SetBehaviour(com);
	end
	-- 开始加载
	self:CreateObject(asset, OnGameLogicResourceLoaded);
	return temp;
end

-- 创建资源对象
function GameLogic:CreateObject(name, callback)
	local function OnGameLogicResourceLoaded(obj, param)
		if obj then
			local root = self.mRoot;
			local node = UnityEngine.Object.Instantiate(obj);
			node.transform:SetParent(root.transform, false);
			node.transform.localPosition = Vector3.zero;
			node.transform.localScale = Vector3.one;
			if callback ~= nil then callback(node) end;
	    end
	end
	-- 开始加载
	EngineSystem:LoadModel(name, OnGameLogicResourceLoaded);
end

-- 游戏stage数据与逻辑相关 -----------------------------------------
-- 数据表的id索引
GameLogic.mBlockIndex = 1;
-- 数据表的id统计数
GameLogic.mBlockCount = 1;

-- 获取数据表对象
function GameLogic:GetIndexBlock(row, column)
	local item = StageLogic:GetPartBlock(self.mBlockIndex);
	if self.mBlockIndex ~= self.mBlockCount then
		local temp = StageLogic:GetPartBlock(self.mBlockCount);
		if temp then 
			self.mBlockIndex = self.mBlockCount;
			item = temp; 
		end
	end
	self.mBlockIndex = self.mBlockIndex + 1;
	self.mBlockCount = self.mBlockCount + 1;
	if item then
		if item.JumpIndex > 0 then
			self.mBlockIndex = item.JumpIndex;
		end
		local temp, utype = nil, -1;
		if item.UnderRandom == -1 then
			utype = item.UnderType;
		elseif item.UnderRandom == 1 then
			local str = Helper:SplitString(item.UnderPool, '|');
			utype = tonumber(str[math.random(#str)]);
		end
		if item.RandomType == -1 then
			temp = self:CreateBlock(item.SecondaryType, row, column, utype);
		elseif item.RandomType == 0 then
			temp = self:GetRandomBlock(row, column, utype);
		elseif item.RandomType == 1 then
			local str = Helper:SplitString(item.RandomPool, '|');
			temp = self:CreateBlock(tonumber(str[math.random(#str)]), row, column, utype);
		end
		return temp;
	end
end