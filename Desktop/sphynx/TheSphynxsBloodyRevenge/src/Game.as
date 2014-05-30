package  
{
	import flash.display.Stage;
	import flash.media.Sound;
	import flash.media.SoundChannel;
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
		public var gameOverLayer:GameOver;
		private var score:Number;
		private var lives:Number;
		public var scoreLayer:ScoreLayer;
		private var timePassed:Number;
		private var timeScore:Number;
		private var music:Sound;
		public static const STAGEWIDTH:Number = 4500;
		
		public static var platforms:Array; 
		public static var fishBones:Array;
		public static var eyes:Array;
		

		private var main:Main; 
		
		public function Game() 
		{
			super();
			timePassed = 90;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}	
		
		private function updateScore(e:Event):void 
		{
			if (screenInGame != null)
			{
				score = screenInGame.sphynx.score;
				scoreLayer.score = score;
			}
			if (screenInGame != null)
			{
				if(screenInGame.visible==true && screenMenu.visible == false)
				{
					timePassed -= 1 / 60;
					timeScore = Math.round(timePassed);
					scoreLayer.time = timeScore;
				}
			}
		}
		
		private function onAddedToStage(event:Event):void
		{
			trace("Juego inicializado");
			
			platforms = new Array();
			fishBones = new Array();
			eyes = new Array();
		
			
			this.addEventListener(NavigationEvent.CHANGE_SCREEN, onChangeScreen);

			
			this.addEventListener(Event.ENTER_FRAME, updateScore);	
			
			this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"init" }, true));
		}
		
		private function initArrays():void 
		{
			//plataformas

			//(x, y, "type")
			
			platforms = [[0, 350, "floor1"], [1300, 350, "smallFloor"], [2550, 350, "smallFloor"],
			[898, 348, "invisibleWall"], [1300, 348, "invisibleWall"], [2550, 348, "invisibleWall"], [2998, 348, "invisibleWall"], [4498, 348, "invisibleWall"],
			[3600, 350, "floor2"], [4050, 150, "smallFloor"], [405, 305, "wall"],
			[1045, 225,"platUp"], [2090, 187.5,"platUp"], [1860, 350,"platSides"], [2320, 350,"platSides"],
			[3245, 350, "platSides"],  [1640, 305, "wall"], [3600, 294, "biggerWall"],  [3835, 175, "platSides"]];
			
			
			//raspas
	
			//(value, x, y, generates)
	
			fishBones = [[1, 420, 257, true], [2, 460, 257, true], [5, 800, 156, true],
			[1, 1065, 99, true], [2, 1105, 99, true], [2, 1898, 150, true], [1, 1860, 150, true],
			[1, 2320, 150, true], [2, 2358, 150, true], [5, 1680, 257, true], [2, 2600, 257, true],
			[1, 2760, 257, true], [2, 2925, 257, true], [5, 3278, 257, true], [5, 3650, 75, true],
			[1, 4360, 300, true], [2, 4400, 300, true], [1, 4440, 300, true]];
			
			
			//enemigos

			//(x, y, bonus, generates)
			eyes = [[650, 253, false, true], [1450, 253, true, true], [2700, 253, false, true], [4000, 253, true, true]];
			
		}
		
		private function onChangeScreen(event:NavigationEvent):void
		{
			switch (event.params.id)
			{
				case "init":
					
					initArrays();
					
					if (gameOverLayer != null)
					{
						gameOverLayer.visible = false;
						gameOverLayer.dispose();
					}
					
					trace("jo");
					screenInGame = new InGame(0, 0, true);
					screenInGame.disposeTemporaly();
					this.addChild(screenInGame);
					
					scoreLayer = new ScoreLayer();
					this.addChild(scoreLayer);
					
					screenMenu = new Menu();
					screenInGame.initialize();
					this.addChild(screenMenu);						
					
					pauseLayer = new PauseLayer();
					pauseLayer.disposePause();
					this.addChild(pauseLayer);
					break;
					
				case "play":
					screenMenu.disposeTemporaly();
					pauseLayer.disposePause();
					music = Assets.getSound("Music");
					//var sc:SoundChannel = music.play(0, 0);
					screenInGame.initialize();
					break;
				
				case"minigame":
					score = screenInGame.sphynx.score;
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
					score += screenDontMiss.score;
					screenDontMiss.disposeTemporaly();
					screenDontMiss.dispose();
					screenInGame = new InGame(3600, score, false);
					this.addChild(screenInGame);
					scoreLayer.dispose();
					scoreLayer = new ScoreLayer();
					this.addChild(scoreLayer);
					break;	
				
				case"deleteAll":
					screenInGame.disposeTemporaly();
					screenInGame.dispose();
					scoreLayer.visible = false;
					scoreLayer.dispose();
					gameOverLayer = new GameOver(score);
					this.addChild(gameOverLayer);
					score = 0;
					timePassed = 90;
					break;
			}
		}
	}
}