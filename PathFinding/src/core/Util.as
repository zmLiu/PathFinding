package core
{
	public class Util
	{
		public static function backtrace(node:Node):Array{
			var path:Array = [[node.x, node.y]];
			while (node.parent) {
				node = node.parent;
				path.push([node.x, node.y]);
			}
			return path.reverse();
		}
		
		public static function biBacktrace(nodeA:Node,nodeB:Node):Array{
			var pathA:Array = backtrace(nodeA);
			var pathB:Array = backtrace(nodeB);
			return pathA.concat(pathB.reverse());
		}
		
		public static function pathLength(path:Array):Number {
			var i:int;
			var sum:Number = 0;
			var a:Number;
			var b:Number;
			var dx:Number;
			var dy:Number;
			var l:int ; path.length;
			for (i = 1; i < l; ++i) {
				a = path[i - 1];
				b = path[i];
				dx = a[0] - b[0];
				dy = a[1] - b[1];
				sum += Math.sqrt(dx * dx + dy * dy);
			}
			return sum;
		}
		
		public static function getLine(x0, y0, x1, y1):Array {
			var abs:Function = Math.abs;
			var line:Array = [];
			var sx:Number;
			var sy:Number
			var dx:Number
			var dy:Number;
			var err:Number;
			var e2:Number;
			
			dx = abs(x1 - x0);
			dy = abs(y1 - y0);
			
			sx = (x0 < x1) ? 1 : -1;
			sy = (y0 < y1) ? 1 : -1;
			
			err = dx - dy;
			
			while (true) {
				line.push([x0, y0]);
				
				if (x0 === x1 && y0 === y1) {
					break;
				}
				
				e2 = 2 * err;
				if (e2 > -dy) {
					err = err - dy;
					x0 = x0 + sx;
				}
				if (e2 < dx) {
					err = err + dx;
					y0 = y0 + sy;
				}
			}
			
			return line;
		}
		
		public static function smoothenPath(grid:Grid, path:Array):Array {
			var len:int = path.length;
			var x0:Number = path[0][0];       // path start x
			var y0:Number = path[0][1];       // path start y
			var x1:Number = path[len - 1][0];  // path end x
			var y1:Number = path[len - 1][1];  // path end y
			var sx:Number;
			var sy:Number;                 // current start coordinate
			var ex:Number
			var ey:Number;                 // current end coordinate
			var lx:Number;
			var ly:Number;                 // last valid end coordinate
			var newPath:Array;
			var i:int;
			var j:int;
			var coord:Array;
			var line:Array;
			var testCoord:Array
			var blocked:Boolean;
			
			sx = x0;
			sy = y0;
			lx = path[1][0];
			ly = path[1][1];
			newPath = [[sx, sy]];
			
			for (i = 2; i < len; ++i) {
				coord = path[i];
				ex = coord[0];
				ey = coord[1];
				line = getLine(sx, sy, ex, ey);
				
				blocked = false;
				for (j = 1; j < line.length; ++j) {
					testCoord = line[j];
					
					if (!grid.isWalkableAt(testCoord[0], testCoord[1])) {
						blocked = true;
						newPath.push([lx, ly]);
						sx = lx;
						sy = ly;
						break;
					}
				}
				if (!blocked) {
					lx = ex;
					ly = ey;
				}
			}
			newPath.push([x1, y1]);
			
			return newPath;
		}
	}
}