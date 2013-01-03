package com.sanrenxing.tb.vos
{
	public class ProductVO
	{
		public var productName:String;
		
		public var productColorImg:Vector.<ProductColorVO>=new Vector.<ProductColorVO>();
		
		public var productPicture:Vector.<String> = new Vector.<String>();
		
		public function ProductVO()
		{
		}
	}
}