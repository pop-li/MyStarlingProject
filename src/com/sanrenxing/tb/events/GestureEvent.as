package com.sanrenxing.tb.events
{
	import starling.events.Event;
	
	public class GestureEvent extends Event
	{
		public static const Gesture_SWIPE:String = "gestureSwipe";
		
		/**
		 * 纵向移动
		 * 值为1 代表向右滑动
		 * 值为-1 代表向左滑动
		 */
		public var offsetX:int;
		/**
		 * 纵向移动
		 * 值为1 代表向下滑动
		 * 值为-1 代表向上滑动
		 */
		public var offsetY:int;
		
		public function GestureEvent(offsetX:int,offsetY:int)
		{
			this.offsetX = offsetX;
			this.offsetY = offsetY;
			super(Gesture_SWIPE, data);
		}
	}
}