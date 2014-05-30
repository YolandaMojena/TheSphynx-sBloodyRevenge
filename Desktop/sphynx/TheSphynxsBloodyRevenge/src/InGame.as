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
		public static const CAM_OFFSET:Number = 450 - 37;
		public static const CAM_OFFSET_Y:Number = 50;
		public static const CAPTURE_POS:Number = 4011;
		private var timePrevious:Number;
		private var timeCurrent:Number;
		private var elapsed:Number;
		public var sphynx:Sphynx;
		private var start:Boolean = true;
		
		public var scene:Stage;
		public static var platform:Platform;
		private var fishBone:FishBone;
		private var wall:Platform;
		//private var eye:Eye;
		private var eye:Eye;
		private var left:Boolean;
		private var right:Boolean;
		
		private var worldPhysics:PhysInjector;
		
		private var camera:Number;
		
		
		
		private var left_limit:Number;
		private var right_limit:Number;
		
		private var sphynxX:Number;
		private var sphynxScore:Number;
		
		private var score:Number;
		private var generate:Boolean;
		
		
		private var background1:Image;
		private var background2:Image;
		private var background3:Image;
		private var background4:Image;
		private var background5:Image;
		
		
		public function InGame(sphynxX:Number,score:Number, generate:Boolean) 
		{
			super();
			this.sphynxX = sphynxX;
			this.score = score;
			this.generate = generate;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			trace("InGame Screen");
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			worldPhysics = new PhysInjector(Starling.current.nativeStage, new b2Vec2(0, 9.8), false); // false y asi no se puede mover con raton 

	
			drawGame();
			
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		
		public function initialize():void
		{
			visible = true;
			//addEventListener(Event.ENTER_FRAME, checkedElapsed);	
			trace("jugando");
		}
		
		// provisional, habrá bucles para las plataformas y las raspas
		
		
		private function drawGame():void
		{	
			
			
			background1 = new Image(Assets.getTexture("Background1"));
			background1.x = 0;
			background1.y = -400;
			this.addChild(background1);
			
			background2 = new Image(Assets.getTexture("Background2"));
			background2.x = 900;
			background2.y = -400;
			this.addChild(background2);
			
			background3 = new Image(Assets.getTexture("Background3"));
			background3.x = 1800;
			background3.y = -400;
			this.addChild(background3);
			
			background4 = new Image(Assets.getTexture("Background4"));
			background4.x = 2700;
			background4.y = -400;
			this.addChild(background4);
			
						
			background5 = new Image(Assets.getTexture("Background5"));
			background5.x = 3600;
			background5.y = -400;
			this.addChild(background5);
			
			//plataformas

			for(var i:int = 0; i<Game.platforms.length; i++)
			{
				//platform = new Platform(phyisics, x, y, type)
				platform = new Platform(worldPhysics, Game.platforms[i][0], Game.platforms[i][1], Game.platforms[i][2]);
				this.addChild(platform);
			}
			
			//raspas
			
			for (var j:int = 0; j<Game.fishBones.length; j++)
			{
				if(Game.fishBones[j][3])
				{
					fishBone = new FishBone(worldPhysics, Game.fishBones[j][0], Game.fishBones[j][1], Game.fishBones[j][2], false);
					fishBone.index = j;
					this.addChild(fishBone);
				}
			}
			
			//enemigos
			
			for (var k:int = 0; k<Game.eyes.length; k++)
			{	
				if(Game.eyes[k][3])
				{
					//eye = new Eye(physics, x, y, bonus)
					eye = new Eye(worldPhysics, Game.eyes[k][0], Game.eyes[k][1], Game.eyes[k][2]);
					eye.index = k;
					this.addChild(eye);
				}
			}
					
			ContactManager.onContactBegin("eyes", "walls", handleContact, true);
			

			
			
			// dibuja gato
			sphynx = new Sphynx(worldPhysics, sphynxX, score, generate); 
			this.addChild(sphynx);
		}
		


		public function disposeTemporaly():void
		{
			this.visible = false;
		}							
		
		private function update(event:Event):void 
		{
			
			if (sphynx.x >= CAM_OFFSET && sphynx.x <=CAPTURE_POS)
			{
				this.x = -sphynx.x+CAM_OFFSET;
				worldPhysics.globalOffsetX = -sphynx.x + CAM_OFFSET;
			}
			
			if (sphynx.x == 37)
			{	
				this.x = 0
				worldPhysics.globalOffsetX = 0
			}
			/*
			if (sphynx.x == 3600 + CAM_OFFSET)
			{
				this.x = -3600 + CAM_OFFSET; //calcular número
				worldPhysics.globalOffsetX = -3600 + CAM_OFFSET;
			}
			*/
			
			if (sphynx.cameraY && sphynx.y <= CAM_OFFSET_Y)
			{
				this.y = -sphynx.y+CAM_OFFSET_Y;
				worldPhysics.globalOffsetY = -sphynx.y+CAM_OFFSET_Y;
			}
			
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