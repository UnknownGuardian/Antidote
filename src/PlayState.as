package  
{
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class PlayState extends Sprite
	{
		public static var sfxMuted:Boolean = false;
		public static var musicMuted:Boolean = false;
		public static var GameLoop:Sfx = new Sfx(MainLoop, null, "music");
		public static var OtherLoop:Sfx = new Sfx(MenuLoop, null, "music");
		public static var Col0:Sfx = new Sfx(Sound0, null, "sfx");
		public static var Col5:Sfx = new Sfx(Sound5, null, "sfx");
		public static var Col10:Sfx = new Sfx(Sound10, null, "sfx");
		public static var Col15:Sfx = new Sfx(Sound15, null, "sfx");
		public static var Col20:Sfx = new Sfx(Sound20, null, "sfx");
		public static var Col25:Sfx = new Sfx(Sound25, null, "sfx");
		public static var Col70:Sfx = new Sfx(SoundSad, null, "sfx");
		
		private static var GameFinished:Sfx = new Sfx(SoundGameOver, null, "sfx");
		private static var GameMultipier:Sfx = new Sfx(SoundMultiplier, null, "sfx");
		
		
		
		
		
		
		
		
		public var bg:GameBackground = new GameBackground();
		public var bgFade:GameBackground = new GameBackground();
		public var menu:MMWindowGroup = new MMWindowGroup();
		public var gameOver:GameOverWindow = new GameOverWindow();
		public var top:TopBar = new TopBar();
		public var p:Pointer = new Pointer();
		public var drawingToggle:Boolean = false;
		public var drawingToggleNum:Number = 0;
		
		public static var viruses:Vector.<BetterVirus> = new Vector.<BetterVirus>();
		public static var powerups:Vector.<PowerUpVirus> = new Vector.<PowerUpVirus>();
		
		public var numHappy:Number = 0;
		public var counter:Number = 0;
		public var goodInARow:Number = 0;
		public var numToRespawn:Number = 0;
		
		public var powerupSpawnCount:int = 0;
		public var powerupSpawnMax:int = 900;
		
		private var _score:Number = 0;
		private var _life:Number = 100;
		private var _multiplier:Number = 1;
		
		
		private static var multi2:Multiplier = new Multiplier(2);
		private static var multi3:Multiplier = new Multiplier(3);
		private static var multi4:Multiplier = new Multiplier(4);
		
		//private var pScore:PlayerScore;
		
		private var pausedForPowerUp:Boolean = false;
		private var powerUpWindow:BetterPowerUpWindow = new BetterPowerUpWindow();
		
		private var _magnetOn:Boolean = false;
		private var _freezeOn:Boolean = false;
		private var _slowOn:Boolean = false;
		private var slowCounter:int = 0;
		private var freezeCounter:int = 0;
		private var magnetCounter:int = 0;
		
		public function PlayState() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoved);
			
			bg.gotoAndStop(1);
			addChild(bg);
			bgFade.gotoAndStop(1);
			addChild(bgFade);
			TweenPlugin.activate([BlurFilterPlugin]);
			
			top.music.useHandCursor = true;
			top.sfx.useHandCursor = true;
			top.music.addEventListener(MouseEvent.CLICK, toggleMusic);
			top.sfx.addEventListener(MouseEvent.CLICK, toggleSFX);
			top.sponsor.addEventListener(MouseEvent.CLICK, gotoMoreGames);
			gameOver.nameInput.restrict = "a-zA-Z 0-9"; //restrict so only numbers, letters, space
			
			
			powerUpWindow.x = stage.stageWidth / 2;
			powerUpWindow.y = stage.stageHeight / 2;
			/*powerUpWindow.p1.addEventListener(MouseEvent.ROLL_OVER, rOverPowerUp);
			powerUpWindow.p2.addEventListener(MouseEvent.ROLL_OVER, rOverPowerUp);
			powerUpWindow.p3.addEventListener(MouseEvent.ROLL_OVER, rOverPowerUp);
			powerUpWindow.p1.addEventListener(MouseEvent.ROLL_OUT, rOutPowerUp);
			powerUpWindow.p2.addEventListener(MouseEvent.ROLL_OUT, rOutPowerUp);
			powerUpWindow.p3.addEventListener(MouseEvent.ROLL_OUT, rOutPowerUp);*/
			
			GameLoop.loop(0);
			OtherLoop.loop(0);
			showMenu();
		}
		private function toggleSFX(e:MouseEvent):void 
		{
			sfxMuted = !sfxMuted;
			if (sfxMuted) top.sfx.gotoAndStop(2);
			else top.sfx.gotoAndStop(1);
		}
		
		private function toggleMusic(e:MouseEvent):void 
		{
			musicMuted = !musicMuted;
			if (musicMuted)
			top.music.gotoAndStop(2);
			else top.music.gotoAndStop(1);
			
			TweenMax.to(GameLoop, 1, { volume:(musicMuted?0:1) } );
			TweenMax.to(OtherLoop, 1, { volume:(musicMuted?0:1) } );
		
		}
		
		
		
		
		
		public function startGame():void
		{
			stage.removeEventListener(Event.ENTER_FRAME, moveMarquee);
			stage.addEventListener(Event.ENTER_FRAME, frame);
			
			
			
			GameLoop.loop(0);
			TweenMax.to(OtherLoop, 1, { volume:0 } );
			TweenMax.to(GameLoop, 1, { volume:(musicMuted?0:1) } );
			
			
			addChild(p);
			
			addChild(top);
			
			var i:int = 0;
			for (i = 0; i < 3; i++)
			{
				spawnNewFace();
			}
			
			multi2.x = top.Mx2.x;
			multi3.x = top.Mx3.x;
			multi4.x = top.Mx4.x;
			multi2.y = top.Mx2.y;
			multi3.y = top.Mx3.y;
			multi4.y = top.Mx4.y;
			
			addChild(multi2);
			addChild(multi3);
			addChild(multi4);
		}
		
		private function frame(e:Event):void 
		{
			//var t:Number = getTimer();
			
			if (pausedForPowerUp)
			{
				powerUpWindow.frame();
				return;
			}
			
			counter++;
			p.addData();
			drawingToggleNum++
			if (drawingToggleNum == 2)
			{
				drawingToggleNum = 0;
				var t:Number = getTimer();
				p.draw();
				trace(getTimer() - t);
			}
			
			
			if (_slowOn)
			{
				slowCounter++;
				if (slowCounter % 4 != 0)
					return;
				if (slowCounter > 480)
				{
					_slowOn = false;
					slowCounter = 0;
				}
			}
			
			
			//{
			var encircledCount:Number = 0;
			var encircledCountPointValue:Number = 0;
			var avgX:Number = 0;
			var avgY:Number = 0;
			//}
			
			
			if (_freezeOn)
			{
				freezeCounter++;
				if (freezeCounter > 300)
				{
					_freezeOn = false;
					freezeCounter = 0;
				}
			}
			if (_magnetOn)
			{
				magnetCounter++;
				if (magnetCounter > 300)
				{
					_magnetOn = false;
					magnetCounter = 0;
				}
			}
			
			
			for (var i:int = 0; i < viruses.length; i++)
			{
				var shouldRemove:Boolean = false;
				if (!_freezeOn)
				{
					shouldRemove = viruses[i].frame();
					if (_magnetOn) viruses[i].magnet(p);
				}
				if(shouldRemove)
				{
					if (viruses[i].isAlly())
					{
						numHappy--;
						if (viruses[i].isMature())
						{
							life -= 3;
							spawnText(3, viruses[i].x, viruses[i].y, "bad");
						}
					}
					
					viruses[i].kill();
					viruses[i] = viruses[viruses.length - 1];
					viruses.length--;
					i--;
					spawnNewFace();
				}
				//{
				else if (drawingToggle == 0)
				{
					if(p.coordsEncircled(viruses[i].x, viruses[i].y))
							//if(pointEncircled(PlayState.faces[k].loc))
							//if (isPointInsideShape(PlayState.faces[k].loc, subArr))
					{
						encircledCount++;
						avgX += viruses[i].x;
						avgY += viruses[i].y;
						//kill
						var kF:BetterVirus = viruses[i];
						if (kF.isAlly())
						{
							if (kF.isMature())
							{
								score += 80 * multiplier;
								spawnText(80 * multiplier, kF.x, kF.y, "good");
								encircledCountPointValue += 80 * multiplier;
								if (!sfxMuted) 
								{
									if(multiplier == 1)
										Col0.play();
									else if (multiplier == 2)
										Col5.play();
									else if (multiplier == 3)
										Col15.play();
									else if (multiplier == 4)
										Col25.play();
								}
							}
							else
							{
								score += 50 * multiplier;
								spawnText(50 * multiplier, kF.x, kF.y, "good");
								encircledCountPointValue += 50 * multiplier;
								if (!sfxMuted) 
								{
									if(multiplier == 1)
										Col0.play();
									else if (multiplier == 2)
										Col0.play();
									else if (multiplier == 3)
										Col10.play();
									else if (multiplier == 4)
										Col20.play();
								}
							}
							life += 0.5;
							goodInARow++;
							if (goodInARow >= 15 && goodInARow < 30)
								multiplier = 2;
							else if (goodInARow >= 30 && goodInARow < 45)
								multiplier = 3;
							else if (goodInARow >= 45)
								multiplier = 4;
						}
						else
						{
							life -= 20;
							goodInARow = 0; 
							multiplier = 1;
							spawnText(20, kF.x, kF.y, "bad");
							encircledCountPointValue -= 20;
							
							if (!sfxMuted) Col70.play();
						}
						viruses[i].kill();
						viruses[i] = viruses[viruses.length - 1];
						viruses.length--;
						i--;
						numToRespawn++;
					}
				}//}
			}
			//{
			avgX /= encircledCount;
			avgY /= encircledCount;
			if (encircledCount > 1)
			{
				spawnText(encircledCountPointValue, avgX , avgY , "group");
				
				spawnEncircledBonus(encircledCount, avgX , avgY);
			}
			//}
			
			while (/*p.*/numToRespawn > 0)
			{
				spawnNewFace();
				/*p.*/numToRespawn--;
			}
			
			
			
			
			
			
			for (i = 0; i < powerups.length; i++)
			{
				var shouldRemove2:Boolean = false;
				if (!_freezeOn)
				{
					shouldRemove2 = powerups[i].frame();
					if (_magnetOn) powerups[i].magnet(p);
				}
				if(shouldRemove2)
				{
					powerups[i].kill();
					powerups[i] = powerups[powerups.length - 1];
					powerups.length--;
					i--;
				}
				else if (drawingToggle == 0)
				{
					if(p.coordsEncircled(powerups[i].x, powerups[i].y))
					{
						showPowerUpWindow();
						powerups[i].kill();
						powerups[i] = powerups[powerups.length - 1];
						powerups.length--;
						i--;
					}
				}
			}
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			powerupSpawnCount++;
			if (powerupSpawnCount > powerupSpawnMax)
			{
				powerupSpawnCount = 0;
				spawnPowerUp();
			}
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			//trace(getTimer() - t);
		}
		
		private function showPowerUpWindow():void 
		{
			addChild(powerUpWindow);
			pausedForPowerUp = true;
			powerUpWindow.generateNew();
			powerUpWindow.addEventListener(Event.REMOVED_FROM_STAGE, closePowerUpWindow);
		}
		
		private function closePowerUpWindow(e:Event):void 
		{
			e.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, closePowerUpWindow);
			pausedForPowerUp = false;
		}
		
		private function spawnEncircledBonus(encircledCount:Number, dx:Number, dy:Number):void 
		{
			var m:CollectionBonus = new CollectionBonus();
			if (encircledCount < 5)
				m.gotoAndStop(encircledCount -1);
			else
				m.gotoAndStop(4);
			m.x = dx;
			m.y = dy;
			addChild(m);
			m.scaleX = m.scaleY = 0.5;
			TweenMax.to(m, 1.2, { scaleY:1, scaleX:1,  onComplete:function():void { m.parent.removeChild(m);} } );	
		}
		
		private function spawnPowerUp():void 
		{
			var dx:Number = 0; 
			var dy:Number = 0;
			
			do {
				dx = Math.random() * 660 + 20;
				dy = Math.random() * 384 + 76;
			} while (p.coordsEncircled(dx, dy))
			
			var po:BetterPowerUpVirus = new BetterPowerUpVirus(dx, dy);
			addChild(po);
			
		}
		
		
		
		
		private function spawnProliferation(v:BetterVirus):void
		{
			if (!v.isAlly()) return;
			
			
			var dx:Number = 0; 
			var dy:Number = 0;
			
			var r:Number = Math.random();
			if (r < 0.25)
			{
				dx = v.x;
				dy = v.y - 35;
			}
			else if (r < 0.5)
			{
				dx = v.x - 35;
				dy = v.y;
			}
			else if (r < 0.75)
			{
				dx = v.x + 35;
				dy = v.y;
			}
			else
			{
				dx = v.x;
				dy = v.y + 35;
			}
			
			
			
			var f:BetterVirus = new BetterVirus(dx,dy,v.getType());
			addChild(f);
		}
		
		private function spawnNewFace():void 
		{
			
			var dx:Number = 0; 
			var dy:Number = 0;
			
			do {
				dx = Math.random() * 660 + 20;
				dy = Math.random() * 384 + 76;
			} while (p.coordsEncircled(dx, dy))
			
			
			
			if (Math.random() < 0.8)
			{
				var f5:BetterVirus = new BetterVirus(dx,dy,"ally");
				addChild(f5);
				//var f5:FaceHappy = new FaceHappy(dx,dy);
				//addChild(f5);
				numHappy++;
			}
			else
			{
				var f6:BetterVirus = new BetterVirus(dx,dy, "enemy");
				addChild(f6);
				//var f6:FaceSad = new FaceSad(dx,dy);
				//addChild(f6);
			}
			
			do {
				dx = Math.random() * 660 + 20;
				dy = Math.random() * 384 + 76;
			} while (p.coordsEncircled(dx, dy))
			
			if (Math.random() < 0.08-(PlayState.viruses.length*.003))
			{
				//var f7:FaceHappy = new FaceHappy(dx,dy);
				//addChild(f7);
				var f7:BetterVirus = new BetterVirus(dx,dy,"ally");
				addChild(f7);
				numHappy++;
			}
			
			
			/*
			var oldLength:int = faces.length;
			//if only 3 happy, we want more
			if (numHappy < 3 + (counter/1000))
			{
				var f:FaceHappy = new FaceHappy(dx,dy);
				faces.push(f);
				addChild(f);
				numHappy++;
			}
			
			if (numHappy > faces.length-2)
			{
				var f1:FaceSad = new FaceSad(dx,dy);
				faces.push(f1);
				addChild(f1);
			}
			//5% chance to spawn another happy
			if (Math.random() < 0.15)
			{
				var f3:FaceHappy = new FaceHappy(dx,dy);
				faces.push(f3);
				addChild(f3);
				numHappy++;
			}
			
			//2.5% chance to spawn another sad
			if (Math.random() < 0.025)
			{
				var f4:FaceSad = new FaceSad(dx,dy);
				faces.push(f4);
				addChild(f4);
			}
			
			if (faces.length == oldLength && Math.random()<0.15)
			{
				if (Math.random() < 0.8)
				{
					var f5:FaceHappy = new FaceHappy(dx,dy);
					faces.push(f5);
					addChild(f5);
					numHappy++;
				}
				else
				{
					var f6:FaceSad = new FaceSad(dx,dy);
					faces.push(f6);
					addChild(f6);
				}
			}*/
		}
		
		
		
		
		
		public function spawnText(value:Number, X:int, Y:int, type:String = "good"):void
		{
			var t:Sprite;
			if (type == "good")
			{
				t = new PlusPoints();
				(t as PlusPoints).box.text = "+" + value;
			}
			else if(type == "bad")
			{
				t = new MinusPoints();
				(t as MinusPoints).box.text = "-" + value;
			}
			else if(type == "group")
			{
				t = new GroupPoints();
				(t as GroupPoints).box.text = "" + value + "";
			}
			else if(type == "multiplier")
			{
				if (!sfxMuted) 
				{
					GameMultipier.play();
				}
			
				t = new MultiplierPoints();
				if (value == 2)
					(t as MovieClip).gotoAndStop(1);
				if (value == 3)
					(t as MovieClip).gotoAndStop(2);
				if (value == 4)
					(t as MovieClip).gotoAndStop(3);
			}
			t.x = X;
			t.y = Y;
			addChild(t);
			if (type == "multiplier")
				TweenMax.to(t, 1, { delay:0.5,alpha:0, blurFilter: { blurX:10, blurY:10 },  onComplete:function():void { t.parent.removeChild(t); } } );
			else
				TweenMax.to(t, 2, { y:"-30", alpha:0,  onComplete:function():void { t.parent.removeChild(t);} } );			
		}
		
		
		private function showMenu():void
		{
			TweenMax.to(OtherLoop, 1, { volume:(musicMuted?0:1) } );
			menu.x = stage.stageWidth / 2;
			menu.y = stage.stageHeight / 2;
			menu.playBtn.addEventListener(MouseEvent.CLICK, fadeToGame);
			//menu.david.addEventListener(MouseEvent.CLICK, gotoSite);
			//menu.danosongs.addEventListener(MouseEvent.CLICK, gotoSite);
			//menu.profusion.addEventListener(MouseEvent.CLICK, gotoSite);
			menu.credits.addEventListener(MouseEvent.CLICK, moveCredits);
			menu.sponsor.addEventListener(MouseEvent.CLICK, gotoSite);
			menu.moreBtn.addEventListener(MouseEvent.CLICK, gotoSite);
			menu.distribute.addEventListener(MouseEvent.CLICK, gotoSite);
			//menu.distribute.useHandCursor = true;
			menu.distribute.buttonMode = true;
			//menu.sponsor.useHandCursor = true;
			menu.sponsor.buttonMode = true;
			addChild(menu);
			
			//Leaderboards.List("HighScores", displayHighScoreList);
			//Data.Plays(showPlaysData);
			
			stage.addEventListener(Event.ENTER_FRAME, moveMarquee);
		}
		
		private function moveCredits(e:MouseEvent):void 
		{
			TweenMax.killTweensOf(menu.creditsWindow);
			TweenMax.to(menu.creditsWindow, 0.5, { x:0, ease:Cubic.easeInOut, overwrite:false } );
			TweenMax.to(menu.creditsWindow, 0.5, { x: -550, delay:2.5, ease:Cubic.easeInOut, overwrite:false } );
		}
		
		private function moveMarquee(e:Event):void 
		{
			menu.marquee.x -= 2;
			if (menu.marquee.x < -3963)
				menu.marquee.x += 3263;
		}
		
		private function showPlaysData(data:Object, response:Object):void 
		{
			if(response.Success)
			{
				if (data.Value == 0)
				{
					menu.playCounter.text = "Can you be number 1?"
				}
				else
				{
					menu.playCounter.text = "Antidote has been played " + data.Value + " times!";
				}
				
			}
			else
			{
				//menu.playCounter.text = "Error loading play count";
				trace("Error loading play count: " + response.ErrorCode);
				// score listing failed because of response.ErrorCode
			}
		}
		
		private function displayHighScoreList(scores:Array, numscores:int, response:Object):void 
		{
			if(response.Success)
			{
				trace(scores.length + " scores returned out of " + numscores);
						
				for(var i:int=0; i<scores.length; i++)
				{
					if (i > 11) break;
					//var score:PlayerScore = scores[i];
					//menu["name" + (i + 1)].text = score.Name;
					//menu["score" + (i + 1)].text = score.Points;
					//trace(" - " + score.Name + " got " + score.Points + " on " + score.SDate);
				}
			}
			else
			{
				menu["name1"].text = "Error Loading";
				menu["score1"].text = "";
				for(var q:int=2; q<=12; q++)
				{
					menu["name" + q].text = "";
					menu["score" + q].text = "";
				}
				trace("Couldn't load highscores due to " + response.ErrorCode);
				// score listing failed because of response.ErrorCode
			}
		}
		
		private function gotoSite(e:MouseEvent):void 
		{
			if (e.currentTarget == menu.david)
			{
				//Link.Open("http://davidarcila.com/?gameref=delineate", "DavidSite", "Developer");
				//Log.CustomMetric("DavidLink", "Links", true); // unique metric with group
				navigateToURL(new URLRequest("http://davidarcila.com/?gameref=Antidote"));
			}
			if (e.currentTarget == menu.danosongs)
			{
				//Link.Open("http://danosongs.com/?gameref=delineate", "DanoSongSite", "Developer");
				//Log.CustomMetric("DanoSongsLinks", "Links", true); // unique metric with group
				navigateToURL(new URLRequest("http://danosongs.com/?gameref=Antidote"));
			}
			if (e.currentTarget == menu.profusion)
			{
				//Link.Open("http://profusiongames.com/blog/?gameref=delineate", "ProfusionSite", "Developer");
				//Log.CustomMetric("UnknownGuardianLink", "Links", true); // unique metric with group
				navigateToURL(new URLRequest("http://profusiongames.com/?gameref=Antidote"));
			}
			if (e.currentTarget == menu.sponsor)
			{
				//throw new Error("Haven't implemented sponsors link on playstate.gotoSite");
				//Link.Open("http://www.startonlinegames.com", "ProfusionSite", "Developer");
				//Log.CustomMetric("SponsorsLink", "Links", true); // unique metric with group
				navigateToURL(new URLRequest("http://www.startonlinegames.com"));
			}
			if (e.currentTarget == menu.moreBtn)
			{
				//throw new Error("Haven't implemented more link on playstate.gotoSite");
				//Link.Open("http://profusiongames.com/blog/?gameref=delineate", "ProfusionSite", "Developer");
				//Log.CustomMetric("SponsorsLink", "Links", true); // unique metric with group
				navigateToURL(new URLRequest("http://www.startonlinegames.com"));
			}
			if (e.currentTarget == menu.distribute)
			{
				//throw new Error("Haven't implemented more link on playstate.gotoSite");
				//Link.Open("http://profusiongames.com/blog/?gameref=delineate", "ProfusionSite", "Developer");
				//Log.CustomMetric("SponsorsLink", "Links", true); // unique metric with group
				navigateToURL(new URLRequest("http://www.startonlinegames.com/download.php"));
			}
		}
		private function fadeToGame(e:MouseEvent):void 
		{
			//menu.playBtn.removeEventListener(MouseEvent.CLICK, fadeToGame);
			//menu.david.removeEventListener(MouseEvent.CLICK, gotoSite);
			//menu.danosongs.removeEventListener(MouseEvent.CLICK, gotoSite);
			menu.credits.removeEventListener(MouseEvent.CLICK, moveCredits);
			//menu.profusion.removeEventListener(MouseEvent.CLICK, gotoSite);
			menu.sponsor.removeEventListener(MouseEvent.CLICK, gotoSite);
			menu.moreBtn.removeEventListener(MouseEvent.CLICK, gotoSite);
			removeChild(menu);
			startGame();
		}
		
		private function showGameOver():void 
		{
			stage.removeEventListener(Event.ENTER_FRAME, frame);
			TweenMax.to(GameLoop, 1, { volume:0, onComplete:function():void {GameLoop.stop();} } );
			TweenMax.to(OtherLoop, 1, { volume:(musicMuted?0:1) } );
			setTimeout(cleanUpStage, 100);
		}
		private function cleanUpStage():void
		{
			bg.gotoAndStop(1);
			TweenMax.to(bgFade, 2, { alpha:0, onComplete:function():void { bgFade.gotoAndStop(1); bgFade.alpha = 1 }, overwrite:true} );
			
			for (var i:int = 0; i < numChildren; i++)
			{
				if(getChildAt(i) is BetterVirus)
					(getChildAt(i) as BetterVirus).kill();
			}
			viruses.length = 0;
			
			if (!sfxMuted) 
			{
				GameFinished.play();
			}
			
			
			gameOver.score.text = "" + score;
			gameOver.x = stage.stageWidth / 2;
			gameOver.y = stage.stageHeight / 2;
			gameOver.replay.addEventListener(MouseEvent.CLICK, replay);
			gameOver.more.addEventListener(MouseEvent.CLICK, gotoMoreGames);
			gameOver.sponsor.addEventListener(MouseEvent.CLICK, gotoMoreGames);
			gameOver.sponsor.buttonMode = true;
			gameOver.distribute.buttonMode = true;
			gameOver.distribute.addEventListener(MouseEvent.CLICK, gotoDistributeGame);
			addChild(gameOver);
			
			stage.focus = gameOver.nameInput;
			setTimeout(gameOver.nameInput.setSelection,50,0,gameOver.nameInput.text.length);
			gameOver.nameInput.addEventListener(FocusEvent.FOCUS_IN, onFocus)
			
			
			//package immediately. Less time to edit highscores by player
			//pScore = new PlayerScore("cake" + Math.random() * 1000, score);
		}
		
		private function onFocus(e:FocusEvent):void 
		{
			setTimeout(e.target.setSelection,50,0,e.target.text.length);
		}
		
		private function savedScore(response:Object):void 
		{
			if(response.Success)
			{
				trace("Score saved!");		
			}
			else
			{
				// submission failed because of response.ErrorCode
			}
		}
		
		
		
		private function gotoDistributeGame(e:MouseEvent):void 
		{
			navigateToURL(new URLRequest("http://www.startonlinegames.com/download.php"));
		}
		private function gotoMoreGames(e:MouseEvent):void 
		{
			navigateToURL(new URLRequest("http://www.startonlinegames.com"));
		}
		
		private function replay(e:MouseEvent):void 
		{
			//pScore.Name = gameOver.nameInput.text;
			//Leaderboards.Save(pScore, "HighScores", savedScore);
			
			gameOver.replay.removeEventListener(MouseEvent.CLICK, replay);
			gameOver.more.removeEventListener(MouseEvent.CLICK, gotoMoreGames);
			gameOver.nameInput.removeEventListener(FocusEvent.FOCUS_IN, onFocus)
			removeChild(gameOver);
			
			multiplier = 1;
			score = 0;
			life = 100;
			
			removeChild(top);
			removeChild(multi2);
			removeChild(multi3);
			removeChild(multi4);
			
			showMenu();
		}
		
		
		
		
		
		
		
		
		
		
		
		
		/*
		 * Powerup utils
		 */
		public function clickPowerUp(pU:PowerUp):void 
		{
			if (pU.currentFrame == 1)
				life = 100;
			else if (pU.currentFrame == 2)
			{
				//bomb -> eats bad viruses
				for (var i:int = 0; i < viruses.length; i++)
				{
					if (!viruses[i].isAlly())
					{
						viruses[i].kill();
						viruses[i] = viruses[viruses.length - 1];
						viruses.length--;
						i--;
						spawnNewFace();
					}
				}
			}
			/*else if (pU.currentFrame == 3)
				score += 1000;
			else if (pU.currentFrame == 4)
				score += 2000;
			else if (pU.currentFrame == 5)
				score += 500;*/
			else if (pU.currentFrame == 3)
			{
				//freeze
				_freezeOn = true;
			}
			else if (pU.currentFrame == 4)
			{
				//magnet
				_magnetOn = true;
			}
			else if (pU.currentFrame == 5 || pU.currentFrame == 9)
			{
				//proliferation
				for (var k:int = 0; k < viruses.length; k++)
				{
					spawnProliferation(viruses[k]);
				}
			}
			else if (pU.currentFrame == 6)
			{
				pU.gotoAndStop(int(Math.random() * pU.totalFrames));
				clickPowerUp(pU);
				//recursive call
			}
			else if (pU.currentFrame == 7)
			{
				//slow time
				_slowOn = true;
			}
			else if (pU.currentFrame == 8)
			{
				//special
				for (var j:int = 0; j < viruses.length; j++)
				{
					if (!viruses[j].isAlly())
					{
						viruses[j].kill();
						viruses[j] = viruses[viruses.length - 1];
						viruses.length--;
						j--;
						spawnNewFace();
					}
				}
			}
			
		}
		
		
		
		
		
		
		
		
		/*
		 * Getters and Setters
		 */
		public function get score():Number 
		{
			return _score;
		}
		
		public function set score(value:Number):void 
		{
			top.score.text = "" + value;
			_score = value;
		}
		
		public function get life():Number 
		{
			return _life;
		}
		
		public function set life(value:Number):void 
		{
			if (value > 100) value = 100;
			if (value < 0)
			{
				value = 0;
				showGameOver();
			}
			top.fill.scaleX = value / 100;
			_life = value;
		}
		
		public function get multiplier():Number 
		{
			return _multiplier;
		}
		
		public function set multiplier(value:Number):void 
		{
			if (value == _multiplier) return;
			if(_multiplier != 1)
				PlayState["multi" + _multiplier].hide();
			if (value != 1)
			{
				PlayState["multi" + value].show();
				spawnText(value, stage.stageWidth / 2, stage.stageHeight / 2, "multiplier");
			}
			
			bg.gotoAndStop(value);
			TweenMax.to(bgFade, 2, { alpha:0, onComplete:function():void { bgFade.gotoAndStop(value); bgFade.alpha = 1 }} );
			
			
			
			
			_multiplier = value;
		}
		
	}

}