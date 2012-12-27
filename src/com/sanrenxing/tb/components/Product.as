package com.sanrenxing.tb.components
{
	import com.sanrenxing.tb.utils.Assets;
	import com.sanrenxing.tb.vos.ProductVO;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Product extends Sprite
	{
		public var data:ProductVO;
		
		private var _image:Image;
		
		public function Product(data:ProductVO)
		{
			super();
			
			this.data = data;
			
			_image = new Image(Assets.getTexture(data.productColorImg[0].img));
			_image.x = -_image.width/2;
			_image.y = -_image.height/2;
			addChild(_image);
		}
	}
}