package com.sanrenxing.tb.screens
{
	import com.sanrenxing.tb.components.Product;
	import com.sanrenxing.tb.models.ModelLocator;
	import com.sanrenxing.tb.vos.ProductVO;
	
	import flash.geom.Point;
	
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	[Event(name="toProductHeatScreen",type="starling.events.Event")]
	
	public class ProductColorScreen extends ScrollContainer
	{
		private var data:ProductVO;
		
		private var _colorPane:ScrollContainer;
		private var _product:Product;
		
		private var _model:ModelLocator=ModelLocator.getInstance();
		
		public function ProductColorScreen()
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
			
			_product = new Product(data);
			this.addChild(_product);
			
			_colorPane = new ScrollContainer();
			this.addChild(_colorPane);
			
			this.addEventListener(TouchEvent.TOUCH,onTouchHandler);
			
		}
		
		protected function initUI():void
		{
			_product.x = this.width/2;
			_product.y = this.height/2;
			
			var _colorPaneLayout:VerticalLayout = new VerticalLayout();
			_colorPaneLayout.gap = 5;
			_colorPaneLayout.paddingTop = 5;
			_colorPane.layout = _colorPaneLayout;
			_colorPane.y = -_colorPane.height;
			
			var _colorPaneTween:Tween= new Tween(_colorPane,0.7,Transitions.EASE_OUT_BACK);
			_colorPaneTween.animate("y",0);
			Starling.juggler.add(_colorPaneTween);
		}
		
		private function onTouchHandler(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(this);
			
			trace(this.horizontalScrollPosition + "        " + this.verticalScrollPosition);
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
				
//				if(sizeDiff>1) {
//					if(_pictureGap>=_model.pictureMaxGap) return;
//					_pictureGap+=20;
//				} else {
//					if(_pictureGap<=0) return;
//					_pictureGap-=20;
//				}
//				
//				var length:int = pictureVector.length;
//				for(var i:int=0;i<length;i++) {
//					pictureVector[i].x = pictureVector[0].x + _pictureGap*i;
//					trace("pictureVector[i].initAngle   " +  pictureVector[i].initAngle + "_pictureGap/_model.pictureMaxGap   " + (_pictureGap/_model.pictureMaxGap));
//					
//					pictureVector[i].angle = pictureVector[i].initAngle*(1-(_pictureGap/_model.pictureMaxGap));
//				}
			}
		}
		
	}
}