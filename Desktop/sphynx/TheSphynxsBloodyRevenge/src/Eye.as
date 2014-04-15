package  
{
	import Box2D.Collision.b2Collision;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.core.Starling;
	import starling.display.Image;
	
	import com.reyco1.physinjector.PhysInjector;
    import com.reyco1.physinjector.data.PhysicsObject;
    import com.reyco1.physinjector.data.PhysicsProperties;
	
	import Box2D.Dynamics.Contacts.b2Contact;
	import com.reyco1.physinjector.contact.ContactManager;
	
	import Box2D.Common.Math.b2Vec2;
	
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author Yolanda
	 */
	public class Eye extends Sprite 
	{
		public var eyeSprite:Image;
		private var eyePhysics:PhysInjector;
		private var eyeObject:PhysicsObject; 
		private var velocity:Number;
		
		private var posX:Number;
		private var posY:Number;
		private var bonus:Boolean;
		
		private var fish1:FishBone;
		private var fish2:FishBone;
		private var fish3:FishBone;
		
		
		//private var physics:PhysInjector = new PhysInjector(stage,new b2Vec2(0,10),true);
		
		
		public function Eye(worldPhysics:PhysInjector, x:Number, y:Number,bonus:Boolean) 
		{
			super();
			eyePhysics = worldPhysics;
			posX = x;
			posY = y;
			velocity = new Number(1.5);
			this.bonus = bonus;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
			
		}
		
		private function onAddedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			eyeArt();
			injectPhysics();
			
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function eyeArt():void
		{
			eyeSprite = new Image(Assets.getTexture("Eye"));
			eyeSprite.pivotX = eyeSprite.width / 2;
			eyeSprite.x = posX;
			eyeSprite.y = posY;
			this.addChild(eyeSprite);
		}
		
		private function injectPhysics():void
		{
			eyeObject = eyePhysics.injectPhysics(this, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.5, restitution:0 } ));
			eyeObject.physicsProperties.x = posX;
			eyeObject.name = "eye" + new String(eyeObject.x);
			//eyeObject.physicsProperties.contactGroup = ;
			eyeObject.body.SetFixedRotation(true);
			InGame.eyes.push(eyeObject);
			
		}
		
		public function handleContact(objectA:PhysicsObject, objectB:PhysicsObject,contact:b2Contact):void
		{
			//objectA.x = 700;
			//physics.removePhysics(objectB.displayObject);
			velocity *= -1;
			eyeSprite.scaleX *= -1;
		}
		
		public function explosionContact(objectA:PhysicsObject, objectB:PhysicsObject,contact:b2Contact):void
		{
			removeEventListener(Event.ENTER_FRAME, update);
			eyeObject.body.GetWorld().DestroyBody(eyeObject.body);
			this.removeChild(eyeSprite);
			trace("explosion");
			
			// random para que los value no sean siempre los mismos
			fish1 = new FishBone(eyePhysics, 5, eyeObject.x , eyeObject.y-200, true);
			this.addChild(fish1);
			/*fish2 = new FishBone(eyePhysics, 2, eyeObject.x, eyeObject.y-300, true);
			this.addChild(fish2);
			fish3 = new FishBone(eyePhysics, 1, eyeObject.x, eyeObject.y-400, true);
			this.addChild(fish3);*/
		}
		
		private function explosion():void 
		{
			ContactManager.onContactBegin(eyeObject.name, "punch", explosionContact);
		}
		
		private function update(e:Event):void 
		{
			eyeObject.body.SetLinearVelocity(new b2Vec2(velocity, 0));  // con esto no se come las paredes, poner en el gato
			
			for (var i:int = 0; i < InGame.walls.length; i++){
				ContactManager.onContactBegin(eyeObject.name, InGame.walls[i].name, handleContact);
			}
			if (bonus) explosion();
		}
	}

}