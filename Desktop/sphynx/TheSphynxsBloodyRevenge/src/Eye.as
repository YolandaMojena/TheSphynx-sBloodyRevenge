package  
{
	import Box2D.Collision.b2Collision;
	import flash.geom.Point;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	
	import com.reyco1.physinjector.PhysInjector;
    import com.reyco1.physinjector.data.PhysicsObject;
    import com.reyco1.physinjector.data.PhysicsProperties;
	
	import Box2D.Dynamics.Contacts.b2Contact;
	import com.reyco1.physinjector.contact.ContactManager;
	
	import Box2D.Common.Math.b2Vec2;
	
	import flash.display.Stage;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	/**
	 * ...
	 * @author Yolanda
	 */
	public class Eye extends Sprite 
	{
		private var _eyeSprite:MovieClip;
		private var deadSprite:MovieClip;
		private var eyePhysics:PhysInjector;
		private var eyeObject:PhysicsObject; 
		private var _velocity:Number;
		private var posX:Number;
		private var posY:Number;
		private var bonus:Boolean;
		private var fish1:FishBone;
		private var fish2:FishBone;
		private var fish3:FishBone;
		private var boom:Boolean;
		private var _index:Number;
		private var animationTime:Number;
		private var first:Boolean = true;
		private var tempX:Number;
		private var tempY:Number;
		private var sc:SoundChannel;
		private var smudge:Sound;

		
		//private var physics:PhysInjector = new PhysInjector(stage,new b2Vec2(0,10),true);
		
		
		public function Eye(worldPhysics:PhysInjector, x:Number, y:Number,bonus:Boolean) 
		{
			super();
			eyePhysics = worldPhysics;
			posX = x;
			posY = y;
			animationTime = 0;
			velocity = new Number(0.75);
			this.bonus = bonus;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		private function onAddedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			eyeArt();
			injectPhysics();
			boom = false;
			
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function eyeArt():void
		{
			eyeSprite = new MovieClip(Assets.getMoves().getTextures("eye"), 5);
			eyeSprite.pivotX = eyeSprite.width / 2;
			eyeSprite.x = posX;
			eyeSprite.y = posY;
			starling.core.Starling.juggler.add(eyeSprite);
			this.addChild(eyeSprite);
			eyeSprite.scaleX *= -1;
			
			smudge = Assets.getSound("SmudgeSound");
			
			
		}
		
		private function injectPhysics():void
		{
			eyeObject = eyePhysics.injectPhysics(this, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.5, restitution:0 } ));
			eyeObject.physicsProperties.x = posX;
			eyeObject.name = "eye" + new String(eyeObject.x);
			eyeObject.physicsProperties.contactGroup = "eyes";
			eyeObject.body.SetFixedRotation(true);			
			eyeObject.data = new Array(this,_index);
			
		}
		
		private function explosion():void 
		{
			removeEventListener(Event.ENTER_FRAME, update);
			eyeObject.body.GetWorld().DestroyBody(eyeObject.body);
			//eyePhysics.removePhysics(eyeObject.displayObject);
			this.removeChild(eyeSprite);
			if (bonus) boom = true;
			this.addEventListener(Event.ENTER_FRAME, explosionCheck);
			this.addEventListener(Event.ENTER_FRAME, dead);
		}
		
		private function fishExplosion():void
		{
			// hacer random para que los value no sean siempre los mismos
			fish1 = new FishBone(eyePhysics, 5, eyeObject.x + 5 , eyeObject.y, true);
			fish1.index = Game.fishBones.length;
			Game.fishBones.push([5,eyeObject.x + 5,eyeObject.y,true]);
			this.addChild(fish1);
			fish2 = new FishBone(eyePhysics, 2, eyeObject.x, eyeObject.y, true);
			fish2.index = Game.fishBones.length;
			Game.fishBones.push([2,eyeObject.x,eyeObject.y,true]);
			this.addChild(fish2);
			fish3 = new FishBone(eyePhysics, 1, eyeObject.x - 5, eyeObject.y, true);
			fish3.index = Game.fishBones.length;
			Game.fishBones.push([1,eyeObject.x -5,eyeObject.y,true]);
			this.addChild(fish3);
		}
		
		private function update(e:Event):void 
		{
			
			eyeObject.body.SetLinearVelocity(new b2Vec2(velocity, 0));  
			if (eyeObject.name == "dead")
			{	
				trace(tempX);
				trace(eyeObject.x);
				trace(_eyeSprite.x);
				trace(this.x);
				
				tempX = _eyeSprite.x;
				tempY = 253;
				explosion();
			}
		}
		
		private function explosionCheck(e:Event):void
		{
			
			if (boom) {
				fishExplosion();
				boom = false;
				
				trace("boom");
			}
		}
		
		private function dead(e:Event):void
		{
			if (first)
			{
				sc = smudge.play(0, 1);
				deadSprite = new MovieClip(Assets.getMoves().getTextures("die"), 6);
				starling.core.Starling.juggler.add(deadSprite);
				
				deadSprite.x = tempX;
				
				deadSprite.y = tempY;
				deadSprite.scaleX =- _eyeSprite.scaleX;
				
				
			this.addChild(deadSprite);


				first = false;
			}
			
			animationTime += 1/60;
			
			if (animationTime >= 0.3)
			{
				deadSprite.visible = false;
				deadSprite.dispose();
				removeEventListener(Event.ADDED_TO_STAGE, dead);
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
		
		public function get velocity():Number 
		{
			return _velocity;
		}
		
		public function set velocity(value:Number):void 
		{
			_velocity = value;
		}
		
		public function get eyeSprite():MovieClip
		{
			return _eyeSprite;
		}
		
		public function set eyeSprite(value:MovieClip):void 
		{
			_eyeSprite = value;
		}
	}

}