package 
{
	import com.greensock.* ;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import Playtomic.Link;
	
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class SplashScreen extends Sprite 
	{
		//[Embed(source = "../../../Sequence/Week Based/src/assets/Backgrounds/bkg_day.png")]private const BG:Class;
		[Embed(source = "assets/Graphics/Backgrounds/main_menu_background.png")]private const BG:Class;
		private var b:Bitmap;
		private var logo:ProfusionLogo;
		private var text:ProfusionText;
		public function SplashScreen():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			b = new BG();
			addChild(b );
			logo = new ProfusionLogo();
			logo.x = stage.stageWidth / 2;
			logo.y = stage.stageHeight / 2 - 10;
			addChild(logo);
			
			text = new ProfusionText();
			text.x = stage.stageWidth / 2;
			text.y = logo.y + logo.height / 2 + text.height / 2 + 30;
			addChild(text);
			
			(new ProfusionIntroSound).play();
			
			TweenPlugin.activate([BlurFilterPlugin]);
			
			TweenMax.from(logo, 2, { blurFilter: { blurX:10, blurY:10 } , ease:Bounce.easeInOut } );
			TweenMax.from(text, 2, { delay:2, alpha:0, y:"-20",  ease:Cubic.easeOut, onComplete:out } );
			
			stage.addEventListener(MouseEvent.CLICK, gotoSite);
		}
		
		private function gotoSite(e:MouseEvent):void 
		{
			Link.Open("http://profusiongames.com/", "SplashScreen", "Developer");
		}
		
		private function out():void 
		{
			TweenMax.to(logo, 1, { delay:1, y:"-50", alpha:0, ease:Sine.easeInOut } );
			TweenMax.to(text, 1, { delay:1, y:"200", alpha:0, ease:Cubic.easeIn, onComplete:kill } );
			//TweenMax.to(b, 1, { delay:1.5, alpha:1, onComplete:kill } );
		}
		
		private function kill():void 
		{
			stage.removeEventListener(MouseEvent.CLICK, gotoSite);
			parent.removeChild(this);
			removeChild(b);
			removeChild(logo);
			removeChild(text);
		}
		
	}
	
}