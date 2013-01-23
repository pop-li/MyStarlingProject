package com.sanrenxing.tb.models
{
	import com.sanrenxing.tb.utils.Assets;
	
	import feathers.controls.Button;
	import feathers.controls.ScrollContainer;
	import feathers.display.TiledImage;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;

	public class CustomComponentTheme extends MetalWorksMobileTheme
	{
//		protected static const BUTTON_SCALE9_GRID:Rectangle = new Rectangle(5, 5, 50, 50);
		
		public static const MAIN_BACKGROUND:String = "mainBackGround";
		public static const BACK_BTN:String = "backBtn";
		public static const CONTROL_PANE_BACKGROUND:String = "controlPaneBackground";
		public static const ATTENTION_BTN:String = "attentionBtn";
		
		public var backButtonUpSkinTextures:Texture;
		public var backButtonDownSkinTextures:Texture;
		
		public function CustomComponentTheme( root:DisplayObjectContainer, scaleToDPI:Boolean = true )
		{
			super( root, scaleToDPI );
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			// set new initializers here
			this.setInitializerForClass( Button, backButtonInitializer, BACK_BTN );
			this.setInitializerForClass( ScrollContainer, mainBackgroundInitializer, MAIN_BACKGROUND );
			this.setInitializerForClass( ScrollContainer, controlPaneBackgroundInitializer, CONTROL_PANE_BACKGROUND );
			
			this.setInitializerForClass( Button, attentionBtnInitializer, ATTENTION_BTN );
		}
		
		public function backButtonInitializer(button:Button):void
		{
//			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
//			skinSelector.defaultValue = this.buttonDisabledSkinTextures;
//			skinSelector.setValueForState(this.buttonUpSkinTextures, Button.STATE_DOWN, false);
//			skinSelector.imageProperties = 
//				{
//					width: 60 * this.scale,
//					height: 60 * this.scale,
//					textureScale: this.scale
//				};
//			button.stateToSkinFunction = skinSelector.updateValue;
			button.defaultSkin = new Image(this.buttonDisabledSkinTextures.texture);
			button.downSkin = new Image(this.buttonUpSkinTextures.texture);
		}
		
		public function mainBackgroundInitializer(container:ScrollContainer):void
		{
			container.backgroundSkin = new TiledImage(Assets.getTexture("MAIN_BG"));
		}
		
		public function controlPaneBackgroundInitializer(container:ScrollContainer):void
		{
			container.backgroundSkin = new Image(Assets.getTexture("CONTROL_PANE_BG"));
		}
		
		public function attentionBtnInitializer(button:Button):void
		{
			button.defaultSkin = new Image(Assets.getTexture("ATTENTION_BTN_UP"));
			button.downSkin = new Image(Assets.getTexture("ATTENTION_BTN_DOWN"));
		}
	}
}