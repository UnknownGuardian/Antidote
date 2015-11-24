package 
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * ...
	 * @author UnknownGuardian
	 */
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{
		public static var play:PlayState;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			
			//var sp:SplashScreen = new SplashScreen();
			//addChild(sp);
			//sp.addEventListener(Event.REMOVED_FROM_STAGE, continueToGame);
			continueToGame(null);
		}
		
		private function continueToGame(e:Event):void 
		{
			if(e)e.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, continueToGame);
			TweenPlugin.activate([GlowFilterPlugin]);
			play = new PlayState();
			addChild(play);
			
		}

	}

}







//TOdo
/*
Here is our logo and preloader..

1) Preloader must be clickable to our website "http://www.startonlinegames.com" while loading.
2) More game link should go to http://www.startonlinegames.com
3) In game logo and logo on every page as possible all clickable..
4) This text on Main menu and game over page"Add This Game To Your Site" link to this "http://www.startonlinegames.com/download.php"

Example for our branding. http://www.startonlinegames.com/play.php?id=4757

Note :You can release the game on mochi ads under your account using mochi highscores to it (Our Branding Included)...  (I will inform you the game release date.)

Please do not add any tracking codes in the game....

Find attachment for preloader and stuff.*/