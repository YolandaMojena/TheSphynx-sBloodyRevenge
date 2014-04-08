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
	
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;

	
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
		private var velocity:Number;
		private var goingUp:Number;
		private var limit:Number;
		private var count:uint;
		private var fishBones:Vector.<FishBone>;
		public var score:Number;
/*		private var posX:Number;
		private var posY:Number;*/
		
		private var jumpHeight:Number;
	
		
		private var canJump:Boolean = true;
		

		public function Sphynx(worldPhysics:PhysInjector, x:Number, y:Number, fishBones:Vector.<FishBone>) 
		{
			super();
			sphynxPhysics = worldPhysics;
	/*		posX = x;
			posY = y;*/
			velocity = 0.2;
			limit = 2;
			canJump = true;
			score = 0;
			this.fishBones = fishBones;
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
				

		private function sphynxArt(/*_x:Number, _y:Number*/):void
		{
			sphynxSprites = new Image(Assets.getTexture("Cat"));
	/*		sphynxSprites.x = _x;
			sphynxSprites.y = _y;*/
			this.addChild(sphynxSprites);	
			

		}
		
		private function injectPhysics():void
		{
			sphynxObject = sphynxPhysics.injectPhysics(this, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.5, restitution:0 } ));
	/*		sphynxObject.physicsProperties.x = posX;
			sphynxObject.physicsProperties.y = posY;*/
			sphynxObject.body.SetFixedRotation(true);
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
					if (canJump)
						jump = true;
						canJump = false;
						
					break;
					
				case Keyboard.X:
					sphynxAttack();
					break;	
			}
				
		}
		
		private function scoreValue(fishBones:Vector.<FishBone>):void
		{
			for ( var i:uint = 0; i < fishBones.length; i++)
			{
				if (this.bounds.intersects(fishBones[i].bounds))
				{
					this.score += fishBones[i].value;
					fishBones[i].removeFromParent(true);
					fishBones.splice(i, 1);
				}
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
			if (sphynxObject.body.GetLinearVelocity().y < 0) goingUp == true;
			else goingUp == false;
			
			if (left) {
				if(Math.abs(sphynxObject.body.GetLinearVelocity().x)<limit)
					sphynxObject.body.GetLinearVelocity().x -= velocity;
				
//				sphynxObject.body.ApplyForce(new b2Vec2(-velocity, 0), sphynxObject.body.GetWorldCenter());
			}
			if (right) { 
				trace(sphynxObject.body.GetLinearVelocity().x);
				if(Math.abs(sphynxObject.body.GetLinearVelocity().x)<limit)
					sphynxObject.body.GetLinearVelocity().x += velocity;
//				sphynxObject.body.ApplyForce(new b2Vec2(velocity, 0), sphynxObject.body.GetWorldCenter());
			}
			
			
			if (jump) 
				sphynxObject.body.ApplyImpulse(new b2Vec2(0, -13), sphynxObject.body.GetWorldCenter());
				//sphynxObject.body.GetLinearVelocity().y -= 5;
				jump = false;
					
				if (sphynxObject.body.GetLinearVelocity().y == 0 && !goingUp)
					canJump = true;
			
			scoreValue(fishBones);		

						
		}	
		
	}
}