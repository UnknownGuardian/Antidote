package  
{
	import flash.display.Bitmap;
	import net.profusiondev.graphics.SpriteSheetAnimation;
	
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Multiplier extends SpriteSheetAnimation 
	{
		[Embed(source = "assets/Graphics/HUD/x2_SS_test.png")]private const X2:Class;
		[Embed(source = "assets/Graphics/HUD/x3_SS_test.png")]private const X3:Class;
		[Embed(source = "assets/Graphics/HUD/x4_SS.png")]private const X4:Class;
		
		private const MultiplierX2:Bitmap = new X2();
		private const MultiplierX3:Bitmap = new X3();
		private const MultiplierX4:Bitmap = new X4();
		
		
		
		public function Multiplier(num:int) 
		{
			super(this["MultiplierX" + num], 29, 28, 50, false, false);
			visible = false;
		}
		
		public function hide():void
		{
			if (isAnimating)
			{
				stopAnimation();
			}
			visible = false;
		}
		public function show():void
		{
			if (!isAnimating)
			{
				startAnimation();
			}
			visible = true;
		}
		
	}

}