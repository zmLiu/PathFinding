package astar{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 * 寻路基类,抽象类
	 */	
	public class Path extends EventDispatcher{
		/**4方向模式*/
		public static const DIRECTION_4:String="4";
		/**4方向斜角模式*/
		public static const DIRECTION_4_BEVEL:String="5";
		/**8方向模式*/
		public static const DIRECTION_8:String="8";
		/**方向模式*/
		protected var _directionMode:String="8";
		
		/**节点二维数组*/
		protected var _pointsArr2D:Array=[];
		/**起始点*/
		protected var _startPoint:PathPoint;
		/**目标点*/
		protected var _targetPoint:PathPoint;
		/**每次可移动但已标记过的节点数组(关闭列表)*/
		protected var _finishList:Array=[];
		/**要测试的节点数组(开放列表)*/
		protected var _waitList:Array=[];
		/**找到终点标记*/
		protected var _finded:Boolean;
		
		private var _lastTime:uint;
		
		/**测试点可往上移动*/
		protected var _topMove:Boolean;
		/**测试点可往下移动*/
		protected var _bottomMove:Boolean;
		/**测试点可往左移动*/
		protected var _leftMove:Boolean;
		/**测试点可往右移动*/
		protected var _rightMove:Boolean;
		/**地图大小*/
		protected var _mapRectangle:Rectangle;
		
		protected var _ddArray:Array;
		/**用于判断可否移动的函数,参数是值,返回Boolean*/		
		protected var _moveJudgeFun:Function;
		
		/**
		 *创建寻路类
		 * @param 2Darray 二维数组
		 * @param moveValue 可移动值
		 */
		public function Path(ddArray:Array=null,moveJudgeFun:Function=null,directionMode:String="8"){
			if(ddArray)setGrids(ddArray);
			setMoveJudgeFun(moveJudgeFun);
			if(directionMode)setDirectionMode(directionMode);
		}
		
		public function setGrids(ddArray:Array):void{
			_pointsArr2D=[];
			_ddArray=ddArray;
			var col:int=_ddArray.length;
			var row:int=_ddArray[0].length;
			for (var i:uint=0;i<col;i++){//克隆一个由AStarPoint组成的二维数组
				if(!_pointsArr2D[i])_pointsArr2D[i]=new Array();
				for (var s:uint=0;s<row;s++){
					if(!_pointsArr2D[i][s])_pointsArr2D[i][s]=new PathPoint(i,s,null);
				}
			}
		}
		
		public function setPointValue(x:int,y:int,value:Object):void{
			_ddArray[x][y] = value;
		}
		
		public function setMoveJudgeFun(fun:Function):void{
			_moveJudgeFun=fun;
		}
		
		
		public function setDirectionMode(directionMode:String):void{
			_directionMode=directionMode;
		}
		public function getDirectionMode():String{
			return _directionMode;
		}
		
		public function findPath(currentLocation:Point,targetLocation:Point):Array{
			throw new Error("Min:未执行复写");
		}
		
		protected function resetParameters(currentLocation:Point,targetLocation:Point):void{
			_lastTime=getTimer();
			_finded=false;
			_startPoint=_pointsArr2D[currentLocation.x][currentLocation.y];
			_startPoint._parentPoint=null;
			_startPoint._G=0;
			_targetPoint=_pointsArr2D[targetLocation.x][targetLocation.y];//设置终点
			_finishList=[];//清空关闭列表
			_mapRectangle=new Rectangle(0,0,_ddArray.length,_ddArray[0].length);
			_waitList=[_startPoint];//将起点加入开放列表
		}
		
		
		protected function findComplete():void{
			for each(var i:PathPoint in _finishList){
				i._moved=false;
			}
		}
		
		/**
		 *获得周围点可移动的点,加入_aroundPointArr数组
		 * @param testPoint当前要测试的点
		 * @return 是否找到终点
		 */
		protected function testPoint(testPoint:PathPoint):void{
			_rightMove=testAroundPoint(testPoint,1,0);
			_leftMove=testAroundPoint(testPoint,-1,0);
			_bottomMove=testAroundPoint(testPoint,0,1);
			_topMove=testAroundPoint(testPoint,0,-1);
			if(_directionMode==DIRECTION_4_BEVEL){//4方向斜角时,确保2个方向都畅通才可穿过夹角
				if(_rightMove && _topMove)testAroundPoint(testPoint,1,-1);
				if(_rightMove && _bottomMove)testAroundPoint(testPoint,1,1);
				if(_leftMove && _bottomMove)testAroundPoint(testPoint,-1,1);
				if(_leftMove && _topMove)testAroundPoint(testPoint,-1,-1);
			}else if(_directionMode==DIRECTION_8){//8方向
				testAroundPoint(testPoint,1,-1);
				testAroundPoint(testPoint,1,1);
				testAroundPoint(testPoint,-1,1);
				testAroundPoint(testPoint,-1,-1);
			}
			//方向判断,经测试在150*80无障碍网格中,从中间到顶角寻路时间少1-2毫秒;因为多了一个属性且代码繁冗,所以注释
			/*
			if(testPoint.direction){//非起点
			switch(testPoint.direction){
			case "right":
			getAroundPoint(testPoint,1,0);
			getAroundPoint(testPoint,0,-1);
			getAroundPoint(testPoint,0,1);
			if(_directionType=="8"){
			getAroundPoint(testPoint,1,-1);
			getAroundPoint(testPoint,1,1);
			}
			break;
			case "rightDown":
			getAroundPoint(testPoint,0,1);
			getAroundPoint(testPoint,1,0);
			getAroundPoint(testPoint,1,1);
			getAroundPoint(testPoint,1,-1);
			getAroundPoint(testPoint,-1,1);
			break;
			case "down":
			getAroundPoint(testPoint,1,0);
			getAroundPoint(testPoint,-1,0);
			getAroundPoint(testPoint,0,1);
			if(_directionType=="8"){
			getAroundPoint(testPoint,1,1);
			getAroundPoint(testPoint,-1,1);
			}
			break;
			case "leftDown":
			getAroundPoint(testPoint,-1,0);
			getAroundPoint(testPoint,0,1);
			getAroundPoint(testPoint,-1,1);
			getAroundPoint(testPoint,1,1);
			getAroundPoint(testPoint,-1,-1);
			break;
			case "left":
			getAroundPoint(testPoint,-1,0);
			getAroundPoint(testPoint,0,-1);
			getAroundPoint(testPoint,0,1);
			if(_directionType=="8"){
			getAroundPoint(testPoint,-1,1);
			getAroundPoint(testPoint,-1,-1);
			}
			break;
			case "leftUp":
			getAroundPoint(testPoint,-1,0);
			getAroundPoint(testPoint,0,-1);
			getAroundPoint(testPoint,-1,-1);
			getAroundPoint(testPoint,-1,1);
			getAroundPoint(testPoint,1,-1);
			break;
			case "up":
			getAroundPoint(testPoint,0,-1);
			getAroundPoint(testPoint,1,0);
			getAroundPoint(testPoint,-1,0);
			if(_directionType=="8"){
			getAroundPoint(testPoint,-1,-1);
			getAroundPoint(testPoint,1,-1);
			}
			break;
			case "rightUp":
			getAroundPoint(testPoint,0,-1);
			getAroundPoint(testPoint,1,0);
			getAroundPoint(testPoint,1,-1);
			getAroundPoint(testPoint,1,1);
			getAroundPoint(testPoint,-1,-1);
			break;
			default:
			throw new Error("Min:与父坐标不相邻,请检查");
			}
			}else{//起点
			getAroundPoint(testPoint,1,0);
			getAroundPoint(testPoint,-1,0);
			getAroundPoint(testPoint,0,1);
			getAroundPoint(testPoint,0,-1);
			if(_directionType=="8"){
			getAroundPoint(testPoint,1,-1);
			getAroundPoint(testPoint,1,1);
			getAroundPoint(testPoint,-1,1);
			getAroundPoint(testPoint,-1,-1);
			}
			}*/
		}
		
		
		
		protected function testAroundPoint(testPoint:PathPoint,offsetX:int,offsetY:int):Boolean{
			throw new Error("未执行复写");
		}
		
		
		private var _indexArr:Array;
		public function getOptimizePath(path:Array,crossBorder:Boolean):Array{
			if (!path)return null;
			_lastTime=getTimer();
			var testPath:Array = path.concat();
			var len:int = testPath.length;
			var i:int;
			_peakArr=[];
			_indexArr=[0];
			var index:int;
			do{
				_testPeakArr=PathLineUtils.getPeaksInLine(testPath,notInArr);//取得路径上的所有顶点,包含起点和终点
				
				len = _testPeakArr.length;
				for(i=1;i<len-1;i++){//遍历顶点,尝试消除
					index=testPath.indexOf(_testPeakArr[i]);
					if(_peakArr.indexOf(_testPeakArr[i])<0){//未记录为不可消除
						if (canCross(testPath[index+1], testPath[index-1],crossBorder)){//顶点的2个相邻点连接无障碍,消除这个顶点
							testPath.splice(index,1);
						}else{//有障碍,保留这个点
							_peakArr.push(_testPeakArr[i]);
							_indexArr.push(path.indexOf(_testPeakArr[i]));
						}
					}
				}
			}while(_testPeakArr.length>2);//大于1表示取得了
			_indexArr.sort(Array.NUMERIC);
			_indexArr.push(path.length-1)
			
			//得到的顶点数组是树形排列的,这里对齐顺序
			var orderArr:Array=[];
			for each(index in _indexArr){
				orderArr.push(path[index]);
			}
			return orderArr;
		}
		private var _testPeakArr:Array;
		private var _peakArr:Array;
		/**
		 * 判断函数 
		 * @param point
		 * @return 
		 */		
		private function notInArr(point:Point):Boolean{
			return _peakArr.indexOf(point)<0;
		}
		
		/**
		 * 2点是否没有障碍
		 * @param n1 点1
		 * @param n2 点2
		 * @return 是否没有障碍
		 */
		private function canCross(point1:Point, point2:Point,crossBorder:Boolean):Boolean{
			var points:Array = PathLineUtils.getCrossPoint(point1, point2,crossBorder);
			var len:uint=points.length;
			for (var i:uint=0;i<len;i++){
				if (_moveJudgeFun.call(null,_ddArray[points[i].x][points[i].y])==false){
					return false;
				}
			}
			return true;
		}
	}
}