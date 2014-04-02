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
		
		[Embed(source = "../tempAssets/blackFish.png")]
		public static const FishBone:Class;
		
		[Embed(source = "../fonts/myFont.TTF", fontFamily = "MyFontName", embedAsCFF = "false")]
		public static var MyFont:Class;
		
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