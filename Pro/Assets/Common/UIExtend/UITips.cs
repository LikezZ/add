//using System;
//using UnityEngine;
//using System.Collections;
//using UnityEngine.UI;
//using UnityEngine.Events;

//public class UITips
//{

//    #region Tips Tools
//    // 显示UI图片提示
//    public static void ShowUITips(Vector3 pos, UnityAction<GameObject> func, string sprite)
//    {
//        NewTipUI(UIUtility.WorldPosToUiPos(pos), sprite, UIParent, delegate (GameObject obj)
//        {

//            if (func != null)
//            {
//                func(obj);
//            }

//            fadeAction(obj.gameObject, 0.6f, iTween.EaseType.linear, delegate ()
//            {
//                GameObject.Destroy(obj);
//                obj = null;
//            });
//        });
//    }

//    // 显示移动UI图片提示
//    public static void ShowUIMoveTips(Vector3 pos, Vector3 topos, UnityAction<GameObject> func, string prefab)
//    {
//        NewTipPrefab(UIUtility.WorldPosToUiPos(pos), prefab, UIParent, delegate (GameObject obj)
//        {
//            obj.transform.localScale = new Vector3(100f, 100f, 100f);
//            foreach (Transform ch in obj.GetComponentsInChildren<Transform>())
//            {
//                //遍历当前物体及其所有子物体
//                ch.gameObject.layer = LayerMask.NameToLayer("UI");
//            }

//            moveAction(obj.gameObject, topos, 0.5f, iTween.EaseType.easeInCubic, delegate ()
//            {
//                if (func != null)
//                {
//                    func(obj);
//                }

//                GameObject.Destroy(obj);
//                obj = null;
//            }, false);
//        });
//    }

//    // 3D对象显示提示(跟随消失)
//    public static void ShowTips(Transform target, UnityAction<GameObject> func, string prefab = "TextTip")
//    {
//        if (target != null)
//        {
//            GameObject pa = new GameObject();
//            pa.SetActive(true);
//            pa.transform.SetParent(target);
//            pa.transform.localScale = Vector3.one;
//            pa.transform.localPosition = Vector3.zero;

//            NewTipPrefab(UIUtility.WorldPosToUiPos(pa.transform.position), prefab, UIParent, delegate (GameObject obj)
//            {
//                if (pa == null)
//                {
//                    GameObject.Destroy(obj);
//                    return;
//                }

//                TipsFollow tf = obj.AddComponent<TipsFollow>();
//                if (tf != null)
//                {
//                    tf.Init(pa.transform);
//                }

//                if (func != null)
//                {
//                    func(obj);
//                }

//                moveAction(pa.gameObject, new Vector2(pa.transform.localPosition.x, pa.transform.localPosition.y + 1f), 1f, iTween.EaseType.linear, delegate ()
//                {
//                    if (pa == null)
//                    {
//                        return;
//                    }

//                    fadeAction(pa.gameObject, 0.5f, iTween.EaseType.linear, delegate ()
//                    {
//                        GameObject.Destroy(pa);
//                        pa = null;
//                    });
//                });
//            });
//        }
//    }

//    // 在屏幕中间显示图片提示
//    public static void ShowUITips(string sprite, UnityAction<GameObject> func = null)
//    {
//        NewTipUI(new Vector3(Screen.width * 0.5f / UIUtility.Offset, Screen.height * 0.75f / UIUtility.Offset, 0f), sprite, UIParent, delegate (GameObject obj)
//        {

//            if (func != null)
//            {
//                func(obj);
//            }

//            moveAction(obj.gameObject, new Vector2(obj.transform.localPosition.x, obj.transform.localPosition.y + 80f), 1f, iTween.EaseType.linear, delegate ()
//            {
//                fadeAction(obj.gameObject, 0.5f, iTween.EaseType.linear, delegate ()
//                {
//                    GameObject.Destroy(obj);
//                });
//            });
//        });
//    }

//    // 获取提示窗口的父节点
//    private static Transform uiParent;
//    private static Transform UIParent
//    {
//        get
//        {
//            if (uiParent != null)
//            {
//                return uiParent;
//            }
//            else
//            {
//                // 暂时先用这个
//                Transform trans = UIManager.Instance.Root.transform;
//                if (trans != null)
//                {
//                    uiParent = trans;
//                    return uiParent;
//                }
//                else
//                {
//                    Debug.LogError("获取提示窗口父节点错误！！！");
//                    return null;
//                }
//            }
//        }
//    }

//    public static void NewTipPrefab(Vector3 pos, string prefab, Transform parent, UnityAction<GameObject> func)
//    {
//        parent.loadPrefab(prefab, prefab, delegate (GameObject tmp)
//        {
//            if (tmp != null)
//            {
//                GameObject obj = GameObject.Instantiate(tmp);
//                obj.SetActive(true);
//                obj.transform.SetParent(parent);
//                obj.transform.localScale = Vector3.one;
//                obj.layer = LayerMask.NameToLayer("UI");

//                RectTransform rt = obj.GetComponent<RectTransform>();
//                if (rt == null)
//                {
//                    rt = obj.AddComponent<RectTransform>();
//                }

//                rt.anchorMin = new Vector2(0f, 0f);
//                rt.anchorMax = new Vector2(0f, 0f);
//                rt.anchoredPosition3D = pos;

//                if (func != null)
//                {
//                    func(obj);
//                }
//            }
//        });
//    }

//    public static void NewTipUI(Vector3 pos, string sprite, Transform parent, UnityAction<GameObject> func)
//    {
//        parent.loadUI(sprite, delegate (Sprite tmp)
//        {
//            if (tmp != null)
//            {
//                GameObject obj = new GameObject();
//                obj.SetActive(true);
//                obj.transform.SetParent(parent);
//                obj.transform.localScale = Vector3.one;
//                obj.layer = LayerMask.NameToLayer("UI");

//                Image img = obj.AddComponent<Image>();
//                img.raycastTarget = false;
//                img.sprite = tmp;
//                img.SetNativeSize();

//                obj.GetComponent<RectTransform>().anchorMin = new Vector2(0f, 0f);
//                obj.GetComponent<RectTransform>().anchorMax = new Vector2(0f, 0f);
//                obj.GetComponent<RectTransform>().anchoredPosition3D = pos;

//                if (func != null)
//                {
//                    func(obj);
//                }
//            }
//        });
//    }
//    #endregion

//    #region 移动动画
//    public static void moveAction(GameObject obj, Vector2 pos, float time, iTween.EaseType ease, Action func, bool local = true)
//    {
//        //键值对儿的形式保存iTween所用到的参数
//        Hashtable args = new Hashtable();

//        //这里是设置类型，iTween的类型又很多种，在源码中的枚举EaseType中
//        //例如移动的特效，先震动在移动、先后退在移动、先加速在变速、等等
//        args.Add("easeType", ease);

//        //移动的整体时间
//        args.Add("time", time);

//        //三个循环类型 none loop pingPong (一般 循环 来回)	
//        args.Add("loopType", "none");

//        //移动结束时调用，参数和上面类似
//        args.Add("oncomplete", "OniTweenCallback");
//        args.Add("oncompleteparams", func);
//        args.Add("oncompletetarget", GameManager.Instance.Root.gameObject);

//        // 是否本地坐标
//        args.Add("islocal", local);

//        // x y z 标示移动的位置。
//        args.Add("y", pos.y);
//        args.Add("x", pos.x);

//        //最终让改对象开始移动
//        iTween.MoveTo(obj, args);
//    }

//    public static void fadeAction(GameObject obj, float time, iTween.EaseType ease, Action func = null)
//    {
//        //键值对儿的形式保存iTween所用到的参数
//        Hashtable args = new Hashtable();

//        //这里是设置类型，iTween的类型又很多种，在源码中的枚举EaseType中
//        //例如移动的特效，先震动在移动、先后退在移动、先加速在变速、等等
//        args.Add("easeType", ease);

//        //移动的整体时间
//        args.Add("time", time);

//        //三个循环类型 none loop pingPong (一般 循环 来回)	
//        args.Add("loopType", "none");

//        //移动结束时调用，参数和上面类似
//        args.Add("oncomplete", "OniTweenCallback");
//        args.Add("oncompleteparams", func);
//        args.Add("oncompletetarget", GameManager.Instance.Root.gameObject);

//        // 是否本地坐标
//        args.Add("islocal", true);

//        // x y z 标示移动的位置。
//        args.Add("alpha", 0);

//        //最终让改对象开始移动
//        iTween.FadeTo(obj, args);
//    }
//    #endregion
//}
