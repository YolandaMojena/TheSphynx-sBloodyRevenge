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
		public var screenDontMiss:DontMiss;
		public var pauseLayer:PauseLayer;
		private var score:Number;
		private var lives:Number;
		public var scoreLayer:ScoreLayer;
		private var timePassed:Number;
		private var timeScore:Number;

		private var main:Main; 
		
		public function Game() 
		{
			super();
			timePassed = 0;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}	
		
		private function updateScore(e:Event):void 
		{
			if (screenInGame != null)
			{
				score = screenInGame.sphynx.score;
				scoreLayer.score = score;
			}
			if (screenDontMiss!=null && pauseLayer!=null && screenDontMiss.visible == false && pauseLayer.visible == false)
			{
				timePassed += 1 / 60;
				timeScore = Math.round(timePassed);
			}
		}
		
		private function onAddedToStage(event:Event):void
		{
			trace("Juego inicializado");
			
			scoreLayer = new ScoreLayer();
			this.addChild(scoreLayer);
			
			this.addEventListener(NavigationEvent.CHANGE_SCREEN, onChangeScreen);
			
			screenInGame = new InGame(20,0,true,7);
			screenInGame.disposeTemporaly();
			this.addChild(screenInGame);
			
			screenMenu = new Menu();
			screenInGame.initialize();
			this.addChild(screenMenu);						
			
			pauseLayer = new PauseLayer();
			pauseLayer.disposePause();
			this.addChild(pauseLayer);
			
			this.addEventListener(Event.ENTER_FRAME, updateScore);	
		}
		
		private function onChangeScreen(event:NavigationEvent):void
		{
			switch (event.params.id)
			{
				case "play":
					screenMenu.disposeTemporaly();
					pauseLayer.disposePause();
					screenInGame.initialize();
					break;
				
				case"minigame":
					score = screenInGame.sphynx.score;
					lives = screenInGame.sphynx.lives;
					screenInGame.disposeTemporaly();
					screenInGame.dispose();
					screenInGame = null;
					screenDontMiss = new DontMiss();
					this.addChild(screenDontMiss);	
					screenDontMiss.initialize();
					break;
				
				case"pause":
					screenInGame.disposeTemporaly();
					pauseLayer.initializePause();
					break;			
				
				case"play2":
					screenDontMiss.disposeTemporaly();
					screenDontMiss.dispose();
					screenInGame = new InGame(3600,score,true,lives);
					this.addChild(screenInGame);
					break;		
			}
		}
	}
}