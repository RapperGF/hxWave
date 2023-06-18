package format;

import haxe.io.Bytes;
import haxe.io.BytesOutput;

class RIFF4
{
	static public function encodeWAV(buffer:Bytes, sampleCount:Int, sampleRate:Int, channels:Int):Bytes
	{
		var nbit:Int = 16;
		var FORMAT_PCM:Int = 1;
		var nbyte:Int = Std.int(nbit / 8);

		var bo = new BytesOutput();
		bo.writeString("RIFF");
		bo.writeInt32(36 + (sampleCount));
		bo.writeString("WAVE");
		bo.writeString("fmt ");
		bo.writeInt32(16);
		bo.writeInt16(FORMAT_PCM);
		bo.writeInt16(channels);
		bo.writeInt32(sampleRate);
		bo.writeInt32(sampleRate * nbyte);
		bo.writeInt16(nbyte);
		bo.writeInt16(nbit);
		bo.writeString("data");
		bo.writeInt32(sampleCount);
		bo.writeBytes(buffer, 0, sampleCount);
		return bo.getBytes();
	}
}
