package  
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import com.reyco1.physinjector.PhysInjector;
    import com.reyco1.physinjector.data.PhysicsObject;
    import com.reyco1.physinjector.data.PhysicsProperties;
	import com.reyco1.physinjector.manager.Utils;
	
	import Box2D.Collision.b2AABB;
	import Box2D.Dynamics.Contacts.b2Contact;
	import com.reyco1.physinjector.contact.ContactManager;
	
	import Box2D.Common.Math.b2Vec2;
	
	import flash.ui.Keyboard;
	import starling.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author Yolanda
	 */
	public class DontMiss extends Sprite
	{
		private var fishPhysics:PhysInjector;
		private var fishObject:PhysicsObject;
		
		private var scoreText:TextField;
		
		private var pawObject:PhysicsObject;
		private var block1:PhysicsObject;
		private var block2:PhysicsObject;
		private var trash:PhysicsObject;
		
		private var touch:Touch;
		private var touchX:Number;
		private var touchY:Number;
		private var valor:Number;
		
		private var touchPaw:Touch;
		
		public var fishBoneSprite:Image;
		private var value:Number;
		private var limit:Number;
		private var posX:int;
		private var random:Number;
		private var localPos:Point;
		private var catPaw:Image;
		private var Block1:Image;
		private var Block2:Image;
		private var gameArea:Rectangle;
		
		private var background:Image;
		private var background2:Image;
		private var background1:Image;
		
		private var timeCurrent:Number;
		
		private var _score:Number;
		private var lives:Number;
		
		private var fishTime:Number;
		
		private var time:Number;
		
		private var previousPos:Point;
		private var currentPos:Point;
		
		private var fishBones:Vector.<PhysicsObject>;
		
		private var collides:Boolean;
		
		private var lose:Image;
		
		public function DontMiss()
		{
			super();
			trace("Don't Miss the Fish");
			lives = 3;
			time = 250;
			timeCurrent = 0;
			score = 0;
			fishTime = 0;
			valor = 0;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		public function initialize():void
		{
			this.visible = true;
			trace("minigame");
		}
		
		private function onAddedToStage(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			Mouse.hide();
			trace("aish");
			fishBones = new Vector.<PhysicsObject>;
			localPos = new Point(0, 0);
			previousPos = new Point(0, 0);
			currentPos = new Point(0, 0);
			fishPhysics = new PhysInjector(Starling.current.nativeStage, new b2Vec2(0, 2.5), false); // false y asi no se puede mover con raton 
			gameArea = new Rectangle(100, 0, 700, 400);
			
			drawPaw();
			
			addEventListener(TouchEvent.TOUCH, onTouch);
			addEventListener(TouchEvent.TOUCH, onClick);
			addEventListener(Event.ENTER_FRAME, update);
			
			
		}
		
		private function drawPaw():void
		{
			background = new Image(Assets.getAtlasMini().getTexture("asset7"));
			this.addChild(background);
			
			background2 = new Image(Assets.getAtlasMini().getTexture("asset8"));
			this.addChild(background2);
			background2.visible = false;
			
			background1 = new Image(Assets.getAtlasMini().getTexture("asset9"));
			this.addChild(background1);
			background1.visible = false;
			

			
			Block1 =  new Image(Assets.getAtlasMini().getTexture("asset6"));
			this.addChild(Block1);
			block1 = fishPhysics.injectPhysics(Block1, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:false, friction:0.35, restitution:0.8, contactGroup:"walls" } ));
			
			Block2 =  new Image(Assets.getAtlasMini().getTexture("asset6"));
			Block2.x = 800;
			this.addChild(Block2);
			block2 = fishPhysics.injectPhysics(Block2, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:false, friction:0.35, restitution:0.8, contactGroup:"walls" } ));
			
			
			catPaw = new Image(Assets.getAtlasMini().getTexture("asset1"));
			this.addChild(catPaw);
			
			
			lose = new Image(Assets.getAtlasMini().getTexture("asset2"));
			this.addChild(lose);
			lose.visible = false;
			
			scoreText = new TextField(925, 400, "Score:", "MyFontName", 48, 0x670f10);
			this.addChild(scoreText);
			scoreText.visible = false;
			
			ContactManager.onContactBegin("fishBones", "walls", wallCollides, true);
			ContactManager.onContactEnd("fishBones", "walls", wallNotCollides, true);

		}
		
		private function onTouch(event:TouchEvent):void
		{
			touchPaw = event.getTouch(stage);

			if (touchPaw != null)	
			{			
				touchX = touchPaw.globalX;
				touchY = touchPaw.globalY;
				
				if (touchX < gameArea.x)
					touchX = gameArea.x;
				if (touchX > gameArea.x + gameArea.width)
					touchX = gameArea.x + gameArea.width;
					
				if (touchY < gameArea.y)
					touchY = gameArea.y;
				if (touchY > gameArea.y + gameArea.height)
					touchY = gameArea.y + gameArea.height;
				
				catPaw.x = touchX - catPaw.width/2;
				catPaw.y = touchY - catPaw.height / 2;
				
				currentPos.x = touchX;
				if(currentPos.x - previousPos.x!=0) valor = currentPos.x - previousPos.x;
				previousPos.x = touchX;

			}	
			
			else valor = 0;
		}
		
		private function onClick(event:TouchEvent):void
		{	
			touch = event.getTouch(this, TouchPhase.BEGAN);
			if (touch)
			{
				
				for (var i:uint = 0; i < fishBones.length; i++)
				{
					if (catPaw.bounds.intersects(fishBones[i].displayObject.bounds))
					{
						fishBones[i].body.ApplyImpulse(new b2Vec2((valor), -6), new b2Vec2(touch.globalX,touch.globalY));
						fishBones[i].body.ApplyImpulse(new b2Vec2((valor), -6), fishBones[i].body.GetWorldCenter());
					}
				}
			}	
		}

		private function createFishBones():void 
		{
		
			random = Math.random() * 10;
			
			posX = Math.random() * 900;
			if (posX < 200) posX = 200;
			if (posX > 700) posX = 600;
		
			if (random <= 3.33) value = 3;
			else if (random <= 6.66) value = 2;
			else value = 5;
		
			switch (value)
			{
				case 5:
					fishBoneSprite = new Image(Assets.getAtlasMini().getTexture("asset3"));
					fishBoneSprite.x = posX;
					break;
				
				case 2:
					fishBoneSprite = new Image(Assets.getAtlasMini().getTexture("asset4"));
					fishBoneSprite.x = posX;
					break;
					
				case 3:
					fishBoneSprite = new Image(Assets.getAtlasMini().getTexture("asset5"));
					fishBoneSprite.x = posX;
					break;
			}
			
			this.addChild(fishBoneSprite);
			fishObject = fishPhysics.injectPhysics(fishBoneSprite, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.35, restitution:0.5, contactGroup:"fishBones", isSensor:true, isBullet:true } ));
			
			fishObject.name = "fish";
			
			fishObject.body.SetFixedRotation(false);
			fishBones.push(fishObject);
			

		}

		private function update(e:Event):void 
		{	

			for (var i:uint = 0; i < fishBones.length; i++)
			{
				if (fishBones[i].body.GetAngularVelocity() > 0.8) fishBones[i].body.SetAngularVelocity(0.8);
				else if (fishBones[i].body.GetAngularVelocity() < -0.8) fishBones[i].body.SetAngularVelocity( -0.8);
				
				if (fishBones[i].body.GetLinearVelocity().x > 5) fishBones[i].body.GetLinearVelocity().x = 5;
				else if (fishBones[i].body.GetLinearVelocity().x < -5) fishBones[i].body.GetLinearVelocity().x = -5;
				
				if (fishBones[i].body.GetLinearVelocity().y > 5) fishBones[i].body.GetLinearVelocity().y = 4;
				else if (fishBones[i].body.GetLinearVelocity().y < -5) fishBones[i].body.GetLinearVelocity().y = -5;
				
				if (fishBones[i].y > gameArea.y + gameArea.height)
				{
					trash = fishBones[i];
					fishBones.splice(i, 1);
					trash.body.GetWorld().DestroyBody(trash.body);
					fishPhysics.removePhysics(trash.displayObject);
					removeChild(trash.displayObject);
					lives --;
					
					if (lives == 2) 
					{
						background2.visible = true;

					}
					else if (lives == 1)
					{
						background1.visible = true;
					}
					else if( lives == 0)
					{
						lose.visible = true;
						scoreText.visible = true;
						Mouse.show();
						removeEventListener(Event.ENTER_FRAME, update);	
						addEventListener(KeyboardEvent.KEY_DOWN, disposeDM);
					}	
				}
				
				else if (fishBones[i].y < gameArea.y && (fishBones[i].x<gameArea.x || fishBones[i].x >gameArea.x+gameArea.width))
				{
					fishBones[i].body.GetLinearVelocity().x *= -1;
				}
			}
			
			timeCurrent += 1;
			if (timeCurrent == time)
			{
				createFishBones();
				timeCurrent = 0;
				
				if(time>50)
					time -= 10;
			}
			
			fishTime += 1 / 60;
			_score = Math.round(fishTime);
			
			scoreText.text = "Score: " + _score;
			
			fishPhysics.update();
			
		}
		
		private function disposeDM(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.R)
			{	
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"play2" }, true));
			}
		}
		
		
		private function wallCollides(objectA:PhysicsObject, objectB:PhysicsObject, contact:b2Contact):void
		{
			objectA.physicsProperties.isSensor = false;
		}
		
		private function wallNotCollides(objectA:PhysicsObject, objectB:PhysicsObject, contact:b2Contact):void
		{
			objectA.physicsProperties.isSensor = true;
		}
		
		public function disposeTemporaly():void
		{
			this.visible = false;
		}
		
		public function get score():Number 
		{
			return _score;
		}
		
		public function set score(value:Number):void 
		{
			_score = value;
		}
		
		


	}

}