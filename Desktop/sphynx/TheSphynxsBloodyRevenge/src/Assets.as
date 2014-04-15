package  
{
	import flash.display.Bitmap;
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
		
		[Embed(source = "../tempAssets/suelo.png")]
		public static const Floor:Class;
		
		[Embed(source = "../tempAssets/blueFish.png")]
		public static const FishBoneB:Class;
		
		[Embed(source = "../tempAssets/goldFish.png")]
		public static const FishBoneG:Class;
		
		[Embed(source = "../tempAssets/redFish.png")]
		public static const FishBoneR:Class;
		
		[Embed(source = "../tempAssets/turqFishBone.png")]
		public static const FishBoneT:Class;
		
		[Embed(source = "../tempAssets/orangeFishbone.png")]
		public static const FishBoneO:Class;
		
		[Embed(source = "../tempAssets/purpleFishBone.png")]
		public static const FishBoneP:Class;
		
		[Embed(source = "../tempAssets/eyeRight.png")]
		public static const Eye:Class;
		
		[Embed(source = "../tempAssets/wall.png")]
		public static const Wall:Class;
		
		[Embed(source = "../tempAssets/punch.png")]
		public static const Punch:Class;
		
		[Embed(source = "../tempAssets/paw.png")]
		public static const Paw:Class;
		
		//menu
		
		[Embed(source = "../tempAssets/play.png")]
		public static const Play:Class;
		
		[Embed(source = "../tempAssets/background.png")]
		public static const Background:Class;
		
		[Embed(source = "../tempAssets/gname.png")]
		public static const Gname:Class;
		
		
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
		
		/*
		public static function getAtlas():TextureAtlas
		{	
			if (gameTextureAtlas == null) {
				
				var texture:Texture = getTexture("AtlasTextureGame");
				var xml:XML= XML(new AtlasXmlGame());
				gameTextureAtlas = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlas;
			
		}
		*/
		
	}

}