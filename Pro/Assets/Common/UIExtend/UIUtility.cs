using System;
using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using UnityEngine.Events;

public class UIUtility
{

    #region UI Tools
    private static float offset = 0f;
    public static float Offset
    {
        get
        {
            if (offset == 0f)
            {
                GameObject root = GameObject.Find("MainUI");
                CanvasScaler canvasScaler = root.GetComponent<CanvasScaler>();
                offset = (Screen.width / canvasScaler.referenceResolution.x) * (1 - canvasScaler.matchWidthOrHeight)
                    + (Screen.height / canvasScaler.referenceResolution.y) * canvasScaler.matchWidthOrHeight;
            }
            return offset;
        }
    }

    public static Vector3 WorldPosToUiPos(Vector3 worldPos)
    {
        Vector2 vec = RectTransformUtility.WorldToScreenPoint(Camera.main, worldPos);
        return new Vector3(vec.x / Offset, vec.y / Offset, 0f);
    }

    public static Vector3 UIWorldPosToScreenPos(Vector3 uiPos)
    {
        GameObject root = GameObject.Find("MainUI");
        Camera uiCamera = ComponentTool.FindChildComponent<Camera>("Camera", root);
        Vector2 vec = RectTransformUtility.WorldToScreenPoint(uiCamera, uiPos);
        return new Vector3(vec.x / Offset, vec.y / Offset, 0f);
    }

    public static Vector2 GetViewSize()
    {
        return new Vector2(Screen.width / Offset, Screen.height / Offset);
    }
    #endregion

    #region Camera Tools
    public static void FixCameraSize(Camera sceneCamera, Vector2 min, Vector2 max, out Vector2 outMin, out Vector2 outMax, float dis = 12f)
    {
        var conners = GetCorners(sceneCamera, dis);
        float w = conners[1].x - conners[3].x;
        w *= 0.5f;
        w = Mathf.Abs(w);
        float h = conners[1].y - conners[3].y;
        h *= 0.5f;
        h = Mathf.Abs(h);
        Vector2 half = new Vector2(w, h);
        outMin = min + half;
        outMax = max - half;
        if (outMin.x > outMax.x)
        {
            var x = (outMin.x + outMax.x) / 2;
            outMin.x = x;
            outMax.x = x;
        }
        if (outMin.y > outMax.y)
        {
            var y = (outMin.y + outMax.y) / 2;
            outMin.y = y;
            outMax.y = y;
        }
    }

    public static Vector3[] GetCorners(Camera theCamera, float distance)
    {
        Transform tx = theCamera.transform;
        Vector3[] corners = new Vector3[4];

        if (theCamera.orthographic)
        {
            float height = theCamera.orthographicSize;
            float rate = (float)(Screen.width) / (float)(Screen.height);
            float width = rate * height;

            // UpperLeft
            corners[0] = tx.position - (tx.right * width);
            corners[0] += tx.up * height;

            // UpperRight
            corners[1] = tx.position + (tx.right * width);
            corners[1] += tx.up * height;

            // LowerRight
            corners[2] = tx.position + (tx.right * width);
            corners[2] -= tx.up * height;

            // LowerLeft
            corners[3] = tx.position - (tx.right * width);
            corners[3] -= tx.up * height;
        }
        else
        {
            float halfFOV = (theCamera.fieldOfView * 0.5f) * Mathf.Deg2Rad;
            float aspect = theCamera.aspect;

            float height = distance * Mathf.Tan(halfFOV);
            float width = height * aspect;

            // UpperLeft
            corners[0] = tx.position - (tx.right * width);
            corners[0] += tx.up * height;
            corners[0] += tx.forward * distance;

            // UpperRight
            corners[1] = tx.position + (tx.right * width);
            corners[1] += tx.up * height;
            corners[1] += tx.forward * distance;

            // LowerRight
            corners[2] = tx.position + (tx.right * width);
            corners[2] -= tx.up * height;
            corners[2] += tx.forward * distance;

            // LowerLeft
            corners[3] = tx.position - (tx.right * width);
            corners[3] -= tx.up * height;
            corners[3] += tx.forward * distance;
        }
        return corners;
    }
    #endregion
}
