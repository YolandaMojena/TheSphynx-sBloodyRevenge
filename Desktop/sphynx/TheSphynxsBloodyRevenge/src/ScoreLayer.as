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
		private var _score:Number;
		private var scoreText:TextField;
		private var _time:Number;
		private var timeText:TextField;
		private var bones:Image;
		
		public function ScoreLayer() 
		{
			super();	
			score = 0;
			time = 90;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.ENTER_FRAME, updateScore);
			
		}
		
		private function updateScore(e:Event):void 
		{
			scoreText.text = score + "";
			
			if (time >= 60)
			{
				var thisTime:Number = time-60;
				if (thisTime < 10)
				{
					timeText.text = "1:0" + thisTime;
				}
				else timeText.text = "1:" + thisTime;
			}
			else
			{
				if (time < 10)
				{
					timeText.text = "0:0" + time;
				}
				else timeText.text = "0:" + time;
				
			}
			
			if(time == 0) this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"deleteAll" }, true));
			
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage); 
			
			
			scoreText = new TextField(1725, 80, "0", "Verdana", 24, 0xff0000);
			this.addChild(scoreText);
			
			timeText = new TextField(150, 80, "1:30", "Verdana", 24, 0xff0000);
			this.addChild(timeText);
			
			bones = new Image(Assets.getTexture("Bones"));
			bones.x = 775;
			bones.y = 5;
			this.addChild(bones);
			
		}
		
		public function get score():Number 
		{
			return _score;
		}
		
		public function set score(value:Number):void 
		{
			_score = value;
		}
		
		public function get time():Number 
		{
			return _time;
		}
		
		public function set time(value:Number):void 
		{
			_time = value;
		}
		
	}

}