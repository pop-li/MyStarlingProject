package com.sanrenxing.tb.components
{
	import com.sanrenxing.tb.events.GestureEvent;
	
	import flash.geom.Point;
	
	import feathers.controls.ScrollContainer;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	public class ProductDetailContainer extends ScrollContainer
	{
		private var firY:int;
		
		public function ProductDetailContainer()
		{
			super();
			
			this.addEventListener(TouchEvent.TOUCH,onTouchHandler);
		}
		
		private function onTouchHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(stage); 
			var pos:Point = touch.getLocation(stage); //相对于stage的坐标
			
			if(touch.phase == "began") {
				firY = pos.y;
			} else if(touch.phase == "moved") {
				if(pos.y - firY>20) {
					this.dispatchEvent(new GestureEvent(0,1));
				} else if(firY - pos.y>20) {
					this.dispatchEvent(new GestureEvent(0,-1));
				}
			}
			
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