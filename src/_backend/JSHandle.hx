package _backend;

import _backend.Native;
import openfl.net.NetStream;
import openfl.net.NetConnection;
import openfl.events.NetStatusEvent;
import openfl.media.Video as Media;
import openfl.media.SoundTransform;
import openfl.media.Sound;
import openfl.events.Event;
import openfl.Lib;
#if lime
import lime.app.Application;
#end 
#if flixel
import flixel.FlxG;
#end

/** 
    hxWave JavaScript web handler!
    plays a media file with Audio Or Video codecs. 
    *see Native.hx for full format support*
    *additionaly see licensing for modifications*
**/

class JSHandle {
    public var src:Media;
    public var looping:Bool;
    public var playing:Bool;
    public var autoSize:Bool = true;
    public var preservesPitch:Bool = false;
    public var ext:String;

    @:isVar public var rate(get, set):Float = 1.0;
    @:isVar public var volume(get, set):Float = 1.0;
    
    private var _net:NetStream;
    private var _nc:NetConnection;
    private var _srcAVC:Bool;
    private var _AA:Bool; 
    private var _URL:String;
    private var _recur:Bool;
    private var _resize:Bool = true;
    private var _rate:Float = 1.0;
    private var _volume:Float = 1.0;
    private var _data:Bool;

    public function new()
	{
    }

    /**
	 * Creates a AdvancedAudioCodec or AdvancedVideoCodec for playback.

	 * @param Path Example: `your/media/here.mp4`
	 * @param Loop Loop the video.
	 */
	public function load(Path:String, ?loop:Bool = false, ?AA:Bool = true):Void
	{
        final _ext = Native.checkFormat(Path);
        ext = _ext;
        _AA = AA;
        _URL = Path;
        _recur = loop;
        _nc = new NetConnection();
		_nc.connect(null);
        _net = new NetStream(_nc);
		_net.client = {onMetaData: client_onMetaData};
        _nc.addEventListener("netStatus", netConnection_onNetStatus);
        Native.extAudio(_ext, true) ? initAAC() : initAVC(); // INIT the AdvancedAudioCodec or AdvancedVideoCodec.
        playing = !playing;
    }

    private inline function initAAC() {
        _net.play(_URL);
        @:privateAccess
		_net.__video.preservesPitch = preservesPitch;
        _net.speed = _rate;
    }

    private inline function initAVC() {
        src = new Media();
		src.x = 0;
		src.y = 0;
		src.smoothing = _AA;
        src.width = calcSize(0);
		src.height = calcSize(1);
        src.attachNetStream(_net);
        #if flixel
        FlxG.addChildBelowMouse(src);
        FlxG.stage.addEventListener(Event.ENTER_FRAME, _frame);
        #end
        _net.play(_URL);
        #if web
        @:privateAccess
		_net.__video.preservesPitch = preservesPitch;
        _net.speed = _rate;
        #end
    }

    @:noCompletion private function resize(?E:Event):Void
	{		
        autoSize ? _reload() : return;
	}
    /**
	 * Reloads the media context.
	 */
    private function _reload() {
		_net.pause();
        #if flixel
		FlxG.removeChild(src);
        #end
		src = new Media();
		src.x = 0;
		src.y = 0;
		src.smoothing = _AA;
		src.attachNetStream(_net);
		src.width = calcSize(0);
		src.height = calcSize(1);
        #if flixel
		FlxG.addChildBelowMouse(src);
        #end
		_net.resume();
	}

    private function _load() {
        src.attachNetStream(_net);
		src.width = calcSize(0);
		src.height = calcSize(1);
    }

    function client_onMetaData(path) {
        #if flixel
        _data = true;
		Lib.current.stage.addEventListener(Event.RESIZE, resize);
        #end
        _srcAVC ? _load() : return;
	}

    @:noCompletion function netConnection_onNetStatus(path) {
		if (path.info.code == "NetStream.Play.Complete") {
			if (_recur) {
                looping = !looping;
				_net.play(_URL);
			} else {
				dispose(); 
			}
		}
	}
    /** Disposes the media context. **/
    public function dispose() {
        #if flixel
		if (FlxG.game.contains(src)) {
			FlxG.game.removeChild(src);
		}
        if (Lib.current.stage.hasEventListener(Event.ENTER_FRAME))
			Lib.current.stage.removeEventListener(Event.ENTER_FRAME, _frame);

		if (Lib.current.stage.hasEventListener(Event.RESIZE))
			Lib.current.stage.removeEventListener(Event.RESIZE, resize);
        #end 
		if (src != null)
            src = null;
			_net.dispose();
	}

    @:noCompletion inline function get_rate() {
        return _rate;
    }

    @:noCompletion inline function set_volume(vol:Float) {
        _volume = vol;
        _net.soundTransform = new SoundTransform(_volume);
        return vol;
    }

    @:noCompletion inline function get_volume() {
        return _rate;
    }

    @:noCompletion inline function set_rate(speed:Float) {
        rate = speed;
        _rate = speed;
        return _net.speed = _rate;
    }

    @:noCompletion private function _frame(e:Event) {
        #if flixel
        if(FlxG.sound.muted) {
            volume = 0;
        }
        if(FlxG.sound.volume == _volume || FlxG.sound.muted) return;
        volume = FlxG.sound.volume;
        #end
    }
    /** Manually calculate the size of the media container window. 
        @param Ind Int the stageWidth or StageHeight 0,1
    **/
    public function calcSize(Ind:Int):Float
	{
		var stageWidth:Float = Lib.current.stage.stageWidth;
        var stageHeight:Float = Lib.current.stage.stageHeight;
        
        var appliedWidth:Float = stageHeight * (stageWidth / stageHeight);
        var appliedHeight:Float = stageWidth * (stageHeight / stageWidth);
        
        if (appliedHeight > stageHeight)
            appliedHeight = stageHeight;
        
        if (appliedWidth > stageWidth)
            appliedWidth = stageWidth;

		switch (Ind)
		{
			case 0:
				return appliedWidth;
			case 1:
				return appliedHeight;
		}

		return 0;
	}
}