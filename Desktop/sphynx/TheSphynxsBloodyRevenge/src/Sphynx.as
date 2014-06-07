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
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	import flash.display.Stage;
	
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Yolanda
	 */
	public class Sphynx extends Sprite 
	{
		
		private var _sphynxSprites:MovieClip;
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
		private var _attackActive:Boolean;
		private var smallJump:Boolean;
		private var punch:Platform;
		private var counter:Number;
		private var pause:Boolean;
		private var canJump:Boolean = true;	
		private var passed:Number;
		private var minigame:Boolean;
		private var _cameraY:Boolean;
		private var attackTime:Number;
		private var upNotPressed:Boolean;
		private var first:Boolean = true;
		private var second:Boolean = true;
		private var sameHeight:Boolean = false;
		private var lookingLeft:Boolean = false;
		private var dead:Boolean = false;
		
		private var sc:SoundChannel;
		private var sc2:SoundChannel;
		private var punchSound:Sound;
		private var madCat:Sound;
		

		public function Sphynx(worldPhysics:PhysInjector, posX:Number,score:Number, minigame:Boolean) 
		{
			super();
			sphynxPhysics = worldPhysics;
			this.posX = posX;
			velocity = 0.5;
			limit = 2;
			canJump = true;
			pause = false;
			cameraY = false;
			attackTime = 0;
			sc = new SoundChannel();
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
			_sphynxSprites =  new MovieClip(Assets.getMoves().getTextures("still"), 10);
			starling.core.Starling.juggler.add(_sphynxSprites);
			_sphynxSprites.pivotX = _sphynxSprites.width / 2;
			this.addChild(_sphynxSprites);	
			
			//sphynxSprites.x = posX;
			x = posX;
			
			punchSound = Assets.getSound("PunchSound");
			madCat = Assets.getSound("Meow");
			
			
		}
		
		private function injectPhysics():void
		{
			sphynxObject = sphynxPhysics.injectPhysics(this, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.2, restitution:0 } ));
			sphynxObject.body.SetFixedRotation(true);
			sphynxObject.name = "cat";
			sphynxObject.physicsProperties.contactGroup = "cats";
			//sphynxObject.x = this.x;
			sphynxObject.x = posX;
			trace(sphynxObject.body.GetMass());
			
			ContactManager.onContactBegin("cats", "walls", handleContactPlat,true);
			ContactManager.onContactBegin("cats", "floor", handleContactFloor, true);
			
			ContactManager.onContactBegin("cats", "fishbones", scoreContact, true); 
			ContactManager.onContactBegin("cats", "eyes", handleContactLives, true);
		}
	 
		private function sphynxAttack():void
		{
			attackActive = true;
			sc = punchSound.play(0, 1);
			
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
				case Keyboard.A:
					left = true;
					break;
					
				case Keyboard.D:
					right = true;
					break;
					
				case Keyboard.W:
					
					upNotPressed = false;
					
					if (canJump)
					{					
						jump = true;
						
					}
					
					if (counter == 2)
					{
						smallJump = true;
					}
					break;
					
				case Keyboard.SPACE:
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
			//we manage attacks, the cat can only kill an eye if he's attacking and facing him
			if (attackActive && attackTime <= 0.5 && sameHeight)
			{
				if (eyeObject.body.GetLinearVelocity().x < 0)
				{
					if (sphynxObj.physicsProperties.x < eyeObject.physicsProperties.x)
					{
						eyeObject.name = "dead";
						Game.eyes[eyeObject.data[1]][3] = false;
					}
					else _sphynxSprites.visible = false;
				}
				else
				{
					if (sphynxObj.physicsProperties.x > eyeObject.physicsProperties.x)
					{
						eyeObject.name = "dead";
						Game.eyes[eyeObject.data[1]][3] = false;
					}
					else _sphynxSprites.visible = false;
				}		
			}
			else
			{
				dead = true;
				_sphynxSprites.visible = false;
			}
		}			
		
		private function handleContactPlat(sphynxObj:PhysicsObject, objectB:PhysicsObject, contact:b2Contact):void
		{
			counter = 0;
			if (upNotPressed)
			{
				canJump = true;
			}
			
			handle = true;
			cameraY = true;
			sameHeight = false;
		}
		
		private function handleContactFloor(sphynxObj:PhysicsObject, objectB:PhysicsObject, contact:b2Contact):void
		{
			counter = 0;
			if (upNotPressed)
			{
				canJump = true;
			}
			
			handle = true;
			cameraY = true;
			sameHeight = true;
		}
		
		private function fall():void
		{	
			
			if ( sphynxObject.y >430)
			{
				cameraY = false;
				if (sphynxObject.x > 2900 && sphynxObject.x < 3600 && minigame) 
				{
					this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"minigame" }, true));
				}
				else
				{
					sphynxSprites.visible = false;	
				}
				
			}
			
			if (sphynxObject.y >= 350 && sphynxObject.y<=360)
			{
				sc2 = madCat.play(149, 1);
			}
		}
		private function sphynxStops(event:KeyboardEvent):void
		{ 
			switch(event.keyCode)
			{
				case Keyboard.A:
					left = false;
					break;
					
				case Keyboard.D:
					right = false;
					break;
					
				case Keyboard.W:
					upNotPressed = true;
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
				if (first) 
				{
					_sphynxSprites.visible = false;
					if (_sphynxSprites.scaleX < 0)
					{
						_sphynxSprites = new MovieClip(Assets.getMoves().getTextures("attack"), 20);
						_sphynxSprites.scaleX *= -1;
						_sphynxSprites.pivotX +=20;
						
					}
					else
					{
						_sphynxSprites = new MovieClip(Assets.getMoves().getTextures("attack"), 20);
						_sphynxSprites.pivotX +=20;
						
					}
				
					
					
					
					_sphynxSprites.visible = true;
					starling.core.Starling.juggler.add(_sphynxSprites);
					this.addChild(_sphynxSprites);
					first = false;
					second = true;
					
					
				}
				 
				attackTime += 1 / 60;
				if (attackTime >= 0.8)
				{
					
					if (second)
					{
						_sphynxSprites.visible = false;
						if (_sphynxSprites.scaleX < 0)
						{
							_sphynxSprites = new MovieClip(Assets.getMoves().getTextures("still"), 10);
							_sphynxSprites.scaleX *= -1;
							_sphynxSprites.pivotX = _sphynxSprites.width / 2;
							
						}
						else 
						{
							
							_sphynxSprites = new MovieClip(Assets.getMoves().getTextures("still"), 10);
							_sphynxSprites.pivotX = _sphynxSprites.width / 2;
						}
						
						
						
						_sphynxSprites.visible = true;
						starling.core.Starling.juggler.add(_sphynxSprites);
						this.addChild(_sphynxSprites);
						second = false;
						
					}
					
					attackTime = 0;
					//punch.visible = false;
					//this.removeChild(punch);
					attackActive = false;	
					first = true;
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
				_sphynxSprites.scaleX = 1;
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
				{
					if (_sphynxSprites.scaleX > 0)
					{
						_sphynxSprites.scaleX *= -1;
					}
					
					 sphynxObject.body.GetLinearVelocity().x -= velocity;	
					
				}
					
			}
			
			if (right) { 
				if (Math.abs(sphynxObject.body.GetLinearVelocity().x) < limit)
				{
					if (_sphynxSprites.scaleX < 0)
					{
						_sphynxSprites.scaleX *= -1;
					}
					else sphynxObject.body.GetLinearVelocity().x += velocity;
					
					
				}
			}
			
			if (jump) {
				
				if (canJump)
				{
					trace("whaaatda...");
					canJump = false;
					sphynxObject.body.GetLinearVelocity().y -= 4.5;
					
					//sphynxObject.body.ApplyImpulse(new b2Vec2(0, -5), sphynxObject.body.GetWorldCenter());
					jump = false;
					counter = 2;
				}
			}
				
			if (smallJump)
			{
				counter = 0;
				smallJump = false;
				if (goingUp) sphynxObject.body.GetLinearVelocity().y -= 3; //sphynxObject.body.ApplyImpulse(new b2Vec2(0, -3), sphynxObject.body.GetWorldCenter());
				else sphynxObject.body.GetLinearVelocity().y -= 3;//sphynxObject.body.ApplyImpulse(new b2Vec2(0, -4), sphynxObject.body.GetWorldCenter());
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
		
		public function get sphynxSprites():MovieClip 
		{
			return _sphynxSprites;
		}
		
		public function set sphynxSprites(value:MovieClip):void 
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
		
		public function get attackActive():Boolean 
		{
			return _attackActive;
		}
		
		public function set attackActive(value:Boolean):void 
		{
			_attackActive = value;
		}
		
	}
}