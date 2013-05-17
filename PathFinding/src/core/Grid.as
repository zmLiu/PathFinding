package core
{
	public class Grid
	{
		private var _width:int;
		private var _height:int;
		private var _nodes:Vector.<Vector.<Node>>;
		
		public function Grid(width:int,height:int,matrix:Array = null) {
			
			this._width = width;
			this._height = height;
			this._nodes = buildNodes(width,height,matrix);
		}
		
		
		private function buildNodes(width:int,height:int,matrix:Array):Vector.<Vector.<Node>>{
			var i:int;
			var j:int;
			var nodes:Vector.<Vector.<Node>> = new Vector.<Vector.<Node>>();
			
			for (i = 0; i < height; i++) {
				nodes.push(new Vector.<Node>);
				for (j = 0; j < width; j++) {
					nodes[i].push(new Node(i,j));
				}
			}
			
			if(matrix == null){
				return nodes;
			}
			
			if (matrix.length !== height || matrix[0].length !== width) {
				throw new Error('Matrix size does not fit');
			}
			
			for (i = 0; i < height; ++i) {
				for (j = 0; j < width; ++j) {
					nodes[i][j].walkable = (matrix[i][j] == 0);
				}
			}
			
			return nodes;
		}
		
		public function getNodeAt(x:int,y:int):Node{
			return _nodes[y][x];
		}
		
		public function isWalkableAt(x:int,y:int):Boolean{
			return isInside(x, y) && _nodes[y][x].walkable;
		}
		
		public function isInside(x:int,y:int):Boolean{
			return (x >= 0 && x < this._width) && (y >= 0 && y < this._height);
		}
		
		public function setWalkableAt(x:int,y:int,walkable:Boolean):void{
			_nodes[y][x].walkable = walkable;
		}
		
		public function getNeighbors(node:Node, allowDiagonal:Boolean, dontCrossCorners:Boolean):Array{
			var x:int = node.x;
			var y:int = node.y;
			var neighbors:Array = [];
			var s0:Boolean = false;
			var d0:Boolean = false;
			var s1:Boolean = false;
			var d1:Boolean = false;
			var s2:Boolean = false;
			var d2:Boolean = false;
			var s3:Boolean = false;
			var d3:Boolean = false;
			var nodes:Vector.<Vector.<Node>> = _nodes;
			
			// ↑
			if (this.isWalkableAt(x, y - 1)) {
				neighbors.push(nodes[y - 1][x]);
				s0 = true;
			}
			// →
			if (this.isWalkableAt(x + 1, y)) {
				neighbors.push(nodes[y][x + 1]);
				s1 = true;
			}
			// ↓
			if (this.isWalkableAt(x, y + 1)) {
				neighbors.push(nodes[y + 1][x]);
				s2 = true;
			}
			// ←
			if (this.isWalkableAt(x - 1, y)) {
				neighbors.push(nodes[y][x - 1]);
				s3 = true;
			}
			
			if (!allowDiagonal) {
				return neighbors;
			}
			
			if (dontCrossCorners) {
				d0 = s3 && s0;
				d1 = s0 && s1;
				d2 = s1 && s2;
				d3 = s2 && s3;
			} else {
				d0 = s3 || s0;
				d1 = s0 || s1;
				d2 = s1 || s2;
				d3 = s2 || s3;
			}
			
			// ↖
			if (d0 && this.isWalkableAt(x - 1, y - 1)) {
				neighbors.push(nodes[y - 1][x - 1]);
			}
			// ↗
			if (d1 && this.isWalkableAt(x + 1, y - 1)) {
				neighbors.push(nodes[y - 1][x + 1]);
			}
			// ↘
			if (d2 && this.isWalkableAt(x + 1, y + 1)) {
				neighbors.push(nodes[y + 1][x + 1]);
			}
			// ↙
			if (d3 && this.isWalkableAt(x - 1, y + 1)) {
				neighbors.push(nodes[y + 1][x - 1]);
			}
			
			return neighbors;
		}
		
		public function clone():Grid{
			var i:int;
			var j:int;
			
			var width:int = _width;
			var height:int = _height;
			var	thisNodes:Vector.<Vector.<Node>> = _nodes;
				
			var newGrid:Grid = new Grid(width, height);
			var newNodes:Vector.<Vector.<Node>> = new Vector.<Vector.<Node>>();
			
			for (i = 0; i < height; ++i) {
				newNodes[i] = new Vector.<Node>();
				for (j = 0; j < width; ++j) {
					newNodes[i][j] = new Node(j, i, thisNodes[i][j].walkable);
				}
			}
			
			newGrid._nodes = newNodes;
			
			return newGrid;
		}
		
		public function get width():int{
			return _width;
		}
		
		public function get height():int{
			return _height;
		}
	}
}