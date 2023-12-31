/*
 * format - Haxe File Formats
 *
 *  WAVE File Format
 *  Copyright (C) 2009 Robin Palotai
 *
 * Copyright (c) 2009, The Haxe Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	- Redistributions of source code must retain the above copyright
 *	  notice, this list of conditions and the following disclaimer.
 *	- Redistributions in binary form must reproduce the above copyright
 *	  notice, this list of conditions and the following disclaimer in the
 *	  documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE HAXE PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE HAXE PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
package format.decode;

typedef WAVE = {
	header : WAVEHeader,
	data : haxe.io.Bytes,
	cuePoints : Array<CuePoint>
}

typedef WAVEHeader = {
	format : WAVEFormat,
	channels : Int,
	samplingRate : Int,
	byteRate : Int,		// samplingRate * channels * bitsPerSample / 8
	blockAlign : Int,	 // channels * bitsPerSample / 8
	bitsPerSample : Int
}

typedef CuePoint = {
	id : Int,
	sampleOffset : Int
}

enum WAVEFormat {
	WF_PCM;
}

