package astar{
	import flash.geom.Point;
	/**
	 * 寻路点 
	 * @author J_Min
	 * 为JMPath类提供实例帮助寻路
	 */	
	public class PathPoint extends Point{
		/**父坐标*/
		public var _parentPoint:PathPoint;
		/**是否被标记在某条路径上(关闭列表中)*/
		public var _moved:Boolean;
		/**是否处于等待状态(开放列表中)*/
		public var _wait:Boolean;
		/**是否处于等待状态(开放列表中)*/
		public var _wait2:Boolean;
		/**已移动值*/
		public var _G:int;
		/**评分*/
		public var _F:int;
		/**
		 *A星寻路点 
		 * @param $x x坐标
		 * @param $y y坐标
		 * @param $parentPoint 父坐标
		 */	
		public function PathPoint($x:int,$y:int,parentPoint:PathPoint=null){
			x=$x;
			y=$y;
			_parentPoint=parentPoint;
		}
		
		
		public function getWay():Array{
			//trace("终点"+finalPoint);
			var wayPointArr:Array=[];
			var testPoint:PathPoint=this;
			while(testPoint){//非起点(起点的parentPoint属性是null);
				//trace(">"+testPoint);
				wayPointArr.push(testPoint);
				testPoint=testPoint._parentPoint;
			}
			return wayPointArr;
		}
		
		
		//方向判断,经测试在150*80无障碍网格中,从中间到顶角寻路时间少1-2毫秒;因为多了一个属性且代码繁冗,所以注释
		/*
		public function set parentPoint($parentPoint:AStarPoint):void{
			_parentPoint=$parentPoint;
			if(_parentPoint){
				var $x:int=x-_parentPoint.x;
				var $y:int=y-_parentPoint.y;
				if($x==1&&$y==0){
					_direction="right";
				}else if($x==1&&$y==1){
					_direction="rightDown";
				}else if($x==0&&$y==1){
					_direction="down";
				}else if($x==-1&&$y==1){
					_direction="leftDown";
				}else if($x==-1&&$y==0){
					_direction="left";
				}else if($x==-1&&$y==-1){
					_direction="leftUp";
				}else if($x==0&&$y==-1){
					_direction="up";
				}else if($x==1&&$y==-1){
					_direction="rightUp";
				}else{
					throw new Error("Min:与父坐标不相邻,请检查");
				}
			}
		}*/
		
	}
}