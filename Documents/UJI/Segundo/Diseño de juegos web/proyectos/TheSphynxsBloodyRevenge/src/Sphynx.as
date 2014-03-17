package  
{
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.core.Starling;
	import starling.display.Image;
	import flash.ui.Keyboard;
	import starling.events.KeyboardEvent;

	
	/**
	 * ...
	 * @author Yolanda
	 */
	public class Sphynx extends Sprite 
	{
		private var sphynxSprites:Image;
		private var moving:Boolean;
		private var state:String;
		private var jumping:Boolean;
		
		public function Sphynx() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, update);
			sphynxArt();	
			sphynxKeyboard();
		}
				
		private function sphynxArt():void
		{
			sphynxSprites = new Image(Assets.getTexture("Cat"));
			this.addChild(sphynxSprites);	
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
				case Keyboard.UP:
				
					jumping = true;
					break;
				
				case Keyboard.LEFT:
				
					state = "left";
					break;
					
				case Keyboard.RIGHT:
				
					state = "right";
					break;
				
				case Keyboard.X:
				
					state = "attack";
					break;
			}
		}
		
		private function sphynxStops(event:KeyboardEvent):void
		{ 
			state = "";
			jumping = false;
		}
		
		private function update(e:Event):void 
		{
			switch(state)
			{			
				case "left":
					
					this.x -= 5;
					break;
				
				case "right":
					
					this.x += 5;
					break;
					
				case "attack":
					
					break;	
			}
			
			if (jumping) this.y -= 5;
		}
	}
}