/*
 * 
 *  Instruction :
 *  
 *      It contain all template for singleton.
 */

using UnityEngine;

public class Singleton<T> where T : class, new()
{
    private static T _instance;
    private static readonly object _lock = new object();  

    public static T Instance
    {
        get
        {
            if (_instance == null)
            {
                lock (_lock)
                {
                    _instance = new T();
                }
            }

            return _instance;
        }
    }
}

public class SingletonMono<T> where T : MonoBehaviour
{
    private static T _instance;
    private static readonly object _lock = new object();

    public static T Instance
    {
        get
        {
            if (_instance == null)  // null才lock, 优化性能
            {
                lock (_lock)
                {
                    if (_instance == null)
                    {
                        _instance = (T)UnityEngine.Object.FindObjectOfType(typeof(T));
                        if (_instance == null)
                        {
                            GameObject singleton = new GameObject();
                            _instance = singleton.AddComponent<T>();
                            if (singleton.name == "New Game Object")
                                singleton.name = "(singleton) " + typeof(T).ToString();
                            UnityEngine.Object.DontDestroyOnLoad(singleton);
                        }
                        else
                        {
                            Debug.Log("[Singleton] Using instance already created: " + _instance.gameObject.name);
                        }
                    }
                }
            }
            return _instance;
        }
    }
}