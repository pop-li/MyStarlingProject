package com.sanrenxing.tb.components
{
	import com.sanrenxing.tb.events.GestureEvent;
	
	import flash.geom.Point;
	
	import feathers.controls.ScrollContainer;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	[Event(name="gestureSwipe",type="com.sanrenxing.tb.events.GestureEvent")]
	
	public class ProductDetailContainer extends ScrollContainer
	{
		private var firY:int;
		private var firX:int;
		
		/**
		 * 当前手势标记
		 * 0为默认
		 * 1为一手指move
		 * 2为两手指zoom
		 * 3为禁用
		 */
		private var _isGestureFlag:int = 0;
		
		public function set isGestureFlag(value:int):void
		{
			_isGestureFlag = value;
		}
		
		public function ProductDetailContainer()
		{
			super();
			
			this.addEventListener(TouchEvent.TOUCH,onTouchHandler);
		}
		
		private function onTouchHandler(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(stage);
			
			var len:int = touches.length;
			
			if(len == 1) {
				if(_isGestureFlag == 2 || _isGestureFlag == 3) return;
				
				var touch:Touch = touches[0];
				
				var pos:Point = touch.getLocation(this);
				if(touch.phase == "began") {
					firX = pos.x;
					firY = pos.y;
				} else if(touch.phase == "moved") { 
					if(_isGestureFlag == 1) return;
					
					if(pos.y - firY>20) {
						this.dispatchEvent(new GestureEvent(0,1));
						_isGestureFlag = 1;
					} else if(firY - pos.y>20) {
						this.dispatchEvent(new GestureEvent(0,-1));
						_isGestureFlag = 1;
					} else if(pos.x - firX>20) {
						this.dispatchEvent(new GestureEvent(1,0));
						_isGestureFlag = 1;
					} else if(firX - pos.x>20) {
						this.dispatchEvent(new GestureEvent(-1,0));
						_isGestureFlag = 1;
					}
				}
			} else if(len == 2) {
				_isGestureFlag = 2;
			}
			
			for(var i:int=0;i<len;i++) {
				if(touches[i].phase != "ended") {
					return;
				}
			}
			_isGestureFlag = 0;
			
//			trace("touch.globalX   " + touch.globalX + "     touch.globalY   " + touch.globalY);
//			trace("touch.pressure   " + touch.pressure);
//			trace("touch.previousGlobalX   " + touch.previousGlobalX + "     touch.previousGlobalY   " + touch.previousGlobalY);
//			trace("touch.tapCount   " + touch.tapCount);
//			trace("touch.timestamp   " + touch.timestamp);
//			trace("touch.width   " + touch.width);
//			trace("----------------------");
		}
		
	}
}