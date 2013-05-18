package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
	
	import astar.AStar;
	
	[SWF(width=1024,height=768)]
	public class AstarTest extends Sprite
	{
		private var _cellSize:int = 6;
		private var _numRow:int = 100;
		private var _numCols:int = 160;
		private var _tileContainer:Sprite;
		
		private var _lineShape:Shape;
		
		private var _map:Array;
		
		private var _astar:AStar;
		
		private var _stautsTextField:TextField;
		private var _timeTextfiled:TextField;
		
		public function AstarTest()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.color = 0x999999;
			
			_tileContainer = new Sprite();
			_tileContainer.cacheAsBitmap = true;
			_tileContainer.addEventListener(MouseEvent.CLICK,mouseClick);
			_tileContainer.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			_tileContainer.addEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
			_tileContainer.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			addChild(_tileContainer);
			
			_lineShape = new Shape();
			addChild(_lineShape);
			
			_stautsTextField = new TextField();
			_stautsTextField.autoSize = TextFieldAutoSize.LEFT;
			_stautsTextField.textColor = 0xffffff;
			_stautsTextField.text = "蓝色线:未优化路径,红色线:优化过的路径\n单击寻路\n按下鼠标移动添加障碍";
			_stautsTextField.y = 610;
			addChild(_stautsTextField);
			
			_timeTextfiled = new TextField();
			_timeTextfiled.autoSize = TextFieldAutoSize.LEFT;
			_timeTextfiled.textColor = 0xff0000;
			_timeTextfiled.text = "";
			_timeTextfiled.y = 650;
			addChild(_timeTextfiled);
			
			drawGrid(_numRow,_numCols);
			_astar = new AStar(_map,canMove);
		}
		
		private function canMove(value:int):Boolean{
			return value != 0;
		}
		
		
		private function drawGrid(numRows:int,numCols:int):void{
			_tileContainer.graphics.clear();
			_tileContainer.graphics.beginFill(0xffffff);
			_tileContainer.graphics.drawRect(0,0,numCols * _cellSize,numRows * _cellSize);
			_tileContainer.graphics.endFill();
			
			_map = [];
			
			var tile:Tile;
			for (var i:int = 0; i < numCols; i++) {
				var mapArray:Array = [];
				var num:int;
				for (var j:int = 0; j < numRows; j++) {
					num = Math.random() * 5;
					if(i == 0 && j == 0){
						num = 1;
					}
					
					mapArray.push(num);
					if(num == 0){
						tile = new Tile(_cellSize);
						tile.x = i * _cellSize;
						tile.y = j * _cellSize;
						_tileContainer.addChild(tile);
					}
				}
				_map.push(mapArray)
			}
		}
		
		private var _mouseDown:Boolean = false;
		private function mouseDown(e:MouseEvent):void{
			_mouseDown = true;
		}
		
		private function mouseMove(e:MouseEvent):void{
			if(!_mouseDown) return;
			
			var x:int = _tileContainer.mouseX / _cellSize;
			var y:int = _tileContainer.mouseY / _cellSize;
			if(_map[x][y] == 0) return;
			
			_map[x][y] = 0;
			_astar.setPointValue(x,y,0);
			
			var tile:Tile = new Tile(_cellSize);
			tile.x = _cellSize * x;
			tile.y = _cellSize * y;
			_tileContainer.addChild(tile);
			
		}
		
		private function mouseUp(e:MouseEvent):void{
			_mouseDown = false;
		}
		
		private function mouseClick(e:MouseEvent):void{
			
			var x:int = _tileContainer.mouseX / _cellSize;
			var y:int = _tileContainer.mouseY / _cellSize;
			if(x >= _numCols || y > _numRow){
				return;
			}
			
			var time:uint = getTimer();
			
			var path:Array = _astar.findPath(new Point(0,0),new Point(x,y));
			
			_timeTextfiled.text = "寻路耗时:" + (getTimer() - time + "  路径长度:" + path.length);
			
			var l:int = path.length;
			if(l == 0) return;
			
			var i:int;
			var p:Point = path[0];
			
			_lineShape.graphics.clear();
			_lineShape.graphics.lineStyle(1,0x0000ff);
			_lineShape.graphics.moveTo(p.x * _cellSize + _cellSize/2,p.y * _cellSize + _cellSize/2);
			
			for (i = 1; i < l; i++) {
				p = path[i];
				_lineShape.graphics.lineTo(p.x * _cellSize + _cellSize/2,p.y * _cellSize + _cellSize/2);
			}
			
			time = getTimer();
			
			path = _astar.getOptimizePath(path,true);
			
			_timeTextfiled.text += "\n优化耗时:" + (getTimer() - time + "  优化后路径长度:" + path.length);
			
			
			l = path.length;
			p = path[0];
			
			_lineShape.graphics.lineStyle(1,0xff0000);
			_lineShape.graphics.moveTo(p.x * _cellSize + _cellSize/2,p.y * _cellSize + _cellSize/2);
			
			for (i = 1; i < l; i++) {
				p = path[i];
				_lineShape.graphics.lineTo(p.x * _cellSize + _cellSize/2,p.y * _cellSize + _cellSize/2);
			}
			
		}
	}
}