package  
{
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.core.Starling;
	import starling.display.Image;
	import flash.ui.Keyboard;
	import starling.events.KeyboardEvent;
	
	import com.reyco1.physinjector.PhysInjector;
    import com.reyco1.physinjector.data.PhysicsObject;
    import com.reyco1.physinjector.data.PhysicsProperties;
	
	import Box2D.Common.Math.b2Vec2;

	
	/**
	 * ...
	 * @author Yolanda
	 */
	public class Sphynx extends Sprite 
	{
		public var sphynxSprites:Image;
		private var state:String;
		
		public function Sphynx() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, update);
			sphynxArt();	
			sphynxKeyboard();
		}
				
		private function sphynxArt():void
		{
			sphynxSprites = new Image(Assets.getTexture("Cat"));
			this.scaleX = 0.5;
			this.scaleY = 0.5;
			this.addChild(sphynxSprites);	
		}
		
		private function sphynxKeyboard():void
		{
			this.addEventListener(KeyboardEvent.KEY_DOWN, sphynxMoves);
			this.addEventListener(KeyboardEvent.KEY_UP, sphynxStops);
		}
		
		private function sphynxMoves(event:KeyboardEvent):void
		{ 
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
					state = "left"
					break;
					
				case Keyboard.RIGHT:
					state = "right"
					break;
					
				case Keyboard.UP:
					state = "jump";
					break;
					
				case Keyboard.X:
					state = "attack";
					break;	
			}

		}
		
		private function sphynxStops(event:KeyboardEvent):void
		{ 
			state = "";
		}
		
		private function update(e:Event):void 
		{
			switch(state)
			{
				case "left":
					this.x -= 5;
					break;
					
				case "right":
					this.x += 5;
					break;
					
				case "jump":
					this.y -= 5;
					break;
					
				case "attack":
					break;		
			}		
		}	
	}
}