package  
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.display.Image;
	
	/**
	 * ...
	 * @author Yolanda
	 */
	public class ScoreLayer extends Sprite 
	{
		public var score:Number;
		private var scoreText:TextField;
		private var bones:Image;
		
		public function ScoreLayer() 
		{
			super();	
			score = 0;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.ENTER_FRAME, updateScore);

			
		}
		
		private function updateScore(e:Event):void 
		{
			scoreText.text = score + "";
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage); 
			
			
			scoreText = new TextField(1725, 80, "0", "MyFontName", 24, 0xff0000);
			this.addChild(scoreText);
			
			bones = new Image(Assets.getTexture("Bones"));
			bones.x = 775;
			bones.y = 5;
			this.addChild(bones);
			
		}
		
	}

}