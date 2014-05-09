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
	
	
	/**
	 * ...
	 * @author Yolanda
	 */
	public class FishBone extends Sprite 
	{
		public var fishBoneSprite:Image;
		private var fishObject:PhysicsObject;
		private var fishPhysics:PhysInjector;

		private var posX:Number;
		private var posY:Number;
		private var _value:uint;
		private var physicsActive:Boolean;
		
		public function FishBone(worldPhysics:PhysInjector, value:uint, x:Number, y:Number,physics:Boolean) 
		{
			super();
			posX = x;
			posY = y;
			this.value = value;
			physicsActive = physics;
			fishPhysics = worldPhysics;
			trace(fishPhysics == worldPhysics);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
		}
		
		private function onAddedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			fishboneArt();
			trace(physicsActive);
			if (physicsActive) 
			{
				injectPhysics();
				addEventListener(Event.ENTER_FRAME, update);
			}
		}
		
		private function fishboneArt():void
		{
			
			if (value == 5) fishBoneSprite = new Image(Assets.getTexture("FishBoneG"));
			else if (value == 2) fishBoneSprite = new Image(Assets.getTexture("FishBoneR"));
			else fishBoneSprite = new Image(Assets.getTexture("FishBoneB"));
			
			fishBoneSprite.x = posX;
			fishBoneSprite.y = posY;
			this.addChild(fishBoneSprite);
		}
		
		private function injectPhysics():void
		{
			fishObject = fishPhysics.injectPhysics(this, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.5, restitution:0 } ));
			fishObject.x = posX;
			fishObject.y = posY;
			fishObject.physicsProperties.isSensor = true;
			fishObject.body.SetLinearVelocity(new b2Vec2(Math.random() * 3, -8));			
		}
		
		public function get value():uint 
		{
			return _value;
		}
		
		public function set value(value:uint):void 
		{
			_value = value;
		}
		
		private function update(e:Event):void 
		{
			if ( fishObject.y > posY)
			{
				removeEventListener(Event.ENTER_FRAME, update);
				fishObject.body.GetWorld().DestroyBody(fishObject.body);
			}
		}
	}
}