package com.sanrenxing.tb.screens
{
	import com.sanrenxing.tb.components.ProductClassBox;
	import com.sanrenxing.tb.models.CustomComponentTheme;
	import com.sanrenxing.tb.models.ModelLocator;
	import com.sanrenxing.tb.vos.ProductClassVO;
	
	import flash.geom.Point;
	
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.layout.HorizontalLayout;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	[Event(name="toProductList",type="starling.events.Event")]
	
	public class ProductClassScreen extends Screen
	{
		public var data:ProductClassVO;
		
		private var _model:ModelLocator = ModelLocator.getInstance();
		
		private var _container:ScrollContainer;
		
		private var _productClassList:Vector.<ProductClassBox> = new Vector.<ProductClassBox>();
		
		private var isMove:Boolean = false;
		private var firX:int = 0;
		private var firY:int = 0;
		
		public function ProductClassScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			const layout:HorizontalLayout = new HorizontalLayout();
			layout.verticalAlign=HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			layout.paddingLeft = 50;
			layout.gap = 50;
			
			this._container = new ScrollContainer();
			this._container.layout = layout;
			//when the scroll policy is set to on, the "elastic" edges will be
			//active even when the max scroll position is zero
			this._container.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON;
//			this._container.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			this._container.scrollerProperties.snapScrollPositionsToPixels = true;
//			this._container.nameList.add(CustomComponentTheme.MAIN_BACKGROUND);
			this.addChild(this._container);
			
			var productClassBox:ProductClassBox;
			const classLength:int = _model.productVector.length;
			for(var i:int=0;i<classLength;i++) {
				productClassBox = new ProductClassBox(_model.productVector[i]);
				productClassBox.visible = false;
				productClassBox.addEventListener(TouchEvent.TOUCH, onTouch); 
				_productClassList.push(productClassBox);
				this._container.addChild(productClassBox);
			}
			
		}
		
		override protected function draw():void
		{
			this._container.width = this.actualWidth;
			this._container.height = this.actualHeight;
			
			var productClassBox:ProductClassBox;
			const classLength:int = _model.productVector.length;
			for(var i:int=0;i<classLength;i++) {
				productClassBox = _productClassList[i];
				Starling.juggler.delayCall(productClassBox.showEffect,i*0.5);
			}
		}
		
		private function onTouch (e:TouchEvent):void 
		{ 
			// get the mouse location related to the stage 
			var touch:Touch = e.getTouch(stage); 
			var pos:Point = touch.getLocation(stage); 
//			var classBtn:ProductClassBox = e.currentTarget as ProductClassBox;
			
			if(touch.phase == "began") {
				firX = pos.x;
				firY = pos.y;
			}
			
			if(touch.phase == "ended") {
				if(isMove) {
					isMove=false;
				} else {
					toProductListScreen((e.currentTarget as ProductClassBox).data);
				}
			}
			
			if(touch.phase == "moved") {
				if(Math.abs(pos.x-firX)>20||Math.abs(pos.y-firY)>20) {
					isMove = true;
				}
			}
		}
		
		protected function toProductListScreen(data:ProductClassVO):void
		{
			_model.currentProductClass = data;
			this.dispatchEvent(new Event("toProductList"));
		}
	}
}