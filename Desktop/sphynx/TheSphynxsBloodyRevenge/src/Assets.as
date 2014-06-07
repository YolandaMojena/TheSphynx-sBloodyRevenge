package  
{
	import flash.display.Bitmap;
	import flash.media.Sound;
	import starling.display.Image;
	import starling.textures.Texture;
	import flash.utils.Dictionary;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author Yolanda
	 */
	public class Assets 
	{
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameSounds:Dictionary = new Dictionary();
		
		private static var gameTextureAtlas2:TextureAtlas;
		private static var gameTextureAtlas:TextureAtlas; //para el minijuego
		private static var gameTextureAtlas3:TextureAtlas; //para las animaciones del gato
		
		[Embed(source = "../tempAssets/cat.png")]
		public static const Cat:Class;
		
		[Embed(source = "../tempAssets/blueFish.png")]
		public static const FishBoneB:Class;
		
		[Embed(source = "../tempAssets/goldFish.png")]
		public static const FishBoneG:Class;
		
		[Embed(source = "../tempAssets/redFish.png")]
		public static const FishBoneR:Class
		
		[Embed(source = "../tempAssets/invisibleWall.png")]
		public static const InvisibleWall:Class;
		
		[Embed(source = "../tempAssets/montoncito.png")]
		public static const Bones:Class;
		
		[Embed(source = "../tempAssets/play.png")]
		public static const Play:Class;
		
		[Embed(source = "../tempAssets/gameOver.jpg")]
		public static const GameOverImage:Class;
		
		[Embed(source = "../tempAssets/revenge.jpg")]
		public static const RevengeImage:Class;
	
		
		[Embed(source = "../tempAssets/hb1.jpg")]
		public static const Background1:Class;
		
		[Embed(source = "../tempAssets/hb2.jpg")]
		public static const Background2:Class;
		
		[Embed(source = "../tempAssets/hb3.jpg")]
		public static const Background3:Class;
		
		[Embed(source = "../tempAssets/hb2.jpg")]
		public static const Background4:Class;
		
		[Embed(source = "../tempAssets/menu.jpg")]
		public static const MenuPic:Class;
		
		[Embed(source = "../tempAssets/howToText.png")]
		public static const HowTo:Class;
		
		[Embed(source = "../tempAssets/hb5.jpg")]
		public static const Background5:Class;
		
		[Embed(source = "../fonts/myFont.TTF", fontFamily ="MyFontName", embedAsCFF = false)]
		public static const MyFontName:Class;
		
		[Embed(source = "../fonts/AYearWithoutRain.ttf", fontFamily ="WithoutRain", embedAsCFF = false)]
		public static const WithoutRain:Class;
		
		[Embed(source = "../spriteSheets/minigameSpriteSheet.png")]
		public static const MinigameSheet:Class;
		
		[Embed(source = "../spriteSheets/minigameSpriteSheet.xml", mimeType ="application/octet-stream")]
		public static const AtlasMinigame:Class;
		
		[Embed(source = "../spriteSheets/sprite_sheet_1.png")]
		public static const GameSheet:Class;
		
		[Embed(source = "../spriteSheets/sprite_sheet_1.xml", mimeType ="application/octet-stream")]
		public static const AtlasGame:Class;
		
		[Embed(source = "../spriteSheets/sphynxMoves.png")]
		public static const MovesSheet:Class;
		
		[Embed(source = "../spriteSheets/sphynxMoves.xml", mimeType ="application/octet-stream")]
		public static const AtlasMoves:Class;
		
		[Embed(source = "../tempAssets/howTo.jpg")]
		public static const HowToText:Class;

		[Embed(source = "../sounds/madCat.mp3")]
		public static const MadCat:Class;
		
		[Embed(source = "../sounds/Meow2.mp3")]
		public static const Meow:Class;	
		
		[Embed(source = "../sounds/punch.mp3")]
		public static const PunchSound:Class;
		
		[Embed(source = "../sounds/smudge.mp3")]
		public static const SmudgeSound:Class;
		
		[Embed(source = "../sounds/RisedDontFall.mp3")]
		public static const Rised:Class;
		
		
		public static function getTexture(name:String):Texture
		{
			if (gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);			
			}
			return gameTextures[name];	
		}
		
		public static function getAtlasMini():TextureAtlas
		{	
			if (gameTextureAtlas == null) {
				
				var texture:Texture = getTexture("MinigameSheet");
				var xml:XML= XML(new AtlasMinigame());
				gameTextureAtlas = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlas;	
		}
		
		public static function getAtlas():TextureAtlas
		{	
			if (gameTextureAtlas2 == null) {
				
				var texture:Texture = getTexture("GameSheet");
				var xml:XML= XML(new AtlasGame());
				gameTextureAtlas2 = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlas2;	
		}
		
		public static function getSound(name:String):Sound
		{
			if (gameSounds[name] == undefined)
			{
				var sound:Sound = new Assets[name]();
				gameSounds[name] = sound;			
			}
			return gameSounds[name];	
		}
		
		
		public static function getMoves():TextureAtlas
		{	
			if (gameTextureAtlas3 == null) {
				
				var texture:Texture = getTexture("MovesSheet");
				var xml:XML= XML(new AtlasMoves());
				gameTextureAtlas3 = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlas3;	
		}
	}
}