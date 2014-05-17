package 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;	
	import flash.events.StatusEvent;
	import starling.core.Starling;
    
    import com.reyco1.physinjector.PhysInjector;

	/**
	 * ...
	 * @author Yolanda
	 */
	
	[SWF(backgroundColor = "0x000000", width=900, height=400, frameRate="60")]
	public class Main extends Sprite 
	{
		private var starling:Starling;
		PhysInjector.STARLING = true;
		
		public function Main():void 
		{
			
			if (stage) init();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
						
			starling = new Starling(DontMiss,stage);
			starling.start();	
			starling.nativeStage;
		}
		
		

	}
	
}