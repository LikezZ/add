﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class LuaObjectBehaviourWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(LuaObjectBehaviour), typeof(LuaMonoBehaviour));
		L.RegFunction("SetLuaObject", SetLuaObject);
		L.RegFunction("OnCollisionHandle", OnCollisionHandle);
		L.RegFunction("OnRaycastHitHandle", OnRaycastHitHandle);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetLuaObject(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			LuaObjectBehaviour obj = (LuaObjectBehaviour)ToLua.CheckObject(L, 1, typeof(LuaObjectBehaviour));
			LuaTable arg0 = ToLua.CheckLuaTable(L, 2);
			obj.SetLuaObject(arg0);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnCollisionHandle(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			LuaObjectBehaviour obj = (LuaObjectBehaviour)ToLua.CheckObject(L, 1, typeof(LuaObjectBehaviour));
			UnityEngine.RaycastHit2D arg0 = (UnityEngine.RaycastHit2D)ToLua.CheckObject(L, 2, typeof(UnityEngine.RaycastHit2D));
			UnityEngine.GameObject arg1 = (UnityEngine.GameObject)ToLua.CheckUnityObject(L, 3, typeof(UnityEngine.GameObject));
			bool o = obj.OnCollisionHandle(arg0, arg1);
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnRaycastHitHandle(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			LuaObjectBehaviour obj = (LuaObjectBehaviour)ToLua.CheckObject(L, 1, typeof(LuaObjectBehaviour));
			UnityEngine.RaycastHit2D arg0 = (UnityEngine.RaycastHit2D)ToLua.CheckObject(L, 2, typeof(UnityEngine.RaycastHit2D));
			obj.OnRaycastHitHandle(arg0);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int op_Equality(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Object arg0 = (UnityEngine.Object)ToLua.ToObject(L, 1);
			UnityEngine.Object arg1 = (UnityEngine.Object)ToLua.ToObject(L, 2);
			bool o = arg0 == arg1;
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

