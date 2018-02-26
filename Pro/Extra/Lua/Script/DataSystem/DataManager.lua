-- define DataManager
require("Script.DataSystem.LoadData");

-- 全局lua datamanager
DataManager = {};
DataManager.Data = {};

-- 加载静态数据 txt
function DataManager:RegisterLuaData(dataName, fileName)
	local data = LoadDataFile(fileName);
	DataManager.Data[dataName] = data;
end

-- 初始化lua 加载静态数据 txt
function DataManager:Init()

	-- 加载静态数据 txt
	-- !!! 所有表格中的项不能为空
	DataManager:RegisterLuaData("Window", "Window");
	DataManager:RegisterLuaData("Scene", "Scene");
	DataManager:RegisterLuaData("Object", "Object");
	-- 加载所有布局数据
	DataManager:RegisterLuaData("Stage", "Stage");
	for i = 1, DataManager.Data.Stage:GetDataCount() do
		local item = DataManager.Data.Stage:GetDataByIndex(i);
		if item then
			DataManager:RegisterLuaData(item.DataName, item.ResName);
		end
	end
	
	print("Init DataManager Succeed");
end

-- 获取表数据
function DataManager:GetData(dataName)
	return DataManager.Data[dataName];
end	

-- 销毁
function DataManager:Destroy()
	DataManager.Data = {};
	LoggerSystem:Info("Destroy DataManager Succeed");
end



