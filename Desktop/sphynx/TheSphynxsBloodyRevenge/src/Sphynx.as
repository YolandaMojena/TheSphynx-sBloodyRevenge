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
	public class Sphynx extends Sprite 
	{
		
		public var sphynxSprites:Image;
		private var sphynxPhysics:PhysInjector;
		private var sphynxObject:PhysicsObject;
		private var centerPoint:Point;
		private var center:b2Vec2;
		private var left:Boolean;
		private var right:Boolean;
		private var jump:Boolean;
		private var attack:Boolean;
		private var velocity:uint;

		private var platforms:Vector.< Platform>;
		private var fishBones:Vector.<FishBone>;
		private var posX:Number;
		private var posY:Number;
		
		private var jumpHeight:Number;
	
		
		private var canJump:Boolean = true;
		

		public function Sphynx(worldPhysics:PhysInjector, platforms:Vector.<Platform>, x:Number, y:Number) 
		{
			super();
			sphynxPhysics = worldPhysics;
			this.platforms = platforms;
			posX = x;
			posY = y;
			velocity = 2.8;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, update);
			sphynxArt();
			injectPhysics();
			sphynxKeyboard();
		}
				

		private function sphynxArt():void
		{
			sphynxSprites = new Image(Assets.getTexture("Cat"));
			sphynxSprites.x = posX;
			sphynxSprites.y = posY;
			this.addChild(sphynxSprites);	
		}
		
		private function injectPhysics():void
		{
			sphynxObject = sphynxPhysics.injectPhysics(this, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.5, restitution:0 } ));
			sphynxObject.physicsProperties.x = posX;
			sphynxObject.body.SetFixedRotation(true);
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
		
		
		private function sphynxJump(platforms:Vector.<Platform>):void
		{
			jumpHeight = sphynxObject.physicsProperties.y;
			canJump = false;
			sphynxObject.body.ApplyImpulse(new b2Vec2(0, -1), sphynxObject.body.GetWorldCenter());
			
			
			for (var i:uint = 0; i < platforms.length; i++)
			{
				if (sphynxObject.physicsProperties.y + sphynxSprites.height >= platforms[i].platformSprite.y)
					canJump = true;
			}	
			
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
					if(canJump)
						jump = true;
					break;
					
				case Keyboard.X:
					sphynxAttack();
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
				
				case Keyboard.UP:
					jump = false;
					break;
			}	
		}
		
		private function update(e:Event):void 
		{			
			if (!sphynxCollides(platforms))
			{
				if (left) sphynxObject.physicsProperties.x -= velocity;
				if (right) sphynxObject.physicsProperties.x += velocity;
			}
			
			if (jump) sphynxJump(platforms);
				
					
			sphynxPhysics.update();	
		}	
		
	}
}