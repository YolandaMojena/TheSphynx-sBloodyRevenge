package  
{
	import starling.display.Sprite	
	import starling.animation.Tween;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Yolanda
	 */
	public class Menu extends Sprite 
	{
		private var gname:Image;
		private var background:Image;
		
		private var playBtn:Button;
		
		
		public function Menu() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		private function onAddedToStage(event:Event):void
		{
			trace("Menu");
			drawScreen();
		
		}
		
		private function drawScreen():void
		{
			background = new Image(Assets.getTexture("Background"));
			this.addChild(background);
			//background.x =
			//background.y = 
			
			gname = new Image(Assets.getTexture("Gname"));
			this.addChild(gname);
			gname.x = 250;
			gname.y = 15;
			
			playBtn = new Button(Assets.getTexture("Play"));
			this.addChild(playBtn);
			playBtn.x = 425;
			playBtn.y = 275;
			
			this.addEventListener(Event.TRIGGERED, onMainMenuClick);
			
		}
		
		private function onMainMenuClick(event:Event):void
		{
			trace("click");
			var buttonClicked:Button = event.target as Button;
			
			if (buttonClicked as Button == playBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"play" }, true));
				trace("PLAY");
			}
			
			/*
			else if (buttonClicked as Button == aboutBtn)
			{
				trace("ABOUT");
			}
			*/
		}
		
		public function disposeTemporaly():void
		{
			this.visible = false;
			
		}
		
		public function initialize():void
		{
			this.visible = true;
			
		}
		
	}

}