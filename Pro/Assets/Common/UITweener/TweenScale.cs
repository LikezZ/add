
using UnityEngine;
using DG.Tweening;

/// <summary>
/// Tween the object's local scale.
/// </summary>

[AddComponentMenu("Tween/Tween Scale")]
public class TweenScale : UITweener
{
	public Vector3 to = Vector3.one;

    public override void UpdateTweener()
    {
        tweener = transform.DOScale(to, duration);
        base.UpdateTweener();
    }
}
