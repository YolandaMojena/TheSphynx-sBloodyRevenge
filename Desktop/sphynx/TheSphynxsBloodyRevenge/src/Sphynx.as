package  
{
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2MassData;
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
	
	import Box2D.Dynamics.Contacts.b2Contact;
	import com.reyco1.physinjector.contact.ContactManager;
	
	
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
		
		private var sphynxSprites:Image;
		private var sphynxPhysics:PhysInjector;
		public var sphynxObject:PhysicsObject;
		private var centerPoint:Point;
		private var center:b2Vec2;
		private var left:Boolean;
		private var right:Boolean;
		private var jump:Boolean;
		private var attack:Boolean;
		private var velocity:Number;
		private var goingUp:Boolean;
		private var limit:Number;
		private var count:uint;
		private var fishBones:Vector.<PhysicsObject>;
		public var score:Number;
		private var posX:Number;
		private var posY:Number;
		private var handle:Boolean;
		private var overHeight:Number;
		private var jumpHeight:Number;
		
		
		
		private var attackActive:Boolean;
		
		public var lives:Number;

		private var smallJump:Boolean;
		
		private var punch:Platform;
		
		private var counter:Number;
		
		private var pause:Boolean;
	
		private var canJump:Boolean = true;	
		
		private var passed:Number;

		public function Sphynx(worldPhysics:PhysInjector, x:Number, fishBones:Vector.<PhysicsObject>,score:Number, lives:Number) 
		{
			super();
			sphynxPhysics = worldPhysics;
			posX = x;
			velocity = 0.2;
			limit = 2;
			canJump = true;
			overHeight = 0;
			this.lives = lives;
			pause = false;
			this.score = score;
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
			attackActive = false;			
		}
				

		private function sphynxArt():void
		{
			sphynxSprites = new Image(Assets.getTexture("Cat"));
			sphynxSprites.x = posX;
			this.addChild(sphynxSprites);	
		}
		
		private function injectPhysics():void
		{
			sphynxObject = sphynxPhysics.injectPhysics(this, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.2, restitution:0 } ));
			sphynxObject.body.SetFixedRotation(true);
			sphynxObject.name = "cat";
			sphynxObject.physicsProperties.contactGroup = "cats";
			sphynxObject.x = posX;
			
			//ContactManager.onContactBegin("cats", "walls", handleContactPlat,true);
			ContactManager.onContactBegin("cats", "floor", handleContactPlat, true);
			
			ContactManager.onContactBegin("cats", "fishbones", scoreContact, true); 
			ContactManager.onContactBegin("cats", "eyes", handleContactLives, true);
		}
	 
		private function sphynxAttack():void
		{
			punch = new Platform(sphynxPhysics, sphynxObject.x+1, sphynxObject.y -175, "punch");
			this.addChild(punch);
			attackActive = true; 
			ContactManager.onContactBegin("punch", "eyes", handleContactAttack, true); //NO ENTRA
		}
		
		
		private function handleContactAttack(punchObject:PhysicsObject, eyeObject:PhysicsObject,contact:b2Contact):void
		{
			trace("AAAAARGH");
			eyeObject.name = "dead";
		}
		
		private function sphynxKeyboard():void
		{
			this.addEventListener(KeyboardEvent.KEY_DOWN, sphynxMoves);
			this.addEventListener(KeyboardEvent.KEY_UP, sphynxStops);
		}
		
		private function sphynxMoves(event:KeyboardEvent):void
		{ 
			if (!pause)
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
					{					
						jump = true;
						canJump = false;
					}
					
					if (counter == 2)
					{
						smallJump = true;
					}
					break;
					
				case Keyboard.X:
					if (canJump) 
					{
						sphynxAttack();
					}
			
					break;	
					
				case Keyboard.ESCAPE:
					pause = true;
					this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"pause" }, true));
					break;				
				}	
			}
			
			else
			{
				if (event.keyCode == Keyboard.R)
				{
					pause = false;
					sphynxObject.y -= 1
				}
			}		
		}
		

		
		private function scoreContact(sphynxObj:PhysicsObject, objectB:PhysicsObject, contact:b2Contact):void 
		{
			score += objectB.data as Number;
			objectB.body.GetWorld().DestroyBody(objectB.body);
			sphynxPhysics.removePhysics(objectB.displayObject);
			objectB.displayObject.parent.removeChild(objectB.displayObject);
			
			
		}
		
		private function handleContactLives(sphynxObj:PhysicsObject, objectB:PhysicsObject,contact:b2Contact):void
		{
			/*if (!attackActive) {
				
			}
			*/
			
			objectB.name = "dead";
			//sphynxSprites.visible = false; // para que el objeto no aparezca en pantalla , ve a update
			
			if(lives >1) lives--;
		}

		
		private function handleContactPlat(sphynxObj:PhysicsObject, objectB:PhysicsObject, contact:b2Contact):void
		{
			
			counter = 0;
			canJump = true;

		}
		

		
		private function fall():void
		{
			
			if (sphynxObject.y > 430) 
				if (sphynxObject.x > 900 && sphynxObject.x < 1000) 
				{
					this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"minigame" }, true));
					
				}
				else sphynxSprites.visible = false;	
			
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
					
			if (!sphynxSprites.visible) // si no esta visible mandarlo al principio y visble de nuevo
			{
				sphynxObject.x = posX;
				sphynxObject.y = 0;
				sphynxObject.body.GetLinearVelocity().x = 0;
				sphynxSprites.visible = true;
			}
		

			if (sphynxObject.body.GetLinearVelocity().y < 0) goingUp = true;
			else goingUp = false;
			
			if (left) {
				if(Math.abs(sphynxObject.body.GetLinearVelocity().x)<limit)
					sphynxObject.body.GetLinearVelocity().x -= velocity;
			}
			
			if (right) { 
				if(Math.abs(sphynxObject.body.GetLinearVelocity().x)<limit)
					sphynxObject.body.GetLinearVelocity().x += velocity;
			}
			
			if (jump) {
				
				if (sphynxObject.body.GetLinearVelocity().y < 4)
				{
					sphynxObject.body.ApplyImpulse(new b2Vec2(0, -13), sphynxObject.body.GetWorldCenter());
					jump = false;
					counter = 2;
				}
			}
				
			if (smallJump)
			{
				counter = 0;
				smallJump = false;
				if (goingUp) sphynxObject.body.ApplyImpulse(new b2Vec2(0, -8), sphynxObject.body.GetWorldCenter());
				else sphynxObject.body.ApplyImpulse(new b2Vec2(0, -18), sphynxObject.body.GetWorldCenter());
				
			}
			
			if (sphynxObject.body.GetLinearVelocity().y == 0 && !goingUp )
			{
				counter = 0;
				canJump = true;
			}
			
			fall();	
			
			/*
			if(handle)
			{
				sphynxObject.y -= 1; //temporal
				handle = false;
				overHeight = 0;
			}	
			*/
										
		}	
	}
}