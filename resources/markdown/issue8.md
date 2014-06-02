Some pointless text ending with a carriage and newline.

```Haxe
@:include("string")
@:structAccess		//	Marks an extern class as using struct access(".") not pointer("->").
@:unreflective		//	Avoids generating dynamic accessors.
@:native("std::string")
extern class StdString {
	@:native("new std::string")
	public static function create(inString:String):cpp:Pointer<StdString>;
	public function size():Int;
	public function find(str:String):Int;
}

class Main {
	
	public static function main() {
		var std = StdString.create("my std::string");
		trace( std.value.size() );
		std.destroy();
	}
}
```

Another pointless text.