package  
{
	import com.greensock.TweenLite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class FaceSad extends Sad
	{
		public var loc:Point = new Point();
		private var _counter:int = 0;
		public function FaceSad(dx:Number, dy:Number) 
		{
			gotoAndStop(int(Math.random()*2)+1);
			loc.x = x = dx;
			loc.y = y = dy;
			
			TweenLite.from(this, .5, { delay:Math.random()*2, scaleX:.5, scaleY:0.5, alpha:0, onComplete:push} );
		}
		
		private function push():void 
		{
			PlayState.viruses.push(this);
		}
		
		
		public function get counter():int 
		{
			return _counter;
		}
		
		public function frame():Boolean //returns if it should be removed
		{
			_counter++;
			if (_counter > 480)
			//if (_counter > 48)
			{
				return true;
			}
			return false;
		}
		public function kill():void
		{
			TweenLite.to(this, .5, { scaleX:.5, scaleY:0.5, alpha:.2, onComplete:_kill, overwrite:true});
		}
		
		private function _kill():void 
		{
			if (parent == null) return;
			parent.removeChild(this);
		}
	}

}