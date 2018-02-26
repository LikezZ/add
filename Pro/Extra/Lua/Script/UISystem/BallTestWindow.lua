
-- UI窗口虚基类
local IWindow = import("Script.UISystem.IWindow")
local BallTestWindow = class("BallTestWindow", IWindow)
function BallTestWindow:ctor()
	BallTestWindow.super.ctor(self);

end

-- 初始化处理
function BallTestWindow:Init()
	BallTestWindow.super.Init(self);

	-- 注册窗口事件
	self:RegisterEvent(SysEvent._TYPED_EVENT_BALLTESTWINDOW_SHOW_, self.OnShowWindowEventHandler, true);
	self:RegisterEvent(SysEvent._TYPED_EVENT_BALLTESTWINDOW_HIDE_, self.OnHideWindowEventHandler);
	self:RegisterEvent(SysEvent._TYPED_EVENT_BALLTESTWINDOW_UPDATE_, self.OnUpdateWindowEventHandler);
end

-- 窗口显示事件处理
function BallTestWindow:OnShowWindowEventHandler(paramList)
	self.super.ShowWindow(self, true);

end

-- 窗口隐藏事件处理
function BallTestWindow:OnHideWindowEventHandler(paramList)
	self:Destroy(paramList);
end

-- 窗口更新事件处理
function BallTestWindow:OnUpdateWindowEventHandler(paramList)
	
end

-- 加载处理
function BallTestWindow:Load()
	BallTestWindow.super.Load(self);

	local camera = UnityEngine.GameObject.FindWithTag("MainCamera");
	camera = camera:GetComponent("Camera");
	local ball = UnityEngine.GameObject.Find("Sphere");
    ball = ball:AddComponent(typeof(LuaColliderBehaviour));
	if ball then
		local obj = import("Script.LogicSystem.Object.PlayerObject").new();
		ball:SetLuaObject(obj);
	end

	local btn = self:GetChild("Button");
	if btn then
		-- 返回按钮
		local function OnBackBtn(obj)
			SceneManager:ChangeScene("LoginScene");
		end
		UIEventTrigger.Get(btn).onClick = OnBackBtn;
	end
	btn = self:GetChild("Control/Tap1");
	if btn then
		-- 按钮
		local function OnTapBtn(obj)
			--EventSystem:PushEvent(SysEvent._TYPED_EVENT_LOGIC_TAPROLE_);
		end
		UIEventTrigger.Get(btn).onClick = OnTapBtn;

		local function OnDownBtn(data)
			--print("ddddd"..data.position.x)
			if data.position.x > UnityEngine.Screen.width / 2 then
				-- 向右跳
				EventSystem:PushEvent(SysEvent._TYPED_EVENT_LOGIC_TAPROLE_, 1);
			else
				-- 向左跳
				EventSystem:PushEvent(SysEvent._TYPED_EVENT_LOGIC_TAPROLE_, -1);
			end
			--local temp = camera:WorldToScreenPoint(ball.position);
			--print("ggggg"..temp.x)
			--temp.z = 0;
			--local dir = Vector3.Normalize(temp:Clone():Sub(Vector3.New(data.position.x, data.position.y, 0)));
			--ball.velocity = Vector3.New(0, 0, 0);
			--ball:AddForce(Vector3.New(0, 500, 0));
			--ball:AddForce(dir:Mul(500));
		end
		UIEventTrigger.Get(btn).onPointerDown = OnDownBtn;
		local function OnUpBtn(data)
			
		end
		UIEventTrigger.Get(btn).onPointerUp = OnUpBtn;
	end
end

-- 桢更新处理
function BallTestWindow:Update()
	BallTestWindow.super.Update(self);
end

-- 销毁处理
function BallTestWindow:Destroy(bDestroyAll)
	BallTestWindow.super.Destroy(self, bDestroyAll);

end

return BallTestWindow
