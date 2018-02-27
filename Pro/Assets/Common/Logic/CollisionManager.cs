using System;
using System.Collections.Generic;
using UnityEngine;

namespace L
{
    public class CollisionManager
    {
        private CollisionManager()
        {
            _raycastHits = new RaycastHit2D[maxCollection];
            _colliders = new Collider2D[maxCollection];
        }

        private static CollisionManager s_Instance = null;

        public static CollisionManager Instance
        {
            get
            {
                if (s_Instance == null)
                {
                    s_Instance = new CollisionManager();
                }
                return s_Instance;
            }
        }

        public static int maxCollection = 100;
        protected int _checkLayer;
        private Collider2D _collider;
        private Transform _transform;

        // RaycastHit2D
        private RaycastHit2D[] _raycastHits;
        protected List<RaycastHit2D> _castList = new List<RaycastHit2D>();
        protected Vector3 _dir = Vector3.zero;
        protected float _dis;
        protected int _castLen;

        // Collider2D
        private Collider2D[] _colliders;
        private int _cldLen;

        public Collider2D Collider
        {
            get
            {
                if (_collider == null)
                    _collider = _transform.GetComponent<Collider2D>();

                return _collider;
            }
        }

        public void GetCurrentCast(Vector2 dir, float distance)
        {
            Vector3 pos = _transform.position + new Vector3(Collider.offset.x, Collider.offset.y, 0);
            if (Collider is BoxCollider2D)
            {
                _castLen = Physics2D.BoxCastNonAlloc(pos, (Collider as BoxCollider2D).size, 0, dir, _raycastHits, distance, _checkLayer);
            }
            else if (Collider is CircleCollider2D)
            {
                _castLen = Physics2D.CircleCastNonAlloc(pos, (Collider as CircleCollider2D).radius, dir, _raycastHits, distance, _checkLayer);
            }
        }

        public Vector3 CheckCollision(Transform transform, int checkLayer, Vector3 moves)
        {
            _castList.Clear();

            _checkLayer = checkLayer;
            _transform = transform;
            ICollisionHandler ich = _transform.GetComponent<ICollisionHandler>();
            if (ich == null) { return moves; }

            _dir = moves.normalized;
            _dis = moves.magnitude;

            if (_dir == Vector3.zero)
                return moves;
            
            GetCurrentCast(_dir, _dis);
            for (int i = 0; i < _castLen; i++)
            {
                RaycastHit2D hitData = _raycastHits[i];
                if (hitData.collider.gameObject == _transform.gameObject)
                    continue;

                // only handle forward
                if (Vector3.Dot(_dir, hitData.normal) >= 0)
                    continue;

                _castList.Add(hitData);
            }

            if (_castList.Count == 0)
                return moves;

            if (_castList.Count > 1)
                _castList.Sort(Sort);
            int len = _castList.Count;
            for (int i = 0; i < len; i++)
            {
                RaycastHit2D hitData = _castList[i];
                ICollisionHandler hit = hitData.collider.gameObject.GetComponent<ICollisionHandler>();
                if (hit == null) { continue; }
                ich.OnRaycastHitHandle(hitData);
                if (hit.OnCollisionHandle(hitData, _transform.gameObject))
                {
                    Vector3 pos = hitData.centroid - Collider.offset;
                    moves = pos - _transform.position;
                    return moves;
                }
            }

            return moves;
        }

        private int Sort(RaycastHit2D item1, RaycastHit2D item2)
        {
            float dis1 = item1.distance;
            float dis2 = item2.distance;

            if (dis1 > dis2)
                return -1;

            if (dis1 < dis2)
                return 1;

            return 0;
        }

        public void GetCurrentOverlap()
        {
            if (Collider is BoxCollider2D)
            {
                Bounds bounds = (Collider as BoxCollider2D).bounds;
                _cldLen = Physics2D.OverlapAreaNonAlloc(bounds.min, bounds.max, _colliders, _checkLayer);
            }
            else if (Collider is CircleCollider2D)
            {
                Vector3 pos = _transform.position + new Vector3(Collider.offset.x, Collider.offset.y, 0);
                _cldLen = Physics2D.OverlapCircleNonAlloc(pos, (Collider as CircleCollider2D).radius, _colliders, _checkLayer);
            }
        }

        public void CheckOverlap(Transform transform, int checkLayer)
        {
            _checkLayer = checkLayer;
            _transform = transform;
            GetCurrentOverlap();
            for (int i = 0; i < _cldLen; i++)
            {
                Collider2D cldData = _colliders[i];
                if (cldData.gameObject == _transform.gameObject)
                    continue;

                // TODO
            }
        }
    }
}
