
using UnityEngine;
using DG.Tweening;

/// <summary>
/// Tween the object's position.
/// </summary>

[AddComponentMenu("Tween/Tween Position")]
public class TweenPosition : UITweener
{
	public Vector3 to;
    public bool worldSpace = false;

    public override void UpdateTweener()
    {
        if (worldSpace)
            tweener = transform.DOMove(to, duration);
        else
            tweener = transform.DOLocalMove(to, duration);
        base.UpdateTweener();
    }
}
