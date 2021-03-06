package  
{
	import Box2D.Common.Math.b2Vec2;
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
	
	/**
	 * ...
	 * @author Yolanda
	 */
	public class FishBone extends Sprite 
	{
		private var fishBoneSprite:Image;
		private var fishObject:PhysicsObject;
		private var fishPhysics:PhysInjector;

		private var posX:Number;
		private var posY:Number;
		private var value:uint;
		private var physicsActive:Boolean;
		private var _index:Number;
		//private var physicsOff:Boolean;
		
		public function FishBone(worldPhysics:PhysInjector, value:uint, x:Number, y:Number, physics:Boolean) 
		{
			super();
			posX = x;
			posY = y;
			this.value = value;
			physicsActive = physics;
			fishPhysics = worldPhysics;
			//trace(fishPhysics == worldPhysics);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
		}
		
		private function onAddedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			fishboneArt();
			trace(physicsActive);
			//physicsOff = false;
			//if (physicsActive) 
			//{
				injectPhysics();
				
				ContactManager.onContactBegin("fishbones", "floor", handleRemoveContact, true);
				ContactManager.onContactBegin("fishbones", "walls", handleRemoveContact,true); 

			//}
		}
		
		private function fishboneArt():void
		{
			
			if (value == 5) fishBoneSprite = new Image(Assets.getAtlas().getTexture("goldFish"));
			else if (value == 2) fishBoneSprite = new Image(Assets.getAtlas().getTexture("redFish"));
			else fishBoneSprite = new Image(Assets.getAtlas().getTexture("blueFish"));
			
			fishBoneSprite.x = posX;
			fishBoneSprite.y = posY;
			this.addChild(fishBoneSprite);
		}
		
		
		private function injectPhysics():void
		{
			fishObject = fishPhysics.injectPhysics(this, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:false, friction:0.5, restitution:0 } ));
			fishObject.x = posX;
			fishObject.y = posY;
			fishObject.physicsProperties.isSensor = true;
			fishObject.physicsProperties.contactGroup = "fishbones";
			fishObject.data = new Array(value, index);
			
			if (physicsActive) 
			{
				fishObject.physicsProperties.isDynamic = true;
				fishObject.body.SetAwake(true);
				if(value == 5) fishObject.body.SetLinearVelocity(new b2Vec2(Math.random()*1.5, -8));
				else if (value == 2) fishObject.body.SetLinearVelocity(new b2Vec2(Math.random()*-1.5, -6));
				else fishObject.body.SetLinearVelocity(new b2Vec2(Math.random()*3, -6));
			}
		
		}
		
		
		public function handleRemoveContact(objectA:PhysicsObject, objectB:PhysicsObject,contact:b2Contact):void
		{
			
			if (objectB.data == "fishBones")
			{
				objectA.physicsProperties.isDynamic = false;
				objectA.physicsProperties.contactGroup = "fishbones";
				objectA.physicsProperties.isSensor = true;
			}

		}
		
		public function get index():Number 
		{
			return _index;
		}
		
		public function set index(value:Number):void 
		{
			_index = value;
		}
	}

}