using UnityEngine;
using System.Collections;
using LuaInterface;
using System;

// MonoBehavior和Lua之间绑定的局部对象接口
// 需要外部提供对应的局部LuaTable对象
public class LuaObjectBehaviour : LuaMonoBehaviour, ICollisionHandler
{
    // Lua函数接口
    private LuaFunction m_LuaRaycastHitFunc = null;
    private LuaFunction m_LuaCollisionFunc = null;

    public new void SetLuaObject(LuaTable obj)
    {
        base.SetLuaObject(obj);

        // 获取对应的Lua函数接口
        m_LuaRaycastHitFunc = GetLuaObject().GetLuaFunction("RaycastHitFunc");
        m_LuaCollisionFunc = GetLuaObject().GetLuaFunction("CollisionFunc");
    }

    public bool OnCollisionHandle(RaycastHit2D hitData, GameObject hitObj)
    {
        LuaMonoBehaviour tmp = hitObj.GetComponent<LuaMonoBehaviour>();
        if (tmp == null) { return false; }
        // Lua调用
        object[] param = { false};
        if (m_LuaCollisionFunc != null)
            param = m_LuaCollisionFunc.Call(GetLuaObject(), tmp.GetLuaObject());
        return (bool)param[0];
    }

    public void OnRaycastHitHandle(RaycastHit2D hitData)
    {
        LuaMonoBehaviour tmp = hitData.collider.gameObject.GetComponent<LuaMonoBehaviour>();
        if (tmp == null) { return; }
        // Lua调用
        if (m_LuaRaycastHitFunc != null)
            m_LuaRaycastHitFunc.Call(GetLuaObject(), tmp.GetLuaObject());
    }

    protected new void OnDestroy()
    {
        // 销毁Lua接口函数
        if (m_LuaRaycastHitFunc != null)
        {
            m_LuaRaycastHitFunc.Dispose();
            m_LuaRaycastHitFunc = null;
        }
        if (m_LuaCollisionFunc != null)
        {
            m_LuaCollisionFunc.Dispose();
            m_LuaCollisionFunc = null;
        }

        base.OnDestroy();
    }
}
