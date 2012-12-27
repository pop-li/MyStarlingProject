package com.sanrenxing.tb.screens
{
	import com.sanrenxing.tb.components.Product;
	import com.sanrenxing.tb.models.ModelLocator;
	import com.sanrenxing.tb.vos.ProductClassVO;
	
	import flash.geom.Point;
	
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	[Event(name="toProductDetail",type="starling.events.Event")]
	
	public class ProductListScreen extends Screen
	{
		public var data:ProductClassVO;
		
		private var _model:ModelLocator = ModelLocator.getInstance();
		
		private var _container:ScrollContainer;
		
		/**
		 * 该类商品的所有商品列表
		 */
		private var _protuctsArr:Vector.<Product>=new Vector.<Product>();
		/**
		 * 当前聚焦的产品在所有产品中的索引位置
		 */
		private var _focusProductIndex:int = 0;
		
		/**
		 * 产品列表当前在显示视图内最左侧的索引位置
		 */
		private var leftIndex:int=0;
		/**
		 * 产品列表当前在显示视图内最右侧的索引位置
		 */
		private var rightIndex:int=0;
		/**
		 * 当前交互是否为移动
		 */
		private var _isClick:Boolean=false;
//		/**
//		 * 用来判断当前是否处于显示详细状态，若为true，则不允许在拖拽和响应touch事件
//		 */
//		private var _isToDetail:Boolean=false;
		
		private var _curTouchProduct:Product;
		
		//----------用来记录手势相关坐标-----------------------
		private var _firstX:int;  //触摸开始时的mouseX
		private var _preX:int;  //捕捉上一阵的mouseX
		private var _curX:int;  //捕捉当前帧的mouseX
		//----------------------------------------------------
		
		public function ProductListScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			this._container = new ScrollContainer();
			this._container.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			this._container.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			this.addChild(this._container);
			
			data = _model.currentProductClass;
			
			const showProductLength:int = Math.min(_model.showCount4Stage,data.productListVO.length);
			for(var i:int=0;i<showProductLength;i++) { //同屏显示个数
//				var productVO:ProductVO = new ProductVO();
//				productVO.shoeImagSource = "/assets/shoes/" + (i+1) + ".png";
				var product:Product=new Product(data.productListVO[i]);
				product.data = data.productListVO[i];
				_protuctsArr.push(product);
			}
		}
		
//		private function ScrollPolicyHandler(event:Event):void
//		{
//			if(event.target == this._container) {
//				var _i:int=0;
//				var _length:int=this._container.numChildren;
//				for(_i;_i<this._container.numChildren;_i++) {
//					var child:DisplayObject = this._container.getChildAt(_i);
//					if(child is ScrollContainer) {
//						(child as ScrollContainer).stopScrolling();
//					}
//				}
//			} else {
//				this._container.stopScrolling();
//			}
//		}
		
		override protected function draw():void
		{
			this._container.width = this.actualWidth;
			this._container.height = this.actualHeight;
			
			leftIndex = _focusProductIndex;
			rightIndex = _focusProductIndex + Math.min(Math.floor(_model.showCount4Stage)/2,data.productListVO.length);
			var l:int=0;
			for(var i:int=_focusProductIndex;i<=rightIndex;i+=l) {
				var productMoveTween:Tween;
				if(i==_focusProductIndex) {
					if(_protuctsArr[i].parent==null) {
						addProductToStage(i);
					}
					productMoveTween = new Tween(_protuctsArr[i],1,Transitions.EASE_OUT_BACK);
					productMoveTween.onComplete = productMoveTweenCompleteHandler;
				} else {
					addProductToStage(i);
					productMoveTween = new Tween(_protuctsArr[i],0.7,Transitions.EASE_IN_OUT);
				}
				productMoveTween.animate("x",calculateExpectX(i));
				Starling.juggler.add(productMoveTween);
				
				if(i==leftIndex) {
					i=_focusProductIndex;
					l=1;
				} else {
					if(i==_focusProductIndex) {
						l=-1;
					}
				}
			}
			
			function productMoveTweenCompleteHandler():void {
				if(!_container.hasEventListener(TouchEvent.TOUCH)) {
					_container.addEventListener(TouchEvent.TOUCH, onTouch); 
				}
			}
		}
		
		/**
		 * 将指定产品添加到舞台
		 * @param index 要添加到舞台的指定产品的索引
		 */
		protected function addProductToStage(index:int):Product
		{
			if(index<0||index>_protuctsArr.length-1) return null; //如果超出范围，则直接return
			
			
			if(index>rightIndex) {
				rightIndex = index;
			} else if(index<leftIndex){
				leftIndex = index;
			}
			_protuctsArr[index].scaleX = _model.productsScale;
			_protuctsArr[index].scaleY = _model.productsScale;
			
			this._container.addChildAt(_protuctsArr[index],0)
			
			_protuctsArr[index].x = calculateExpectX(index);
			_protuctsArr[index].y = this._container.height/2;
			
			if(index==this._focusProductIndex) {
				makeFocusProduct(index);
			} else {
			}
			return _protuctsArr[index];//this._container.addChildAt(_protuctsArr[index],0) as Product;
		}
		/**
		 * 计算预期索引位置的商品应该存在的坐标位置
		 */
		protected function calculateExpectX(index:int):int
		{
			var _distance:int=index-this._focusProductIndex;
			if(0==_distance) {
				return _model.screenWidth/2;
			} else {
				if(_distance<0) {
					if(_isClick) {
						return -_model.productWidth;
					} else {
						return _model.screenWidth/2 - _model.focusProductSpace - _model.focusProductSpace/_model.focusDividedUnfocusSpeed - (-_distance-1)*_model.unfocusProductSpace;
					}
				} else {
					if(_isClick) {
						return _model.screenWidth + _model.productWidth;
					} else {
						return _model.screenWidth/2 + _model.focusProductSpace + _model.focusProductSpace/_model.focusDividedUnfocusSpeed + (_distance-1)*_model.unfocusProductSpace;
					}
				}
			}
		}
		
		private function onTouch(event:TouchEvent):void
		{
//			if(_isTouching) {
//				return;
//			}
//			_isTouching = true;
			
//			event.stopImmediatePropagation();
			
//			//结束当前的效果
//			for(var i:int=leftIndex;i<=rightIndex;i++) { //同屏显示5个
//				TweenLite.killTweensOf(_protuctsArr[i]);
//			}
			// get the mouse location related to the stage 
			var touch:Touch = event.getTouch(stage); 
			var pos:Point = touch.getLocation(stage); 
			//			var classBtn:ProductClassBox = e.currentTarget as ProductClassBox;
			
			
			trace(touch.phase);
			
			if(touch.phase == "began") {
				//记录开始触摸屏幕时的坐标和时间点
				_firstX = _curX = _preX = pos.x;
				_isClick = true;
				
				//结束当前的效果
				for(var a:int=leftIndex;a<=rightIndex;a++) { //同屏显示5个
					Starling.juggler.removeTweens(_protuctsArr[a]);
				}
			} else if(touch.phase == "moved") {
				trace(_preX + "     " + _curX + "     " + pos.x);
				_preX = _curX;
				_curX = pos.x;
				
				if(Math.abs(_firstX-_preX)>20) {
					_isClick = false;
				}
				
				var _distanceX:Number = Math.min(_model.focusProductSpace*2,(_curX-_preX)*_model.focusDividedTouchSpeed); //计算手势移动的位移在实际效果中移动多少
				var l:int=0;
				
				for(var i:int=_focusProductIndex;i<=rightIndex;i+=l) {
					/**
					 //0.判断是否为聚焦商品
					 //--1.若为聚焦商品，则区分向左还是向右拖动
					 //----2.若从左向右，则判断是否跨越了聚焦区域右断点
					 //------3.没有跨越聚焦区域的右侧端点
					 //--------fomula : 聚焦商品移动位移=移动位移×卷轴移动倍数
					 //------3.跨越了聚焦区域的右侧端点，则判断当前聚焦商品是否为最右侧
					 //--------4.若为最左侧，
					 //----------fomula : 聚焦商品移动位移=移动位移×卷轴移动倍数
					 //--------4.否则代表向右跨越右侧聚焦区域断点
					 //----------fomula : 聚焦商品移动位移=跨越之前的移动位移×卷轴移动倍数+跨越之后的移动位移
					 //----------fomula : 聚焦商品左侧的前一个非聚焦商品移动位移=跨越之前的移动位移+跨越之后的移动位移×卷轴移动倍数
					 //----2.若从右向左，则判断是否跨越了聚焦区域左断点
					 //------3.没有跨越聚焦区域的左侧端点
					 //----------fomula : 聚焦商品移动位移=移动位移×卷轴移动倍数
					 //------3.跨越了聚焦区域的左侧端点，则判断当前聚焦商品是否为最右侧
					 //--------4.若为最右侧，
					 //----------fomula : 聚焦商品移动位移=移动位移×卷轴移动倍数
					 //--------4.否则代表向右跨越右侧聚焦区域断点
					 //----------fomula : 聚焦商品移动位移=跨越之前的移动位移×卷轴移动倍数+跨越之后的移动位移
					 //----------fomula : 聚焦商品左侧的前一个非聚焦商品移动位移=跨越之前的移动位移+跨越之后的移动位移×卷轴移动倍数
					 //0.判断是否为聚焦商品
					 //--1.若不为聚焦商品
					 //----fomula : 非聚焦商品移动位移=移动位移
					 **/
					//0.判断是否为聚焦商品
					if(i==_focusProductIndex) { //--1.若为聚焦商品，则区分向左还是向右拖动
						var destionationX:Number = _protuctsArr[i].x + _distanceX*_model.focusDividedUnfocusSpeed;
						
						if(_distanceX>0) { //----2.若从左向右，则判断是否跨越了聚焦区域右断点
							if(destionationX<_model.screenWidth/2+_model.focusProductSpace) { //------3.没有跨越聚焦区域的右侧端点
								//--------fomula : 聚焦商品移动位移=移动位移×卷轴移动倍数
								_protuctsArr[i].x = destionationX;
								trace("move to   _distanceX " + _distanceX + " * _model.focusDividedUnfocusSpeed" + _model.focusDividedUnfocusSpeed);
							} else { //------3.跨越了聚焦区域的右侧端点，则判断当前聚焦商品是否为最右侧
								if(i==leftIndex) { //--------4.若为最左侧，
									//----------fomula : 聚焦商品移动位移=移动位移×卷轴移动倍数
									trace("leftest   toX " + destionationX + "  fromX " + _protuctsArr[i].x + " + _distanceX " + _distanceX + "  *    _model.focusDividedUnfocusSpeed " + _model.focusDividedUnfocusSpeed);
									_protuctsArr[i].x = destionationX;
								} else { //--------4.否则代表向右跨越右侧聚焦区域断点
									//----------fomula : 聚焦商品移动位移=跨越之前的移动位移×卷轴移动倍数+跨越之后的移动位移(此处是将多计算出来的部分剪掉)
									_protuctsArr[i].x += _distanceX*_model.focusDividedUnfocusSpeed - (destionationX-_model.screenWidth/2-_model.focusProductSpace)/_model.focusDividedUnfocusSpeed;
									//----------fomula : 聚焦商品左侧的前一个非聚焦商品移动位移=跨越之前的移动位移+跨越之后的移动位移×卷轴移动倍数(此处仅计算多余移动的部分，后面遍历时会再计算正常移动的位移)
									_protuctsArr[i-1].x += ((destionationX-_model.screenWidth/2-_model.focusProductSpace)/_model.focusDividedUnfocusSpeed)*(_model.focusDividedUnfocusSpeed-1);//*_model.focusDividedUnfocusSpeed + (_model.screenWidth/2+_model.focusShoeSpace-_shoesArr[i].x);
									addProductToStage(i-3);
									removeProductFromStage(i+2);
									trace("from left change To right unfocus  " + _protuctsArr[i].x);
								}
							}
						} else { //----2.若从右向左，则判断是否跨越了聚焦区域左断点
							if(destionationX>_model.screenWidth/2-_model.focusProductSpace) { //------3.没有跨越聚焦区域的左侧端点
								//----------fomula : 聚焦商品移动位移=移动位移×卷轴移动倍数
								_protuctsArr[i].x = destionationX;
								trace("move to   _distanceX " + _distanceX + " * _model.focusDividedUnfocusSpeed" + _model.focusDividedUnfocusSpeed);
							} else { //------3.跨越了聚焦区域的左侧端点，则判断当前聚焦商品是否为最右侧
								if(i==rightIndex) { //--------4.若为最右侧，
									//----------fomula : 聚焦商品移动位移=移动位移×卷轴移动倍数
									trace("rightest   toX " + destionationX + "  fromX " + _protuctsArr[i].x + " + _distanceX " + _distanceX + "  *    _model.focusDividedUnfocusSpeed " + _model.focusDividedUnfocusSpeed);
									_protuctsArr[i].x = destionationX;
								} else { //--------4.否则代表向左跨越左侧聚焦区域断点
									//----------fomula : 聚焦商品移动位移=跨越之前的移动位移×卷轴移动倍数+跨越之后的移动位移(此处是将多计算出来的部分剪掉)
									_protuctsArr[i].x -= -_distanceX*_model.focusDividedUnfocusSpeed - (_model.screenWidth/2-_model.focusProductSpace-destionationX)/_model.focusDividedUnfocusSpeed;
									//----------fomula : 聚焦商品左侧的前一个非聚焦商品移动位移=跨越之前的移动位移+跨越之后的移动位移×卷轴移动倍数(此处仅计算多余移动的部分，后面遍历时会再计算正常移动的位移)
									_protuctsArr[i+1].x -= ((_model.screenWidth/2-_model.focusProductSpace-destionationX)/_model.focusDividedUnfocusSpeed)*(_model.focusDividedUnfocusSpeed-1);//*_model.focusDividedUnfocusSpeed + (_shoesArr[i].x-_model.screenWidth/2+_model.focusShoeSpace);
									addProductToStage(this._focusProductIndex+3);
									removeProductFromStage(this._focusProductIndex-2);
									trace("from right change To left unfocus  " + _protuctsArr[i].x);
								}
							}
						}
					} else { //--1.若不为聚焦商品
						trace("move to   _distanceX " + _distanceX);
						//----fomula : 非聚焦商品移动位移=移动位移
						_protuctsArr[i].x += _distanceX;
					}
					
					if(i==leftIndex) {
						i=_focusProductIndex;
						l=1;
					} else {
						if(i==_focusProductIndex) {
							l=-1;
						}
					}
				}
				
				//？每次都要执行嘛？
				if(_protuctsArr[this._focusProductIndex].x>_model.screenWidth/2 + _model.focusProductSpace) { //如果向右拖动到位置，聚焦商品换为上一个
					if(this._focusProductIndex-1<0) return; //如果已经到边缘，则直接return
					makeFocusProduct(this._focusProductIndex-1);
					trace("-----------------------change focus toLeft--------------------");
				} else if(_protuctsArr[this._focusProductIndex].x<_model.screenWidth/2 - _model.focusProductSpace) { //如果向左拖动到位置，聚焦商品换为下一个
					if(this._focusProductIndex == _protuctsArr.length-1) return; //如果已经到边缘，则直接return
					makeFocusProduct(this._focusProductIndex+1);
					trace("-----------------------change focus toRight --------------------");
				}
				
			} else if(touch.phase == "ended") {
				var moveProductTween:Tween;
				if(!_isClick||_curTouchProduct==null) {
					trace("move End");
					trace(_protuctsArr[_focusProductIndex].x);
					for(var j:int=leftIndex;j<=rightIndex;j++) { //同屏显示5个
						moveProductTween = new Tween(_protuctsArr[j],0.7,Transitions.EASE_OUT);
						moveProductTween.animate("x",calculateExpectX(j));
						Starling.juggler.add(moveProductTween);
					}
					trace(_protuctsArr[_focusProductIndex].x);
				} else {
					trace("click End");
					//如果为点击状态，则删除touch侦听，跳转到详细页
					_container.removeEventListener(TouchEvent.TOUCH, onTouch); 
					for(var k:int=leftIndex;k<=rightIndex;k++) { //同屏显示5个
						if(k==_focusProductIndex) {
							moveProductTween = new Tween(_protuctsArr[k],0.7,Transitions.EASE_OUT);
							moveProductTween.onComplete = toProductDetail;
						} else {
							moveProductTween = new Tween(_protuctsArr[k],1,Transitions.EASE_OUT_BACK);
						}
						moveProductTween.animate("x",calculateExpectX(k));
						Starling.juggler.add(moveProductTween);
					}
				}
				_isClick = false;
				_curTouchProduct==null;
				
			}
		}
		
		/**
		 * 将产品聚焦中央
		 * @param index 要聚焦的产品的索引
		 */
		protected function makeFocusProduct(index:int):void
		{
			if(index<0||index>_protuctsArr.length-1) return; //如果超出范围，则直接return
			
			var zoomTween:Tween = new Tween(this._protuctsArr[index],0.7,Transitions.EASE_OUT);
			zoomTween.scaleTo(1);
			var narrowTween:Tween = new Tween(this._protuctsArr[this._focusProductIndex],0.7,Transitions.EASE_OUT);;
			narrowTween.scaleTo(_model.productsScale);
			Starling.juggler.add(narrowTween);
			Starling.juggler.add(zoomTween);
			
			_protuctsArr[_focusProductIndex].removeEventListener(TouchEvent.TOUCH,touchProductHandler);
			if(!_protuctsArr[index].hasEventListener(TouchEvent.TOUCH)) {
				_protuctsArr[index].addEventListener(TouchEvent.TOUCH,touchProductHandler);
			}
			
			this._focusProductIndex = index;
			this._container.setChildIndex(this._protuctsArr[index],this._container.numChildren-1);
		}
		/**
		 * 讲指定的产品从舞台删除
		 * 
		 * @param index 要从舞台删除的指定产品的索引
		 */
		protected function removeProductFromStage(index:int):Product
		{
			if(index<0||index>_protuctsArr.length-1) return null; //如果超出范围，则直接return
			
			if(index>this._focusProductIndex) {
				rightIndex --;
			} else {
				leftIndex ++;
			}
			return this._container.removeChild(_protuctsArr[index]) as Product;
		}
		
		private function touchProductHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(stage);
			if(touch.phase == "began") {
				_curTouchProduct = event.currentTarget as Product;
			}
		}
		
		/**
		 * 跳转到产品详细
		 */
		protected function toProductDetail():void
		{
			_model.currentProduct = _protuctsArr[_focusProductIndex].data;
			this.dispatchEvent(new Event("toProductDetail"));
		}
	}
}