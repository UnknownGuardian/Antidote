package  
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import ugLabs.graphics.SpriteSheetAnimation;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class FaceHappy extends Happy
	{
		public var loc:Point = new Point();
		private var _counter:int = 0;
		
		[Embed(source = "assets/Graphics/Smilies/super_happy_SS.png")]private static const SS:Class;
		private static const HAPPY_SS:Bitmap = new SS();
		private var spritesheet:SpriteSheetAnimation;
		
		public function FaceHappy(dx:Number, dy:Number) 
		{
			gotoAndStop(int(Math.random()*2)+1);
			loc.x = x = dx;
			loc.y = y = dy;
			
			TweenLite.from(this, .5, { delay:Math.random()*2, scaleX:.5, scaleY:.5, alpha:0, onComplete:push} );
		}
		
		private function push():void 
		{
			PlayState.viruses.push(this);
		}
		
		
		public function frame():Boolean //returns if it should be removed
		{
			_counter++;
			if (_counter > 360 && currentFrame == 2)
			//if (_counter > 36 && currentFrame == 2)
			{
				gotoAndStop(3);
				spritesheet = new SpriteSheetAnimation(HAPPY_SS, 32, 32, 30, true, false);
				spritesheet.x = -16;
				spritesheet.y = -16;
				addChild(spritesheet);
			}
			if (_counter > 540)
			//if (_counter > 54)
			{
				return true;
			}
			return false;
		}
		
		public function kill():void
		{
			TweenLite.to(this, .5, { scaleX:.5, scaleY:0.5, alpha:.2, onComplete:_kill } );
		}
		
		private function _kill():void 
		{
			if (currentFrame == 3)
			{
				removeChild(spritesheet);
				spritesheet.destroy();
			}
			if (parent == null) return;
			parent.removeChild(this);
		}
	}

}