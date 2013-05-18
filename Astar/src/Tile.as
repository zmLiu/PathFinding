package
{
	import flash.display.Sprite;
	
	public class Tile extends Sprite
	{
		private var _size:Number;
		public function Tile(size:Number)
		{
			super();
		
			this._size = size;
			
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0,0,_size,_size);
			this.graphics.endFill();
		}
	}
}