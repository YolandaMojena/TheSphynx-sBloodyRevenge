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
		
		private var _sphynxSprites:Image;
		private var sphynxPhysics:PhysInjector;
		private var sphynxObject:PhysicsObject;
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
		private var _score:Number;
		private var posX:Number;
		private var posY:Number;
		private var handle:Boolean;
		private var attackActive:Boolean;
		private var smallJump:Boolean;
		private var punch:Platform;
		private var counter:Number;
		private var pause:Boolean;
		private var canJump:Boolean = true;	
		private var passed:Number;
		private var minigame:Boolean;
		private var _cameraY:Boolean;
		private var attackTime:Number;
		private var jumpTime:Number;
		

		public function Sphynx(worldPhysics:PhysInjector, posX:Number,score:Number, minigame:Boolean) 
		{
			super();
			sphynxPhysics = worldPhysics;
			this.posX = posX;
			velocity = 0.2;
			limit = 2;
			canJump = true;
			pause = false;
			cameraY = false;
			attackTime = 0;
			this.minigame = minigame;
			this.score = score;
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
			this.addChild(sphynxSprites);	
			
			//sphynxSprites.x = posX;
			x = posX;
			
			
		}
		
		private function injectPhysics():void
		{
			sphynxObject = sphynxPhysics.injectPhysics(this, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.2, restitution:0 } ));
			sphynxObject.body.SetFixedRotation(true);
			sphynxObject.name = "cat";
			sphynxObject.physicsProperties.contactGroup = "cats";
			//sphynxObject.x = this.x;
			sphynxObject.x = posX;
			
			ContactManager.onContactBegin("cats", "walls", handleContactPlat,true);
			ContactManager.onContactBegin("cats", "floor", handleContactPlat, true);
			
			ContactManager.onContactBegin("cats", "fishbones", scoreContact, true); 
			ContactManager.onContactBegin("cats", "eyes", handleContactLives, true);
		}
	 
		private function sphynxAttack():void
		{
			attackActive = true;
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
					if (canJump && !attackActive) 
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
			score += objectB.data[0] as Number;
			Game.fishBones[objectB.data[1]][[3]] = false;
			objectB.body.GetWorld().DestroyBody(objectB.body);
			sphynxPhysics.removePhysics(objectB.displayObject);
			objectB.displayObject.parent.removeChild(objectB.displayObject);	
		}
		
		private function handleContactLives(sphynxObj:PhysicsObject, eyeObject:PhysicsObject,contact:b2Contact):void
		{
			/*
			if (attackActive)
			{
				eyeObject.name = "dead";
				Game.eyes[eyeObject.data[1]][3] = false;
			}
			else _sphynxSprites.visible = false;
			*/
		
			/*if (!attackActive) {
			}
			*/	
			//objectB.name = "dead";
			//Game.eyes[objectB.data[1]][3] = false;
			//sphynxSprites.visible = false; // para que el objeto no aparezca en pantalla , ve a update
			
			eyeObject.name = "dead";
			Game.eyes[eyeObject.data[1]][3] = false;
		}

		
		private function handleContactPlat(sphynxObj:PhysicsObject, objectB:PhysicsObject, contact:b2Contact):void
		{
			counter = 0;
			canJump = true;
			handle = true;
			cameraY = true;
		}
		
		private function fall():void
		{	
			if (sphynxObject.y > 430)
			{
				cameraY = false;
				if (sphynxObject.x > 2900 && sphynxObject.x < 3600 && minigame) 
				{
					this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"minigame" }, true));
			
					
				}
				else sphynxSprites.visible = false;	
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
		
		/*
		private function handleContactAttack(punchObject:PhysicsObject, eyeObject:PhysicsObject,contact:b2Contact):void
		{
			eyeObject.name = "dead";
			Game.eyes[eyeObject.data[1]][3] = false;
			trace("jop");
		}
		*/

		private function update(e:Event):void 
		{		
			if (attackActive)
			{
				attackTime += 1 / 60;
				if (attackTime >= 1)
				{
					attackTime = 0;
					//punch.visible = false;
					//this.removeChild(punch);
					attackActive = false;	
				}		
			}
			
			if (sphynxObject.x < sphynxSprites.width / 2) sphynxObject.x =sphynxSprites.width / 2;
			if (sphynxObject.x > Game.STAGEWIDTH - sphynxSprites.width / 2) 
			{
				if (sphynxObject.y < 150) this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"deleteAll" }, true));
				else sphynxObject.x = Game.STAGEWIDTH - sphynxSprites.width / 2;
				
			}
			
			if (!sphynxSprites.visible) // si no esta visible mandarlo al principio y visble de nuevo
			{			
				this.x = 37;
				sphynxObject.x = 37;
				this.y = 0;
				sphynxObject.y = 0
				sphynxObject.body.GetLinearVelocity().x = 0;
				sphynxSprites.visible = true;
			}
			

			if (sphynxObject.body.GetLinearVelocity().y < 0) goingUp = true;
			else goingUp = false;
			
			if (left) {
				if (Math.abs(sphynxObject.body.GetLinearVelocity().x) < limit)
					sphynxObject.body.GetLinearVelocity().x -= velocity;
					
			}
			
			if (right) { 
				if(Math.abs(sphynxObject.body.GetLinearVelocity().x)<limit)
					sphynxObject.body.GetLinearVelocity().x += velocity;
			}
			
			if (jump) {
				
				if (sphynxObject.body.GetLinearVelocity().y < 4)
				{
					sphynxObject.body.ApplyImpulse(new b2Vec2(0, -11), sphynxObject.body.GetWorldCenter());
					jump = false;
					counter = 2;
				}
			}
				
			if (smallJump)
			{
				if (sphynxObject.body.GetLinearVelocity().y < 4) {
					counter = 0;
					smallJump = false;
					if (goingUp) sphynxObject.body.ApplyImpulse(new b2Vec2(0, -6), sphynxObject.body.GetWorldCenter());
					else sphynxObject.body.ApplyImpulse(new b2Vec2(0, -9), sphynxObject.body.GetWorldCenter());
				}
			}
			
			if (sphynxObject.body.GetLinearVelocity().y == 0 && !goingUp )
			{
				counter = 0;
				canJump = true;
			}
			
			fall();	
			

			if(handle)
			{
				sphynxObject.y -= 0.5;
				handle = false;
			}											
		}	
		
		public function get score():Number 
		{
			return _score;
		}
		
		public function set score(value:Number):void 
		{
			_score = value;
		}
		
		public function get sphynxSprites():Image 
		{
			return _sphynxSprites;
		}
		
		public function set sphynxSprites(value:Image):void 
		{
			_sphynxSprites = value;
		}
		
		public function get cameraY():Boolean 
		{
			return _cameraY;
		}
		
		public function set cameraY(value:Boolean):void 
		{
			_cameraY = value;
		}
		
	}
}