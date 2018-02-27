using UnityEngine;
using System.Collections;
using UnityEngine.EventSystems;

public class UIEventTrigger : UnityEngine.EventSystems.EventTrigger
{
	public delegate void VoidDelegate (GameObject go);
	public delegate void VectorDelegate(Vector2 delta);
    public delegate void PointerEventDataDelegate(PointerEventData eventData);

	public VoidDelegate onClick;
	public VoidDelegate onDown;
	public VoidDelegate onEnter;
	public VoidDelegate onExit;
	public VoidDelegate onUp;
	public VoidDelegate onSelect;

	public VectorDelegate onDrag;

    public PointerEventDataDelegate onPointerDown;
    public PointerEventDataDelegate onPointerUp;
    public PointerEventDataDelegate onDragBegin;
    public PointerEventDataDelegate onDragEnd;
    public PointerEventDataDelegate onDragging;
    public PointerEventDataDelegate onPointerClick;

    static public UIEventTrigger Get(UnityEngine.Object obj)
	{
        GameObject go = null;
        if (obj is Component)
            go = (obj as Component).gameObject;
        else if (obj is GameObject)
            go = (obj as GameObject);

        UIEventTrigger listener = go.GetComponent<UIEventTrigger>();
		if (listener == null) listener = go.AddComponent<UIEventTrigger>();
		return listener;
	}

	public override void OnPointerClick(PointerEventData eventData)
	{
		if(onClick != null) onClick(gameObject);
        if (onPointerClick != null) onPointerClick(eventData);
    }

	public override void OnPointerDown(PointerEventData eventData)
    {
		if(onDown != null) onDown(gameObject);
        if (onPointerDown != null) onPointerDown(eventData);
	}

	public override void OnPointerEnter(PointerEventData eventData)
    {
		if(onEnter != null) onEnter(gameObject);
	}

	public override void OnPointerExit(PointerEventData eventData)
    {
		if(onExit != null) onExit(gameObject);
	}

	public override void OnPointerUp(PointerEventData eventData)
    {
		if(onUp != null) onUp(gameObject);
        if (onPointerUp != null) onPointerUp(eventData);
	}

	public override void OnSelect(BaseEventData eventData)
    {
		if(onSelect != null) onSelect(gameObject);
	}

	public override void OnDrag(PointerEventData eventData)
	{
		if(onDrag != null) onDrag(eventData.delta);
        if (onDragging != null) onDragging(eventData);
	}

	public override void OnEndDrag(PointerEventData eventData)
	{
        if (onDragEnd != null) onDragEnd(eventData);
	}

    public override void OnBeginDrag(PointerEventData eventData)
    {
        if (onDragBegin != null) onDragBegin(eventData);
    }
}