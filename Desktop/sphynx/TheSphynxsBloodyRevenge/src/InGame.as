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
		private var fishBone:FishBone;
		
		private var worldPhysics:PhysInjector;
		
		private var platforms:Vector.<Platform>;
		private var fishBones:Vector.<FishBone>;
	
		
		public function InGame() 
		{
			super();
		
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			trace("InGame Screen");
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			worldPhysics = new PhysInjector(Starling.current.nativeStage, new b2Vec2(0, 9.8), true);
			platforms = new Vector.<Platform>();
			fishBones = new Vector.<FishBone>();
			drawGame();

		}
		
		public function initialize():void
		{
			this.visible = true;
			this.addEventListener(Event.ENTER_FRAME, checkedElapsed);
			
			trace("jugando");
		}
		
		// provisional, habrá bucles para las plataformas y las raspas
		
		private function drawGame():void
		{	
			// dibuja suelo
			floorPlatform = new Platform(worldPhysics, 0, 344);
			this.addChild(floorPlatform);
			platforms.push(floorPlatform);
			
			// dibuja raspas
			fishBone = new FishBone(5, 300, 280);
			this.addChild(fishBone);
			fishBones.push(fishBone);


			// dibuja gato
			sphynx = new Sphynx(worldPhysics, platforms, 20, floorPlatform.platformSprite.y-146);
			this.addChild(sphynx);
			trace("cat");
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
		
	}

}