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
		
		private var _id:uint;
		
		public var sprite:String;
		
		public function Platform(worldPhysics:PhysInjector, x:Number, y:Number, _id:uint, sprite:String )
		{
			super();
			platformPhysics = worldPhysics;
			posX = x;
			posY = y;
			this._id = id;
			this.sprite = sprite;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			platformArt();
			injectPhysics();
		}
		
		private function platformArt():void
		{
			platformSprite = new Image(Assets.getTexture(sprite));
			platformSprite.x = posX;
			platformSprite.y = posY;
			this.addChild(platformSprite);
		}
		
		 
		private function injectPhysics():void
		{
			platformObject = platformPhysics.injectPhysics(this, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:false, friction:0.5, restitution:0 } ));
			if (_id == 2 || _id == 3) platformObject.name = "wall";
		}	
				
		public function get id():uint 
		{
			return _id;
		}
		
		public function set id(value:uint):void 
		{
			_id = value;
		}
		

		
	}

}