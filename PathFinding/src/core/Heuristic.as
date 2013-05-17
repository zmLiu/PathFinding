package core
{
	public class Heuristic
	{
		public static function manhattan(dx:Number, dy:Number):Number{
			return dx + dy;
		}
		
		public static function euclidean(dx:Number, dy:Number):Number{
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		public static function chebyshev(dx:Number, dy:Number):Number{
			return Math.max(dx, dy);
		}
	}
}