-- define LogicDefine

-- 全局静态定义lua
LogicDefine = {};

-- 方向定义
LogicDefine.Dir = {
	Up = 0,
	Left = 1,
	Right = 2,
	Down = 3,
}

-- 游戏行列数
LogicDefine.Rows = 9; 
LogicDefine.Columns = 8;

-- 对象主类型 ObjectMainType
LogicDefine.OMType = {
	Red = 0,          -- 红块
	Blue = 1,         -- 蓝块
	Green = 2,        -- 绿块
	Yellow = 3,       -- 黄块
	Black = 4,        -- 黑块
	White = 5,        -- 白块
	Key = 6,          -- 钥匙
	Door = 7,         -- 传送门
	Coin = 8,         -- 货币等
	Obst = 9,         -- 阻挡
}

-- 对象第二类型
LogicDefine.OSType = {
	Red1 = 0,          -- 红块
	Blue1 = 1,         -- 蓝块
	Green1 = 2,        -- 绿块
	Yellow1 = 3,       -- 黄块
	Black1 = 4,        -- 黑块
	White1 = 5,        -- 白块
	Red2 = 6,          -- 超级红块
	Blue2 = 7,         -- 超级蓝块
	Green2 = 8,        -- 超级绿块
	Yellow2 = 9,       -- 超级黄块
	Black2 = 10,       -- 超级黑块
	White2 = 11,       -- 超级白块
	Red3 = 12,         -- 冻结红块1
	Blue3 = 13,        -- 冻结蓝块1
	Green3 = 14,       -- 冻结绿块1
	Yellow3 = 15,      -- 冻结黄块1
	Black3 = 16,       -- 冻结黑块1
	White3 = 17,       -- 冻结白块1
	Red4 = 18,         -- 冻结红块2
	Blue4 = 19,        -- 冻结蓝块2
	Green4 = 20,       -- 冻结绿块2
	Yellow4 = 21,      -- 冻结黄块2
	Black4 = 22,       -- 冻结黑块2
	White4 = 23,       -- 冻结白块2
	Key1 = 24,         -- 主门钥匙
	Door1 = 25,        -- 主传送门
	Coin1 = 26,        -- 金币
	Obst1 = 26,        -- 第一层阻挡
	Obst2 = 27,        -- 第二层阻挡
}

-- 方块速度大小
LogicDefine.Velocity = 10; 

-- 检测是否移动的帧数
-- 应该等于最多的行列数减一
LogicDefine.MoveFrame = 8; 
