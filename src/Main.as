package
{
	import com.sanrenxing.tb.models.ModelLocator;
	import com.sanrenxing.tb.screens.ProductClassScreen;
	import com.sanrenxing.tb.screens.ProductDetailScreen;
	import com.sanrenxing.tb.screens.ProductListScreen;
	import com.sanrenxing.tb.vos.ProductClassVO;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.Scroller;
	import feathers.motion.transitions.ScreenFadeTransitionManager;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	
	public class Main extends Sprite
	{
		private var _model:ModelLocator = ModelLocator.getInstance();
		
		private var _theme:MetalWorksMobileTheme;
		private var _navigator:ScreenNavigator;
		private var _transitionManager:ScreenFadeTransitionManager;
		
		
		public function Main()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private var productClassVO:ProductClassVO;
		
		private function addedToStageHandler():void
		{
			this._theme = new MetalWorksMobileTheme(this.stage);
			
			this._navigator = new ScreenNavigator();
			this.addChild(this._navigator);
			
			this._navigator.addScreen(_model.PRODUCT_CLASS_SCREEN, new ScreenNavigatorItem(
				ProductClassScreen,
				{
					toProductList:_model.RPODUCT_LIST_SCREEN
				}
			));
			this._navigator.addScreen(_model.RPODUCT_LIST_SCREEN, new ScreenNavigatorItem(
				ProductListScreen,
				{
					toProductDetail:_model.PRODUCT_DETAIL_SCREEN,
					toProductClass:_model.PRODUCT_CLASS_SCREEN
				}
			));
			
			this._navigator.addScreen(_model.PRODUCT_DETAIL_SCREEN,new ScreenNavigatorItem(
				ProductDetailScreen,
				{
					toProductList:_model.RPODUCT_LIST_SCREEN
				}
			));
			
			this._navigator.showScreen(_model.PRODUCT_CLASS_SCREEN);
			
			this._transitionManager = new ScreenFadeTransitionManager(this._navigator);
			this._transitionManager.duration=1;
			
		}
		
	}
}