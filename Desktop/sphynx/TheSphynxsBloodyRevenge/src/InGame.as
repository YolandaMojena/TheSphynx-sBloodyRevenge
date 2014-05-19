package  
{
	import adobe.utils.CustomActions;
	import Box2D.Dynamics.Contacts.b2Contact;
	import flash.geom.Matrix;
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
		public static var platform:Platform;
		private var fishBone:FishBone;
		private var wall:Platform;
		//private var eye:Eye;
		private var eye:Eye;
		private var left:Boolean;
		private var right:Boolean;
		
		private var worldPhysics:PhysInjector;
		
		public static var platforms:Array; 
		public static var fishBones:Array;
		public static var eyes:Array;
		
		private var sphynxX:Number;
		private var sphynxScore:Number;
		
		private var score:Number;
		private var generate:Boolean;
		
		public var lives:Number;
		
		
		public function InGame(sphynxX:Number,score:Number, generate:Boolean,lives:Number) 
		{
			super();
			this.sphynxX = sphynxX;
			this.score = score;
			this.lives = lives;
			this.generate = generate;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			trace("InGame Screen");
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			worldPhysics = new PhysInjector(Starling.current.nativeStage, new b2Vec2(0, 9.8), false); // false y asi no se puede mover con raton 
			platforms = new Array();
			fishBones = new Array();
			eyes = new Array();
	
			drawGame();
			
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
			/*
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
			*/
			
			//plataformas

			//(x, y, "type")
	
			platforms = [[0, 350, "floor"], [1300, 350, "smallFloor"], [2550, 350, "smallFloor"],
			[898, 348, "invisibleWall"], [1300, 348, "invisibleWall"], [2550, 348, "invisibleWall"], [2998, 348, "invisibleWall"], [4498, 348, "invisibleWall"],
			[3600, 350, "floor"], [4050, 150, "smallFloor"], [405, 305, "wall"],
			[1045, 225,"platUp"], [2090, 187.5,"platUp"], [1860, 350,"platSides"], [2320, 350,"platSides"],
			[3245, 350, "platSides"],  [1640, 305, "wall"], [3600, 294, "biggerWall"],  [3835, 175, "platSides"]];
			
			for(var i:int = 0; i<platforms.length; i++)
			{
				//platform = new Platform(phyisics, x, y, type)
				platform = new Platform(worldPhysics, platforms[i][0]-137, platforms[i][1], platforms[i][2]);
				this.addChild(platform);
			}
			
			//raspas
	
			//(value, x, y, generates)

			fishBones = [[1,420,257,true], [2,460,257,true], [5,800,156,true],[1,1065,99,true], [2,1105,99,true]];
			for (var j:int = 0; j<fishBones.length; j++)
			{
				if(fishBones[j][3])
				{
					fishBone = new FishBone(worldPhysics, fishBones[j][0], fishBones[j][1]-137, fishBones[j][2], false);
					fishBone.index = j;
					this.addChild(fishBone);
				}
			}
			
			//enemigos

			//(x, y, bonus, generates)
	
			eyes = [[650, 253, false, true], [1450, 253, false, true], [2700, 253, false, true], [4000, 253, false, true]];
			
			for (var k:int = 0; k<eyes.length; k++)
			{
				
				if(eyes[k][3])
				{
					//eye = new Eye(physics, x, y, bonus)
					eye = new Eye(worldPhysics, eyes[k][0], eyes[k][1], eyes[k][2]);
					eye.index = k;
					this.addChild(eye);
				}
			}
			

					
			ContactManager.onContactBegin("eyes", "walls", handleContact, true);		
			
			// dibuja gato
			sphynx = new Sphynx(worldPhysics, sphynxX, score, lives); 
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
			this.x = -sphynx.x+100;
			worldPhysics.globalOffsetX = -sphynx.x+100;
			
			if (this.visible == true)
			{
				worldPhysics.update();
			}							
		}
		
		public function handleContact(objectA:PhysicsObject, objectB:PhysicsObject,contact:b2Contact):void
		{	
			if (objectA.data[0] as Eye)
			{
				(objectA.data[0] as Eye).velocity *= -1;
				(objectA.data[0] as Eye).eyeSprite.scaleX *= -1; 
			}
		}		

	}

}