package com.sanrenxing.tb.models
{
	import flash.errors.IllegalOperationError;

	[Bindable]
	public class ModelLocator extends UIModel
	{
		private static var instance:ModelLocator;
		
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