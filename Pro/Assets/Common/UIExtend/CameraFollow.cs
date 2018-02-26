/********************************************************************************
 *	文件名：	CameraFollow.cs
 *	创建人：	Like
 *	创建时间：2016-08-17
 *
 *	功能说明：摄像机跟随， 带边界限制固定2D视角的摄像机跟随
 *	修改记录：
*********************************************************************************/

using UnityEngine;

[RequireComponent(typeof(Camera))]
public class CameraFollow : MonoBehaviour
{
    public float _distance = -12f;
    public float yOffset = 3f;
    public bool _followStarted = false;
    public GameObject _target;
    public Vector2 _maxXAndY; // The maximum x and y coordinates the camera can have.
    public Vector2 _minXAndY; // The minimum x and y coordinates the camera can have.
    private Camera _sceneCam;

    public GameObject Target
    {
        get
        {
            return _target;
        }
    }

    void Awake()
    {
        _sceneCam = transform.GetComponent<Camera>();
        // 矫正摄像机移动范围
        UIUtility.FixCameraSize(_sceneCam, _minXAndY, _maxXAndY, out _minXAndY, out _maxXAndY, _distance);
    }

    void LateUpdate()
    {
        TrackPlayer();
    }

    private void TrackPlayer()
    {
        if (!_followStarted || Target == null)
            return;
        // 如果摄像机抖动，可能是因为x和y是分别赋值的所以Lerp应该分别计算;
        // 暂时不用缓动了插值设置为1
        transform.position = Vector3.Lerp(transform.position, GetCamPos(Target), 0.3f);
    }

    public Vector3 GetCamPos(GameObject go)
    {
        // By default the target x and y coordinates of the camera are it's current x and y coordinates.
        float targetX = go.transform.position.x;
        float targetY = go.transform.position.y + yOffset;
        // The target x and y coordinates should not be larger than the maximum or smaller than the minimum.
        targetX = Mathf.Clamp(targetX, _minXAndY.x, _maxXAndY.x);
        targetY = Mathf.Clamp(targetY, _minXAndY.y, _maxXAndY.y);

        // Set the camera's position to the target position with the same z component.
        return new Vector3(targetX, targetY, transform.position.z);
    }

    public void FollowStart()
    {
        if (!_followStarted)
            _followStarted = true;
    }

    public void FollowPause(bool pause)
    {
        _followStarted = !pause;
    }

    /// <summary>
    /// 是否掉出屏幕下方,用于销毁判定
    /// </summary>
    /// <param name="be"></param>
    /// <returns></returns>
    public bool UnitIsDropOutScene(GameObject go)
    {
        return go.transform.position.y < transform.position.y - 15f
            //|| go.transform.position.y > transform.position.y + 15f
            || go.transform.position.x < transform.position.x - 15f
            || go.transform.position.x > transform.position.x + 15f;
    }
}
