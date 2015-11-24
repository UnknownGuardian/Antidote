package  
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BetterPowerUpWindow extends PowerUpWindow
	{
		private var _isAnimating:Boolean = false;
		public function BetterPowerUpWindow() 
		{
			p1.gotoAndStop(1);
			p2.gotoAndStop(1);
			p3.gotoAndStop(1);
		}
		
		public function generateNew():void
		{
			p1.gotoAndStop(int(Math.random() * p1.totalFrames));
			p2.gotoAndStop(int(Math.random() * p2.totalFrames));
			p3.gotoAndStop(int(Math.random() * p3.totalFrames));
			p1.alpha = p2.alpha = p3.alpha = 0;
			p1.y = p2.y = p3.y = -200;
			p1.rotationY = Math.random() * 180 - 90;
			p2.rotationY = Math.random() * 180 - 90;
			p3.rotationY = Math.random() * 180 - 90;
			stage.addEventListener(MouseEvent.CLICK, choseUpgrade);
			TweenMax.allTo([p1, p2, p3], 0.5, { rotationY:0, y:0, alpha:1 }, 0.1, function():void { _isAnimating = false } );
			_isAnimating = true;
		}
		
		
		private function choseUpgrade(e:MouseEvent):void 
		{
			var p:PowerUp;
			if (stage.mouseX < 263)
				p = p1;
			else if (stage.mouseX > 437)
				p = p3;
			else
				p = p2;
			Main.play.clickPowerUp(p);
			stage.removeEventListener(MouseEvent.CLICK, choseUpgrade);
			TweenMax.allTo([p1, p2, p3], 0.5, { rotationY:Math.random() * 180 - 90, y:"-200", alpha:0 }, 0.1, close );
			_isAnimating = true;
		}
		
		private function close():void 
		{
			parent.removeChild(this);
		}
		
		public function frame():void
		{
			if (_isAnimating) return;
			p1.rotationY+=0.4;
			p2.rotationY+=0.4;
			p3.rotationY += 0.4;
			
			if (stage.mouseX < 263)
			{
				p1.blendMode = 'overlay';
				p2.blendMode = 'normal';
				p3.blendMode = 'normal';
			}
			else if (stage.mouseX > 437)
			{
				p1.blendMode = 'normal';
				p2.blendMode = 'normal';
				p3.blendMode = 'overlay';
			}
			else
			{
				p1.blendMode = 'normal';
				p2.blendMode = 'overlay';
				p3.blendMode = 'normal';
			}
		}
		
	}

}