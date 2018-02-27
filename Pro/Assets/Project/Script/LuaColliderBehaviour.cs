using UnityEngine;
using System.Collections;
using LuaInterface;
using System;

// MonoBehavior和Lua之间绑定的局部对象接口
// 需要外部提供对应的局部LuaTable对象
public class LuaColliderBehaviour : LuaMonoBehaviour
{
    // Lua函数接口
    private LuaFunction m_LuaCollisionEnter = null;
    private LuaFunction m_LuaCollisionExit = null;
    private LuaFunction m_LuaCollisionStay = null;
    private LuaFunction m_LuaTriggerEnter = null;
    private LuaFunction m_LuaTriggerExit = null;
    private LuaFunction m_LuaTriggerStay = null;

    public new void SetLuaObject(LuaTable obj)
    {
        base.SetLuaObject(obj);

        // 获取对应的Lua函数接口
        m_LuaCollisionEnter = GetLuaObject().GetLuaFunction("OnCollisionEnter");
        m_LuaCollisionExit = GetLuaObject().GetLuaFunction("OnCollisionExit");
        m_LuaCollisionStay = GetLuaObject().GetLuaFunction("OnCollisionStay");
        m_LuaTriggerEnter = GetLuaObject().GetLuaFunction("OnTriggerEnter");
        m_LuaTriggerExit = GetLuaObject().GetLuaFunction("OnTriggerExit");
        m_LuaTriggerStay = GetLuaObject().GetLuaFunction("OnTriggerStay");
    }

    public void OnCollisionEnter(Collision collision)
    {
        // Lua调用
        if (m_LuaCollisionEnter != null)
            m_LuaCollisionEnter.Call(GetLuaObject(), collision);
    }

    public void OnCollisionExit(Collision collision)
    {
        // Lua调用
        if (m_LuaCollisionExit != null)
            m_LuaCollisionExit.Call(GetLuaObject(), collision);
    }

    public void OnCollisionStay(Collision collision)
    {
        // Lua调用
        if (m_LuaCollisionStay != null)
            m_LuaCollisionStay.Call(GetLuaObject(), collision);
    }

    public void OnTriggerEnter(Collider collider)
    {
        // Lua调用
        if (m_LuaTriggerEnter != null)
            m_LuaTriggerEnter.Call(GetLuaObject(), collider);
    }

    public void OnTriggerExit(Collider collider)
    {
        // Lua调用
        if (m_LuaTriggerExit != null)
            m_LuaTriggerExit.Call(GetLuaObject(), collider);
    }

    public void OnTriggerStay(Collider collider)
    {
        // Lua调用
        if (m_LuaTriggerStay != null)
            m_LuaTriggerStay.Call(GetLuaObject(), collider);
    }

    protected new void OnDestroy()
    {
        // 销毁Lua接口函数
        if (m_LuaCollisionEnter != null)
        {
            m_LuaCollisionEnter.Dispose();
            m_LuaCollisionEnter = null;
        }
        if (m_LuaCollisionExit != null)
        {
            m_LuaCollisionExit.Dispose();
            m_LuaCollisionExit = null;
        }
        if (m_LuaCollisionStay != null)
        {
            m_LuaCollisionStay.Dispose();
            m_LuaCollisionStay = null;
        }
        if (m_LuaTriggerEnter != null)
        {
            m_LuaTriggerEnter.Dispose();
            m_LuaTriggerEnter = null;
        }
        if (m_LuaTriggerExit != null)
        {
            m_LuaTriggerExit.Dispose();
            m_LuaTriggerExit = null;
        }
        if (m_LuaTriggerStay != null)
        {
            m_LuaTriggerStay.Dispose();
            m_LuaTriggerStay = null;
        }

        base.OnDestroy();
    }
}
