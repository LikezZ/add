using System;
using System.Collections.Generic;
using UnityEngine;

public interface ICollisionHandler
{
    // 主动碰撞回调
    void OnRaycastHitHandle(RaycastHit2D hitData);
    // 被动碰撞回调
    bool OnCollisionHandle(RaycastHit2D hitData, GameObject hitObj);
}

