package  
{
	import flash.display3D.textures.Texture;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import flash.ui.Keyboard;
	import starling.events.KeyboardEvent;
	
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Yolanda
	 */
	public class GameOver extends Sprite 
	{
		private var over:Image;
		private var score:Number;
		private var scoreText:TextField;
		private var time:Number;
		
		public function GameOver(score:Number,time:Number) 
		{
			super();
			this.score = score;
			this.time = time;

			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			if (time ==0)
			{
				over = new Image(Assets.getAtlas().getTexture("gameOver"));
				this.addChild(over);
			}
			else
			{
				over = new Image(Assets.getAtlas().getTexture("revenge"));
				scoreText = new TextField(1200, 578, "" + score, "MyFontName", 24, 0x670f10);
				scoreText.x = 0;
				scoreText.y = 0;
				this.addChild(over);
				this.addChild(scoreText);
			}
			
	
			addEventListener(KeyboardEvent.KEY_DOWN, playAgain);
		}
		
		private function playAgain(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.R)
			{	
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"init" }, true));
			}
		}
		
	}

}