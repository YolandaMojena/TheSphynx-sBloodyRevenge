package  
{
	import flash.display.Bitmap;
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
		[Embed(source = "../tempAssets/cat.png")]
		public static const Cat:Class;
		
		[Embed(source = "../tempAssets/suelo.jpg")]
		public static const Floor:Class;
		
		[Embed(source = "../tempAssets/sueloSmall.jpg")]
		public static const FloorSmall:Class;
		
		[Embed(source = "../tempAssets/blueFish.png")]
		public static const FishBoneB:Class;
		
		[Embed(source = "../tempAssets/goldFish.png")]
		public static const FishBoneG:Class;
		
		[Embed(source = "../tempAssets/redFish.png")]
		public static const FishBoneR:Class;
		
		[Embed(source = "../tempAssets/eye.jpg")]
		public static const Eye:Class;
		
		[Embed(source = "../tempAssets/wall.jpg")]
		public static const Wall:Class;
		
		[Embed(source = "../tempAssets/invisibleWall.png")]
		public static const InvisibleWall:Class;
		
		[Embed(source = "../tempAssets/biggerWall.jpg")]
		public static const BiggerWall:Class;
		
		[Embed(source = "../tempAssets/punch.png")]
		public static const Punch:Class;
		
		[Embed(source = "../tempAssets/game_background.png")]
		public static const BackgroundG:Class;
		
		[Embed(source = "../tempAssets/plat.jpg")]
		public static const Plat:Class;
		
		[Embed(source = "../tempAssets/montoncito.png")]
		public static const Bones:Class;

		[Embed(source = "../tempAssets/pauseLayer.jpg")]
		public static const Pause:Class;
		
		[Embed(source = "../tempAssets/play.png")]
		public static const Play:Class;
		
		[Embed(source = "../tempAssets/background.png")]
		public static const Background:Class;
		
		[Embed(source = "../tempAssets/gname.png")]
		public static const Gname:Class;
		
		[Embed(source = "../spriteSheets/minigameSpriteSheet.png")]
		public static const MinigameSheet:Class;
		
		[Embed(source = "../spriteSheets/minigameSpriteSheet.xml", mimeType ="application/octet-stream")]
		public static const AtlasMinigame:Class;
		
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameTextureAtlas:TextureAtlas;

		
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
		
		
	}

}