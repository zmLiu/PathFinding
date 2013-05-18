package astar{
	
	import flash.geom.Point;
	
	/**
	 * A*寻路 
	 */	
	public class AStar extends Path{
		/**
		 * 创建A*寻路类
		 * @param 2Darray 二维数组
		 * @param moveValue 可移动值
		 */
		public function AStar(ddArray:Array=null,moveJudgeFun:Function=null,directionMode:String="5"){
			super(ddArray,moveJudgeFun,directionMode);
			_binaryHeap=new BinaryHeap("_F");
		}
		/**二叉堆优化*/
		private var _bmh:Boolean=true;
		public function setBMH(enable:Boolean):void{
			_bmh=enable;
		}
		public function getBMH():Boolean{
			return _bmh;
		}
		private var _binaryHeap:BinaryHeap;
		
		
		override public function findPath(currentLocation:Point,targetLocation:Point):Array{
			if(_moveJudgeFun==null)throw new Error("Min:未设置移动判断函数");
			if(!_moveJudgeFun(_ddArray[currentLocation.x][currentLocation.y]) || !_moveJudgeFun(_ddArray[targetLocation.x][targetLocation.y]))return [];
			resetParameters(currentLocation,targetLocation);
			while(true){//循环,开放列表存在节点时
				if(_bmh){
					testPoint(_binaryHeap.getTop() as PathPoint);
				}else{
					_waitList.sortOn("_F",Array.NUMERIC);
					testPoint(_waitList[0]);
				}
				if(_finded){
					//trace("找到终点"+_targetPoint);
					findComplete();
					return _targetPoint.getWay().reverse();
				}
				if(_bmh){
					if(_binaryHeap.getTop()==null)break;
				}else{
					if(_waitList.length==0)break;
				}
			}
			findComplete();
			return [];
		}
		
		override protected function resetParameters(currentLocation:Point,targetLocation:Point):void{
			super.resetParameters(currentLocation,targetLocation);
			if(_bmh){
				_binaryHeap.clear();
				_binaryHeap.addToBMH(_startPoint);
			}else{
				_waitList=[_startPoint];//将起点加入开放列表
			}
		}
		
		override protected function testPoint(testPoint:PathPoint):void{
			if(_bmh){
				_binaryHeap.removeFromBMHByIndex(0);
			}else{
				_waitList.splice(0,1);
			}
			testPoint._wait=false;
			testPoint._moved=true;
			_finishList.push(testPoint);
			super.testPoint(testPoint);
		}
		
		override protected function testAroundPoint(testPoint:PathPoint,offsetX:int,offsetY:int):Boolean{
			var x:int=testPoint.x+offsetX;
			var y:int=testPoint.y+offsetY;
			if(x<_mapRectangle.x || x>(_mapRectangle.x+_mapRectangle.width-1)|| y<_mapRectangle.y ||y>(_mapRectangle.y+_mapRectangle.height-1)){
				return false;
			}
			var pFPoint:PathPoint=_pointsArr2D[x][y];
			var G:uint=(offsetX!=0 && offsetY!=0)?14:10;
			if(!pFPoint._moved){//不在关闭列表中
				if(!pFPoint._wait){//不在开放列表中
					if(_moveJudgeFun(_ddArray[pFPoint.x][pFPoint.y])){//该点可移动
						pFPoint._parentPoint=testPoint;//标记父坐标
						pFPoint._G=testPoint._G+G;
						pFPoint._F=pFPoint._G+(Math.abs(_targetPoint.x-pFPoint.x)+Math.abs(_targetPoint.y-pFPoint.y))*10;
						//pFPoint._F=pFPoint._G+Math.floor(Point.distance(_targetPoint,pFPoint)*10);
						if(pFPoint==_targetPoint){
							_finded=true;
						}else{
							pFPoint._wait=true;
							if(_bmh){
								_binaryHeap.addToBMH(pFPoint);//该点若不是终点,加入待测试数组
							}else{
								_waitList.push(pFPoint);
							}
						}
						return true;
					}
				}else{//在开放列表中
					if(pFPoint._G>(testPoint._G+G)){//如果该点移动代价小
						pFPoint._parentPoint=testPoint;
						pFPoint._G=testPoint._G+G;
						//pFPoint._F=pFPoint._G+Math.floor(Point.distance(_targetPoint,pFPoint)*10);
						pFPoint._F=pFPoint._G+(Math.abs(_targetPoint.x-pFPoint.x)+Math.abs(_targetPoint.y-pFPoint.y))*10;
						if(_bmh)_binaryHeap.changeFromBMH(pFPoint);
					}
					return true;
				}
			}
			return false;
		}
		override protected function findComplete():void{
			var arr:Array=_bmh?_binaryHeap.getArr():_waitList;
			for each(var point:PathPoint in arr){
				point._wait=false;
			}
			super.findComplete();
		}
	}
}