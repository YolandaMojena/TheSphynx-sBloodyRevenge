package  
{
	import adobe.utils.CustomActions;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import starling.display.Button;
	import starling.events.Event;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.deg2rad;
	import starling.core.Starling;
	import starling.textures.Texture;	
	import flash.utils.getTimer;

	
	/**
	 * ...
	 * @author Yolanda
	 */
	public class InGame extends Sprite 
	{
		private var timePrevious:Number;
		private var timeCurrent:Number;
		private var elapsed:Number;
		private var floor:Sprite;
		public var sphynx:Sphynx;
		
		public function InGame() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			trace("InGame Screen");
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			drawGame();

		}
		
		public function initialize():void
		{
			this.visible = true;
			this.addEventListener(Event.ENTER_FRAME, checkedElapsed);
			trace("jugando");
		}
		
		// provisional
		
		private function drawGame():void
		{
			// crea suelo
			trace("suelo");
			floor = new Sprite();
			floor.x = stage.stageWidth * 0.5 - floor.width * 0.5;
			floor.y = stage.stageHeight - floor.height - 10;
			addChild( floor );
			
			// dibuja gato
			trace("cat");
			sphynx = new Sphynx();
			sphynx.x = 20;
			sphynx.y = 120;
			sphynx.scaleX = 0.6;
			sphynx.scaleY = 0.6;
			addChild(sphynx);
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