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
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;

	
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
		private var aboutBtn:Button;
		private var aboutImage:Image;
		
		private var cinematic:Image;
		private var canAdvance:Boolean;
		
		private var first:Boolean = true;
		private var second:Boolean = false;
		private var third:Boolean = false;
		
		
		public function Menu() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(KeyboardEvent.KEY_DOWN, closeHowTo);
			canAdvance = true;
			
			
		}
		
		private function onAddedToStage(event:Event):void
		{
			trace("Menu");
			drawScreen();
			
		
		}
		
		private function drawScreen():void
		{
			background = new Image(Assets.getAtlas().getTexture("menu"));
			this.addChild(background);
		
			playBtn = new Button(Assets.getAtlas().getTexture("play"));
			this.addChild(playBtn);
			playBtn.x = 425;
			playBtn.y = 205;
			
			aboutBtn = new Button(Assets.getAtlas().getTexture("about"));
			this.addChild(aboutBtn);
			aboutBtn.y = 337;
			aboutBtn.x = 510;
			
			howTo = new Button(Assets.getAtlas().getTexture("howToText"));
			this.addChild(howTo);
			howTo.x = 220;
			howTo.y = 325;
			
			howToImage = new Image(Assets.getAtlas().getTexture("howTo"));
			this.addChild(howToImage);
			howToImage.visible = false;
			
			aboutImage = new Image(Assets.getAtlas().getTexture("About"));
			this.addChild(aboutImage);
			aboutImage.visible = false;
			
			cinematic = new Image(Assets.getTexture("Cin1"));
			cinematic.visible = false;
			this.addChild(cinematic);
			
			this.addEventListener(Event.TRIGGERED, onMainMenuClick);
			
		}
		
		private function onMainMenuClick(event:Event):void
		{
			trace("click");
			var buttonClicked:Button = event.target as Button;
			
			if (buttonClicked as Button == playBtn)
			{
				SoundMixer.soundTransform = new SoundTransform(0);
				cinematic.visible = true;
				this.addEventListener(KeyboardEvent.KEY_DOWN, cinematicChange);
				this.addEventListener(KeyboardEvent.KEY_UP, cinematicPass);
				//this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"init" }, true));
				trace("PLAY");
			}
			
			
			else if (buttonClicked as Button == howTo)
			{
				howToImage.visible = true;

			}
			
			else if (buttonClicked as Button == aboutBtn)
			{
				aboutImage.visible = true;

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
			
			if (aboutImage.visible)
			{
				if (e.keyCode == Keyboard.R)
				{

					aboutImage.visible = false;		
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
		
		private function cinematicPass(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.SPACE)
			{
				canAdvance = true;
			}
		}
		
		private function cinematicChange(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.SPACE)
			{
				if (first  && canAdvance)
				{
					cinematic = new Image(Assets.getTexture("Cin2"));
					addChild(cinematic);
					canAdvance = false;
					first = false;
					second = true;
				}
				
				if (second  && canAdvance)
				{
					cinematic = new Image(Assets.getTexture("Cin3"));
					addChild(cinematic);
					canAdvance = false;
					second = false;
					third = true;
				}
				
				if (third  && canAdvance)
				{
					this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"init" }, true));
					third = false;
					canAdvance = false;
				}
			}
		}
		
	}

}