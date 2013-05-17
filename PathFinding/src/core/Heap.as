package core
{
	public class Heap
	{
		public function Heap()
		{
			
		}
		
		public static function defaultCmp(x:Number,y:Number):int{
			if (x < y) {
				return -1;
			}
			if (x > y) {
				return 1;
			}
			return 0;
		}
		
		public static function insort(a:Array, x:Number, lo:Number = 0, hi:Number = 0, cmp:Function = null):Number{
			var mid:Number;
			if (lo < 0) {
				throw new Error('lo must be non-negative');
			}
			if (hi == 0) {
				hi = a.length;
			}
			while (cmp(lo, hi) < 0) {
				mid = Math.floor((lo + hi) / 2);
				if (cmp(x, a[mid]) < 0) {
					hi = mid;
				} else {
					lo = mid + 1;
				}
			}
			return ([].splice.apply(a, [lo, lo - lo].concat(x)), x);
		}
		
	}
}