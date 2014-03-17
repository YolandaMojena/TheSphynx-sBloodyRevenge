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
		
		private static var gameTextures:Dictionary = new Dictionary();

		
		public static function getTexture(name:String):Texture
		{
			if (gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);			
			}
			return gameTextures[name];
			
		}
		
	}

}