package core
{
	

	public class Node
	{
		public var x:Number;
		public var y:Number;
		public var walkable:Boolean = true;
		
		public var f:Number;
		public var g:Number;
		public var h:Number;
		public var parent:Node;
		
		public function Node(x:Number,y:Number,walkable:Boolean = true)
		{
			this.x = x;
			this.y = y;
			this.walkable = walkable;
		}
	}
}