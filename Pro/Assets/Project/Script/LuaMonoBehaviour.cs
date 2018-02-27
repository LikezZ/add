using UnityEngine;
using System.Collections;
using LuaInterface;

// MonoBehavior和Lua之间绑定的局部对象接口
// 需要外部提供对应的局部LuaTable对象
public class LuaMonoBehaviour : MonoBehaviour
{

    // 对应的Lua局部Table对象
    private LuaTable m_LuaObject = null;
    // Lua函数接口
    private LuaFunction m_LuaAwakeFunc = null;
    private LuaFunction m_LuaStartFunc = null;
    private LuaFunction m_LuaUpdateFunc = null;
    private LuaFunction m_LuaEnableFunc = null;
    private LuaFunction m_LuaDisableFunc = null;
    private LuaFunction m_LuaFixedUpdateFunc = null;
    private LuaFunction m_LuaDestroyFunc = null;

    // 获取LUA对象
    public LuaTable GetLuaObject()
    {
        return m_LuaObject;
    }

    // 设置对应的Lua对象
    public void SetLuaObject(LuaTable obj)
    {
        m_LuaObject = obj;

        // 获取对应的Lua函数接口
        m_LuaAwakeFunc = m_LuaObject.GetLuaFunction("Awake");
        m_LuaStartFunc = m_LuaObject.GetLuaFunction("Start");
        m_LuaUpdateFunc = m_LuaObject.GetLuaFunction("Update");
        m_LuaEnableFunc = m_LuaObject.GetLuaFunction("OnEnable");
        m_LuaDisableFunc = m_LuaObject.GetLuaFunction("OnDisable");
        m_LuaFixedUpdateFunc = m_LuaObject.GetLuaFunction("FixedUpdate");
        m_LuaDestroyFunc = m_LuaObject.GetLuaFunction("Destroy");

        // Lua调用
        if (m_LuaAwakeFunc != null)
            m_LuaAwakeFunc.Call(m_LuaObject, gameObject);
    }

    protected void Awake()
    {
        // 这里是肯定调用不到了，因为AddComponent的时候已经出发了对象的Awake
        // 而我们只能在其返回后才能设置LuaObject，所以Awake放在Set方法里面
        if (m_LuaObject == null)
            return;
    }

    // Use this for initialization
    protected void Start()
    {
        // Lua调用
        if (m_LuaStartFunc != null)
            m_LuaStartFunc.Call(m_LuaObject);
    }

    // Update is called once per frame
    protected void Update()
    {
        // Lua调用
        if (m_LuaUpdateFunc != null)
            m_LuaUpdateFunc.Call(m_LuaObject);
    }

    protected void FixedUpdate()
    {
        // Lua调用
        if (m_LuaFixedUpdateFunc != null)
            m_LuaFixedUpdateFunc.Call(m_LuaObject);
    }

    // enable
    protected void OnEnable()
    {
        // Lua调用
        if (m_LuaEnableFunc != null)
            m_LuaEnableFunc.Call(m_LuaObject);
    }

    // disable
    protected void OnDisable()
    {
        // Lua调用
        if (m_LuaDisableFunc != null)
            m_LuaDisableFunc.Call(m_LuaObject);
    }

    // Destroy is called once per frame
    protected void OnDestroy()
    {
        // Lua调用
        if (m_LuaDestroyFunc != null)
            m_LuaDestroyFunc.Call(m_LuaObject);

        // 销毁Lua接口函数
        if (m_LuaAwakeFunc != null)
        {
            m_LuaAwakeFunc.Dispose();
            m_LuaAwakeFunc = null;
        }
        if (m_LuaStartFunc != null)
        {
            m_LuaStartFunc.Dispose();
            m_LuaStartFunc = null;
        }
        if (m_LuaUpdateFunc != null)
        {
            m_LuaUpdateFunc.Dispose();
            m_LuaUpdateFunc = null;
        }
        if (m_LuaFixedUpdateFunc != null)
        {
            m_LuaFixedUpdateFunc.Dispose();
            m_LuaFixedUpdateFunc = null;
        }
        if (m_LuaEnableFunc != null)
        {
            m_LuaEnableFunc.Dispose();
            m_LuaEnableFunc = null;
        }
        if (m_LuaDisableFunc != null)
        {
            m_LuaDisableFunc.Dispose();
            m_LuaDisableFunc = null;
        }
        if (m_LuaDestroyFunc != null)
        {
            m_LuaDestroyFunc.Dispose();
            m_LuaDestroyFunc = null;
        }

        // 销毁对应的Table（一定要执行啊，否则内存泄露）
        if (m_LuaObject != null)
            m_LuaObject.Dispose();
        m_LuaObject = null;
    }
}
