package  
{
	import flash.display.Stage;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.core.Starling;
	
	import flash.ui.Keyboard;
	import starling.events.KeyboardEvent;
	
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
		private var sc:SoundChannel;
		private var sc2:SoundChannel;
		
		private var muted:Boolean;
		
		private var meowmeow:Sound;
		

		
		public function Game() 
		{
			super();
			sc = new SoundChannel();
			sc2 = new SoundChannel();
			timePassed = 150;
			muted = false;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}	
		
		private function updateScore(e:Event):void 
		{

			if (screenInGame != null)
			{
				score = screenInGame.sphynx.score;
				scoreLayer.score = score;
				
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
			
			screenMenu = new Menu();
			screenMenu.initialize();
			this.addChild(screenMenu);	
			
			music = Assets.getSound("Rised");
			meowmeow = Assets.getSound("MeowMeow");
			
			sc2 = meowmeow.play(0,50);
			
			this.addEventListener(NavigationEvent.CHANGE_SCREEN, onChangeScreen);
			this.addEventListener(KeyboardEvent.KEY_DOWN, muteSound);

			this.addEventListener(Event.ENTER_FRAME, updateScore);	
		}
		

		
		private function muteSound(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.M && sc!=null)
			{	
				if (!muted)
				{
					SoundMixer.soundTransform = new SoundTransform(0);
					muted = true;
				}
				else
				{
					SoundMixer.soundTransform = new SoundTransform(1);
					muted = false;
				}
				
			}
		}
		
		private function initArrays():void 
		{
			//plataformas

			//(x, y, "type")
			
			platforms = [[405, 305, "wall"],[0, 350, "floor1"], [1300, 350, "smallFloor"], [2550, 350, "smallFloor"],
			[898, 348, "invisibleWall"], [1300, 348, "invisibleWall"], [2550, 348, "invisibleWall"], [2998, 348, "invisibleWall"], [4498, 348, "invisibleWall"],
			[3600, 350, "floor2"], [4050, 150, "smallFloor"], 
			[1045, 250,"platUp"], [2090, 187.5,"platUp"], [1860, 350,"platSides"], [2320, 350,"platSides"],
			[3245, 350, "platSides"],  [1640, 305, "wall"], [3600, 294, "biggerWall"],  [3835, 200, "plat"]];
			
			
			//raspas
	
			//(value, x, y, generates)
	
			fishBones = [[1, 420, 257, true], [2, 460, 257, true], [5, 800, 156, true],
			[1, 1065, 99, true], [2, 1105, 99, true], [2, 1898, 150, true], [1, 1860, 150, true],
			[1, 2320, 150, true], [2, 2358, 150, true], [5, 1680, 257, true], [2, 2600, 257, true],
			[1, 2760, 257, true], [2, 2925, 257, true], [5, 3278, 257, true], [5, 3650, 75, true],
			[1, 4360, 300, true], [2, 4400, 300, true], [1, 4440, 300, true]];
			
			
			//enemigos

			//(x, y, bonus, generates)
			eyes = [[700, 270, true, true], [1450, 270, false, true], [2700, 270, false, true], [4000, 270, true, true]];
		}
		
		private function onChangeScreen(event:NavigationEvent):void
		{
			switch (event.params.id)
			{	
				case "init":
					
					sc2.stop();
					
					initArrays();
					
					if(!muted) SoundMixer.soundTransform = new SoundTransform(1);
					
					if (gameOverLayer != null)
					{
						gameOverLayer.visible = false;
						gameOverLayer.dispose();
					}
					
					screenMenu.disposeTemporaly();
					
					screenInGame = new InGame(37, 0, true);
					screenInGame.initialize();
					this.addChild(screenInGame);
					
					scoreLayer = new ScoreLayer();
					this.addChild(scoreLayer);
					
					pauseLayer = new PauseLayer();
					pauseLayer.disposePause();
					this.addChild(pauseLayer);
					
					pauseLayer.disposePause();
					sc = music.play(1860, 0);
		
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
				
				case"play":
					screenInGame.initialize();
					pauseLayer.disposePause();
					break;
				
				case"play2":
					score += screenDontMiss.score;
					screenDontMiss.disposeTemporaly();
					screenDontMiss.dispose();
					screenInGame = new InGame(3650, score, false);
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
					gameOverLayer = new GameOver(score,timeScore);
					this.addChild(gameOverLayer);
					score = 0;
					timePassed = 150;
					sc.stop();
					break;
			}
		}
	}
}