package  
{
	import flash.geom.Rectangle;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.core.Starling;
	import starling.display.Image;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	import com.reyco1.physinjector.PhysInjector;
    import com.reyco1.physinjector.data.PhysicsObject;
    import com.reyco1.physinjector.data.PhysicsProperties;
	
	import Box2D.Common.Math.b2Vec2;
	/**
	 * ...
	 * @author Yolanda
	 */
	public class DontMiss extends Sprite
	{
		private var fishPhysics:PhysInjector;
		private var fishObject:PhysicsObject;
		
		private var touch:Touch;
		private var touchX:Number;
		private var touchY:Number;
		
		public var fishBoneSprite:Image;
		private var value:Number;
		private var limit:Number;
		private var posX:int;
		private var random:Number;
		
		private var fishBones:Vector.<PhysicsObject>;
		
		public function DontMiss()
		{
			super();
			trace("Don't Miss the Fish");
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		public function initialize():void
		{
			this.visible = true;
		}
		
		private function onAddedToStage(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			fishBones = new Vector.<PhysicsObject>;
			
			
			fishPhysics = new PhysInjector(Starling.current.nativeStage, new b2Vec2(0, 2.8), false); // false y asi no se puede mover con raton 
			var gameArea:Rectangle = new Rectangle(0, -200, 700, 600);
			
			addEventListener(TouchEvent.TOUCH, onTouch);
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function onTouch(event:TouchEvent):void 
		{
			touch = event.getTouch(stage);
			
			if (touch != null)
			{
				touchX = touch.globalX;
				touchY = touch.globalY;
			}	
		
			
			
		}
			
		private function createFishBones():void 
		{
			if (Math.random() > 0.99)
			{
				random = Math.random() * 10;
				
				posX = Math.random() * 900;
				if (posX < 200) posX = 200;
				if (posX > 700) posX = 600;
			
				if (random <= 3.33) value = 3;
				else if (random <= 6.66) value = 2;
				else value = 5;
			
				switch (value)
				{
					case 5:
						fishBoneSprite = new Image(Assets.getTexture("FishBoneO"));
						fishBoneSprite.x = posX;
						break;
					
					case 2:
						fishBoneSprite = new Image(Assets.getTexture("FishBoneT"));
						fishBoneSprite.x = posX;
						break;
						
					case 3:
						fishBoneSprite = new Image(Assets.getTexture("FishBoneP"));
						fishBoneSprite.x = posX;
						break;
					
				}
			
				this.addChild(fishBoneSprite);
				fishObject = fishPhysics.injectPhysics(fishBoneSprite, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.35, restitution:0 } ));
				fishBones.push(fishObject);
			}
		}

		private function update(e:Event):void 
		{	
			createFishBones();
			handleBounds();
			fishPhysics.update();
		}
		
		private function handleBounds():void 
		{
			
		}
		
		public function disposeTemporaly():void
		{
			this.visible = false;
			
		}
	}

}