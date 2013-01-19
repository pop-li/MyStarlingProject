package com.sanrenxing.tb.services
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;

	[Event(name="serviceError", type="flash.events.Event")]
	public class AbstractService extends EventDispatcher
	{
		public static const SERVICE_ERROR:String = "serviceError";
		public function AbstractService()
		{
			
		}
		
		protected function getServiceInstance():Object
		{
			var service:RemoteObject=new RemoteObject();
			service.destination=destination;
			service.endpoint = "http://192.168.1.108:8080/MobileBlazeDSDemo/messagebroker/amf";
			return service;
		}
		
		protected function getResponsder(resultFunction:Function, faultFuntion:Function=null):IResponder{
			var appSealFlag:Boolean = false;
			
			var successFunction:Function = function(data:Object):void
			{
				appSealFlag=true;
				if (resultFunction != null) {
					resultFunction.call(this,data);
				}
				//Application.application.enabled = appSealFlag;
			};
			var onFault:Function = function(faultEvent:FaultEvent):void
			{
				if(faultFuntion!=null){
					faultFuntion.call(this,faultEvent);
				}
				dispatchEvent(new Event(AbstractService.SERVICE_ERROR));
//				OotoAlert.show(faultEvent.fault.faultString, ResourceUtil.getInstance().getString('alert.title.error'));
			};
			return new Responder(successFunction,onFault);
		}
		protected var destination:String;
	}
}