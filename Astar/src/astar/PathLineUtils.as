package astar{
	import flash.geom.Point;
	
	/**
	 * 路径工具
	 * @author J_Min
	 * <p>v1.0 2012.10.15:创建类</p>
	 */	
	public class PathLineUtils{
		/**
		 * 某点是否是顶点(不在另2点的连线上)
		 * @param point 测试点
		 * @param pointStart 起始点
		 * @param pointEnd 终点
		 * @return 该点是否在2个测试点的连线上
		 */
		public static function isPeak(point:Point,pointStart:Point,pointEnd:Point):Boolean{
			return (pointEnd.x-pointStart.x)/(pointEnd.y-pointStart.y)!=(point.x-pointStart.x)/(point.y-pointStart.y);
		}
		
		/**
		 * 获取2点经过的所有整数点
		 * @param n1 点1
		 * @param n2 点2
		 * @return 经过的点
		 */
		public static function getCrossPoint(point1:Point, point2:Point,crossBorder:Boolean=true):Array{
			//trace("\n"+point1+" > "+point2+"=========2点之间的整数点测试:\n");
			var i:uint;
			var len:uint;
			var pointArr:Array = [];
			var testSpeedX:int=point2.x>point1.x?1:-1;
			var testSpeedY:int=point2.y>point1.y?1:-1;
			
			var startX:int;
			var startY:int;
			
			if(point2.x==point1.x){
				startY=Math.min(point1.y,point2.y);
				len=Math.abs(point2.y-point1.y)+1;
				for(i=0;i<len;i++){
					pointArr.push(new Point(point1.x,startY+i));
				}
			}else if(point2.y==point1.y){
				startX=Math.min(point1.x,point2.x);
				len=Math.abs(point2.x-point1.x)+1;
				for(i=0;i<len;i++){
					pointArr.push(new Point(startX+i,point1.y));
				}
			}else{
				var ratio:Number=(point2.x-point1.x)/(point2.y-point1.y);
				if(ratio==1 || ratio==-1){
					len=Math.abs(point2.x-point1.x);
					for(i=0;i<len+1;i++){
						pointArr.push(new Point(point1.x+testSpeedX*i,point1.y+testSpeedY*i));
						
						if(!crossBorder && i<len){//无交点
							pointArr.push(new Point(point1.x+testSpeedX*i+testSpeedX,point1.y+testSpeedY*i));
							pointArr.push(new Point(point1.x+testSpeedX*i,point1.y+testSpeedY*i+testSpeedY));
						}
					}
				}else{
					//trace("非正常斜率情况");
					var lenX:uint=Math.abs(point2.x-point1.x);
					var lenY:uint=Math.abs(point2.y-point1.y);
					var preferX:Boolean=Math.abs(ratio)>1;
					startX=preferX?point1.x:point1.y;
					startY=preferX?point1.y:point1.x;
					
					var testSpeed:int=preferX?testSpeedX:testSpeedY;
					len=preferX?lenX:lenY;
					var testX:int;
					var testY:int;
					//trace("长边:"+len);
					//trace("起始:"+startX);
					//trace("斜率"+ratio);
					//trace("测试速度:"+testSpeed);
					for(i=0;i<len;i++){
						//trace("第"+(i+1)+"次计算");
						var f:Number=(preferX?((i+0.5)/ratio):((i+0.5)*ratio))*testSpeed;
						if(f is int){//是整数
							testY=startY+f;
							testX=startX+testSpeed*i;
							putPoint(testX,testY,pointArr,preferX);
							testX+=testSpeed;
							putPoint(testX,testY,pointArr,preferX);
						}else{
							if(f/0.5 is int){//检查是否是0.5的倍数,是的话说明穿过了像素交界点,根据是否可穿斜角来判断是使用4个点还是0个点
								if(crossBorder){//无交点
									//trace("穿过一个交点,穿过");
								}else{//4交点
									//trace("穿过一个交点,纳入");
									testY=Math.floor(startY+f);
									testX=startX+testSpeed*i;
									putPoint(testX,testY,pointArr,preferX);
									
									var tY:int=Math.ceil(startY+f);
									putPoint(testX,tY,pointArr,preferX);
									
									testX+=testSpeed;
									putPoint(testX,tY,pointArr,preferX);
									
									putPoint(testX,testY,pointArr,preferX);
								}
							}else{
								if(f>0){
									testY=Math.floor(startY+f+0.5);
								}else{
									testY=Math.ceil(startY+f-0.5);
								}
								//每个节点表示2个像素的焦点,将这2个像素加入数组
								testX=startX+testSpeed*i;
								//trace("测试:"+testX+","+testY);
								putPoint(testX,testY,pointArr,preferX);
								testX+=testSpeed;
								putPoint(testX,testY,pointArr,preferX);
							}
						}
					}
				}
			}
			//trace(pointArr);
			return pointArr;
		}
		
		private static function putPoint(putX:int,putY:int,pointArr:Array,preferX:Boolean):void{
			var x:int=preferX?putX:putY;
			var y:int=preferX?putY:putX;
			if(!inLine(x,y,pointArr))pointArr.push(new Point(x,y));
		}
		
		/**检查点是否存在于数组中*/
		private static function inLine(testX:int,testY:int,line:Array):Boolean{
			for each(var testPoint:Point in line){
				if(testPoint.x==testX && testPoint.y==testY){
					return true;
				}
			}
			return false;
		}
		
		
		
		/**
		 * @param 
		 * @return 顶点数组(包含起始点和终点)
		 */
		/**
		 * 获取一条路径上的所有顶点(包含起点终点)
		 * @param path path 路径数组
		 * @param comparator 比较函数,返回布尔值
		 * @param params 比较函数参数
		 * @return 
		 * 
		 */		
		public static function getPeaksInLine(path:Array,comparator:Function):Array{
			var peakArr:Array=[];
			if(!path || path.length<2)return peakArr;
			var len:int=path.length;
			if(len>1){
				for(var i:uint=1;i<len-1;i++){
					if(comparator!=null){
						if(comparator(path[i])==true && PathLineUtils.isPeak(path[i],path[i-1],path[i+1]))peakArr.push(path[i]);
					}else if(PathLineUtils.isPeak(path[i],path[i-1],path[i+1])){
						peakArr.push(path[i]);
					}
				}
				peakArr.unshift(path[0]);
				peakArr.push(path[path.length-1]);
			}else{
				throw new Error("Min:参数错误");
			}
			//trace("获得顶点数组"+peakArr.length+":"+peakArr);
			return peakArr;
		}
		
		/**
		 * 获得路径长度
		 * @param pathArr
		 * @return
		 */
		public static function getPathLength(pathArr:Array):Number{
			var loopLength:int=pathArr.length;
			var len:Number=0;
			if(loopLength>1){
				for(var i:uint=1;i<=loopLength;i++){
					if(pathArr[i] is Array){
						len+=Point.distance(new Point(pathArr[i][0],pathArr[i][1]),new Point(pathArr[i-1][0],pathArr[i-1][1]));
					}else if(pathArr[i] is Point){
						len+=Point.distance(pathArr[i],pathArr[i-1]);
					}
				}
			}
			return len;
		}
	}
}