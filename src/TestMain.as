package
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	
	import feathers.controls.Button;
	import feathers.controls.Screen;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class TestMain extends Screen
	{
		[Embed(source="assets/images/Border.jpg")]
		private static const SKULL_ICON:Class;
		
		private var _icon:Image;
		private var _button:Button;
		
		private var loader:Loader
		
		public function TestMain()
		{
			super();
		}
		
		override protected function initialize():void
		{
			trace("icon");
			this._icon = new Image(Texture.fromBitmap(Test.bitmap));
			trace("icon2");
			
			this._button = new Button();
			this._button.defaultIcon = this._icon;
			this._button.label = "Click Me";
			this.addChild(this._button);
		}
		
		override protected function draw():void
		{
			this._button.validate();
			this._button.x = (this.actualWidth - this._button.width) / 2;
			this._button.y = (this.actualHeight - this._button.height) / 2;
			trace("icon3");
		}
	}
}