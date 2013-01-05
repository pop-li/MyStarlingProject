package
{
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.RemoteNotificationEvent;
	import flash.events.StatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestDefaults;
	import flash.net.URLRequestMethod;
	import flash.notifications.NotificationStyle;
	import flash.notifications.RemoteNotifier;
	import flash.notifications.RemoteNotifierSubscribeOptions;
	import flash.text.TextFormat;
	
	import feathers.controls.Button;
	import feathers.controls.ScrollText;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class TestMain extends Sprite
	{
		private var _theme:MetalWorksMobileTheme;
		
		private var notiStyles:Vector.<String> = new Vector.<String>;;
		private var tt:ScrollText = new ScrollText();
		private var tf:TextFormat = new TextFormat();
		// Contains the notification styles that your app wants to receive
		private var preferredStyles:Vector.<String> = new Vector.<String>();
		private var subscribeOptions:RemoteNotifierSubscribeOptions = new RemoteNotifierSubscribeOptions();
		private var remoteNot:RemoteNotifier = new RemoteNotifier(); 
		
		private var subsButton:Button = new Button();
		private var unSubsButton:Button = new Button();
		private var clearButton:Button = new Button(); 
		
		private var urlreq:URLRequest;
		private var urlLoad:URLLoader = new URLLoader();
		private var urlString:String; 
		
		public function TestMain()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler); 
			this.addEventListener(Event.ADDED_TO_STAGE,activateHandler); 
		}
		
		private function addToStageHandler(event:Event):void
		{
			this._theme = new MetalWorksMobileTheme(this.stage);
			
			tf.size = 20;
			tf.bold = true; 
			tf.color = 0xffffff;
			
			tt.x=0;
			tt.y =150;
			tt.height = this.stage.stageHeight - 150;
			tt.width = this.stage.stageWidth;
			tt.textFormat = tf; 
			
			addChild(tt); 
			
			subsButton.x = 150;
			subsButton.y=10;
			subsButton.label = "subsButton";
			subsButton.addEventListener(Event.TRIGGERED,subsButtonHandler);
			this.addChild(subsButton); 
			
			unSubsButton.x = 300;
			unSubsButton.y=10;
			unSubsButton.label = "unSubsButton";
			unSubsButton.addEventListener(Event.TRIGGERED,unSubsButtonHandler);
			this.addChild(unSubsButton); 
			
			clearButton.x = 450;
			clearButton.y=10;
			clearButton.label = "clearButton";
			clearButton.addEventListener(Event.TRIGGERED,clearButtonHandler);
			this.addChild(clearButton); 
			
			//
			tt.text += "\n SupportedNotification Styles: " + RemoteNotifier.supportedNotificationStyles.toString() + "\n"; 
			
			tt.text += "\n Before Preferred notificationStyles: " + subscribeOptions.notificationStyles.toString() + "\n"; 
			
			// Subscribe to all three styles of push notifications:
			// ALERT, BADGE, and SOUND.
			preferredStyles.push(NotificationStyle.ALERT ,NotificationStyle.BADGE,NotificationStyle.SOUND ); 
			
			subscribeOptions.notificationStyles= preferredStyles; 
			
			tt.text += "\n After Preferred notificationStyles:" + subscribeOptions.notificationStyles.toString() + "\n"; 
			
			remoteNot.addEventListener(RemoteNotificationEvent.TOKEN,tokenHandler);
			remoteNot.addEventListener(RemoteNotificationEvent.NOTIFICATION,notificationHandler);
			remoteNot.addEventListener(StatusEvent.STATUS,statusHandler); 
			
			
		}
		
		// Apple recommends that each time an app activates, it subscribe for
		// push notifications.
		public function activateHandler(e:Event):void{
			// Before subscribing to push notifications, ensure the device supports it.
			// supportedNotificationStyles returns the types of notifications
			// that the OS platform supports
			trace(RemoteNotifier.supportedNotificationStyles.toString());
			if(RemoteNotifier.supportedNotificationStyles.toString() != "")
			{
				remoteNot.subscribe(subscribeOptions);
			}
			else{
				tt.text += "\n Remote Notifications not supported on this Platform !";
			}
		}
		public function subsButtonHandler(e:Event):void{
			remoteNot.subscribe(subscribeOptions);
		}
		// Optionally unsubscribe from push notfications at runtime.
		public function unSubsButtonHandler(e:Event):void{
			remoteNot.unsubscribe();
			tt.text +="\n UNSUBSCRIBED";
		} 
		
		public function clearButtonHandler(e:Event):void{
			tt.text = " ";
		}
		// Receive notification payload data and use it in your app
		public function notificationHandler(e:RemoteNotificationEvent):void{
			tt.text += "\n" +
				"RemoteNotificationEvent type: " + e.type + "\n" +
				"bubbles: "+ e.bubbles + "\n" +
				"cancelable " +e.cancelable; 
			
			for (var x:String in e.data) {
				tt.text += "\n"+ x + ":  " + e.data[x];
			}
		}
		// If the subscribe() request succeeds, a RemoteNotificationEvent of
		// type TOKEN is received, from which you retrieve e.tokenId,
		// which you use to register with the server provider (urbanairship, in
		// this example.
		public function tokenHandler(e:RemoteNotificationEvent):void
		{
			tt.text += "\n" +
				"RemoteNotificationEvent type: "+e.type +"\n" +
				"Bubbles: "+ e.bubbles + "\n" +
				"cancelable " +e.cancelable +"\n" +
				"tokenID:\n"+ e.tokenId +"\n"; 
			
			urlString = new String("https://go.urbanairship.com/api/device_tokens/" +
				e.tokenId);
			urlreq = new URLRequest(urlString); 
			
			urlreq.authenticate = true;
			urlreq.method = URLRequestMethod.PUT; 
			
			URLRequestDefaults.setLoginCredentialsForHost
				("go.urbanairship.com",
					"1ssB2iV_RL6_UBLiYMQVfg","t-kZlzXGQ6-yU8T3iHiSyQ"); 
			
			urlLoad.load(urlreq);
			urlLoad.addEventListener(IOErrorEvent.IO_ERROR,iohandler);
			urlLoad.addEventListener(Event.COMPLETE,compHandler);
			urlLoad.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpHandler); 
			
		} 
		
		private function iohandler(e:IOErrorEvent):void
		{
			tt.text += "\n In IOError handler" + e.errorID +" " +e.type; 
			
		}
		private function compHandler(e:flash.events.Event):void{
			tt.text += "\n In Complete handler,"+"status: " +e.type + "\n";
		} 
		
		private function httpHandler(e:HTTPStatusEvent):void{
			tt.text += "\n in httpstatus handler,"+ "Status: " + e.status;
		} 
		
		// If the subscription request fails, StatusEvent is dispatched with
		// error level and code.
		public function statusHandler(e:StatusEvent):void{
			tt.text += "\n statusHandler";
			tt.text += "event Level" + e.level +"\nevent code " +
				e.code + "\ne.currentTarget: " + e.currentTarget.toString();
		}
		
	}
}