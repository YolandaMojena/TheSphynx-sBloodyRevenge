package  
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.core.Starling;
	import starling.display.Image;
	
	/**
	 * ...
	 * @author Yolanda
	 */
	public class FishBone extends Sprite 
	{
		public var fishBoneSprite:Image;

		private var posX:Number;
		private var posY:Number;
		private var _value:uint;
		
		public function FishBone(value:uint, x:Number, y:Number) 
		{
			super();
			posX = x;
			posY = y;
			this.value = value;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
		}
		
		private function onAddedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			fishboneArt();
		}
		
		private function fishboneArt():void
		{
			fishBoneSprite = new Image(Assets.getTexture("FishBone"));
			fishBoneSprite.x = posX;
			fishBoneSprite.y = posY;
			this.addChild(fishBoneSprite);
		}
		
		public function get value():uint 
		{
			return _value;
		}
		
		public function set value(value:uint):void 
		{
			_value = value;
		}
		
		
	}

}