package  
{
	import starling.display.Image;
	import starling.display.Sprite;
	import flash.ui.Keyboard;
	import starling.events.KeyboardEvent;
	import starling.events.Event;
	
	
	/**
	 * ...
	 * @author Yolanda
	 */
	public class PauseLayer extends Sprite 
	{
		private var pauseLayer:Image;
		
		public function PauseLayer() 
		{
			super();
			draw();
			trace("PAUSE");
			this.addEventListener(KeyboardEvent.KEY_DOWN, gameBack);
		}

		
		private function gameBack(e:KeyboardEvent):void 
		{
			if (this.visible)
			{
				if (e.keyCode == Keyboard.R)
				{
					this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"play" }, true));			
				}
			}	
		}
		
		private function draw():void
		{
			pauseLayer = new Image(Assets.getAtlas().getTexture("pauseLayer"));
			this.addChild(pauseLayer);
		}
		
		public function initializePause():void
		{
			this.visible = true;
		}
		
		public function disposePause():void
		{
			this.visible = false;
		}
		
	}

}