package com.sanrenxing.tb.screens
{
	import com.sanrenxing.tb.components.PictureBox;
	import com.sanrenxing.tb.models.ModelLocator;
	import com.sanrenxing.tb.vos.ProductVO;
	
	import flash.geom.Point;
	
	import feathers.controls.ScrollContainer;
	import feathers.events.FeathersEventType;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	public class ProductPictureScreen extends ScrollContainer
	{
		private var data:ProductVO;
		
		private var _container:ScrollContainer;
		
		private var pictureVector:Vector.<PictureBox> = new Vector.<PictureBox>;
		
		private var _model:ModelLocator=ModelLocator.getInstance();
		
		private var _pictureGap:int;
		
		public function ProductPictureScreen()
		{
			super();
		}
		
		public function init():void
		{
			initData();
			initUI();
		}
		
		protected function initData():void
		{
			data = _model.currentProduct;
			
			this.addEventListener(TouchEvent.TOUCH,onTouchHandler);
		}
		
		protected function initUI():void
		{
			var picturesLength:int = data.productPicture.length;
			_pictureGap = 0;
			for(var i:int=0;i<picturesLength;i++) {
				var picture:PictureBox = new PictureBox(data.productPicture[i]);
				picture.initAngle = (Math.ceil(Math.random()*10))*4-20;
				picture.angle = picture.initAngle;
				picture.x = this.actualWidth/2;
				picture.y = this.actualHeight/2;
				pictureVector.push(picture);
				this.addChild(picture);
			}
		}
		
		private function onTouchHandler(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(stage);
			
			var length:int = pictureVector.length;
			trace(touches.length);
			if(touches.length == 2) {
				
				var touchA:Touch = touches[0];
				var touchB:Touch = touches[1];
				
				var currentPosA:Point  = touchA.getLocation(parent);
				var previousPosA:Point = touchA.getPreviousLocation(parent);
				var currentPosB:Point  = touchB.getLocation(parent);
				var previousPosB:Point = touchB.getPreviousLocation(parent);
				
				var currentVector:Point  = currentPosA.subtract(currentPosB);
				var previousVector:Point = previousPosA.subtract(previousPosB);
				
				var sizeDiff:Number = currentVector.length / previousVector.length;
				trace(sizeDiff);
				
				if(sizeDiff>1) {
					if(_pictureGap>=_model.pictureMaxGap) return;
					_pictureGap+=20;
				} else {
					if(_pictureGap<=0) return;
					_pictureGap-=20;
				}
				
				
				for(var i:int=0;i<length;i++) {
					Starling.juggler.removeTweens(pictureVector[i]);
					
					pictureVector[i].x = pictureVector[0].x + _pictureGap*i;
					trace("pictureVector[i].initAngle   " +  pictureVector[i].initAngle + "_pictureGap/_model.pictureMaxGap   " + (_pictureGap/_model.pictureMaxGap));
					
					pictureVector[i].angle = pictureVector[i].initAngle*(1-(_pictureGap/_model.pictureMaxGap));
				}
				if(pictureVector[0]) {
					pictureVector[0].dispatchEvent(new Event(FeathersEventType.RESIZE,false));
				}
				
				if(touches[0].phase == "ended" || touches[1].phase == "ended") {
					if(_pictureGap>_model.productWidth/2) {
						for(var a:int=1;a<length;a++) {
							var openTween:Tween = new Tween(pictureVector[a],1,Transitions.EASE_OUT);
							_pictureGap = _model.pictureMaxGap;
							openTween.animate("x",pictureVector[0].x + _pictureGap*a);
							openTween.animate("angle",0);
							Starling.juggler.add(openTween);
						}
					} else {
						for(var b:int=1;b<length;b++) {
							var closeTween:Tween = new Tween(pictureVector[b],1,Transitions.EASE_OUT);
							_pictureGap = 0;
							closeTween.animate("x",pictureVector[0].x);
							closeTween.animate("angle",pictureVector[b].initAngle);
							Starling.juggler.add(closeTween);
						}
					}
				}
//				this.removeChildAt(0);
			}
		}
		
	}
}