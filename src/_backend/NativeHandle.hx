package _backend;

#if !web
import cpp.NativeArray;
import cpp.UInt8;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;
import openfl.geom.Rectangle;
import openfl.display3D.textures.RectangleTexture;
import openfl.display3D.textures.Texture;
import openfl.utils.ByteArray;
import openfl.errors.Error;
import openfl.events.Event;
import haxe.io.Bytes;
import haxe.io.Path;
import LibVLC;


@:cppFileCode("#include <LibVLC.cpp>")

class NativeHandle extends Bitmap {

    public var initComplete:Bool = false;
    public var rate:Float = 1.0;
    private var libvlc:LibVLC = LibVLC.create();
    //private var bufferMemory:Array<UInt8> = [];
    private var pixels:Array<UInt8> = [];
    private var bytes:ByteArray;
   // private var bytes:Bytes;
	private var _bitmapData:BitmapData;
    private var deltaTime:Float = 0;
    private var oldTime:Float = 0;
    private var _elem:Int;
    private var _width:Null<Float>;
	private var _height:Null<Float>;
    private var audio:Bool;
   
	public var videoHeight(get, never):Int;
	public var videoWidth(get, never):Int;
    public var onReady:Void->Void = null;

	public function new() {
        super(bitmapData, AUTO, true);
        flixel.FlxG.addChildBelowMouse(this);
    }

    public function load(path:String, ?loop:Bool, ?pitch:Float = 1.0) {
        final url = Path.normalize(path);
        final _ext = Native.checkFormat(url);
        Native.extAudio(_ext, true) ? initAAC(url) : initAVC(url);
    }

    private function onInit() {
        final vWidth:Int = Std.int(libvlc.getWidth());
        final vHeight:Int = Std.int(libvlc.getHeight());

        //_elem = (1920 * 1080)*4;
        if(vWidth == 0 || vHeight == 0)
            return;
        
        _elem = (videoWidth * videoHeight)*4;
        bytes = Bytes.alloc(_elem);
        trace(vWidth, vHeight);
        bitmapData = new BitmapData(vWidth, vHeight, false, 0);
    }

    private function initAAC(url:String) {
        audio = true;
        new lime.app.Future(() ->
		{
            libvlc.playFile(createUrl(url), false, false, 1.0);
        });
        promise_resize();
        openfl.system.System.gc();
    }

    private function initAVC(url:String) {
        audio = false;
        new lime.app.Future(() ->
		{
            libvlc.playFile(createUrl(url), false, false, 1.0);
        });
        promise_resize();
        Lib.current.stage.addEventListener(Event.RESIZE, resize);
        openfl.system.System.gc();

    }

    function promise_resize ():lime.app.Future<String> {

		var promise = new lime.app.Promise<String> ();
	
		var progress = 0, total = 10;
		var timer = new haxe.Timer (10);
		timer.run = function () {
	
			promise.progress (progress, total);
			progress++;
	
			if (progress == total) {
	
				//resize();
				set_height(flixel.FlxG.stage.stageHeight);
                set_width(flixel.FlxG.stage.stageHeight * (16 / 9));
				promise.complete ("Done!");
				timer.stop ();
	
			}
	
		};
		return promise.future;
	}

    @:noCompletion
    private override function __enterFrame(elapsed:Int):Void {
        checkFlags();

        deltaTime += elapsed;

        if(_elem <= 0 || audio)
            return;

        // NativeArray.setUnmanagedData(pixels, libvlc.getPixelData(), (_elem));
        pixels = libvlc.getPixelData().toUnmanagedArray(_elem);
        bytes = pixels;

        bitmapData.image.buffer.data.buffer = bytes;//Bytes.ofData(pixels);
        (Math.abs(deltaTime - oldTime) <= 23) ? oldTime = deltaTime : bitmapData.image.version++;
        __setRenderDirty();
    }

    private function resize(?E:Event):Void
	{
		set_height(Lib.current.stage.stageHeight);
		set_width(Lib.current.stage.stageHeight * (16 / 9));
	}
    

    private override function get_height():Float
	{
		return _height;
	}

	public override function set_height(value:Float):Float
	{
		_height = value;
		return super.set_height(value);
	}

    

    @:noCompletion private function get_videoHeight():Int
	{
		if (libvlc != null) return libvlc.getHeight();

		return 0;
	}

	@:noCompletion private function get_videoWidth():Int
	{
		if (libvlc != null) return libvlc.getWidth();

		return 0;
	}

    

    private function createUrl(FileName:String):String
	{
		#if android
		return Uri.fromFile(FileName);
		#elseif linux
		return 'file://' + Sys.getCwd() + FileName;
		#elseif (windows || mac)
		return 'file:///' + Sys.getCwd() + FileName;
		#end
	}


	private function checkFlags():Void
	{
		/*if (untyped __cpp__('libvlc -> flags[8]') == 1)
		{
			untyped __cpp__('libvlc -> flags[8] = -1');

			if (!initComplete) onInit();

		}*/

       if (untyped __cpp__('libvlc -> flags[9]') == 1)
		{
			untyped __cpp__('libvlc -> flags[9] = -1');

			if (!initComplete) onInit();

		}
		
	}
}
#end
