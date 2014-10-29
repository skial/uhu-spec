(function () { "use strict";
var console = (1,eval)('this').console || {log:function(){}};
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var Main = function() {
	var c = new C();
	var tc = new C();
	switch(tc.c) {
	case "c":
		switch(tc.b) {
		case "b":
			switch(tc.a) {
			case "a":
				console.log("correct");
				break;
			default:
				console.log("bugger");
			}
			break;
		default:
			console.log("bugger");
		}
		break;
	default:
		console.log("bugger");
	}
};
Main.main = function() {
	new Main();
};
var A = function() {
	this.a = "a";
};
var B = function() {
	this.b = "b";
	A.call(this);
};
B.__super__ = A;
B.prototype = $extend(A.prototype,{
});
var C = function() {
	this.c = "c";
	B.call(this);
};
C.__super__ = B;
C.prototype = $extend(B.prototype,{
});
Main.main();
})();
