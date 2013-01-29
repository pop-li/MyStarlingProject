package com.sanrenxing.tb.components
{
	import flash.media.Sound;
	
	import starling.animation.IAnimatable;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	
	public class MMovieClip extends MovieClip implements IAnimatable
	{
		private var _isReverse:Boolean = false;
		
		public function MMovieClip(textures:Vector.<Texture>, fps:Number=12)
		{
			super(textures,fps);
		}
		
		public function set isReverse(value:Boolean):void
		{
			if(this._isReverse != value) {
				var numFrames:int = this.numFrames;
				
				var mTextures:Vector.<Texture> = new Vector.<Texture>();
				var mSounds:Vector.<Sound> = new Vector.<Sound>();
				var mDurations:Vector.<Number> = new Vector.<Number>();
				
				for(var i:int=numFrames-1;i>=0;i--) {
					mTextures.push(this.getFrameTexture(i));
					mSounds.push(this.getFrameSound(i));
					mDurations.push(this.getFrameDuration(i));
				}
				
				for(var j:int=0;j<numFrames;j++) {
					this.setFrameTexture(j,mTextures[j]);
				}
				
				this.currentFrame = numFrames-1 - this.currentFrame;
			}
			
			this._isReverse = value;
		}
		
		public function get isReverse():Boolean
		{
			return this._isReverse;
		}
	}
}