package uhx.tuli.plugins;

import geo.TzDate;
import haxe.Json;
import uhx.sys.*;
import uhx.tuli.plugins.impl.t.Details;
import uhx.tuli.util.File;
import utest.Assert;
import uhx.tuli.plugins.Atom;

using Detox;
using StringTools;
using haxe.io.Path;
using uhx.tuli.util.File.Util;

/**
 * ...
 * @author Skial Bainn
 */
class AtomSpec {
	
	public var feed:String;
	public var entry:String;
	public var global:Tuli.Config;
	public var tuli:Tuli;
	public var plugin:Atom;
	public var files:Array<File>;

	public function new() {
		feed = '<?xml version="1.0" encoding="utf-8" ?>
<feed xmlns="http://www.w3.org/2005/Atom">
	<id></id>
	<title></title>
	<updated></updated>
	<link rel="" href="" />
	<author>
		<name></name>
	</author>
	<contributor>
		<name></name>
	</contributor>
</feed>';
		entry = '<entry>
	<id></id>
	<title></title>
	<published></published>
	<updated></updated>
	<author>
		<name></name>
	</author>
	<contributor>
		<name></name>
	</contributor>
	<summary></summary>
	<content></content>
</entry>';
		
		global = {
			input: '/',
			output: '/',
			ignore: [],
			plugins: [],
			data: {
				site: {
					authors: ['Skial Bainn', 'Fake Bainn'],
					contributors: ['C. Trib 1', 'C. Trib 2'],
					domain: 'http://haxe.io/',
					title: 'Fake Title'
				}
			}
		}
		
		var cf = new File( '' );
		cf.content = Json.stringify( global );
		tuli = cast createFakeTuli( global );
		
		plugin = new Atom( tuli, { feed:'', entry:'' } );
		untyped plugin.feed = cast createFakeFile( 'feed.xml' );
		untyped plugin.feed.content = feed;
		
		untyped plugin.entry = cast createFakeFile( 'entry.xml' );
		untyped plugin.entry.content = entry;
		
		var d = TzDate.now();
		files = [for (i in 0...10) {
			var c:File = cast createFakeFile( '/$i.md' );
			var s:File = cast createFakeFile( '/$i.html' );
			s.content = c.content = '<main><h1>Title $i</h1><p>Content body $i</p></main>';
			(s.data:Details).title = (c.data:Details).title = 'Title $i';
			(s.data:Details).summary = (c.data:Details).summary = 'Content body $i';
			if (i % 2 == 1) (s.data:Details).authors = (c.data:Details).authors = [for (x in 0...i) 'A. Uthor $x'];
			else (s.data:Details).contributors = (c.data:Details).contributors = [for (x in 0...i) 'C. Trib $x'];
			s.created = s.modified = c.created = c.modified = d -= new geo.units.Hours(10.0 - i);
			c.spawned.push( '/$i.html' );
			tuli.spawn.push( s );
			c;
		}];
	}
	
	public function createFakeTuli(config:Tuli.Config) {
		return {
			files: ([]:Array<File>),
			spawn: ([]:Array<File>),
			config: config,
			secrets: { },
			onAllFiles:function(callback:Array<File>->Array<File>, ?when:Tuli.State) { },
			onExtension:function(extension:String, callback:File-> Void, ?when:Tuli.State) { },
			onData:function(callback:Dynamic->Dynamic, ?when:Tuli.State) { },
			onFinish:function(callback:Void->Void, ?when:Tuli.State) { },
			start:function() { },
			finish:function() { },
			asISO8601:function(d:Date):String return '',
			isNewer:function(a:File, b:File):Bool return false,
		}
	}
	
	public function createFakeFile(path:String) {
		path = path.normalize();
		return {
			path: path,
			content: '',
			data: { },
			spawned: [],
			ext: path.extension(),
			name: path.withoutExtension().withoutDirectory(),
			ignore: false,
			fetched: true,
			created: TzDate.now(),
			modified: TzDate.now(),
			get_content: function() return untyped __this__.content,
			get_created: function() return untyped __this__.created,
			get_modified: function() return untyped __this__.modified,
			set_content: function(v:String) return untyped __this__.content = v,
			set_created: function(v:TzDate) return untyped __this__.created = v,
			set_modified: function(v:TzDate) return untyped __this__.modified = v,
			get_fetched: function() return true,
		}
	}
	
	public function testAtom_default() {
		var output = plugin.handler( files.copy() );
		trace( output.map( function(s) return s.path ) );
		Assert.isTrue( output.exists( '//atom.xml' ) );
		
		if (output.exists( '//atom.xml' )) {
			var atom = output.get( '//atom.xml' ).content;
			trace( atom );
			var dom = atom.parse();
			
			// The first `<entry> > <updated>` field should match with `<feed> > <updated>` field value.
			Assert.equals( dom.find( 'feed > updated' ).text(), dom.find( 'feed > entry' ).first().find( 'entry > updated' ).text() );
			
			// There should be 10 entries.
			Assert.equals( 10, dom.find( 'feed > entry' ).length );
			
			// There should be 2 `<author>` entries in `<feed>`.
			Assert.equals( 2, dom.find( 'feed > author' ).length );
			
			// Site authors should match atom.xml feed authors.
			Assert.equals( '' + global.data.site.authors, '' + [for (d in dom.find( 'feed > author > name' )) d.text()] );
			
			// Site contributes should match atom.xml feed contributors.
			Assert.equals( '' + global.data.site.contributors, '' + [for (d in dom.find( 'feed > contributor > name' )) d.text()] );
			
			// Should be `Fake Title`.
			Assert.equals( global.data.site.title, dom.find( 'feed > title' ).text() );
		}
		
	}
	
}