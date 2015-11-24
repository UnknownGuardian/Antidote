package  
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import net.profusiondev.graphics.SpriteSheetAnimation;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BetterVirus extends Virus
	{
		private const ALLIES:Array = ["blue", "green", "orange", "purple", "gray"];
		private const ALL:Array = ["blue", "green", "orange", "purple", "gray", "black"];
		private var _isAlly:Boolean = false;
		private var _counter:int = 0;
		
		
		
		[Embed(source = "assets/Graphics/viruses/bluey_SS.png")]private static const BLUE_SS:Class;
		[Embed(source = "assets/Graphics/viruses/black.png")]private static const BLACK_SS:Class;
		[Embed(source = "assets/Graphics/viruses/gray_SS.png")]private static const GRAY_SS:Class;
		[Embed(source = "assets/Graphics/viruses/greeny_SS.png")]private static const GREEN_SS:Class;
		[Embed(source = "assets/Graphics/viruses/orangy_SS.png")]private static const ORANGE_SS:Class;
		[Embed(source="assets/Graphics/viruses/purply_SS.png")]private static const PURPLE_SS:Class;
		private static var SS:Bitmap;
		private var spritesheet:SpriteSheetAnimation;
		private var _type:String;
		
		public function BetterVirus(dx:Number, dy:Number, type:String) 
		{
			x = dx;
			y = dy
			if (type == "ally") type = ALLIES[int(Math.random() * ALLIES.length)];
			if (type == "enemy") type = "black";
			if (type == "any") type = ALL[int(Math.random() * ALL.length)];
			changeType(type);
			TweenLite.from(this, .5, { delay:Math.random()*2, scaleX:.5, scaleY:.5, alpha:0, onComplete:push} );
		}
		private function push():void 
		{
			PlayState.viruses.push(this);
		}
		
		public function changeType(t:String):void
		{
			if (t == "blue") { gotoAndStop(1); SS = new BLUE_SS(); }
			if (t == "black"){ gotoAndStop(3); SS = new BLACK_SS(); }
			else _isAlly = true;
			if (t == "green") { gotoAndStop(5); SS = new GREEN_SS(); }
			if(t == "orange"){ gotoAndStop(7); SS = new ORANGE_SS(); }
			if(t == "purple"){ gotoAndStop(9); SS = new PURPLE_SS(); }
			if (t == "gray") { gotoAndStop(11); SS = new GRAY_SS(); }
			
			if (Math.random() > 0.5) gotoAndStop(currentFrame + 1);
			
			
			_type = t;
			spritesheet = new SpriteSheetAnimation(SS, 32, 32, SS.width / 32 * SS.height / 32, false, t == "black");
			spritesheet.x = -16;
			spritesheet.y = -16;
			
			
			
		}
		public function getType():String
		{
			return _type;
		}
		public function isAlly():Boolean
		{
			return _isAlly;
		}
		
		public function frame():Boolean //returns if it should be removed
		{
			_counter++;
			if (_counter == 360)
			{
				if (isMature())
				{
					addChild(spritesheet);
					spritesheet.startAnimation();
					removeChildAt(0);
				}
				else if (_type == "black")
				{
					spritesheet.x = spritesheet.y = -8;
					spritesheet.scaleX = spritesheet.scaleY = 0.5;
					addChild(spritesheet);
					spritesheet.startAnimation();
					removeChildAt(0);
				}
				else
				{
					gotoAndStop(currentFrame + 1);
				}
			}
			if (_counter > 540 || (_type == "black" && _counter > 360 + 25))
			{
				return true;
			}
			return false;
		}
		
		
		public function magnet(pointer:Pointer):void
		{
			if (!_isAlly) return;
			
			var p:Point = pointer.getFirstPoint();
			//if ((x - p.x) * (x - p.x) + (y - p.y) * (y - p.y) < 10000)
			{
				stepTowards(p.x, p.y, 2);
			}
		}
		
		public function isMature():Boolean
		{
			return (currentFrame % 2 == 0)
		}
		
		public function kill():void
		{
			TweenLite.to(this, .5, { scaleX:.5, scaleY:0.5, alpha:.2, onComplete:_kill } );
		}
		
		private function _kill():void 
		{
			if (parent == null) return;
			parent.removeChild(this);
		}
		
		public function stepTowards(X:Number, Y:Number, distance:Number = 1):void
		{
			var point:Point = new Point();
			point.x = X - x;
			point.y = Y - y;
			if (point.length <= distance)
			{
				x = X;
				y = Y;
				return;
			}
			point.normalize(distance);
			x += point.x;
			y += point.y;
		}
	}

}