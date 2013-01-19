package com.sanrenxing.tb.models
{
	import flash.errors.IllegalOperationError;
	import flash.notifications.RemoteNotifier;

	[Bindable]
	public class ModelLocator extends UIModel
	{
		private static var instance:ModelLocator;
		
		public var remoteNotifier:RemoteNotifier = new RemoteNotifier();
		
		public function ModelLocator()
		{
			if(instance) {
				throw new IllegalOperationError("this is a singleModel");
			}
		}
		
		public static function getInstance():ModelLocator
		{
			if (instance == null)
			{
				instance=new ModelLocator();
			}
			return instance;
		}
	}
}