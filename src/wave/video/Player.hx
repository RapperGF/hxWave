package wave.video;
import _backend.JSHandle;
import _backend.NativeHandle;
import haxe.io.Path;

#if flixel
import flixel.FlxState;
#end 

typedef Handle = #if web JSHandle #else NativeHandle #end;
/** 
    hxWave player class plays media with the multiplatform handle statically or non statically 
    with the added ability to switch to a new state on haxe flixel using PlayerState.
    *see Native.hx for a list of supported formats*
**/
class Player extends Handle {

    public var url:String; 

    public function new(path:String) {
        url = path;
        super();
    }   
    /**
    *    plays the media.
    */
    public function play() {
        final url:String = Path.normalize(url);
        load(url);
    }
    /**
    *    Loads and plays the media statically returning a context.
    *    @param: path String.
    */
    public static function loadMedia(path:String) {
        var ctx:Handle;
        #if web
        ctx = new JSHandle();
        #else
        ctx = new NativeHandle();
        #end
        ctx.load(path);
        return cast ctx;
    }
}

#if flixel
class PlayerState extends FlxState {

    public var handle:Handle;
    public var url:String;

    public function new(path:String) {
        url = path;
        super();
    }   
    /**
        plays the media in a new state.
    **/
    public function play() {
        final url:String = Path.normalize(url);
        handle = new Handle();
        handle.load(url);
    }
    /** statically load the media from a new state **/
    public static function loadMedia(path:String) {
        var ctx:Handle;
        #if web
        ctx = new JSHandle();
        #else
        ctx = new NativeHandle();
        #end
        ctx.load(path);
        return cast ctx;
    }
    /** creates the handle and plays it statically. **/
    override public function create():Void {
        handle = loadMedia(url);
        super.create();
    }
}
#end