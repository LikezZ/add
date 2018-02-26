using UnityEngine;

/// <summary>
/// ui自适应屏幕
/// </summary>
public class UIResize : MonoBehaviour
{
    RectTransform rtf;
    void OnEnable()
    {
        rtf = GetComponent<RectTransform>();
        Resize();
    }

    public void Resize()
    {
        if (rtf.sizeDelta != Vector2.zero)
            rtf.sizeDelta = Vector2.zero;
        if (rtf.anchorMax != Vector2.one)
            rtf.anchorMax = Vector2.one;
        if (rtf.anchorMin != Vector2.zero)
            rtf.anchorMin = Vector2.zero;
        if (rtf.anchoredPosition != Vector2.zero)
            rtf.anchoredPosition = Vector2.zero;

        rtf.pivot = Vector2.one / 2f;
        if (rtf.localScale != Vector3.one)
            rtf.localScale = Vector3.one;
    }
}
