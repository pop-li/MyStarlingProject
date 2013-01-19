package com.sanrenxing.tb.services
{
	import com.sanrenxing.tb.models.ModelLocator;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class AppService extends AbstractService
	{
		private var _model:ModelLocator = ModelLocator.getInstance();
		
		public function AppService()
		{
			this.destination = "appService";
		}
		
		public function addRegistUser():void
		{
			var call:AsyncToken;
			call = this.getServiceInstance().addRegistUser(_model.TOKEN_ID);
			call.addResponder(this.getResponsder(addRegistUserResult));
			
			function addRegistUserResult(event:ResultEvent):void
			{
				trace("addRegistUserSuccess");
			}
		}
	}
}