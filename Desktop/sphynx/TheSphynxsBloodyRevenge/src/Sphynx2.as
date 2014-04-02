package  
{
	import Box2D.Collision.b2AABB;
	import flash.geom.Point;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.core.Starling;
	import starling.display.Image;
	import flash.ui.Keyboard;
	import starling.events.KeyboardEvent;
	
	import com.reyco1.physinjector.PhysInjector;
    import com.reyco1.physinjector.data.PhysicsObject;
    import com.reyco1.physinjector.data.PhysicsProperties;
	
	import Box2D.Common.Math.b2Vec2;
	
	import flash.display.Stage;

	
	/**
	 * ...
	 * @author Yolanda
	 */
	public class Sphynx2 extends Sprite 
	{
		
		public var sphynxSprites:Image;
		private var centerPoint:Point;
		private var center:b2Vec2;
		private var left:Boolean;
		private var right:Boolean;
		private var jump:Boolean;
		private var attack:Boolean;
		private var velocity:uint;

		private var platforms:Vector.< Platform>
		private var posX:Number;
		private var posY:Number;
		
		private var jumpHeight:Number = 10;
		
		private var velY:Number;

		private var factor:Number = 0.9;
		private var bajando:Boolean = false;
		

		public function Sphynx2(platforms:Vector.<Platform>, x:Number, y:Number) 
		{
			super();
			this.platforms = platforms;
			posX = x;
			posY = y;
			velocity = 2.8
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, update);
			sphynxArt();
			sphynxKeyboard();
		}
				
		private function sphynxArt():void
		{
			sphynxSprites = new Image(Assets.getTexture("Cat"));
			sphynxSprites.x = posX;
			sphynxSprites.y = posY;
			this.addChild(sphynxSprites);	
		}
			
		private function sphynxCollides(platforms:Vector.<Platform>):Boolean
		{
			for (var i:uint = 0; i < platforms.length; i++)
			{
				if (this.bounds.intersects(platforms[i].bounds))
					return true;
			}
			return false;
		}
		
		private function canJump(platforms:Vector.<Platform>):Boolean
		{
			for (var i:uint = 0; i < platforms.length; i++)
			{
				if (sphynxSprites.y + sphynxSprites.height > platforms[i].platformSprite.y)
					return true;
			}	
			
			return false;
		}
		
		private function sphynxJumps():void
		{
			velY = 20;
			jump = true;	
			// cuando velY >0,animar salto
		}
		

			
		
		private function sphynxAttack():void
		{
			
		}
		
		
		
		private function sphynxKeyboard():void
		{
			this.addEventListener(KeyboardEvent.KEY_DOWN, sphynxMoves);
			this.addEventListener(KeyboardEvent.KEY_UP, sphynxStops);
		}
		
		private function sphynxMoves(event:KeyboardEvent):void
		{ 
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
					left = true;
					break;
					
				case Keyboard.RIGHT:
					right = true;
					break;
					
				case Keyboard.UP:
					jump = false;
					sphynxJumps();
					break;
					
				case Keyboard.X:
					attack = true;
					break;	
			}
				
		}
		
		private function sphynxStops(event:KeyboardEvent):void
		{ 
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
					left = false;
					break;
					
				case Keyboard.RIGHT:
					right = false;
					break;
			}	
		}
		
		private function update(e:Event):void 
		{			
			if (!sphynxCollides(platforms))
			{
				if (left) this.x -= velocity;
				if (right) this.x += velocity;
			}
		
			if (jump)
			{
				if (!canJump(platforms))
				{
					this.y -= velY;
					velY -= 0.5;
					
				}
			}	
			
					
		}	
		
	}
}