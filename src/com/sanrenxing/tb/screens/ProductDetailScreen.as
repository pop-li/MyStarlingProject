package com.sanrenxing.tb.screens
{
	import com.sanrenxing.tb.components.ColorButton;
	import com.sanrenxing.tb.components.ProductDetailContainer;
	import com.sanrenxing.tb.events.GestureEvent;
	import com.sanrenxing.tb.models.CustomComponentTheme;
	import com.sanrenxing.tb.models.ModelLocator;
	import com.sanrenxing.tb.utils.Assets;
	
	import flash.events.KeyboardEvent;
	
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.skins.Scale9ImageStateValueSelector;
	
	import flashx.textLayout.formats.VerticalAlign;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	public class ProductDetailScreen extends Screen
	{
		private var _container:ProductDetailContainer;
		private var _controlPane:ScrollContainer;
		private var _colorPane:ScrollContainer;
		private var _model:ModelLocator=ModelLocator.getInstance();
		
		private var _screenVector:Vector.<ScrollContainer>=new Vector.<ScrollContainer>();
		private var _curScreenIndex:int;
		private var _colorScreen:ProductColorScreen;
		private var _heatScreen:ProductHeatScreen;
		private var _viewScreen:ProductPictureScreen;
		
		public function ProductDetailScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			var layout:VerticalLayout = new VerticalLayout();
			
			this._container = new ProductDetailContainer();
			this._container.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			this._container.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			this._container.addEventListener(GestureEvent.Gesture_SWIPE,onGestureSwipeHandler);
			this._container.scrollerProperties.snapToPages = true;
			this.addChild(_container);
			
			this._controlPane = new ScrollContainer();
			this.addChild(_controlPane);
			
			var _infoPane :ScrollContainer = new ScrollContainer();
			_infoPane.nameList.add(CustomComponentTheme.CONTROL_PANE_BACKGROUND);
			_infoPane.layout = layout;
			
			var attentionBtn:Button = new Button();
			attentionBtn.x = 250;
			attentionBtn.y = 150;
			attentionBtn.nameList.add(CustomComponentTheme.ATTENTION_BTN);
			attentionBtn.addEventListener(Event.TRIGGERED,attentionProduct);
			this.addChild(attentionBtn);
			
			this._controlPane.addChild(_infoPane);
			this._controlPane.addChild(attentionBtn);
			
			this._container.layout = layout;
			
			_colorScreen = new ProductColorScreen();
			_colorScreen.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
//			_colorScreen.addEventListener(GestureEvent.Gesture_SWIPE,onGestureSwipeHandler);
			this._container.addChild(_colorScreen);
			
			var _colorPaneLayout:VerticalLayout = new VerticalLayout();
			_colorPaneLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			_colorPaneLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			_colorPaneLayout.gap = 10;
			_colorPaneLayout.paddingTop = 60;
			_colorPaneLayout.paddingBottom = 10;
			
			_colorPane = new ScrollContainer();
			_colorPane.width = 136;
			_colorPane.height = 0;
			_colorPane.maxHeight = 300;
			_colorPane.layout = _colorPaneLayout;
			_colorPane.nameList.add(CustomComponentTheme.COLOR_PANE_BACKGROUND);
			_colorPane.addEventListener(TouchEvent.TOUCH,onTouchColorPaneHandler);
			_colorScreen.addChild(_colorPane);
			
			var cl:int = _model.currentProduct.productColorImg.length;
			for(var c:int = 0;c < 1;c++) {
				var colorBtn:ColorButton = new ColorButton();
				colorBtn.colorIcon = _model.currentProduct.productColorImg[c].colorIcon;
				trace(_model.currentProduct.productColorImg[c].colorIcon);
				_colorPane.addChild(colorBtn);
				this._colorPane.height += 76;
			}
			
			_heatScreen =  new ProductHeatScreen();
			_heatScreen.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			_heatScreen.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
//			_heatScreen.addEventListener(GestureEvent.Gesture_SWIPE,onGestureSwipeHandler);
			this._container.addChild(_heatScreen);
			_viewScreen = new ProductPictureScreen();
			_viewScreen.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			_viewScreen.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
//			_viewScreen.addEventListener(GestureEvent.Gesture_SWIPE,onGestureSwipeHandler);
			this._container.addChild(_viewScreen);
			
			_screenVector.push(_colorScreen,_heatScreen,_viewScreen);
			
			enterEffect();
		}
		
		override protected function draw():void
		{
			this._container.width = this.actualWidth;
			this._container.height = this.actualHeight;
			
			this._controlPane.width = 400;
			this._controlPane.x = -this._controlPane.width;
			
			this._colorPane.x = 750;
			this._colorPane.y = -this._colorPane.height;
			
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
		
		protected function enterEffect():void
		{
			var moveControlPaneTween:Tween = new Tween(this._controlPane,0.25);
			moveControlPaneTween.animate("x",0);
			Starling.juggler.delayCall(Starling.juggler.add,0.15,moveControlPaneTween);
//			Starling.juggler.add(moveControlPaneTween);
			
			var moveColorPaneTween:Tween = new Tween(this._colorPane,0.3);
			moveColorPaneTween.animate("y",0);
			Starling.juggler.delayCall(Starling.juggler.add,0.35,moveColorPaneTween);
			
			
//			var moveColorPaneTween:Tween = new Tween(
		}
		
		protected function leaveEffect():void
		{
			
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
		
		private function attentionProduct(event:Event):void
		{
		}
		
		private function onTouchColorPaneHandler(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(stage);
			
			var len:int = touches.length;
			
			if(len>0&&touches[0].phase == "began") {
				this._container.isGestureFlag = 3;
			}
			
			for(var i:int=0;i<len;i++) {
				if(touches[i].phase != "ended") {
					return;
				}
			}
			this._container.isGestureFlag = 0;
		}
		
	}
}