
using UnityEngine;
using DG.Tweening;

/// <summary>
/// Tween the object's rotation.
/// </summary>

[AddComponentMenu("Tween/Tween Rotation")]
public class TweenRotation : UITweener
{
	public Vector3 to;
    public bool worldSpace = false;

    public override void UpdateTweener()
    {
        if (worldSpace)
            tweener = transform.DORotate(to, duration);
        else
            tweener = transform.DOLocalRotate(to, duration);
        base.UpdateTweener();
    }
}
