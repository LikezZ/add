
--实用函数类
--可以包括和unity引擎相关的方便获取或设置值的函数，或者类似时间处理，字符串处理等相关的
----------------------------------------------------------
_G.Helper = {};

-- 强制去掉富文本的文字信息
-- 强制去除:
--	[b][u][s][url][i][s][sub]
--	[/b][/u][/s][/url][/i][/s][/sub]
function Helper:CheckRichText(text)
	local temp = text;
	temp = string.gsub(temp, "%[b%]", "");
	temp = string.gsub(temp, "%[/b%]", "");
	temp = string.gsub(temp, "%[u%]", "");
	temp = string.gsub(temp, "%[/u%]", "");
	temp = string.gsub(temp, "%[s%]", "");
	temp = string.gsub(temp, "%[/s%]", "");
	temp = string.gsub(temp, "%[url%]", "");
	temp = string.gsub(temp, "%[/url%]", "");
	temp = string.gsub(temp, "%[i%]", "");
	temp = string.gsub(temp, "%[/i%]", "");
	temp = string.gsub(temp, "%[s%]", "");
	temp = string.gsub(temp, "%[/s%]", "");
	temp = string.gsub(temp, "%[sub%]", "");
	temp = string.gsub(temp, "%[/sub%]", "");
	return temp;
end

--[Comment]
--替换子字符串，返回新字符串
function Helper:ReplaceSubString(text, org, tar)
    org = string.gsub(org, "%[", "%%[");
    org = string.gsub(org, "%]", "%%]");
    local txt, num = string.gsub(text, org, tar);
    return txt;
end

--[Comment]
--去字符串左右空格
function Helper:TrimString(str)
   return str:match("^%s*(.-)%s*$");
end

--字符串分割函数
--传入字符串和分隔符，返回分割后的table
function Helper:SplitString(str, delimiter)
    if str==nil or str=='' or delimiter==nil then
        return nil;
    end
    local result = {};
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

--[Comment]
--服务器时间转换
--服务器时间uint时间（形如1512100530），转换为2015-12-10
function  Helper:ConvertServerTime(time)
    local s_min,s_hour,s_day,s_month, s_year;

    local t = os.date("*t", time);
    if t.day < 10 then
        s_day = "0" .. t.day;
    else
        s_day = tostring(t.day);
    end
    if t.month < 10 then
        s_month = "0" .. t.month;
    else
        s_month = tostring(t.month);
    end
    s_year = tostring(t.year);

    return s_year .."-" .. s_month .. "-".. s_day;
end

--[Comment]
--服务器时间转换
--服务器时间uint时间（形如1512100530），转换为12-10 20：15
function  Helper:GetShortTime(time)
    local s_min,s_hour,s_day,s_month;

    local t = os.date("*t", time);
    if t.min < 10 then
        s_min = "0" .. t.min;
    else
        s_min = tostring(t.min);
    end
    if t.hour < 10 then
        s_hour = "0" .. t.hour;
    else
        s_hour = tostring(t.hour);
    end
    if t.day < 10 then
        s_day = "0" .. t.day;
    else
        s_day = tostring(t.day);
    end
    if t.month < 10 then
        s_month = "0" .. t.month;
    else
        s_month = tostring(t.month);
    end

    return s_month.."-"..s_day.." "..s_hour..":"..s_min;
end

--[Comment]
--剩余时间转换
--剩余时间段，转换为23：20
function Helper:GetRemainTime(time)
    local hour = math.floor(time/(60*60));
    local remainSec = (time - hour*60*60);
    local min = math.floor(remainSec/60);
    local sec = time%60;

    if( hour <= 9) then
        hour = "0" .. hour;
    end
    if( min <= 9 ) then
        min = "0" .. min;
    end
    if( sec <= 9) then
        sec = "0" .. sec;
    end
    return hour .. ":" .. min .. ":" .. sec;
end

function Helper:ConcatColorText(txt, color)
    if txt==nil then
        return "";
    end
    txt = string.format("[%s]%s[-]", color, txt);
    return txt ;
end

-- 打印内容（可指定字段 ）
_G.printt = function (value, key)
    local string = "";
    local printTable;
    printTable = function (table, key, space, inherit)
        for k, v in pairs(table) do
            if not key or (key and key == k) or inherit then
                if type(v) == "table" then
                    string = string..space..k.." = {{\n";
                    printTable(v, key, space.."    ", true);
                    string = string..space.."}}\n";
                elseif type(v) == "number" or type(v) == "string" or type(v) == "boolean" then
                    string = string..space..k.." = "..tostring(v).."\n";
                else
                    string = string..space..k.." = "..type(v).."\n";
                end
            else
                if type(v) == "table" then
                    printTable(v, key, space.."    ", false);
                end
            end
        end
    end
    if type(value) == "table" then
        string = string.."table = {{\n";
        printTable(value, key, "    ", false);
        string = string.."}}\n";
    elseif type(value) == "number" or type(value) == "string" or type(value) == "boolean" then
        string = string.."value = "..tostring(value);
    else
        string = string.."value = "..type(value);
    end
    print(string);
end

-- 以下所有与Unity交互函数 ----------------------------------------------------
-- 统一接口 所有的object参数可以是任意Unity的类型--------------------------
-- 会在C#查找正确的类型并使用--------------------------------------------------

-- [Comment]
-- 设置 GameObject 位置
-- 参数
-- object : object
-- xyz : 位置
function Helper:SetPositionXYZ(object, x, y, z)
    if object and x and y and z then
        ScriptHelper.SetPosition(object, x, y, z);
    end
end
function Helper:SetPositionX(object, x)
    if object then
        ScriptHelper.SetPositionX(object, x);
    end
end
function Helper:SetPositionY(object, y)
    if object then
        ScriptHelper.SetPositionY(object, y);
    end
end
function Helper:SetPositionZ(object, z)
    if object then
        ScriptHelper.SetPositionZ(object, z);
    end
end
function Helper:SetPosition(object, vec3)
    if object then
        ScriptHelper.SetPosition(object, vec3.x, vec3.y, vec3.z);
    end
end
function Helper:GetPosition(object)
    if object then
        local x, y, z;
        x, y, z = ScriptHelper.GetPosition(object, x, y, z);
        return Vector3.New(x, y, z);
    end
end
function Helper:GetPositionXYZ(object)
    if object then
        local x, y, z;
        x, y, z = ScriptHelper.GetPosition(object, x, y, z);
        return x, y, z;
    end
end
function Helper:SetLocalPositionXYZ(object, x, y, z)
    if object and x and y and z then
        ScriptHelper.SetLocalPosition(object, x, y, z);
    end
end
function Helper:SetLocalPositionX(object, x)
    if object then
        ScriptHelper.SetLocalPositionX(object, x);
    end
end
function Helper:SetLocalPositionY(object, y)
    if object then
        ScriptHelper.SetLocalPositionY(object, y);
    end
end
function Helper:SetLocalPositionZ(object, z)
    if object then
        ScriptHelper.SetLocalPositionZ(object, z);
    end
end
function Helper:SetLocalPosition(object, vec3)
    if object then
        ScriptHelper.SetLocalPosition(object, vec3.x, vec3.y, vec3.z);
    end
end
function Helper:GetLocalPosition(object)
    if object then
        local x, y, z;
        x, y, z = ScriptHelper.GetLocalPosition(object, x, y, z);
        return Vector3.New(x, y, z);
    end
end
function Helper:GetLocalPositionXYZ(object)
    if object then
        local x, y, z;
        x, y, z = ScriptHelper.GetLocalPosition(object, x, y, z);
        return x, y, z;
    end
end

-- [Comment]
-- 设置 object 旋转
-- 参数
-- object : object
-- rotation : 旋转
function Helper:SetRotation(object, rotation)
    if object then
        ScriptHelper.SetRotation(object, rotation);
    end
end
function Helper:SetRotationXYZ(object, x, y, z)
    if object then
        ScriptHelper.SetRotation(object, x, y, z);
    end
end
function Helper:SetLocalRotation(object, rotation)
    if object then
        ScriptHelper.SetLocalRotation(object, rotation);
    end
end
function Helper:SetLocalRotationXYZ(object, x, y, z)
    if object then
        ScriptHelper.SetLocalRotationXYZ(object, x, y, z);
    end
end
function Helper:GetRotation(object)
    if object then
        return ScriptHelper.GetRotation(object);
    end
end
function Helper:GetLocalRotation(object)
    if object then
        return ScriptHelper.GetLocalRotation(object);
    end
end

-- [Comment]
-- 查找 FindTransform
-- 参数
-- object : object
-- path : 目标object
function Helper:FindTransform(object, path)
    if object and path then
        return ScriptHelper.FindTransform(object, path);
    end
end

-- [Comment]
-- 查找 FindChild
-- 参数
-- object : object
-- index : 从0开始
function Helper:GetChild(object, index)
    if object and index >= 0 then
        return ScriptHelper.GetChild(object, index);
    end
    return nil;
end

-- [Comment]
-- 获取 ChildCount
-- 参数
-- object : object
function Helper:ChildCount(object)
    if object then
        return ScriptHelper.ChildCount(object);
    end
    return 0;
end

-- [Comment]
-- 设置 object 朝向
-- 参数
-- object : object
-- target : 目标object
function Helper:LookAt(object, target)
    if object and target then
        ScriptHelper.LookAt(object, target);
    end
end
function Helper:LookAtPos(object, vec3)
    if object and vec3 then
        ScriptHelper.LookAt(object, vec3.x, vec3.y, vec3.z);
    end
end
function Helper:LookAtXYZ(object, x, y, z)
    if object and x and y and z then
        ScriptHelper.LookAt(object, x, y, z);
    end
end

--[Comment]
--设置Obj子元件的层级
-- 参数
-- object : object
-- layermask : 层级
function Helper:ResetChildLayers(object, layermask)
    if object then
        ScriptHelper.SetobjectLayer(object, layermask);
    end
end

--[Comment]
--根据跟摄摄像机参数
-- 参数
-- isActive : 可见与否
function Helper:EnableOrDisableCamera(object, isActive)
    if object then
        ScriptHelper.EnableOrDisableCamera(object, isActive);
    end
end

--[Comment]
--根据设置可见与否
-- 参数
-- object : 对象等脚本
-- isActive : 可见与否
function Helper:SetActive(object, isActive)
    if object then
        local bool = (isActive and 1) or 0;
        ScriptHelper.SetObjectActive(object, bool);
    end
end

--[Comment]
--根据设置大小缩放
-- 参数
-- object : 所有对象
-- vec3 : 大小
function Helper:SetScaleXYZ(object, x, y, z)
    if object then
        ScriptHelper.SetScale(object, x, y, z);
    end
end
function Helper:SetScale(object, vec3)
    if object then
        ScriptHelper.SetScale(object, vec3.x, vec3.y, vec3.z);
    end
end
function Helper:GetScaleXYZ(object)
    if object then
        local x, y, z;
        x, y, z = ScriptHelper.GetScale(object, x, y, z);
        return x, y, z;
    end
end
function Helper:GetScale(object)
    if object then
        local x, y, z;
        x, y, z = ScriptHelper.GetScale(object, x, y, z);
        return Vector3.New(x, y, z);
    end
end

--[Comment]
--根据设置名字
-- 参数
-- object : 所有对象
-- name : 名字
function Helper:SetName(object, name)
    if object then
        ScriptHelper.SetName(object, name);
    end
end

--[Comment]
--设置文本
-- 参数
-- object : 所有对象
-- text : 文本
function Helper:SetText(object, text)
    if object then
        ScriptHelper.SetText(object, text);
    end
end

--[Comment]
--根据设置父节点
-- 参数
-- object : 所有对象
-- parent : 所有对象
-- isStay : 是否保留世界坐标状态true or false
function Helper:SetParent(object, parent, isStay)
    if object then
        local bool = (isStay and 1) or 0;
        ScriptHelper.SetParent(object, parent, bool);
    end
end

--[Comment]
--射线碰撞检测
-- 参数
-- 
function Helper:RaycastByScreenPoint(mask, distance, x, y, z)
    local retObject, retX, retY, retZ = ScriptHelper.RaycastByScreenPoint(mask, distance, x, y, z, nil, nil, nil, nil);
    return retObject, retX, retY, retZ;
end

