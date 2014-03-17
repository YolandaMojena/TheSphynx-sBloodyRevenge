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
			if (event.keyCode == Keyboard.DOWN)
			{
				moving = true;
				trace("moving");
			}
		}
		
		private function sphynxStops(event:KeyboardEvent):void
		{ 
			if (event.keyCode == Keyboard.DOWN)
			{
				moving = false;
			}
		}
		
		private function update(e:Event):void 
		{
			if (moving) this.x += 10;
			
		}

		
	}

}