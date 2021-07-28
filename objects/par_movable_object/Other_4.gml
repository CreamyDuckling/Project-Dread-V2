/// @description Sets Position to Stored Values

var _objectData = global.movableObjectPos[? objectKey];
if (!is_undefined(_objectData)){
	x = _objectData[X];
	y = _objectData[Y];
}