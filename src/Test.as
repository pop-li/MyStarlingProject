package
{
	import com.sanrenxing.tb.models.ModelLocator;
	import com.sanrenxing.tb.services.AppService;
	import com.sanrenxing.tb.vos.ProductClassVO;
	import com.sanrenxing.tb.vos.ProductColorVO;
	import com.sanrenxing.tb.vos.ProductVO;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.RemoteNotificationEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.notifications.NotificationStyle;
	import flash.notifications.RemoteNotifierSubscribeOptions;
	
	import mx.logging.Log;
	import mx.logging.LogEventLevel;
	import mx.logging.targets.TraceTarget;
	import mx.utils.RpcClassAliasInitializer;
	
	import starling.core.Starling;

	[SWF(frameRate="60",backgroundColor="#2f2f2f")]
	public class Test extends Sprite
	{
		private var _model:ModelLocator = ModelLocator.getInstance();
		
		private var mStarling:Starling;
		
		private var loader:Loader;
		
		public static var bitmap:Bitmap;
		
		public function Test()
		{
			initData();
			
			//日志输出
			var traceTarget:TraceTarget = new TraceTarget();
			traceTarget.filters = []; //这样写过滤器，就是输出全部类了
			traceTarget.includeDate = true; //输出信息是否包含日期
			traceTarget.includeTime = true; //输出信息是否包含时间
			traceTarget.includeLevel = true; //输出信息是否包含等级
			traceTarget.includeCategory = true; //输出信息是否包含class名
			traceTarget.level = LogEventLevel.ALL; //设定输出的等级
			Log.addTarget(traceTarget);
			
		}
		
		private function initData():void
		{
			var subscribeOptions:RemoteNotifierSubscribeOptions = new RemoteNotifierSubscribeOptions();
			var preferredStyles:Vector.<String> = new Vector.<String>();
			preferredStyles.push(NotificationStyle.ALERT ,NotificationStyle.BADGE,NotificationStyle.SOUND );
			subscribeOptions.notificationStyles = preferredStyles;
			_model.remoteNotifier.addEventListener(RemoteNotificationEvent.TOKEN,remoteNotificationHandler);
			_model.remoteNotifier.addEventListener(RemoteNotificationEvent.NOTIFICATION,remoteNotificationHandler);
			_model.remoteNotifier.subscribe(subscribeOptions);
			
			RpcClassAliasInitializer.registerClassAliases();
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,function (e:Event):void
			{
				var xmlList:XMLList = new XMLList(loader.data);
				var classList:XMLList = xmlList.elements("productClass");
				var classLength:int=classList.length();
				for(var i:int=0;i<classLength;i++) {
					var productClassXML:XML=classList[i];
					var productClassVO :ProductClassVO = new ProductClassVO();
					productClassVO.className = productClassXML.attribute("className");
					productClassVO.classImg = productClassXML.attribute("classImg");
					
					var productList:XMLList = productClassXML.elements("product");
					var productLength:int=productList.length();
					for(var j:int=0;j<productLength;j++) {
						var productXML:XML=productList[j];
						var productVO:ProductVO = new ProductVO();
						productVO.productName = productXML.attribute("productName");
						
						var colorList:XMLList = productXML.elements("color");
						var colorLength:int=colorList.length();
						for(var k:int=0;k<colorLength;k++) {
							var colorXML:XML=colorList[k];
							var productColorVO:ProductColorVO = new ProductColorVO();
							productColorVO.colorName = colorXML.attribute("colorName");
							productColorVO.colorIcon = colorXML.attribute("colorIcon");
							productColorVO.img = colorXML.attribute("img");
							
							productVO.productColorImg.push(productColorVO);
						}
						
						var pictureList:XMLList = productXML.elements("picture");
						var pictureLength:int=pictureList.length();
						for(var a:int=0;a<pictureLength;a++) {
							var pictureXML:XML=pictureList[a];
							productVO.productPicture.push(pictureXML.attribute("img"));
						}
						productClassVO.productListVO.push(productVO);
					}
					_model.productVector.push(productClassVO);
				}
				
				loader.close();
				
				initUI();
			});
			loader.load(new URLRequest("assets/images/productData.xml"));
			
		}
		
		private function initUI():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			Starling.multitouchEnabled = true; // useful on mobile devices
			Starling.handleLostContext = true; // deactivate on mobile devices (to save memory)
			
			mStarling = new Starling(Main, stage);
			mStarling.simulateMultitouch = true;
			mStarling.enableErrorChecking = false;
			mStarling.showStats = true;
			mStarling.start();
			
			_model.screenWidth = this.stage.stageWidth;
//			_model.screenHeight = this.height;
			_model.productWidth = 480;
			_model.pictureMaxGap = 480;
//			_model.productHeight = 320;
			_model.focusDividedTouchSpeed = 0.3;
			_model.unfocusProductSpace = _model.productWidth/3;
			_model.focusDividedUnfocusSpeed = 2;
			_model.focusProductSpace = _model.unfocusProductSpace*_model.focusDividedUnfocusSpeed/2;
			_model.productsScale = 0.5;
			_model.showCount4Stage = 5;
			
			this.stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
			
			// this event is dispatched when stage3D is set up
			mStarling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
		}
		
		private function stage_resizeHandler(event:Event):void
		{
			_model.screenWidth = this.stage.stageWidth;
			//			_model.screenHeight = this.height;
			_model.productWidth = 480;
			_model.pictureMaxGap = 480;
			//			_model.productHeight = 320;
			_model.focusDividedTouchSpeed = 0.3;
			_model.unfocusProductSpace = _model.productWidth/3;
			_model.focusDividedUnfocusSpeed = 2;
			_model.focusProductSpace = _model.unfocusProductSpace*_model.focusDividedUnfocusSpeed/2;
			_model.productsScale = 0.5;
			_model.showCount4Stage = 5;
			
			this.mStarling.stage.stageWidth = this.stage.stageWidth;
			this.mStarling.stage.stageHeight = this.stage.stageHeight;
			
			const viewPort:Rectangle = this.mStarling.viewPort;
			viewPort.width = this.stage.stageWidth;
			viewPort.height = this.stage.stageHeight;
			try
			{
				this.mStarling.viewPort = viewPort;
			}
			catch(error:Error) {}
		}
		
		private function onContextCreated(event:Event):void
		{
			// set framerate to 30 in software mode
			
			if (Starling.context.driverInfo.toLowerCase().indexOf("software") != -1)
				Starling.current.nativeStage.frameRate = 30;
		}
		
		private function remoteNotificationHandler(e:RemoteNotificationEvent):void
		{
			if(e.type == RemoteNotificationEvent.TOKEN) {
				_model.TOKEN_ID = e.tokenId;
				if(_model.TOKEN_ID) {
					(new AppService()).addRegistUser();
				}
			} else {
				
			}
			
		}
	}
}