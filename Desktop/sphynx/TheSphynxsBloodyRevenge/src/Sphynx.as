package  
{
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2MassData;
	import flash.geom.Point;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.core.Starling;
	import starling.display.Image;
	import flash.ui.Keyboard;
	import starling.events.KeyboardEvent;
	
	import com.reyco1.physinjector.PhysInjector;
    import com.reyco1.physinjector.data.PhysicsObject;
    import com.reyco1.physinjector.data.PhysicsProperties;
	
	import Box2D.Dynamics.Contacts.b2Contact;
	import com.reyco1.physinjector.contact.ContactManager;
	
	
	
	import Box2D.Common.Math.b2Vec2;
	
	
	import flash.display.Stage;
	
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;

	
	/**
	 * ...
	 * @author Yolanda
	 */
	public class Sphynx extends Sprite 
	{
		
		public var sphynxSprites:Image;
		private var sphynxPhysics:PhysInjector;
		private var sphynxObject:PhysicsObject;
		private var centerPoint:Point;
		private var center:b2Vec2;
		private var left:Boolean;
		private var right:Boolean;
		private var jump:Boolean;
		private var attack:Boolean;
		private var velocity:Number;
		private var goingUp:Boolean;
		private var limit:Number;
		private var count:uint;
		private var fishBones:Vector.<PhysicsObject>;
		public var score:Number;
		private var posX:Number;
		private var posY:Number;
		private var handle:Boolean;
		private var overHeight:Number;
		private var jumpHeight:Number;
		private var attackActive:Boolean;
		
	
		
		private var punch:Platform;
	
		
		private var canJump:Boolean = true;
		

		public function Sphynx(worldPhysics:PhysInjector, x:Number, y:Number, fishBones:Vector.<PhysicsObject>) 
		{
			super();
			sphynxPhysics = worldPhysics;
			//posX = x;
			//posY = y;
			velocity = 0.2;
			limit = 2;
			canJump = true;
			score = 0;
			overHeight = 0;
			this.fishBones = fishBones;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, update);
			sphynxArt();
			injectPhysics();
			sphynxKeyboard();
			attackActive = false;
			
			//massCat = 0;
		}
				

		private function sphynxArt(/*_x:Number, _y:Number*/):void
		{
			sphynxSprites = new Image(Assets.getTexture("Cat"));
			//sphynxSprites.x = _x;
			//sphynxSprites.y = _y;
			this.addChild(sphynxSprites);	
			

		}
		
		private function injectPhysics():void
		{
			sphynxObject = sphynxPhysics.injectPhysics(this, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.35, restitution:0 } ));
			sphynxObject.body.SetFixedRotation(true);
			sphynxObject.name = "cat";
			sphynxObject.physicsProperties.contactGroup = "cats";
			//sphynxObject.body.SetMassData(massCat);
		}
		

		
	
		private function sphynxAttack():void
		{
			
			punch = new Platform(sphynxPhysics, sphynxObject.x+1,sphynxObject.y -175,"punch")
			this.addChild(punch);
			attackActive = true;
			
			ContactManager.onContactBegin("punch", "eyes", handleContactAttack,true);
				
			
			
			
		}
		
		
		private function handleContactAttack(punchObject:PhysicsObject, eyeObject:PhysicsObject,contact:b2Contact):void
		{
		
			eyeObject.name = "dead";
			
			
		}
		
		private function sphynxKeyboard():void
		{
			this.addEventListener(KeyboardEvent.KEY_DOWN, sphynxMoves);
			this.addEventListener(KeyboardEvent.KEY_UP, sphynxStops);
		}
		
		private function sphynxMoves(event:KeyboardEvent):void
		{ 
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
					left = true;
					break;
					
				case Keyboard.RIGHT:
					right = true;
					break;
					
				case Keyboard.UP:
					
					if (canJump)
					{
						jump = true;
						canJump = false;
					}
					break;
					
				case Keyboard.X:
					if(canJump) sphynxAttack();
					break;	
			}
				
		}
		
		private function scoreValue(/*fishBones:Vector.<PhysicsObject>*/):void
		{
			/*for ( var i:uint = 0; i < fishBones.length; i++)
			{*/
				ContactManager.onContactBegin("cats","fishbones", scoreContact,true); 
				
				/*if (this.bounds.intersects(fishBones[i].bounds))
				{
					this.score += fishBones[i].value;
					fishBones[i].removeFromParent(true);
					fishBones.splice(i, 1);
				}*/
			//}
		}
		
		private function scoreContact(sphynxObj:PhysicsObject, objectB:PhysicsObject, contact:b2Contact):void 
		{
			score += objectB.data as Number;
			objectB.body.GetWorld().DestroyBody(objectB.body);
			sphynxPhysics.removePhysics(objectB.displayObject);
			objectB.displayObject.parent.removeChild(objectB.displayObject); 
		
			
			
		}
		
		private function handleContactLives(sphynxObj:PhysicsObject, objectB:PhysicsObject,contact:b2Contact):void
		{
			//if(lives >1) lives--;
			//else
			sphynxSprites.visible = false; // para que el objeto no aparezca en pantalla , ve a update
			
			
		}
		
		private function handleContact():void
		{
			
			for (var j:int =0; j < InGame.platforms.length; j++){
				ContactManager.onContactBegin(sphynxObject.name, InGame.platforms[j].name, handleContactPlat);
			}
			
			for (var k:int =0; k < InGame.walls.length; k++){
				ContactManager.onContactBegin(sphynxObject.name, InGame.walls[k].name, handleContactPlat);
			}
		}
		
		private function handleContactPlat(sphynxObj:PhysicsObject, objectB:PhysicsObject, contact:b2Contact):void
		{
			
			if (this.y + sphynxSprites.height > objectB.y)
			trace("stuck");
				overHeight = this.y + sphynxSprites.height - objectB.y-1;
				handle = true;
		}
		
		private function lives():void
		{
			
			
			if(! attackActive) ContactManager.onContactBegin("cats", "eyes", handleContactLives, true);
			
			
		}
		
		
		private function sphynxStops(event:KeyboardEvent):void
		{ 
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
					left = false;
					break;
					
				case Keyboard.RIGHT:
					right = false;
					break;
			}	
		}

		private function update(e:Event):void 
		{	
			handleContact();
			
			
			if (!sphynxSprites.visible) // si no esta visible mandarlo al principio y visble de nuevo
			{
				sphynxObject.x = 20;
				sphynxSprites.visible = true;
			}

			if (sphynxObject.body.GetLinearVelocity().y < 0) goingUp = true;
			else goingUp = false;
			
			if (left) {
				if(Math.abs(sphynxObject.body.GetLinearVelocity().x)<limit)
					sphynxObject.body.GetLinearVelocity().x -= velocity;
			}
			
			if (right) { 
				if(Math.abs(sphynxObject.body.GetLinearVelocity().x)<limit)
					sphynxObject.body.GetLinearVelocity().x += velocity;
			}
			
			if (jump){
				sphynxObject.body.ApplyImpulse(new b2Vec2(0, -13), sphynxObject.body.GetWorldCenter());
				jump = false;
			}
				
			if (sphynxObject.body.GetLinearVelocity().y == 0 && !goingUp)
			{
				canJump = true;
				if (handle)
				{
					sphynxObject.body.GetPosition().y -= overHeight;
					handle = false;
					overHeight = 0;
				}	
			}	
			
			scoreValue();	
			
			lives();
			
		}	
		
	}
}