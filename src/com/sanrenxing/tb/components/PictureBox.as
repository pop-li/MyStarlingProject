package com.sanrenxing.tb.components
{
	import com.sanrenxing.tb.utils.Assets;
	
	import feathers.core.FeathersControl;
	
	import starling.display.Image;
	
	public class PictureBox extends FeathersControl
	{
		public var initAngle:int;
		private var _angle:int;
		
		private var _image:Image;
		
		public function PictureBox(url:String)
		{
			super();
			
			_image = new Image(Assets.getTexture(url));
			_image.x = -_image.width/2;
			_image.y = -_image.height/2;
			addChild(_image);
			
			setSize(_image.width,_image.height);
		}
		
		public function set angle(value:int):void
		{
			if(value == _angle) return;
			_angle = value;
			this.rotation = value*Math.PI/180;
		}
		
		public function get angle():int
		{
			return _angle;
		}
	}
}