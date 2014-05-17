package  
{
	import adobe.utils.CustomActions;
	import Box2D.Dynamics.Contacts.b2Contact;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import starling.events.KeyboardEvent;
	import starling.animation.Tween;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.core.Starling;
	import starling.textures.Texture;	
	import flash.utils.getTimer;
	import flash.display.Stage;
	import starling.core.Starling;
	
	import com.reyco1.physinjector.PhysInjector;
    import com.reyco1.physinjector.data.PhysicsObject;
    import com.reyco1.physinjector.data.PhysicsProperties;
	import com.reyco1.physinjector.contact.ContactManager;
		
	import Box2D.Common.Math.b2Vec2;

	/**
	 * ...
	 * @author Yolanda
	 */
	public class InGame extends Sprite 
	{
		private var timePrevious:Number;
		private var timeCurrent:Number;
		private var elapsed:Number;
		public var sphynx:Sphynx;
		
		public var scene:Stage;
		public static var floorPlatform:Platform;
		private var fishBone1:FishBone;
		private var fishBone2:FishBone;
		private var fishBone3:FishBone;
		private var wall:Platform;
		private var wall_2:Platform;
		private var wall_3:Platform;
		//private var eye:Eye;
		private var eye2:Eye;
		private var eye3:Eye;
		private var plat:Platform;
		private var platUp:Platform;
		private var left:Boolean;
		private var right:Boolean;
		
		private var worldPhysics:PhysInjector;
		
		public static var platforms:Vector.<PhysicsObject>; // <PhysicsObject>
		public static var fishBones:Vector.<PhysicsObject>;
		public static var walls:Vector.<PhysicsObject>;
		public static var eyes:Vector.<PhysicsObject>;
		
		
		
		private var scoreText:TextField;
		private var timeText:TextField;
		private var timeScore:TextField;
		
		public function InGame() 
		{
			super();
		
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			trace("InGame Screen");
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			worldPhysics = new PhysInjector(Starling.current.nativeStage, new b2Vec2(0, 9.8), false); // false y asi no se puede mover con raton 
			platforms = new Vector.<PhysicsObject>();
			fishBones = new Vector.<PhysicsObject>();
			walls = new Vector.<PhysicsObject>();
			eyes = new Vector.<PhysicsObject>();
			
			
			drawGame();
			
			scoreText = new TextField(1600, 50, "Score: =0", "MyFontName", 24, 0xff0000);
			this.addChild(scoreText);

			


			addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function initialize():void
		{
			visible = true;
			addEventListener(Event.ENTER_FRAME, checkedElapsed);			
			trace("jugando");
		}
		
		// provisional, habrá bucles para las plataformas y las raspas
		
		
		private function drawGame():void
		{	
			
			
			// dibuja suelo
			floorPlatform = new Platform(worldPhysics, 0, 344,"floor");
			this.addChild(floorPlatform);
			
			// dibuja paredes
			wall = new Platform(worldPhysics,350, floorPlatform.platformSprite.y - 72, "wall");
			this.addChild(wall);
			
			wall_2 = new Platform(worldPhysics, 825, floorPlatform.platformSprite.y - 72,"wall");
			this.addChild(wall_2);
			
			wall_3 = new Platform(worldPhysics, 200, floorPlatform.platformSprite.y - 72,"wall");
			this.addChild(wall_3);
			
			
			// dibuja raspas
			fishBone1 = new FishBone(worldPhysics,5, 300, 150,false);
			//fishBones.push(fishBone1);
			addChild(fishBone1);
			
			fishBone2 = new FishBone(worldPhysics,2, 500, 200,false);
			//fishBones.push(fishBone2);
			addChild(fishBone2);
			
			fishBone3 = new FishBone(worldPhysics,1, 700, 75,false);
			//fishBones.push(fishBone3);
			addChild(fishBone3);
			
			//plataforma
			
			plat = new Platform(worldPhysics, 1100, 195,"plat");
			this.addChild(plat);
			
			platUp = new Platform(worldPhysics, 1375, 195,"platUp");
			this.addChild(platUp);
			
			//dibuja ojo
			//eye = new Eye(worldPhysics,450, 344,false); 
			//this.addChild(eye);
			
			
			eye3 = new Eye(worldPhysics,650, 344,false); 
			//this.addChild(eye3);
			
			eye2 = new Eye(worldPhysics, 700, 344,true);
			this.addChild(eye2);				
			
			
			ContactManager.onContactBegin("eyes","walls", handleContact,true);			
			
			/*for (var i:int; i < fishBones.length; i++)
			{
				this.addChild(fishBones[i]);
				trace(fishBones[i]);
			}*/
			
			/*for (var i:int; i < eyes.length; i++)
			{
				this.addChild(eyes[i]);
			}
			*/
			// dibuja gato
			sphynx = new Sphynx(worldPhysics, 20, floorPlatform.platformSprite.y-146, fishBones); 
			this.addChild(sphynx);
		}

		public function disposeTemporaly():void
		{
			this.visible = false;
		}							
		
		private function checkedElapsed(event:Event):void 
		{
			timePrevious = timeCurrent;
			timeCurrent = getTimer();
			elapsed = (timeCurrent - timePrevious) * 0.001;
		}
		private function update(event:Event):void 
		{
			this.x = -sphynx.x+50;
			worldPhysics.globalOffsetX = -sphynx.x+50;
			
			scoreText.text = "Score: " + sphynx.score;
			

			
			worldPhysics.update();
		}
		
		public function handleContact(objectA:PhysicsObject, objectB:PhysicsObject,contact:b2Contact):void
		{
			trace("handlecontact!");
			trace("o1:" + objectA.data);
			trace("o2:" + objectB.data);
			
			//objectA.x = 700;
			//physics.removePhysics(objectB.displayObject);
			
			if (objectA.data as Eye)
			{
				(objectA.data as Eye).velocity *= -1;
				(objectA.data as Eye).eyeSprite.scaleX *= -1; 
			}
		}		
		

	}

}