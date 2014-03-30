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
	public class Platform extends Sprite 
	{
		public var platformSprite:Image;
		private var platformPhysics:PhysInjector;
		private var platformObject:PhysicsObject;
		public var platform:Boolean = true;
		private var posX:Number;
		private var posY:Number;
		
		public function Platform(worldPhysics:PhysInjector, x:Number, y:Number)
		{
			super();
			platformPhysics = worldPhysics;
			posX = x;
			posY = y;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			platformArt();
			injectPhysics();
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function platformArt():void
		{
			platformSprite = new Image(Assets.getTexture("Floor"));
			platformSprite.x = posX;
			platformSprite.y = posY;
			this.addChild(platformSprite);
		}
		
		 
		private function injectPhysics():void
		{
			platformObject = platformPhysics.injectPhysics(this, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:false, friction:0.5, restitution:0 } ));
		}	
		
		
		private function update(e:Event):void 
		{
			platformPhysics.update();
		}
		
	}

}