package wave.sound;

import lime.media.AudioBuffer as Buffer;
import openfl.media.SoundChannel as Channel;
import openfl.media.SoundTransform as Volume;
import openfl.media.Sound;
import openfl.utils.ByteArray;
import _backend.JSHandle;
//import _backend.NativeCodec;
import haxe.io.Bytes;

enum Compression {
	FILE;
	RAW;
}
typedef Handle = #if web JSHandle #else NativeHandle #end;

class Audio extends Sound {

	public var channel:Channel;
	public var src:Sound;
	public var buffer:Buffer;
	public var ext:String;
	public var pitch:Float = 1.0;
	public var data:Bytes;

	private var encoding:Compression = RAW;
	private var thread:Bool = false;
	private var stream:Handle;
	private var _stream:Bool;
	private var _url:String;

	override public function new(?path:String, ?sound:Sound, ?__stream:Bool=false, ?pitch:Float = 1.0) {
        if(path != null && !__stream) {
            _load(path, pitch);
        } 
        if(sound!=null)
           src = sound; 

		if(__stream) {
			_url = path;
			stream = new Handle();
			_stream = __stream;
		}
        super();
    }

	public function _load(path:String, pitch:Float) {
		loadWEB(path);
		src = new Sound();
		//bytes = NativeCodec.getContainer(path);
		//src = NativeCodec.loadContainer(path, pitch);
	}

	public override function play(startTime:Float = 0.0, loops:Int = 0, sndTransform:Volume = null) {
		if(_stream) {
			//stream.rate = 1.2;
			stream.load(_url);
			stream.rate = 1.2;
		}

		return channel = buffer == null ? super.play(startTime, loops, sndTransform) : src.play(startTime, loops, sndTransform);
		//channel = src.play(startTime, loops, sndTransform);
		//channel.pitch = 0.5;		
	}

	public inline function loadWEB(path:String) {
		switch(encoding) {
			case RAW:
				ByteArray.loadFromFile(path).onComplete(function(s) {
					buffer = Buffer.fromBytes(s);
					src = Sound.fromAudioBuffer(buffer);
					play();
				});
			case FILE:
				Buffer.loadFromFile(path).onComplete(function(s) {
					buffer = s;
					src = Sound.fromAudioBuffer(buffer);
					play();
				});
		}
	}

	/*public function _load(path:String, ?pitch:Float = 1)
	{
		final split = path.split('.');
		final EXT = split[1].toUpperCase();

		switch (EXT) {
			case "OGG":
				Native.load(path,pitch)
				//loadOGG(path, pitch);
		}
		ext = EXT;
    }*/
}

