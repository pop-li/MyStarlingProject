package com.sanrenxing.tb.screens
{
	import com.sanrenxing.tb.models.ModelLocator;
	
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	
	public class ProductDetailScreen extends Screen
	{
		private var _navigator:ScreenNavigator;
		private var _transitionManager:ScreenSlidingStackTransitionManager;
		private var _model:ModelLocator=ModelLocator.getInstance();
		
		public function ProductDetailScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			this._navigator = new ScreenNavigator();
			this.addChild(this._navigator);
			
			
			this._navigator.addScreen(_model.PRODUCT_COLOR_SCREEN, new ScreenNavigatorItem(
				ProductColorScreen,
				{
					toProductHeatScreen:_model.PRODUCT_HEAT_SCREEN
				}
			));
			this._navigator.addScreen(_model.PRODUCT_HEAT_SCREEN, new ScreenNavigatorItem(
				ProductHeatScreen,
				{
					toProductColorScreen:_model.PRODUCT_COLOR_SCREEN,
					toProductShowScreen:_model.PRODUCT_SHOW_SCREEN
				}
			));
			this._navigator.addScreen(_model.PRODUCT_SHOW_SCREEN, new ScreenNavigatorItem(
				ProductShowScreen,
				{
					toProductHeatScreen:_model.PRODUCT_HEAT_SCREEN
				}
			));
			
			this._navigator.showScreen(_model.PRODUCT_COLOR_SCREEN);
			this._transitionManager = new ScreenSlidingStackTransitionManager(this._navigator);
			this._transitionManager.duration=1;
		}
		
		override protected function draw():void
		{
			
		}
	}
}