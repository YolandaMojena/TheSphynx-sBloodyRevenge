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
		private var wallSprite:Image;
		private var invisbleWallSprite:Image;		
		private var punchSprite:Image;
		private var punchObject:PhysicsObject;
		
		public var platform:Boolean = true;
		private var posX:Number;
		private var posY:Number;
		private var type:String;
		
		public function Platform(worldPhysics:PhysInjector, x:Number, y:Number,spriteType:String)
		{
			super();
			platformPhysics = worldPhysics;
			posX = x;
			posY = y;
			type = spriteType;
			
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
			if(type == "floor"){
				platformSprite = new Image(Assets.getTexture("Floor"));
				platformSprite.x = posX;
				platformSprite.y = posY;
				this.addChild(platformSprite);
			}
			else if(type == "wall") {
				wallSprite = new Image(Assets.getTexture("Wall"));
				wallSprite.x = posX;
				wallSprite.y = posY;
				this.addChild(wallSprite);	
			}
			else if(type == "punch") {
				punchSprite = new Image(Assets.getTexture("Punch"));
				punchSprite.x = posX;
				punchSprite.y = posY;
				this.addChild(punchSprite);	
			}
			/*else if(tipo == "invisibleWall") {
				invisibleWallSprite = new Image(Assets.getTexture("Wall"));
				invisibleWallSprite.x = posX;
				invisbleWallSprite.y = posY;
				this.addChild(invisibleWallSprite);	
			}*/

		}
		
		 
		private function injectPhysics():void
		{
			platformObject = platformPhysics.injectPhysics(this, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:false, friction:0.5, restitution:0} ));
			if (type == "wall"){ 
				platformObject.name = "wall" + new String(platformObject.x);
				InGame.walls.push(platformObject);
				//platformObject.physicsProperties.isSensor = true;
			}
			if (type == "punch") platformObject.name = "punch";
		}	
		
		
		private function update(e:Event):void 
		{
		}
		
	}

}