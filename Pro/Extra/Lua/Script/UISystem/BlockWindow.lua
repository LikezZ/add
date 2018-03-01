
-- UI窗口虚基类
local IWindow = import("Script.UISystem.IWindow")
local BlockWindow = class("BlockWindow", IWindow)
function BlockWindow:ctor()
	BlockWindow.super.ctor(self);

	self.mText = nil;
end

-- 初始化处理
function BlockWindow:Init()
	BlockWindow.super.Init(self);

	-- 注册窗口事件
	self:RegisterEvent(SysEvent._TYPED_EVENT_BLOCKWINDOW_SHOW_, self.OnShowWindowEventHandler, true);
	self:RegisterEvent(SysEvent._TYPED_EVENT_BLOCKWINDOW_HIDE_, self.OnHideWindowEventHandler);
	self:RegisterEvent(SysEvent._TYPED_EVENT_BLOCKWINDOW_UPDATE_, self.OnUpdateWindowEventHandler);
end

-- 窗口显示事件处理
function BlockWindow:OnShowWindowEventHandler(paramList)
	self.super.ShowWindow(self, true);

end

-- 窗口隐藏事件处理
function BlockWindow:OnHideWindowEventHandler(paramList)
	self:Destroy(paramList);
end

-- 窗口更新事件处理
function BlockWindow:OnUpdateWindowEventHandler(paramList)
	Helper:SetText(self.mText, StageLogic.mSteps);
end

-- 加载处理
function BlockWindow:Load()
	BlockWindow.super.Load(self);

	self.mText = self:GetChild("Image/Text");
	Helper:SetText(self.mText, StageLogic.mSteps);

	local btn = self:GetChild("Button");
	if btn then
		-- 返回按钮
		local function OnBackBtn(obj)
			SceneManager:ChangeScene("LoginScene");
		end
		UIEventTrigger.Get(btn).onClick = OnBackBtn;
	end
	btn = self:GetChild("Control/Tap");
	if btn then
		-- 按钮
		local function OnTapBtn(data)
			if GameLogic.mIsCheck then return; end
			local pos = data.position;
			local obj = Helper:RaycastByScreenPoint(1, 100, pos.x, pos.y, 0);
			if obj then
				obj = obj:GetComponent("LuaMonoBehaviour");
				if obj then
					obj = obj:GetLuaObject();
					if obj and obj.mIsValid then
						if GameLogic:AbleClick() then
							obj:OnClick();
						else
							-- 没有步数暂时返回开始界面
							SceneManager:ChangeScene("LoginScene");
						end
					end
				end
				--UnityEngine.GameObject.Destroy(obj);
			end
		end
		UIEventTrigger.Get(btn).onPointerClick = OnTapBtn;

		local selectObj, startPos, startTime = nil, nil, nil;
		local function OnDownBtn(data)
			if GameLogic.mIsCheck then return; end
			selectObj, startPos, startTime = nil, nil, nil;
			local pos = data.position;
			local obj = Helper:RaycastByScreenPoint(1, 100, pos.x, pos.y, 0);
			if obj then
				obj = obj:GetComponent("LuaMonoBehaviour");
				if obj then
					obj = obj:GetLuaObject();
					if obj and obj.mIsValid then
						selectObj = obj;
						startPos = pos;
						startTime = UnityEngine.Time.unscaledTime;
					end
				end
			end
		end
		--UIEventTrigger.Get(btn).onPointerDown = OnDownBtn;
		local function OnUpBtn(data)
			if GameLogic.mIsCheck then return; end
			if selectObj and startPos and startTime then
				local pos = data.position;
				pos = pos:Clone():Sub(startPos);
				local time = UnityEngine.Time.unscaledTime - startTime;
				if time < 0.5 and (math.abs(pos.x) > 40 or math.abs(pos.y) > 40) then
					if math.abs(pos.x) > math.abs(pos.y) then
						if pos.x > 0 then
							GameLogic:SetDir(LogicDefine.Dir.Right);
						else
							GameLogic:SetDir(LogicDefine.Dir.Left);
						end
					else
						if pos.y > 0 then
							GameLogic:SetDir(LogicDefine.Dir.Up);
						else
							GameLogic:SetDir(LogicDefine.Dir.Down);
						end
					end
					if StageLogic.mSteps > 0 then
						selectObj:OnClick();
						GameLogic:CheckMove();
					else
						-- 没有步数暂时返回开始界面
						SceneManager:ChangeScene("LoginScene");
					end
				end
			end
		end
		--UIEventTrigger.Get(btn).onPointerUp = OnUpBtn;
	end
end

-- 桢更新处理
function BlockWindow:Update()
	BlockWindow.super.Update(self);
end

-- 销毁处理
function BlockWindow:Destroy(bDestroyAll)
	BlockWindow.super.Destroy(self, bDestroyAll);

	self.mText = nil;
end

return BlockWindow
