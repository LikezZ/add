-- 客户端引擎支持类
EngineSystem ={}

--[[
	当前正在加载的模型资源：
	1：在游戏场景内加载的模型等资源，需要公用，即仅存在一份AssetBundle，然后各自实例化
	2：切换场景的时候，需要释放对应的AssetBundle
	3：如果之前为A场景加载的，但是由于异步的原因，在场景B中收到了回调，则直接释放
--]]
-- 对应结构体
local LOADING_CALLBACK_ITEM = class("LOADING_CALLBACK_ITEM")
function LOADING_CALLBACK_ITEM:ctor()
	self.mCallback = nil;-- 回调接口
	self.mParam = nil;-- 回调参数
end
function LOADING_CALLBACK_ITEM:clear()
	self.mCallback = nil;
	self.mParam = nil;
end
local LOADING_BUNDLE_ITEM = class("LOADING_BUNDLE_ITEM")
function LOADING_BUNDLE_ITEM:ctor()
	self.mBundle = nil;-- 缓存的Bundle对象
	self.mCallbackList = nil;-- 加载中缓存的回调对象
end
function LOADING_BUNDLE_ITEM:clear()
	if (self.mBundle ~= nil) then
		UnityEngine.GameObject.DestroyImmediate(self.mBundle, true);
	end
	self.mBundle = nil;
	if (self.mCallbackList ~= nil) then
		for i = 1, #self.mCallbackList do
			local item = self.mCallbackList[i];
			item:clear();
		end
	end
	self.mCallbackList = nil;
end

-- 加载CommonBundle
function EngineSystem:LoadCommonBundle(bundlename, callback, param)
	LuaEngineSystem.LoadCommonBundle(bundlename, callback, param);
end

-- 加载指定AssetBundle （减引用计数不卸载）
function EngineSystem:LoadAssetBundle(bundlename, classType, callback, param)
	LuaEngineSystem.LoadAssetBundle(bundlename, bundlename, classType, callback, param);
end

-- 卸载指定AssetBundle
function EngineSystem:UnLoadAssetBundle(bundlename)
	LuaEngineSystem.UnLoadAssetBundle(bundlename);
end

-- 卸载没用的资源 （引用计数为0的资源）
function EngineSystem:ClearUnusedAssetBundle()
	LuaEngineSystem.ClearUnusedAssetBundle();
end

-- 加载txt文本配表资源
function EngineSystem:LoadDataFile(fileName)
	return LuaEngineSystem.LoadDataFile(fileName);
end

-- 获取指定名字的子节点GameObject对象
function EngineSystem:GetGameObject(target, name)
	return LuaEngineSystem.GetGameObject(target, name);
end

-- modify by like 2017.2.27
-- 当前所有缓存的资源Asset列表类型（Model，Effect，Sound）
EngineSystem._BUNDLE_MODEL_ = "model";
EngineSystem._BUNDLE_EFFECT_ = "effect";
EngineSystem._BUNDLE_SOUND_ = "sound";
EngineSystem.mLoadedBundleMap = {};
EngineSystem.mLoadedBundleMap[EngineSystem._BUNDLE_MODEL_] = {};
EngineSystem.mLoadedBundleMap[EngineSystem._BUNDLE_EFFECT_] = {};
EngineSystem.mLoadedBundleMap[EngineSystem._BUNDLE_SOUND_] = {};

-- 加载Asset资源回调
local function EngineSystem_OnLocalAssetLoadFinished(obj, param)
	local  bundlename = param.bundle;
	local listname = param.list;
	local item = EngineSystem.mLoadedBundleMap[listname][bundlename];
	if (item == nil) then
        if listname ~= EngineSystem._BUNDLE_SOUND_ then
            UnityEngine.GameObject.DestroyImmediate(obj, true);
        end
		return;
	end

	-- 派发对应的事件
	item.mBundle = obj;
	for i = 1, #item.mCallbackList do
		local item = item.mCallbackList[i];
		item.mCallback(obj, item.mParam);
		item:clear();
	end
	item.mCallbackList = nil;
end

-- 加载Asset资源
function EngineSystem:LoadAsset(bundlename, assettype, callback, listname, param)
	local item = EngineSystem.mLoadedBundleMap[listname][bundlename];
	if (item == nil) then
		local temp = LOADING_CALLBACK_ITEM.new();
		temp.mCallback = callback;
		temp.mParam = param;
		local temp2 = LOADING_BUNDLE_ITEM.new();
		temp2.mCallbackList = {};
		table.insert(temp2.mCallbackList, temp);
		EngineSystem.mLoadedBundleMap[listname][bundlename] = temp2;
		EngineSystem:LoadAssetBundle(bundlename, assettype, EngineSystem_OnLocalAssetLoadFinished, {bundle = bundlename, list = listname});
		return;
	end

	-- 是否已经加载完毕了
	if (item.mBundle) then
		callback(item.mBundle, param);
	else
		local temp = LOADING_CALLBACK_ITEM.new();
		temp.mCallback = callback;
		temp.mParam = param;
		if (item.mCallbackList == nil) then
			item.mCallbackList = {};
		end
		table.insert(item.mCallbackList, temp);
	end
end

-- 释放场景所有已加载的Model
function EngineSystem:ClearAllAsset(listname)
	for k,v in pairs(EngineSystem.mLoadedBundleMap[listname]) do
		if (v.mBundle ~= nil) then
            if listname ~= EngineSystem._BUNDLE_SOUND_ then
                UnityEngine.GameObject.DestroyImmediate(v.mBundle, true);
            end
			EngineSystem.mLoadedBundleMap[listname][k] = nil;
		end
	end

	EngineSystem.mLoadedBundleMap[listname] = {};
end

-- 加载场景Model资源
function EngineSystem:LoadModel(bundlename, callback, param)
	EngineSystem:LoadAsset(bundlename, typeof(UnityEngine.GameObject), callback, EngineSystem._BUNDLE_MODEL_, param);
end

-- 释放场景所有已加载的Model
function EngineSystem:ClearAllModel()
	EngineSystem:ClearAllAsset(EngineSystem._BUNDLE_MODEL_);
end

-- 加载场景Effect资源
function EngineSystem:LoadEffect(bundlename, callback, param)
	EngineSystem:LoadAsset(bundlename, typeof(UnityEngine.GameObject), callback, EngineSystem._BUNDLE_EFFECT_, param);
end

-- 释放场景所有已加载的Effect
function EngineSystem:ClearAllEffect()
	EngineSystem:ClearAllAsset(EngineSystem._BUNDLE_EFFECT_);
end

-- 加载场景Sound资源
function EngineSystem:LoadSound(bundlename, callback, param)
    EngineSystem:LoadAsset(bundlename, typeof(UnityEngine.AudioClip), callback, EngineSystem._BUNDLE_SOUND_, param);
end

-- 释放场景所有已加载的Sound
function EngineSystem:ClearAllSound()
	EngineSystem:ClearAllAsset(EngineSystem._BUNDLE_SOUND_);
end

-- 清除场景所有缓冲Asset
function EngineSystem:FreeAllAssetBundle()
	for k,v in pairs(EngineSystem.mLoadedBundleMap) do
		EngineSystem:ClearAllAsset(k);
	end
end

-- 同步切换场景
function EngineSystem:ChangeScene(name)
	LuaEngineSystem.ChangeScene(name);
end

-- 获取当前场景名
function EngineSystem:GetSceneName()
	return LuaEngineSystem.GetSceneName();
end

-- 获取碰撞检测 返回实际可move
function EngineSystem:CheckCollision(transform, layer, move)
	return LuaEngineSystem.CheckCollision(transform, layer, move);
end

-- 异步切换场景
function EngineSystem:ChangeSceneAsync(name)
	local opt = LuaEngineSystem.ChangeSceneAsync(name);
	return opt;
end

-- 强制进行内存回收处理
function EngineSystem:ForceFreeMemory()
	LuaEngineSystem.ClearAllAssetBundle();
	LuaEngineSystem.FreeMemory();
end

-- 初始化引擎控制系统
function EngineSystem:Init()
	print("Init EngineSystem Succeed");
end

-- 引擎控制系统逻辑帧更新
function EngineSystem:Update(deltaTime)
--[[
	首先进行最简单的自动内存回收
	间隔5分钟扫描一次加载的列表，当超多指定最大个数N之后，删除一部分
	但是对应实例化的PREFAB还是可以正常使用的，只是在创建就需要重新加载了
--]]
end

-- 销毁引擎控制系统
function EngineSystem:Destroy()
	EngineSystem:FreeAllAssetBundle();
	print("Destroy EngineSystem Succeed");
end
