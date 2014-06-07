package  
{
	import starling.display.Sprite	
	import starling.animation.Tween;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.core.Starling;
	import flash.ui.Keyboard;
	import starling.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author Yolanda
	 */
	public class Menu extends Sprite 
	{
		private var background:Image;
		
		private var playBtn:Button;
		private var howTo:Button;
		private var howToImage:Image;
		
		
		public function Menu() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(KeyboardEvent.KEY_DOWN, closeHowTo);
			
			
		}
		
		private function onAddedToStage(event:Event):void
		{
			trace("Menu");
			drawScreen();
		
		}
		
		private function drawScreen():void
		{
			background = new Image(Assets.getTexture("MenuPic"));
			this.addChild(background);
			//background.x =
			//background.y = 
		
			
			playBtn = new Button(Assets.getTexture("Play"));
			this.addChild(playBtn);
			playBtn.x = 425;
			playBtn.y = 205;
			
			howTo = new Button(Assets.getTexture("HowTo"));
			this.addChild(howTo);
			howTo.x = 360;
			howTo.y = 325;
			
			howToImage = new Image(Assets.getTexture("HowToText"));
			this.addChild(howToImage);
			howToImage.visible = false;
			this.addEventListener(Event.TRIGGERED, onMainMenuClick);
			
		}
		
		private function onMainMenuClick(event:Event):void
		{
			trace("click");
			var buttonClicked:Button = event.target as Button;
			
			if (buttonClicked as Button == playBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"init" }, true));
				trace("PLAY");
			}
			
			
			else if (buttonClicked as Button == howTo)
			{
				howToImage.visible = true;
			}
			
		}
		
		private function closeHowTo(e:KeyboardEvent):void 
		{
			if (howToImage.visible)
			{
				if (e.keyCode == Keyboard.R)
				{
						howToImage.visible = false;		
				}
			}	
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