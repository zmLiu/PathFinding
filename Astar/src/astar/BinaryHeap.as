package astar{
	/**
	 * 二叉堆
	 */	
	public class BinaryHeap{
		private var _attributeName:String;
		private var _arr:Array;
		private var _min:Boolean;
		
		/**
		 * 新建二叉堆
		 * @param attributeName 用于堆排序的属性名
		 * @param min 最小堆或最大堆
		 */
		public function BinaryHeap(attributeName:String,min:Boolean=true){
			_arr=[];
			_attributeName=attributeName;
			_min=min;
		}
		
		/**获取堆头*/
		public function getTop():Object{
			return _arr[0];
		}
		/**获取堆数组*/
		public function getArr():Array{
			return _arr;
		}
		
		/**是否包含元素*/
		public function hasElement(element:Object):Boolean{
			return _arr.indexOf(element)>=0;
		}
		
		/**清空堆*/
		public function clear():void{
			_arr=[];
		}
		
		/**添加元素至二叉堆*/
		public function addToBMH(element:Object):void{
			_arr.push(element);
			bHUp(_arr.length-1);
		}
		
		/**从二叉堆中删除元素*/
		public function removeFromBMH(element:Object):void{
			var index:int=_arr.indexOf(element);
			removeFromBMHByIndex(index);
		}
		public function removeFromBMHByIndex(index:int):void{
			if(index>=_arr.length || index<0)return;
			if(index==_arr.length-1){
				_arr.pop();
			}else{
				_arr[index]=_arr.pop();//将末端覆盖要删除的元素;
				bHDown(index);
			}
		}
		
		/**重排二叉堆中的某个元素*/
		public function changeFromBMH(element:Object):void{
			var index:int=_arr.indexOf(element);
			var self:Object=_arr[index];
			if(!self)return;
			var selfIndex:int=index+1;
			var parentId:int=Math.floor(selfIndex/2);
			var parent:Object=_arr[parentId-1];
			if(parent && parent[_attributeName]>self[_attributeName]){//有父节点且比父节点小 上滤
				bHUp(index);
			}else{//尝试下滤
				bHDown(index);
			}
		}
		
		/**二叉堆下滤
		 * @param index 元素所在数组的索引
		 */
		private function bHDown(index:int):void{
			var selfIndex:int=index+1;
			do{
				var self:Object=_arr[selfIndex-1];
				if(!self)break;
				var childIndex:int=selfIndex*2;
				var child1:Object=_arr[childIndex-1];//当前测试点的左节点
				var child2:Object=_arr[childIndex];//当前测试点的右节点
				if(child2 && child2[_attributeName]<child1[_attributeName]){//有右节点,且更小
					if(child2[_attributeName]<self[_attributeName]){//如果右节点小,置换
						_arr[childIndex]=self;
						_arr[selfIndex-1]=child2;
						selfIndex=childIndex+1;
					}else{
						break;
					}
				}else if(child1 && child1[_attributeName]<self[_attributeName]){//跟左节点比较,如果左节点小,置换
					_arr[selfIndex-1]=child1;
					_arr[childIndex-1]=self;
					selfIndex=childIndex;
				}else{
					break;
				}
			}while(true);//有右节点(一定有左节点),或有左节点(没有右节点)
		}
		
		/**
		 * 二叉堆上滤
		 * @param index 元素所在数组的索引
		 */
		private function bHUp(index:int):void{
			var selfIndex:int=index+1;
			do{
				var self:Object=_arr[selfIndex-1];
				if(!self)break;
				var parentId:int=Math.floor(selfIndex/2);
				var parent:Object=_arr[parentId-1];
				if(parent && parent[_attributeName]>self[_attributeName]){//父节点大,交换
					_arr[parentId-1]=self;
					_arr[selfIndex-1]=parent;
					selfIndex=parentId;
				}else{
					break;
				}
			}while(true);
		}
		
	}
}