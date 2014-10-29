(function () { "use strict";
var console = (1,eval)('this').console || {log:function(){}};
var Main = function() {
	var a = null;
	var b = null;
	console.log((function($this) {
		var $r;
		var a1;
		if(a != null) a1 = a; else a1 = b;
		$r = a1 != null?a1:"woot";
		return $r;
	}(this)));
};
Main.main = function() {
	new Main();
};
var _Main = {};
_Main.N_Impl_ = {};
_Main.N_Impl_._new = function(v) {
	return v;
};
_Main.N_Impl_.toBool = function(this1) {
	return this1 != null;
};
_Main.N_Impl_.or = function(a,b) {
	if(a != null) return a; else return b;
};
Main.main();
})();
