/********************************************************************************
 *	文件名：	CameraController.cs
 *	全路径：	\Assets\Project\UI
 *	创建人：	Like
 *	创建时间：2016-08-17
 *
 *	功能说明：摄像机跟随控制器， 3D场景摄像机跟随 可设置跟随旋转
 *	修改记录：
*********************************************************************************/

using UnityEngine;
using System.Collections;

public class CameraController : MonoBehaviour
{

    //摄像机朝向的目标模型
    public Transform target;
    //摄像机与模型保持的距离
    public float distance = 10.0f;
    //高度阻尼
    public float heightDamping = 2.0f;
    //旋转阻尼
    public float rotationDamping = 3.0f;
    //摄像机朝向的偏移量
    public Vector3 offset = new Vector3(0, 1, 0);
    //摄像机初始X轴角度
    public float awakeAngleX = 90f;
    //缓存摄像机方向角度
    private Vector3 camDir;

    // 实际摄像机朝向的目标位置
    public Vector3 TargetPosition
    {
        get
        {
            return target.position + offset;
        }
    }

    void Start()
    {
        float wantedRotationAngleY = target.eulerAngles.y;
        transform.rotation = Quaternion.Euler(awakeAngleX, wantedRotationAngleY, 0);
        Vector3 positon = TargetPosition;
        positon -= transform.forward * distance;
        transform.position = positon;
        transform.LookAt(TargetPosition);
    }

    void Update()
    {

    }

    void LateUpdate()
    {
        // Early out if we don't have a target
        if (!target)
            return;

        // 摄像机跟随
        FollowHandle();

        // 调节视角
        RotateHandle();

        // 调节摄像机位置
        FixPosition();

        // 让射线机永远看着主角
        transform.LookAt(TargetPosition);

        // 准星碰撞
        RaycastHandle();
    }

    public void FollowHandle()
    {
        // 摄像机跟随
        Vector3 positon = TargetPosition;
        positon += -transform.forward * distance;
        transform.position = positon;
    }

    public void FixPosition()
    {
        //在场景视图中可以看到这条射线
        Debug.DrawLine(TargetPosition, transform.position, Color.red);
        //主角朝着这个方向发射射线
        RaycastHit hit;
        if (Physics.Linecast(TargetPosition, transform.position, out hit))
        {
            string name = hit.collider.gameObject.tag;
            if (name != "MainCamera")
            {
                //当碰撞的不是摄像机 那么直接移动摄像机的坐标
                transform.position = hit.point;
            }
        }
    }

    public void RaycastHandle()
    {
        Vector3 dir = transform.forward;
        Debug.DrawRay(TargetPosition, dir, Color.blue);

        //朝着摄像机的朝向方向发射射线
        RaycastHit hit;
        if (Physics.Raycast(transform.position, dir, out hit))
        {
            string name = hit.collider.gameObject.tag;
            //准星状态 TODO
        }
    }

    public void StartRotate()
    {
        camDir = transform.eulerAngles;
    }

    public void RotateCamera(Vector3 vec)
    {
        vec *= 0.01f;
        transform.eulerAngles = camDir + new Vector3(vec.y * 50f, vec.x * 50f, 0);
        Vector3 positon = TargetPosition;
        positon += -transform.forward * distance;
        transform.position = positon;
    }

    public void RotateHandle()
    {
        //if (JFConst.TouchBegin())
        //{
        //    StartRotate();
        //}

        ////当鼠标或者手指在触摸中时
        //if (JFConst.TouchIng())
        //{

        //    if (JFConst.startPos.x > Screen.width * 0.5f)
        //    {
        //        Vector3 vpos3 = JFConst.startPos; ;
        //        Vector2 vpos2 = new Vector2(vpos3.x, vpos3.y);
        //        Vector2 input = new Vector2(Input.mousePosition.x, Input.mousePosition.y);
        //        Vector3 dir = input - vpos2;
        //        RotateCamera(dir);
        //    }
        //}
    }

    public void RotateFollow()
    {
        bool follow = true;
        //计算相机与主角Y轴旋转角度的差。
        float abs = Mathf.Abs(transform.eulerAngles.y - target.eulerAngles.y);
        //abs等于180的时候标示摄像机完全面对这主角， 》130 《 230 表示让面对的角度左右偏移50度
        //这样做是不希望摄像机跟随主角，具体效果大家把代码下载下来看看，这样的摄像机效果很好。
        if (abs > 130 && abs < 230)
        {
            follow = false;
        }
        else
        {
            follow = true;
        }

        float wantedRotationAngle = target.eulerAngles.y;
        float currentRotationAngle = transform.eulerAngles.y;
        float currentHeight = transform.position.y;

        //主角面朝射线机 和背对射线机 计算正确的位置
        if (follow)
        {
            currentRotationAngle = Mathf.LerpAngle(currentRotationAngle, wantedRotationAngle, rotationDamping * Time.deltaTime);
            Quaternion currentRotation = Quaternion.Euler(transform.eulerAngles.x, currentRotationAngle, transform.eulerAngles.z);
            Vector3 positon = TargetPosition;
            positon -= currentRotation * Vector3.forward * distance;
            transform.position = Vector3.Lerp(transform.position, positon, 0.3f);
        }
        else
        {
            Vector3 positon = TargetPosition;
            Quaternion cr = Quaternion.Euler(transform.eulerAngles.x, currentRotationAngle, transform.eulerAngles.z);

            positon += cr * Vector3.back * distance;
            transform.position = Vector3.Lerp(transform.position, positon, 0.3f);
        }
    }
}