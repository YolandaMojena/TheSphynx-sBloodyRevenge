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
		
		public function Menu() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		private function onAddedToStage(event:Event):void
		{
			trace("Menu");
			
			this.addEventListener(Event.TRIGGERED, onMainMenuClick);
		}
		
		private function onMainMenuClick(event:Event):void
		{
			trace("click");
			var buttonClicked:Button = event.target as Button;
			/*if (buttonClicked as Button == playBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"play" }, true));
				trace("PLAY");
			}
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