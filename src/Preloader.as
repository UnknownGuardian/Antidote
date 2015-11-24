package 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filters.GlowFilter;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Preloader extends MovieClip 
	{
		[Embed(source = "assets/Graphics/Backgrounds/main_menu_background.png")]private const BG:Class;
		[Embed(source = "assets/Graphics/HUD/mood_bar_bottom.png")]private const BAR:Class
		[Embed(source = "assets/Graphics/HUD/mood_bar_middle.png")]private const FILL:Class;
		[Embed(source = "assets/Graphics/Menus/Main Menu/button_play.png")]private const PLAY:Class;
		[Embed(source = "assets/splash/Logo.png")]private const LOGO:Class;
		private var back:Bitmap = new BG();
		private var loadBar:Bitmap = new BAR();
		private var fillBar:Bitmap = new FILL();
		private var playBtn:Sprite = new Sprite();
		
		public function Preloader() 
		{
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			//addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO show loader
			
			
			
			
			
			var sp:mainloader = new mainloader();
			sp.x = -130;
			sp.y = 90;
			addChild(sp);
			sp.addEventListener(Event.REMOVED_FROM_STAGE, traceStuff);
			return;
			
			
			
			
			
			
			
			
			
			
			stage.addChild(back);
			
			
			loadBar.x = fillBar.x = stage.stageWidth / 2 - loadBar.width / 2;
			loadBar.y = fillBar.y = 350;
			fillBar.x++;
			fillBar.y++;
			stage.addChild(loadBar);
			stage.addChild(fillBar);
			
			
			playBtn.addChild(new PLAY());
			playBtn.x = stage.stageWidth / 2 - playBtn.width / 2;
			playBtn.y = 340;
		}
		
		private function traceStuff(e:Event):void 
		{
			e.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, traceStuff);
			setTimeout(begin, 10);
		}
		
		private function ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void 
		{
			// TODO update loader
			var percent:Number = (e.target.bytesLoaded / e.target.bytesTotal);
			fillBar.scaleX = percent;
		}
		
		private function checkFrame(e:Event):void 
		{
				
			if (currentFrame == totalFrames && playBtn.parent == null) 
			{
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void 
		{
			
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO hide loader
			stage.addChild(playBtn);
			playBtn.addEventListener(MouseEvent.CLICK, startup);
			playBtn.useHandCursor = true;
			playBtn.buttonMode = true;
			playBtn.addEventListener(MouseEvent.ROLL_OVER, rOver);
			playBtn.addEventListener(MouseEvent.ROLL_OUT, rOut);
			stage.removeChild(loadBar);
			stage.removeChild(fillBar);
			
			//return;
			startup(null);
		}
		
		private function rOut(e:MouseEvent):void 
		{
			playBtn.filters = [];
		}
		
		private function rOver(e:MouseEvent):void 
		{
			trace("wot");
			playBtn.filters = [new GlowFilter(0xFFFFFF,1,10,10)];
		}
		
		private function startup(e:MouseEvent):void 
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			playBtn.removeEventListener(MouseEvent.CLICK, startup);
			playBtn.removeEventListener(MouseEvent.ROLL_OVER, rOver);
			playBtn.removeEventListener(MouseEvent.ROLL_OUT, rOut);
			stage.removeChild(playBtn);
			stage.removeChild(back);
			
			setTimeout(begin, 10);
		}
		private function begin():void
		{
			
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}