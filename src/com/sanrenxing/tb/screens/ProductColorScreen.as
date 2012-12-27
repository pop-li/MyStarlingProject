package com.sanrenxing.tb.screens
{
	import com.sanrenxing.tb.components.Product;
	import com.sanrenxing.tb.components.ProductDetailContainer;
	import com.sanrenxing.tb.events.GestureEvent;
	import com.sanrenxing.tb.models.ModelLocator;
	import com.sanrenxing.tb.vos.ProductVO;
	
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	
	[Event(name="toProductHeatScreen",type="starling.events.Event")]
	
	public class ProductColorScreen extends Screen
	{
		private var data:ProductVO;
		
		private var _container:ProductDetailContainer;
		private var _colorPane:ScrollContainer;
		private var _product:Product;
		
		private var _model:ModelLocator=ModelLocator.getInstance();
		
		public function ProductColorScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			data = _model.currentProduct;
			
			this._container = new ProductDetailContainer();
			this._container.addEventListener(GestureEvent.Gesture_SWIPE,onGestureHandler);
			this.addChild(_container);
			
			_product = new Product(data);
			_container.addChild(_product);
			
			_colorPane = new ScrollContainer();
			_container.addChild(_colorPane);
			
		}
		
		override protected function draw():void
		{
			this._container.width = this.actualWidth;
			this._container.height = this.actualHeight;
			
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
		
		private function onGestureHandler(event:GestureEvent):void
		{
			if(event.offsetY == 1) {
				this.dispatchEvent(new Event("toProductHeatScreen"));
			}
		}
	}
}