package  
{
	import flash.display.Stage;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.core.Starling;
	
	import NavigationEvent;
	import InGame;
	import Menu;
	
	/**
	 * ...
	 * @author Yolanda
	 */
	public class Game extends Sprite
	{
		public var screenMenu:Menu;
		public var screenInGame:InGame;

		private var main:Main; //
		
		public function Game() 
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}	
		
		private function onAddedToStage(event:Event):void
		{
			trace("Juego inicializado");
			
			this.addEventListener(NavigationEvent.CHANGE_SCREEN, onChangeScreen);
			
			screenInGame = new InGame();
			screenInGame.disposeTemporaly();
			this.addChild(screenInGame);
			
			screenMenu = new Menu();
			this.addChild(screenMenu);
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