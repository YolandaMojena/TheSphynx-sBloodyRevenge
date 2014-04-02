package  
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.core.Starling;
	import starling.display.Image;
	
	import com.reyco1.physinjector.PhysInjector;
    import com.reyco1.physinjector.data.PhysicsObject;
    import com.reyco1.physinjector.data.PhysicsProperties;
	
	import Box2D.Common.Math.b2Vec2;
	
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author Yolanda
	 */
	public class Wall extends Sprite 
	{
		
		public var wallSprite:Image;
		private var wallPhysics:PhysInjector;
		private var wallObject:PhysicsObject;
		private var posX:Number;
		private var posY:Number;
		
		public function Wall(worldPhysics:PhysInjector, x:Number, y:Number) 
		{
			super();
			wallPhysics = worldPhysics;
			posX = x;
			posY = y;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			wallArt();
			injectPhysics();
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function wallArt():void
		{
			wallSprite = new Image(Assets.getTexture("Wall"));
			wallSprite.x = posX;
			wallSprite.y = posY;
			this.addChild(wallSprite);
		}
		
		private function injectPhysics():void
		{
			wallObject = wallPhysics.injectPhysics(this, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:false, friction:0.5, restitution:0 } ));
			wallObject.physicsProperties.name = "wall";
			//wallObject.physicsProperties.contactGroup = "walls";
			
		}
		
		
		private function update(e:Event):void 
		{
			wallPhysics.update();
		}
		
	}

}