package com.sanrenxing.tb.models
{
	import com.sanrenxing.tb.vos.ProductClassVO;
	import com.sanrenxing.tb.vos.ProductVO;

	public class DataModel
	{
		public const productVector:Vector.<ProductClassVO> = new Vector.<ProductClassVO>();
		
		public var TOKEN_ID:String;// = "F380883BE1563E6A5A8ED27CEC2623E75F4C1113010206DDFF1BF2EB5D172CAE";
		
		public var currentProductClass:ProductClassVO;
		
		public var currentProduct:ProductVO;
		
		public function DataModel()
		{
//			const class1:ProductClassVO = new ProductClassVO();
//			class1.className = "商务";
//			const product1_1:ProductVO = new ProductVO();
//			product1_1.productName = "test";
//			const color1_1_1:ProductColorVO = new ProductColorVO();
//			color1_1_1.colorName="Black";
//			color1_1_1.colorIcon="";
//			color1_1_1.productColorImg="product1";
//			product1_1.productColorImg.push(color1_1_1);
//			class1.productListVO.push(product1_1);
//			productVector.push(class1);
//			
//			const class2:ProductClassVO = new ProductClassVO();
//			class2.className = "休闲";
//			const product2_1:ProductVO = new ProductVO();
//			product2_1.productName = "test";
//			const color2_1_1:ProductColorVO = new ProductColorVO();
//			color2_1_1.colorName="Black";
//			color2_1_1.colorIcon="";
//			color2_1_1.productColorImg="product1";
//			product2_1.productColorImg.push(color2_1_1);
//			class2.productListVO.push(product2_1);
//			productVector.push(class2);
			
		}
		
		public function getProductClass():void
		{
			
		}
		
		public function getProductListByClass(productClassVO:ProductClassVO):void
		{
			
		}
		
	}
}