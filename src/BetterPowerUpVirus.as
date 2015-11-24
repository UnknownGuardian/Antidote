package  
{
	import com.greensock.TweenLite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BetterPowerUpVirus extends PowerUpVirus 
	{
		private var _counter:int = 0;
		public function BetterPowerUpVirus(dx:Number, dy:Number) 
		{
			x = dx;
			y = dy
			TweenLite.from(this, .5, { delay:Math.random() * 2, scaleX:.5, scaleY:.5, alpha:0, onComplete:push } );
		}
		private function push():void 
		{
			PlayState.powerups.push(this);
		}
		public function frame():Boolean //returns if it should be removed
		{
			_counter++;
			if (_counter > 240)
			{
				return true;
			}
			return false;
		}
		public function magnet(pointer:Pointer):void
		{
			var p:Point = pointer.getFirstPoint();
			if ((x - p.x) * (x - p.x) + (y - p.y) * (y - p.y) < 10000)
			{
				stepTowards(p.x, p.y, 2);
			}
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