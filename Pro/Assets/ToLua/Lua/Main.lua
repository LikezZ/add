--主入口函数。从这里开始lua逻辑

require("Script.Start");

function Main()					
	-- 开始游戏
	App:Start();
end

--场景切换通知
function OnLevelWasLoaded(level)
	collectgarbage("collect")
	Time.timeSinceLevelLoad = 0
	App:OnLevelWasLoaded();
end