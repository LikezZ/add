
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;

/// <summary>
/// Base class for all tweening operations.
/// </summary>

public abstract class UITweener : MonoBehaviour
{
    /// <summary>
    /// Current tween that triggered the callback function.
    /// </summary>
    [HideInInspector]
    public Tweener tweener;

	/// <summary>
	/// Tweening method used.
	/// </summary>

	[HideInInspector]
	public Ease method = Ease.Linear;

	/// <summary>
	/// The tween loop type
	/// </summary>

	[HideInInspector]
	public LoopType style = LoopType.Restart;

	/// <summary>
	/// Optional curve to apply to the tween's time factor value.
	/// </summary>

	[HideInInspector]
	public AnimationCurve animationCurve = new AnimationCurve(new Keyframe(0f, 0f, 0f, 1f), new Keyframe(1f, 1f, 1f, 0f));

	/// <summary>
	/// Whether the tween will ignore the timescale, making it work while the game is paused.
	/// </summary>
	
	[HideInInspector]
	public bool ignoreTimeScale = true;

    /// <summary>
    /// Whether the tween will loop
    /// </summary>

    [HideInInspector]
    public bool isLoop = false;

    /// <summary>
    /// the tween loop times
    /// </summary>

    [HideInInspector]
    public int loopCount = -1;

    /// <summary>
    /// How long will the tweener wait before starting the tween?
    /// </summary>

    [HideInInspector]
	public float delay = 0f;

	/// <summary>
	/// How long is the duration of the tween?
	/// </summary>

	[HideInInspector]
	public float duration = 1f;

	/// <summary>
	/// Used by buttons and tween sequences. Group of '0' means not in a sequence.
	/// </summary>

	[HideInInspector]
	public int tweenGroup = 0;

    /// <summary>
    /// the onComplete callback for the tween.
    /// </summary>

    [HideInInspector]
    public TweenCallback callBack;

    /// <summary>
    /// Whether the tween is started
    /// </summary>

    private bool isStart = false;

    /// <summary>
    /// Update as soon as it's started so that there is no delay.
    /// </summary>

    void Start ()
    {
        if (!isStart)
            PlayForward();   
    }

    /// <summary>
    /// Update Tween.
    /// </summary>

    public virtual void UpdateTweener()
    {
        if (tweener != null)
        {
            tweener.SetDelay(delay);
            tweener.SetUpdate(ignoreTimeScale);
            if (isLoop)
            {
                tweener.SetLoops(loopCount, style);
            }
            tweener.SetEase(method);
            tweener.OnComplete(callBack);
        }
    }

	/// <summary>
	/// Play the tween forward.
	/// </summary>

	public void PlayForward () { Play(true); }

	/// <summary>
	/// Play the tween in reverse.
	/// </summary>
	
	public void PlayReverse () { Play(false); }

	/// <summary>
	/// Manually activate the tweening process, reversing it if necessary.
	/// </summary>

	public void Play (bool forward)
	{
        if (!isStart)
        {
            isStart = true;
            UpdateTweener();
        }
        if (forward)
            tweener.PlayForward();
        else
            tweener.PlayBackwards();
    }

    /// <summary>
    /// Rewind Tween.
    /// </summary>

    public void RewindTweener()
    {
        if (tweener != null)
        {
            tweener.Rewind();
        }
    }

    /// <summary>
    /// Restart Tween.
    /// </summary>

    public void RestartTweener()
    {
        if (tweener != null)
        {
            tweener.Restart();
        }
    }
}
