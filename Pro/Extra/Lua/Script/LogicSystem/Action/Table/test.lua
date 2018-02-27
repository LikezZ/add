-- define test
-- %Name[测试]%
-- %Describe[测试动作]%

local test = {
	{
		mId = 2,
		mTrigger = {mType = "event", mEvent = "finish:6"},
		mParams = {mActor = "role", mShow = 1, mSyslangId = 6828, mDuration = 2.00, mDelay = 0.00},
		mHandler = "ComShowTalkActionHandler"
	},
	{
		mId = 3,
		mTrigger = {mType = "event", mEvent = "finish:22"},
		mParams = {mDelay = 0.00},
		mHandler = "DoManagerEndActionHandler"
	},
	{
		mId = 4,
		mTrigger = {mType = "event", mEvent = "finish:8"},
		mParams = {mActor = "trans", mMoveToTime = 0.00, mMoveX = 14.00, mMoveY = 0.00, mMoveZ = 25.00, mDelay = 0.00, mPosType = 0},
		mHandler = "ComMoveToPosActionHandler"
	},
	{
		mId = 8,
		mTrigger = {mType = "event", mEvent = "finish:1"},
		mParams = {mTrans = "trans", mPath = "h-0-2", mDelay = 0.00},
		mHandler = "ComFindTransformActionGetter"
	},
	{
		mId = 9,
		mTrigger = {mType = "event", mEvent = "finish:4"},
		mParams = {mTrans = "cam", mPath = "TraceCamera/Animator/Camera", mDelay = 0.00},
		mHandler = "ComFindTransformActionGetter"
	},
	{
		mId = 10,
		mTrigger = {mType = "event", mEvent = "finish:9"},
		mParams = {mTrans = "cam", mActive = 1, mDelay = 0.00},
		mHandler = "ComActiveTransActionGetter"
	},
	{
		mId = 11,
		mTrigger = {mType = "event", mEvent = "finish:13"},
		mParams = {mActor = "cam", mTarget = "trans", mDuration = 0.00, mOffsetX = 0.00, mOffsetY = 1.00, mOffsetZ = 0.00, mDelay = 0.00},
		mHandler = "ComLookAtActionHandler"
	},
	{
		mId = 12,
		mTrigger = {mType = "event", mEvent = "finish:21"},
		mParams = {mTrans = "cam", mActive = 0, mDelay = 0.00},
		mHandler = "ComActiveTransActionGetter"
	},
	{
		mId = 13,
		mTrigger = {mType = "event", mEvent = "finish:10"},
		mParams = {mActor = "cam", mMoveToTime = 0.00, mPosType = 0, mMoveX = 20.00, mMoveY = 3.00, mMoveZ = 18.00, mDelay = 0.00},
		mHandler = "ComMoveToPosActionHandler"
	},
	{
		mId = 14,
		mTrigger = {mType = "event", mEvent = "finish:10"},
		mParams = {mTrans = "main", mPath = "Camera_V/Camera_H/Main Camera", mDelay = 0.00},
		mHandler = "ComFindTransformActionGetter"
	},
	{
		mId = 15,
		mTrigger = {mType = "event", mEvent = "finish:14"},
		mParams = {mTrans = "main", mActive = 0, mDelay = 0.00},
		mHandler = "ComActiveTransActionGetter"
	},
	{
		mId = 16,
		mTrigger = {mType = "event", mEvent = "finish:12"},
		mParams = {mTrans = "main", mActive = 1, mDelay = 0.00},
		mHandler = "ComActiveTransActionGetter"
	},
	{
		mId = 17,
		mTrigger = {mType = "event", mEvent = "finish:21"},
		mParams = {mActor = "cam", mMoveToTime = 0.00, mPosType = 1, mMoveX = 0.00, mMoveY = 0.00, mMoveZ = 0.00, mDelay = 0.00},
		mHandler = "ComMoveToPosActionHandler"
	},
	{
		mId = 18,
		mTrigger = {mType = "event", mEvent = "finish:21"},
		mParams = {mActor = "cam", mDoType = 1, mRotateTime = 0.00, mRotateX = 0.00, mRotateY = 0.00, mRotateZ = 0.00, mDelay = 0.00},
		mHandler = "ComRotateToActionHandler"
	},
	{
		mId = 19,
		mTrigger = {mType = "event", mEvent = "finish:2"},
		mParams = {mActor = "role", mShow = 1, mSyslangId = 6829, mDuration = 3.00, mDelay = 0.00},
		mHandler = "ComShowTalkActionHandler"
	},
	{
		mId = 21,
		mTrigger = {mType = "event", mEvent = "finish:11"},
		mParams = {mActor = "cam", mTarget = "trans", mDuration = 5.00, mOffsetX = 0.00, mOffsetY = 0.00, mOffsetZ = 0.00, mDelay = 0.00},
		mHandler = "ComFollowToActionHandler"
	},
};
return test
