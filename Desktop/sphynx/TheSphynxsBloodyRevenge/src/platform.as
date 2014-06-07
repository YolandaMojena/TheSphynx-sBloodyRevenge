package  
{
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
	public class Platform extends Sprite
	{
		public var platformSprite:Image;
		private var platformPhysics:PhysInjector;
		public var platformObject:PhysicsObject;
		private var wallSprite:Image;
		private var invisbleWallSprite:Image;		
		private var punchSprite:Image;
	//	private var punchObject:PhysicsObject;
		private var platSprite:Image;
		
		
		public var platform:Boolean = true;
		private var posX:Number;
		private var posY:Number;
		private var type:String;
		private var velocity:Number;
		private var k:Number = 0;
		
		public function Platform(worldPhysics:PhysInjector, x:Number, y:Number,spriteType:String)
		{
			super();
			platformPhysics = worldPhysics;
			posX = x;
			posY = y;
			type = spriteType;
			velocity = 0.5;
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
			if(type == "floor1"){
				platformSprite = new Image(Assets.getAtlas().getTexture("floor_right"));
				platformSprite.x = posX;
				platformSprite.y = posY;
				this.addChild(platformSprite);
			}
			if(type == "floor2"){
				platformSprite = new Image(Assets.getAtlas().getTexture("floor_left"));
				platformSprite.x = posX;
				platformSprite.y = posY;
				this.addChild(platformSprite);
			}
			
			else if (type == "smallFloor") {
				platformSprite = new Image(Assets.getAtlas().getTexture("floor"));
				platformSprite.x = posX;
				platformSprite.y = posY;
				this.addChild(platformSprite);
			}
			
			else if(type == "wall") {
				wallSprite = new Image(Assets.getAtlas().getTexture("small_wall"));
				wallSprite.x = posX;
				wallSprite.y = posY;
				this.addChild(wallSprite);	
			}
			
			else if(type == "biggerWall") {
				wallSprite = new Image(Assets.getAtlas().getTexture("big_wall"));
				wallSprite.x = posX;
				wallSprite.y = posY;
				this.addChild(wallSprite);	
			}
			
			else if(type == "punch") {
				punchSprite = new Image(Assets.getTexture("InvisibleWall"));
				punchSprite.x = posX;
				punchSprite.y = posY;
				this.addChild(punchSprite);	
			}
			
			else if (type == "platSides")
			{
				platSprite = new Image(Assets.getAtlas().getTexture("plat 2"));
				platSprite.x = posX;
				platSprite.y = posY;
				this.addChild(platSprite);	
			}
			else if (type == "platUp")
			{
				platSprite = new Image(Assets.getAtlas().getTexture("plat 3"));
				platSprite.x = posX;
				platSprite.y = posY;
				this.addChild(platSprite);	
			}
			else if (type == "plat")
			{
				platSprite = new Image(Assets.getAtlas().getTexture("plat 1"));
				platSprite.x = posX;
				platSprite.y = posY;
				this.addChild(platSprite);	
			}
			
			else if(type == "invisibleWall") {
				wallSprite= new Image(Assets.getTexture("InvisibleWall"));
				wallSprite.x = posX;
				wallSprite.y = posY;
				this.addChild(wallSprite);	
			}
		}
		
		 
		private function injectPhysics():void
		{
			if (type == "floor1" ||type == "floor2" )
			{
				platformObject = platformPhysics.injectPhysics(this, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:false, friction:0.5, restitution:0 } ));
				platformObject.name = "floor" + new String(platformObject.x);
				platformObject.physicsProperties.contactGroup = "floor";
				platformObject.data = "fishBones";
			}
			
			else if (type == "smallFloor")
			{
				platformObject = platformPhysics.injectPhysics(this, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:false, friction:0.5, restitution:0 } ));
				platformObject.name = "floor" + new String(platformObject.x);
				platformObject.physicsProperties.contactGroup = "floor";
				platformObject.data = "noFishBones";
			}
			
			
			
			else if (type == "wall" || type == "biggerWall") { 
				platformObject = platformPhysics.injectPhysics(this, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:false, friction:0.5, restitution:0 } ));
				platformObject.physicsProperties.contactGroup = "walls";
				platformObject.data = "fishBones";
	
			}
			
			else if (type == "invisibleWall")
			{
				platformObject = platformPhysics.injectPhysics(this, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:false, friction:0.5, restitution:0 } ));
				platformObject.physicsProperties.contactGroup = "walls";
				platformObject.physicsProperties.isSensor = true;
			}
			else if (type == "punch") 
			{
				platformObject = platformPhysics.injectPhysics(this, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:false, friction:0.5, restitution:0 } ));
				platformObject.physicsProperties.contactGroup = "punch";
				platformObject.physicsProperties.isSensor = true;
				
			}
			
			else if (type == "plat" || type == "platUp" || type == "platSides")
			{
				platformObject = platformPhysics.injectPhysics(platSprite, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:false, friction:0.5, restitution:0 } ));
				platformObject.body.SetFixedRotation(true);  // si se quita la plataforma se queda moviendose y dndo vueltas en plan guay =)
				platformObject.body.SetType(1);
				platformObject.physicsProperties.contactGroup = "floor";
			}
		
		}
		
		
		
		private function update(e:Event):void 
		{
			
			if (type == "platSides" || type == "plat")
			{
		
				velocity = Math.cos(k/80);
				k++;
				platformObject.body.SetLinearVelocity(new b2Vec2(velocity, 0));
			}
			if (type == "platUp")
			{	
				velocity = Math.cos(k/75);
				k++;
		
				platformObject.body.SetLinearVelocity(new b2Vec2(0, velocity));		
			}
			
		} 
		

		
	}

}