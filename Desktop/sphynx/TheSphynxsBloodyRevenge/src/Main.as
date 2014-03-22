package 
{
	import flash.display.Sprite;
	import flash.events.Event;	
	import flash.events.StatusEvent;
	import starling.core.Starling;
		
	
	/**
	 * ...
	 * @author Yolanda
	 */
	
	[SWF(backgroundColor = "0x000000", width=900, height=400)]
	public class Main extends Sprite 
	{
		private var starling:Starling;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
						
			starling = new Starling(Game, stage);
			starling.start();
		}
	}
	
}