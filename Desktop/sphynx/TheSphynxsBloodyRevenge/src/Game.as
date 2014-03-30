package  
{
	import flash.display.Stage;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Yolanda
	 */
	public class Game extends Sprite 
	{
		public var screenMenu:Menu;
		public var screenInGame:InGame;

		private var main:Main;
		
		public function Game() 
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(NavigationEvent.CHANGE_SCREEN, onChangeScreen);
		}	
		
		private function onAddedToStage(event:Event):void
		{
			trace("Juego inicializado");
			
			screenInGame = new InGame();
			//screenInGame.disposeTemporaly();
			//screenMenu = new Menu();
			//addChild(screenMenu);
			addChild(screenInGame);
			screenInGame.initialize();
			
			
		}
		
		private function onChangeScreen(event:NavigationEvent):void
		{
			switch (event.params.id)
			{
				case "play":
					screenMenu.disposeTemporaly();
					screenInGame.initialize();
					break;
			}
		}
		

		

	}
}