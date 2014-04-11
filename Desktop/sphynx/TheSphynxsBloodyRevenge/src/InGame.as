package  
{
	import adobe.utils.CustomActions;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
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
	
	import Box2D.Common.Math.b2Vec2;

	import com.joeonmars.camerafocus.events.CameraFocusEvent;
	import com.joeonmars.camerafocus.StarlingCameraFocus;
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
		private var floorPlatform:Platform;
		private var fishBone1:FishBone;
		private var fishBone2:FishBone;
		private var fishBone3:FishBone;
		private var wall:Platform;
		private var wall_2:Platform;
		private var eye:Eye;
		
		private var worldPhysics:PhysInjector;
		
		private var platforms:Vector.<Platform>; // <PhysicsObject>
		public static var fishBones:Vector.<FishBone>;
		public static var walls:Vector.<PhysicsObject>;
	
		
		private var scoreText:TextField;
		private var timeText:TextField;
		private var timeScore:TextField;
		
		private var stageContainer:Sprite;
		private var cameraSt:StarlingCameraFocus;
		
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
			platforms = new Vector.<Platform>(); //<PhysicsObject>
			fishBones = new Vector.<FishBone>();
			walls = new Vector.<PhysicsObject>();
				
			drawGame();
			
			scoreText = new TextField(1600, 50, "Score: =0", "MyFontName", 24, 0xff0000);
			this.addChild(scoreText);
			
			timeText = new TextField(1564, 100, "Time:    ", "MyFontName", 24, 0xff0000);
			this.addChild(timeText);
			
			timeScore = new TextField(1650, 100, "   0", "MyFontName", 24, 0xff0000);
			this.addChild(timeScore);

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
			platforms.push(floorPlatform);
			
			
			
			// dibuja paredes
			wall = new Platform(worldPhysics, 400, floorPlatform.platformSprite.y - 100, "wall");
			this.addChild(wall);

			wall_2 = new Platform(worldPhysics, 800, floorPlatform.platformSprite.y - 100,"wall");
			this.addChild(wall_2);
			
			
			// dibuja raspas
			fishBone1 = new FishBone(5, 300, 150);
			fishBones.push(fishBone1);

			
			fishBone2 = new FishBone(2, 500, 280);
			fishBones.push(fishBone2);

			
			fishBone3 = new FishBone(1, 700, 75);
			fishBones.push(fishBone3);

			
			for (var i:int; i < fishBones.length; i++)
			{
				this.addChild(fishBones[i]);
			}
			
			//dibuja ojo
			eye = new Eye(worldPhysics, 550, 344);
			this.addChild(eye);
			
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
			
			scoreText.text = "Score: " + sphynx.score;
			worldPhysics.update();
			//camera();
		}
		/*
		private function camera():void
		{
			this.x = Starling.current.nativeStage.width / 2 - sphynx.x;
			
		}
		*/
		
	}

}