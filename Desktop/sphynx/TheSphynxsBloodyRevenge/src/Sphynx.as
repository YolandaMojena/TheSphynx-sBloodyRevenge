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
		private var canJump:Boolean;
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
		private var canDie:Boolean = false;
		
		private var sc:SoundChannel;
		private var sc2:SoundChannel;
		private var sc3:SoundChannel;
		private var punchSound:Sound;
		private var madCat:Sound;
		private var deadCat:Sound;
		

		private var firstRight:Boolean = true;
		private var firstLeft:Boolean = true;
		private var firstStill:Boolean = true;
		
		private var deadTime:Number;
		
		private var jumpStill:Boolean;
		private var jumpTime:Number;
		
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
			deadTime = 0;
			jumpTime = 0;
		
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
			deadCat = Assets.getSound("MadCat");
		}
		
		//method to change the animations of the Sphynx, including pivot and scale
		private function changeSprites(name:String,rate:Number):void
		{
			_sphynxSprites.visible = false;
					
			if (_sphynxSprites.scaleX < 0)
			{
				_sphynxSprites = new MovieClip(Assets.getMoves().getTextures(name), rate);
				_sphynxSprites.scaleX *= -1;
				if(name!="attack")_sphynxSprites.pivotX += 20;			
			}
			else
			{
				_sphynxSprites = new MovieClip(Assets.getMoves().getTextures(name),rate);
				if(name!="attack") _sphynxSprites.pivotX += 20;	
						
			}
			
			if (name == "still") _sphynxSprites.pivotY -= 3;
					
			_sphynxSprites.visible = true;
			starling.core.Starling.juggler.add(_sphynxSprites);
			this.addChild(_sphynxSprites);
			
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
			if (!pause && !dead)
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
		
		// handles core on contact with fishbones
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
			if (attackActive)
			{
				if (eyeObject.body.GetLinearVelocity().x < 0)
				{

					if (sphynxObj.physicsProperties.x <= eyeObject.physicsProperties.x)
					{
						eyeObject.name = "dead";
						Game.eyes[eyeObject.data[1]][3] = false;
					}
				}
				else
				{
					if (sphynxObj.physicsProperties.x >= eyeObject.physicsProperties.x)
					{
						eyeObject.name = "dead";
						Game.eyes[eyeObject.data[1]][3] = false;
					}
				}		
			}
			else
			{
				trace("porquee");
				if (!dead)
				{
					if (sameHeight) canDie=true;
					dead = true;	
				}
			}
		}			
		
		private function handleContactPlat(sphynxObj:PhysicsObject, objectB:PhysicsObject, contact:b2Contact):void
		{
			if (_sphynxSprites.visible)
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
		}
		
		private function handleContactFloor(sphynxObj:PhysicsObject, objectB:PhysicsObject, contact:b2Contact):void
		{
			
			if (_sphynxSprites.visible)
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
		}
		
		private function fall():void
		{	
			//death by falling down a gap or navigation to minigame
			
			if ( sphynxObject.y >430)
			{
				cameraY = false;
				if (sphynxObject.x > 2900 && sphynxObject.x < 3600 && minigame) 
				{
					sc2 = madCat.play(149, 1);
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
					firstLeft = true;
					firstRight = true;
					break;
					
				case Keyboard.D:
					right = false;
					firstRight = true;
					firstLeft = true;

					break;
					
				case Keyboard.W:
					upNotPressed = true;
					break;
			}	
		}

		private function update(e:Event):void 
		{		
			
			if (!canJump) canDie = false;
			if (attackActive)
			{	
				if (first) 
				{
					changeSprites("attack_",10);
					first = false;
					second = true;	
				}
				 
				attackTime += 1 / 60;

				if (attackTime >= 0.5)
				{
					if (second)
					{
						changeSprites("still",15);
					}
					
					attackTime = 0;
					attackActive = false;	
					first = true;
				}
							
			}
			
			if (sphynxObject.x < sphynxSprites.width / 2) sphynxObject.x =sphynxSprites.width / 2;
			if (sphynxObject.x > 4440 ) 
			{
				if (sphynxObject.y < 150) this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"deleteAll" }, true));
				else if(sphynxObject.x > Game.STAGEWIDTH - sphynxSprites.width / 2) sphynxObject.x = Game.STAGEWIDTH - sphynxSprites.width / 2;
				
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
					if (firstRight)
					{
						firstRight = false;
					}
					
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
					goingUp = true;
					changeSprites("jumpUp_ 8", 10);
					canJump = false;
					sphynxObject.body.GetLinearVelocity().y -= 4.5;
					jump = false;
					counter = 2;
				}
			}
				
			if (smallJump)
			{
				counter = 0; 
				
				smallJump = false;
				changeSprites("jumpAir", 8);
				if (goingUp) sphynxObject.body.GetLinearVelocity().y -= 3; 
				else sphynxObject.body.GetLinearVelocity().y -= 3;	
				jumpStill = true;
			}
			
			if (jumpStill)
			{
				jumpTime += 1 / 60;
				trace(jumpTime);
			}
			if (!goingUp && !canJump && (jumpTime ==0 || jumpTime >= 0.8)) 
			{
				jumpStill = false;
				jumpTime = 0;
				changeSprites("still", 15);
			}
			
			
			fall();	

			// avoids getting stuck
			if(handle)
			{
				sphynxObject.y -= 0.5;
				handle = false;
			}	
			
			if ((right || left) && !_attackActive && !dead && canJump)
			{
				if (firstRight || firstLeft)
				{
					changeSprites("move",20);
					firstRight = false;
					firstLeft = false;
					firstStill = true;
				}
			}
			
			if (firstRight == true && firstLeft == true && !attackActive && !dead && !goingUp)
			{
				if (firstStill)
				{
					changeSprites("still",15);
					firstStill = false;
				}
			}
			
			if (dead)
			{
				if (!canDie) 
				{
					dead = false;
					sc3 = deadCat.play(0, 1);
					cameraY = false;
					
					_sphynxSprites.visible = false;
				}
				
				else
				{
					if(deadTime == 0)
					{
						changeSprites("death", 22);
						sc3 = deadCat.play(0, 1);
					}
				
					deadTime += 1 / 60;

					if (deadTime >= 0.5)
					{
						dead = false
						changeSprites("still",15);
						deadTime = 0;
						_sphynxSprites.visible = false;
						cameraY = false;
						canDie = false;
					}
				}
				
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