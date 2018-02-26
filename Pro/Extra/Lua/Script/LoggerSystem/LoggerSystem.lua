-- 客户端日志系统类
LoggerSystem ={}

-- 日志分类
LoggerSystem._TYPED_LOGGER_DEBUG_ = 1;
LoggerSystem._TYPED_LOGGER_INFO_  = 2;
LoggerSystem._TYPED_LOGGER_ERROR_ = 3;

-- 是否开启日志
LoggerSystem.mIsLogEnabled = true;
-- 当前开启级别
LoggerSystem.mLogLevel = LoggerSystem._TYPED_LOGGER_DEBUG_;

-- 打印debug日志
function LoggerSystem:Debug(fmt, ...)
	if (not LoggerSystem.mIsLogEnabled) then
		return;
	end

	if (LoggerSystem.mLogLevel > LoggerSystem._TYPED_LOGGER_DEBUG_) then
		return;
	end

	print(string.format(tostring(fmt), ...));
end

-- 打印Info日志
function LoggerSystem:Info(fmt, ...)
	if (not LoggerSystem.mIsLogEnabled) then
		return;
	end

	if (LoggerSystem.mLogLevel > LoggerSystem._TYPED_LOGGER_INFO_) then
		return;
	end

	print(string.format(tostring(fmt), ...));
end

-- 打印Error日志
function LoggerSystem:Error(fmt, ...)
	if (not LoggerSystem.mIsLogEnabled) then
		return;
	end

	if (LoggerSystem.mLogLevel > LoggerSystem._TYPED_LOGGER_ERROR_) then
		return;
	end

	print(string.format(tostring(fmt), ...));
end

-- 初始化引擎控制系统
function LoggerSystem:Init()
	print("Init LoggerSystem Succeed");
end

-- 引擎控制系统逻辑帧更新
function LoggerSystem:Update()
end

-- 销毁引擎控制系统
function LoggerSystem:Destroy()
	print("Destroy LoggerSystem Succeed");
end
