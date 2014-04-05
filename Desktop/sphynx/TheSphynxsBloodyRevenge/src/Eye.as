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
		
		
		//private var physics:PhysInjector = new PhysInjector(stage,new b2Vec2(0,10),true);
		
		
		public function Eye(worldPhysics:PhysInjector, x:Number, y:Number) 
		{
			super();
			eyePhysics = worldPhysics;
			posX = x;
			posY = y;
			velocity = new Number(0.75);
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
			eyeObject.name = "eye";
			//eyeObject.physicsProperties.contactGroup = ;
			eyeObject.body.SetFixedRotation(true);
			
		}
		
		public function handleContact(objectA:PhysicsObject, objectB:PhysicsObject,contact:b2Contact):void
		{
			//objectA.x = 700;
			//physics.removePhysics(objectB.displayObject);
			velocity *= -1;
			eyeSprite.scaleX *= -1;
			trace("contact");
			
		}
		
		private function update(e:Event):void 
		{
			eyePhysics.update();
			eyeObject.body.SetLinearVelocity(new b2Vec2(velocity, 0));  // con esto no se come las paredes, poner en el gato
			
			ContactManager.onContactBegin("eye", "wall", handleContact);
			ContactManager.onContactBegin("eye", "wall2", handleContact);
			
		}
	}

}