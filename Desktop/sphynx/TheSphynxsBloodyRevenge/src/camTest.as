package  
{
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
	public class camTest extends Sprite 
	{
		private var left:Boolean;
		private var right:Boolean;
		
		public function camTest() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, update);
			camKeyboard();
		}
		

		
		private function camKeyboard():void 
		{
			this.addEventListener(KeyboardEvent.KEY_DOWN, camMoves);
			this.addEventListener(KeyboardEvent.KEY_UP, camStops);
		}
		
		private function camMoves(e:KeyboardEvent):void 
		{
			switch(e.keyCode)
			{
				case Keyboard.LEFT:
					left = true;
					break;
					
				case Keyboard.RIGHT:
					right = true;
					break;
			}
		}
		
		private function camStops(e:KeyboardEvent):void 
		{
			switch(e.keyCode)
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
			if (left) this.x += 10;
			if (right) this.x -= 10;
			
		}
		
	}

}