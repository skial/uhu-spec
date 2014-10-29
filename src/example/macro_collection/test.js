(function () { "use strict";
var console = (1,eval)('this').console || {log:function(){}};
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var Helper = function() { };
var Main = function() {
	new A();
	console.log(Helper.values);
};
Main.main = function() {
	new Main();
};
var Builder = function() { };
var A = function() {
	this.a = "a";
};
A.__interfaces__ = [Builder];
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
var D = function() {
	this.d = "d";
	C.call(this);
};
D.__super__ = C;
D.prototype = $extend(C.prototype,{
});
Helper.values = ["1","2","3","4"];
A.__meta__ = { fields : { a : { f : ["1"]}}};
B.__meta__ = { fields : { b : { f : ["2"]}}};
C.__meta__ = { fields : { c : { f : ["3"]}}};
D.__meta__ = { fields : { d : { f : ["4"]}}};
Main.main();
})();
