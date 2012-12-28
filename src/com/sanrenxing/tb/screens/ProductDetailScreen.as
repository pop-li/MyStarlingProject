package com.sanrenxing.tb.screens
{
	import com.sanrenxing.tb.components.ProductDetailContainer;
	import com.sanrenxing.tb.events.GestureEvent;
	import com.sanrenxing.tb.models.ModelLocator;
	
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.layout.VerticalLayout;
	
	public class ProductDetailScreen extends Screen
	{
		private var _container:ProductDetailContainer;
		private var _model:ModelLocator=ModelLocator.getInstance();
		
		private var _screenVector:Vector.<ScrollContainer>=new Vector.<ScrollContainer>();
		private var _curScreenIndex:int;
		private var _colorScreen:ProductColorScreen;
		private var _heatScreen:ProductHeatScreen;
		private var _viewScreen:ProductShowScreen;
		
		public function ProductDetailScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			var layout:VerticalLayout = new VerticalLayout();
			
			this._container = new ProductDetailContainer();
			this._container.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			this._container.addEventListener(GestureEvent.Gesture_SWIPE,onGestureSwipeHandler);
			this._container.scrollerProperties.snapToPages = true;
			this.addChild(_container);
			
			this._container.layout = layout;
			
			_colorScreen = new ProductColorScreen();
			_colorScreen.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
//			_colorScreen.addEventListener(GestureEvent.Gesture_SWIPE,onGestureSwipeHandler);
			this._container.addChild(_colorScreen);
			_heatScreen =  new ProductHeatScreen();
			_heatScreen.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
//			_heatScreen.addEventListener(GestureEvent.Gesture_SWIPE,onGestureSwipeHandler);
			this._container.addChild(_heatScreen);
			_viewScreen = new ProductShowScreen();
			_viewScreen.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
//			_viewScreen.addEventListener(GestureEvent.Gesture_SWIPE,onGestureSwipeHandler);
			this._container.addChild(_viewScreen);
			
			_screenVector.push(_colorScreen,_heatScreen,_viewScreen);
		}
		
		override protected function draw():void
		{
			this._container.width = this.actualWidth;
			this._container.height = this.actualHeight;
			
			_colorScreen.width = this.actualWidth;
			_colorScreen.height = this.actualHeight;
			_colorScreen.init();
			_heatScreen.width = this.actualWidth;
			_heatScreen.height = this.actualHeight;
			_heatScreen.init();
			_viewScreen.width = this.actualWidth;
			_viewScreen.height = this.actualHeight;
			_viewScreen.init();
		}
		
		private function onGestureSwipeHandler(event:GestureEvent):void
		{
			if(event.offsetY == -1) {
				if(_curScreenIndex==_screenVector.length-1) {
					return;
				}
				trace(_container.verticalPageIndex);
//				this._container.verticalScrollPosition = _heatScreen.y;
				_container.scrollToPageIndex(0,++_curScreenIndex,1);
				trace(_container.verticalPageIndex);
			} else if(event.offsetY == 1) {
				if(_curScreenIndex==0) {
					return;
				}
				_container.scrollToPageIndex(0,--_curScreenIndex,1);
			}
		}
		
	}
}