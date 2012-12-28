package com.sanrenxing.tb.screens
{
	import com.sanrenxing.tb.components.Product;
	import com.sanrenxing.tb.events.GestureEvent;
	import com.sanrenxing.tb.models.ModelLocator;
	import com.sanrenxing.tb.vos.ProductVO;
	
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	
	public class ProductHeatScreen extends ScrollContainer
	{
		private var data:ProductVO;
		
		private var _colorPane:ScrollContainer;
		private var _product:Product;
		
		private var _model:ModelLocator=ModelLocator.getInstance();
		
		public function ProductHeatScreen()
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
//			this.addChild(_product);
			
			_colorPane = new ScrollContainer();
			this.addChild(_colorPane);
			
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
		
		private function onGestureHandler(event:GestureEvent):void
		{
			if(event.offsetY == -1) {
				this.dispatchEvent(new Event("toProductColorScreen"));
			} else if(event.offsetY == 1) {
				this.dispatchEvent(new Event("toProductShowScreen"));
			}
		}
	}
}