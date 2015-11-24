package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Pointer extends Sprite
	{
		private var lastPoints:Vector.<Point> = new Vector.<Point>();
		private var drawingPad:Sprite;
		
		
		public var minX:Number = 0;
		public var maxX:Number = 0;
		public var minY:Number = 0;
		public var maxY:Number = 0;
		
		public var maxPoints:int = 52;
		
		public var bitmap:Bitmap = new Bitmap(new BitmapData(700, 480, true, 0));
		
		public function Pointer() 
		{
			addChild(bitmap);
			drawingPad = new Sprite();
			//addChild(drawingPad);
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			for (var i:int = 0; i < maxPoints; i++)
			{
				lastPoints[i] = new Point(stage.mouseX,stage.mouseY);
			}
			
		}
		
		public function getFirstPoint():Point
		{
			return lastPoints[0];
		}
		
		public function addData():void
		{
			for (var i:int = maxPoints-1; i>0 ; i--)
			{
				lastPoints[i].x = lastPoints[i-1].x
				lastPoints[i].y = lastPoints[i-1].y
			}
			lastPoints[0].x = stage.mouseX;
			lastPoints[0].y = stage.mouseY < 32 ? 32 : stage.mouseY;
			
			//lastPoints[0] = Point.interpolate(lastPoints[1], lastPoints[0], 0.2);
			lastPoints[0].x = (lastPoints[1].x - lastPoints[0].x) * 0.2 + lastPoints[0].x;
			lastPoints[0].y = (lastPoints[1].y - lastPoints[0].y) * 0.2 + lastPoints[0].y;
			
			findMinMax();
			
			
			//var p:Point = new Point(stage.mouseX, stage.mouseY)
			//if (p.y < 32) p.y = 32;			
			//if (lastPoints.length > 1)
			//{
				//p = Point.interpolate(lastPoints[0], p, 0.2);
			//}
			
			
			//var length:int = lastPoints.unshift(p);
			//findMinMax();
			//if (length > 52)
			//{
				//var e:Point = lastPoints.pop();
			//}
		}
		
		private function findMinMax():void 
		{
			minX = 349;
			maxX = 351;
			minY = 239;
			maxY = 241;
			var p:Point;
			for (var i:int = 0; i < lastPoints.length; i++)
			{
				p = lastPoints[i];
				if (p.x > maxX) maxX = p.x;
				if (p.x < minX) minX = p.x;
				if (p.y > maxY) maxY = p.y;
				if (p.y < minY) minY = p.y;
			}
		}
		
		public function draw():void
		{			
			var g:Graphics = drawingPad.graphics;
			g.clear();
			
			var i:int = 0;
			
			var fillArr:Vector.<Point> = new Vector.<Point>();
			outer: for (i = 0; i < lastPoints.length-3; i++)
			{
				inner: for (var j:int = i+2; j < lastPoints.length-3; j++)
				{
					var p:Point = lineIntersectLine(lastPoints[i], lastPoints[i + 1], lastPoints[j], lastPoints[j + 1])
					if (p != null)
					{
						//g.beginFill(0xFF0000);
						//g.drawCircle(p.x, p.y, 8);
						//g.endFill();
						
						var subArr:Vector.<Point> = new Vector.<Point>();
						subArr.push(p);
						g.lineStyle(6, 0xFFFFFF,.4);
						g.beginFill(0xFFFFFF, .1);
						g.moveTo(p.x, p.y);
						for (var k:int = i+1; k < j + 1; k++)
						{
							g.lineTo(lastPoints[k].x, lastPoints[k].y);
							subArr.push(lastPoints[k]);
						}
						g.endFill();
						
						/*var encircledCount:Number = 0;
						var encircledCountPointValue:Number = 0;
						var avgX:Number = 0;
						var avgY:Number = 0;
						for (k = 0; k < PlayState.faces.length; k++)
						{
							if(coordsEncircled(PlayState.faces[k].x, PlayState.faces[k].y))
							//if(pointEncircled(PlayState.faces[k].loc))
							//if (isPointInsideShape(PlayState.faces[k].loc, subArr))
							{
								encircledCount++;
								avgX += PlayState.faces[k].x;
								avgY += PlayState.faces[k].y;
								//kill
								var kF:Face = PlayState.faces[k];
								if (kF is FaceHappy)
								{
									if (kF.currentFrame == 3)
									{
										Main.play.score += 80 * Main.play.multiplier;
										Main.play.spawnText(80 * Main.play.multiplier, kF.x, kF.y, "good");
										encircledCountPointValue += 80 * Main.play.multiplier;
										if (!PlayState.sfxMuted) 
										{
											if(Main.play.multiplier == 1)
												PlayState.Col0.play();
											else if (Main.play.multiplier == 2)
												PlayState.Col5.play();
											else if (Main.play.multiplier == 3)
												PlayState.Col15.play();
											else if (Main.play.multiplier == 4)
												PlayState.Col25.play();
										}
									}
									else
									{
										Main.play.score += 50 * Main.play.multiplier;
										Main.play.spawnText(50 * Main.play.multiplier, kF.x, kF.y, "good");
										encircledCountPointValue += 50 * Main.play.multiplier;
										if (!PlayState.sfxMuted) 
										{
											if(Main.play.multiplier == 1)
												PlayState.Col0.play();
											else if (Main.play.multiplier == 2)
												PlayState.Col0.play();
											else if (Main.play.multiplier == 3)
												PlayState.Col10.play();
											else if (Main.play.multiplier == 4)
												PlayState.Col20.play();
										}
									}
									Main.play.life += 0.5;
									goodInARow++;
									if (goodInARow >= 15 && goodInARow < 30)
									{
										Main.play.multiplier = 2;
									}
									else if (goodInARow >= 30 && goodInARow < 45)
									{
										Main.play.multiplier = 3;
									}
									else if (goodInARow >= 45)
									{
										Main.play.multiplier = 4;
									}
								}
								else
								{
									Main.play.life -= 20;
									goodInARow = 0; 
									Main.play.multiplier = 1;
									Main.play.spawnText(20, kF.x, kF.y, "bad");
									encircledCountPointValue -= 20;
									
									if (!PlayState.sfxMuted) PlayState.Col70.play();
								}
								PlayState.faces[k].kill();
								PlayState.faces[k] = PlayState.faces[PlayState.faces.length - 1];
								PlayState.faces.length--;
								k--;
								numToRespawn++;
							}
						}
						avgX /= encircledCount;
						avgY /= encircledCount;
						if (encircledCount > 1)
						{
							Main.play.spawnText(encircledCountPointValue,avgX ,avgY , "group");
						}*/
						
						
						break inner;
					}
				}
			}
			
			
			
			
			
			g.lineStyle(3, 0xFFFFFF, 1);
			g.moveTo(lastPoints[0].x, lastPoints[0].y);
			for (i = 1; i < lastPoints.length-2; i++)
			{
				g.lineTo(lastPoints[i].x, lastPoints[i].y);
			}
			
			
			/*if (fillArr.length == 0) return;
			g.lineStyle(2, 0xFFFFFF);
			g.beginFill(0x000000, 0.5);
			g.moveTo(fillArr[0].x, fillArr[0].y);
			for (i = 1; i < fillArr.length; i++)
			{
				g.lineTo(fillArr[i].x, fillArr[i].y);
			}
			g.endFill();*/
			
			
			
			//bitmap.bitmapData.fillRect(new Rectangle(0, 28, 700, 480 - 28), 0);
			bitmap.bitmapData.fillRect(new Rectangle(minX-5, minY-5, maxX - minX+10, maxY-minY+10), 0);
			bitmap.bitmapData.draw(drawingPad);
		}
		
		
		
		
		
		
		
		
		
		public function lineIntersectLine(A : Point, B : Point,	E : Point, F : Point, ABasSeg : Boolean = true, EFasSeg : Boolean = true):Point
		{
			var ip:Point;
			var a1:Number;
			var a2:Number;
			var b1:Number;
			var b2:Number;
			var c1:Number;
			var c2:Number;
		 
			a1= B.y-A.y;
			b1= A.x-B.x;
			c1= B.x*A.y - A.x*B.y;
			a2= F.y-E.y;
			b2= E.x-F.x;
			c2= F.x*E.y - E.x*F.y;
		 
			var denom:Number=a1*b2 - a2*b1;
			if (denom == 0) {
				return null;
			}
			ip=new Point();
			ip.x=(b1*c2 - b2*c1)/denom;
			ip.y=(a2*c1 - a1*c2)/denom;
		 
			//---------------------------------------------------
			//Do checks to see if intersection to endpoints
			//distance is longer than actual Segments.
			//Return null if it is with any.
			//---------------------------------------------------
			if ( A.x == B.x )
				ip.x = A.x;
			else if ( E.x == F.x )
				ip.x = E.x;
			if ( A.y == B.y )
				ip.y = A.y;
			else if ( E.y == F.y )
				ip.y = E.y;
				//	Constrain to segment.
			if ( ABasSeg )
			{
				if ( ( A.x < B.x ) ? ip.x < A.x || ip.x > B.x : ip.x > A.x || ip.x < B.x )
					return null;
				if ( ( A.y < B.y ) ? ip.y < A.y || ip.y > B.y : ip.y > A.y || ip.y < B.y )
					return null;
			}
			if ( EFasSeg )
			{
				if ( ( E.x < F.x ) ? ip.x < E.x || ip.x > F.x : ip.x > E.x || ip.x < F.x )
					return null;
				if ( ( E.y < F.y ) ? ip.y < E.y || ip.y > F.y : ip.y > E.y || ip.y < F.y )
					return null;
			}
			return ip;
		}
		
		
		/*public function isPointInsideShape(point:Point, shapeVertices:Vector.<Point>):Boolean
		{
			var numberOfSides:int = shapeVertices.length;
		 
			var i:int = 0;
			var j:int = numberOfSides - 1;
		 
			var oddNodes:Boolean = false;
		 
			while (i < numberOfSides)
			{
				if ((shapeVertices[i].y < point.y && shapeVertices[j].y >= point.y) ||
					(shapeVertices[j].y < point.y && shapeVertices[i].y >= point.y))
				{
					if (shapeVertices[i].x + (((point.y - shapeVertices[i].y) / (shapeVertices[j].y - shapeVertices[i].y)) *
						(shapeVertices[j].x - shapeVertices[i].x)) < point.x)
					{
						oddNodes = !oddNodes;
					}
				}
		 
				j = i;
		 
				i++;
			}
		 
			return oddNodes;
		}*/
		
		/*public function pointEncircled(p:Point):Boolean
		{
			return bitmap.bitmapData.getPixel(p.x, p.y) != 0;
		}*/
		public function coordsEncircled(dx:Number, dy:Number):Boolean
		{
			return bitmap.bitmapData.getPixel(dx, dy) != 0 &&
					bitmap.bitmapData.getPixel(dx + 4, dy - 4) != 0 &&
					bitmap.bitmapData.getPixel(dx + 4, dy + 4) != 0 &&
					bitmap.bitmapData.getPixel(dx - 4, dy - 4) != 0 &&
					bitmap.bitmapData.getPixel(dx - 4, dy + 4) != 0;
		}
		
	}

}