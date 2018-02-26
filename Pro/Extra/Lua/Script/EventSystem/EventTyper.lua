
-- 客户端全局事件定义类
SysEvent = {};

-----------------------------------------------------------------------------------------------------------------------
-- 系统事件定义区域
-----------------------------------------------------------------------------------------------------------------------
SysEvent._TYPED_EVENT_SYSTEM_CHANGESCENE_ = 101; -- 切换场景
SysEvent._TYPED_EVENT_SYSTEM_BACKTOLOGIN_ = 102; -- 重新登录

-----------------------------------------------------------------------------------------------------------------------
-- 窗口事件定义区域
-----------------------------------------------------------------------------------------------------------------------
-- Loading窗口事件定义
SysEvent._TYPED_EVENT_LOADINGWINDOW_SHOW_       = 1001;
SysEvent._TYPED_EVENT_LOADINGWINDOW_HIDE_       = 1002;
SysEvent._TYPED_EVENT_LOADINGWINDOW_UPDATE_     = 1003;

-- 游戏窗口事件定义
SysEvent._TYPED_EVENT_GAMEWINDOW_SHOW_       = 1011;
SysEvent._TYPED_EVENT_GAMEWINDOW_HIDE_       = 1012;
SysEvent._TYPED_EVENT_GAMEWINDOW_UPDATE_     = 1013;

-- 登录窗口事件定义
SysEvent._TYPED_EVENT_LOGINWINDOW_SHOW_       = 1021;
SysEvent._TYPED_EVENT_LOGINWINDOW_HIDE_       = 1022;
SysEvent._TYPED_EVENT_LOGINWINDOW_UPDATE_     = 1023;

-- 登录窗口事件定义
SysEvent._TYPED_EVENT_BALLTESTWINDOW_SHOW_       = 1031;
SysEvent._TYPED_EVENT_BALLTESTWINDOW_HIDE_       = 1032;
SysEvent._TYPED_EVENT_BALLTESTWINDOW_UPDATE_     = 1033;

-- 登录窗口事件定义
SysEvent._TYPED_EVENT_BLOCKWINDOW_SHOW_       = 1041;
SysEvent._TYPED_EVENT_BLOCKWINDOW_HIDE_       = 1042;
SysEvent._TYPED_EVENT_BLOCKWINDOW_UPDATE_     = 1043;

-----------------------------------------------------------------------------------------------------------------------
-- 逻辑事件定义区域
-----------------------------------------------------------------------------------------------------------------------

-- 动作系统事件
SysEvent._TYPED_EVENT_ACTION_ON_EVENT_       = 10000;

-- 重置陀螺仪
SysEvent._TYPED_EVENT_LOGIC_RESETGYRO_       = 10001;
-- 点击 触发
SysEvent._TYPED_EVENT_LOGIC_TAPROLE_         = 10002;