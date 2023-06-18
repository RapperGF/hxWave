package _backend;

#if sys
import sys.FileSystem;
#end
#if cpp 
//import hxcodecplus.format.MP3;
//import hfft.MiniMP3 as MP3;
#end 
import _internal.Native;
//import format.decode.*;
//import format.RIFF4;
import openfl.media.Sound;
import lime.media.AudioBuffer;
import openfl.utils.ByteArray;
import haxe.io.BytesInput;
import haxe.io.Bytes;

enum Compression {
	PCM;
	FILE;
}

class NativeCodec {

	public static inline function OGGS(data:Bytes, ?_pitch:Float=1) {
		return AudioBuffer.fromBytes(data);
		//return compressedBuffer(data);
	}

	public static inline function getContainer(path:String) {
		ByteArray.loadFromFile(path).onComplete(function(s)) {
			
		}
	}
}