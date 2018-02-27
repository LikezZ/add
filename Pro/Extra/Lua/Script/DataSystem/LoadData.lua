--lua datamanager
--读取静态数据 txt

-------------------------------------------------
--功能：字符串按格式的分解(gmatch)
--输入：字符串，格式符号
--输出：分割好的字符串table
local function trimstr(str, c)
	local t={}
	if nil~=str then
		local s=string.gsub(str, "^%s*(.-)%s*$", "%1")	--去除字符串首尾的空格
		if nil==string.find(c, " ")	then		--分隔符不为空格
			local strtmp=string.gsub(s, " ", "")	--消除所有空格
			local strall=string.gsub(strtmp, c, " ") --用空格代替分隔符
			s=strall
		end

		for k, v in string.gmatch(s, "%S*") do
			if 0~=string.len(k) then		--获取长度非0的字符串
				t[#t+1]=k
			end
		end
	end
	return t
end

-------------------------------------------------
--功能：字符串按格式的分解(gsub)
--输入：字符串，格式符号
--输出：分割好的字符串table
local function substr(str, c)
	local t={}
	if nil~=str then
		local str_t = 0
		while true do
			local str_s, str_e = string.find(str, c, str_t+1)
			if str_s == nil then break end
			local tmpstr = string.sub(str, str_t+1, str_s-1)
			str_t = str_e
			if 0~=string.len(tmpstr) then		--获取长度非0的字符串
				t[#t+1]=tmpstr
			end
		end
	end
	return t
end

--功能：解析非字段名
--输入: 字段类型和名table，读取的一行字符串
--输出: 解析后的table
local function parseline(ttype, tname, rline)
	local t={}				--存储每一行的分割后的数据
	local info={}		    --存放解析后的table
	local num=0				--默认的每一行字段个数
	t=trimstr(rline, "\t")	--以空格为分隔符获取
	num=#(ttype)>#(t) and #(t) or #(ttype)--取字段名和数据名较少的

	for i=1, num do
		if ttype[i] == "String" then
			info[tname[i]] = t[i]
		elseif ttype[i] == "Num" then
			info[tname[i]] = tonumber(t[i])
		elseif ttype[i] == "Bool" then
			local b = tonumber(t[i])
			if b == 0 then
				info[tname[i]] = false 
			else
				info[tname[i]] = true
			end
		else
			info[tname[i]] = t[i]
		end
	end
	return info
end

-------------------------------------------------
--功能：加载静态数据
--输入：文件路径
--输出：数据table
function LoadDataFile(fileName)
	local buffer = EngineSystem:LoadDataFile(fileName)
	local temp = substr(buffer, "\n")
	--local tdes = trimstr(temp[1], "\t")     --第一行为描述
	local ttype = {}
	local tname = {}
	tname=trimstr(temp[2], "\t")		    --第二行为变量名
	ttype=trimstr(temp[3], "\t")		    --第三行为变量类型

	local data = {}
	data.List = {}
	data.Map = {}
	for i=4,#temp do
		local line = parseline(ttype, tname, temp[i])
		table.insert(data.List, line)
		-- 以第一列的项为key
		data.Map[line[tname[1]]] = line
	end
	function data:GetDataByKey(key)
	 	return self.Map[key]
	end
	function data:GetDataByIndex(index)
	 	return self.List[index]
	end
	function data:GetDataCount()
	 	return #self.List
	end

	return data
end
