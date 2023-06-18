/**
 * hxWave *Powered by Hxcodec!*
 * This library handles many media formats with the added ability of streaming, pitch modulation and decoding. 
 * Copyright (C) 2023 RapperGF.
 * 
 * Permision is hereby granted through This codebase and its subsidaries allowed use
 * Released under the Mozilla Public License Version 2.0.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	- Redistributions of source code must retain the above copyright
 *	  notice, this list of conditions and the following disclaimer.
 *	- Redistributions in binary form must reproduce the above copyright
 *	  notice, this list of conditions and the following disclaimer in the
 *	  documentation and/or other materials provided with the distribution.
 * 
 * 	Mozilla Public License Version 2.0
 *	==================================
 * 
 * - Supported Platforms -
 * 		    WEB
 * 		  WINDOWS
 * 		   Linux
 * 		  Android 
 * 
 * - Current Limitations -
 * 	 - Web playback can not get samplerates or byte data.
 *   - Pitching on web is only on flixel 5.0.0 +
 * 
 * *see complete format support below*
 * *be sure to checkout hxcodec! - https://github.com/polybiusproxy/hxCodec*
 */

package _backend;

#if sys
import sys.FileSystem;
#end
import lime.app.Application;
import lime.app.Future;
import flixel.FlxG;

 enum Context {
	NATIVE;
	WEB;
	// TODO: add mobile support!?
}

class Native {
    // Version + Headers // 
    public static final VLC_VERSION = "2.2.x";
	public static final VERSION = "1.0";
	public static final LIB = "hxWave";
	#if !web
	public static final _CONTEXT = Context.NATIVE;
	public static final HEADER = ["OGG", "MP3", "WAV"];
	public static final VIDEO_HEADER = ["MP4", "MP4V", "M4V", "MKV", "MOV", "WEBM", "F4V", "3GP", "3G2", "WMV", "AVI"]; // All Supported Native Video Formats
	public static final AUDIO_HEADER = ["MP3", "WAV", "OGG", "FLAC", "AAC", "AC3", "M4A", "WMA", "MPG"]; // All Supported Native Audio Formats
	#else
	public static final _CONTEXT = Context.WEB;
	public static final VIDEO_HEADER = ["MP4", "MP4V", "M4V", "MKV", "MOV", "WEBM", "F4V", "3GP", "3G2", "OGV"]; // All Supported HTML5 Video Formats
	public static final AUDIO_HEADER = ["MP3", "WAV", "OGG", "FLAC", "AAC", "AC3", "M4A",]; // All Supported HTML5 Audio Formats
	public static final HEADER = ["OGG", "MP3", "WAV", "FLAC"];
	#end
	public static final ERROR = ["[Load_Error]","[Context_Error]", "[Unsupported_Error]"];
	public static final ERR = 'Context Failed to Load! : \n';

    public static inline function exists(path:String):Bool {
		var b:Bool = false;
		#if sys
		if (sys.FileSystem.exists(path)) {
			b = true;
		}
		#else
		if (lime.utils.Assets.exists(path)) {
			b = true;
		}
		#end
		if(!b) {
			log("Failed to Locate Format : " + checkFormat(path) + "\n FILE: " + path, ERROR[0]);
		}
		return b;
	}

    public static inline function checkFormat(path:String) {
		final index = path.lastIndexOf("."); // Added support for paths with extra dots.
		final EXT = index != -1 ? path.substr(index + 1) : null;
		return EXT.toUpperCase();
	}
	/**
	 * Checks if the format header contains Audio
	 * @param f the extension.
	 * @param checkAll checks all streamable formats with native formats.
	 * @return true or false if this header contains Audio.
	 */
	public static inline function extAudio(f:String, ?checkAll:Bool = false) { // TODO: Use Enums for Formats.
		@:privateAccess
		final header = checkAll ? AUDIO_HEADER.indexOf(f) : HEADER.indexOf(f);
		if (header > -1)
			return true;
		return false;
	}
	/**
	 * Checks if the format header contains video
	 * @param f the extension.
	 * @return true or false if this header contains video.
	 */
	public static inline function extVideo(f:String) { // TODO: Use Enums for Formats.
		@:privateAccess
		final header = VIDEO_HEADER.indexOf(f);
		if (header > -1)
			return true;
		return false;
	}

	public static function calcSize(Ind:Int):Int
	{
		var appliedWidth:Float = FlxG.stage.stageHeight * (FlxG.width / FlxG.height);
		var appliedHeight:Float = FlxG.stage.stageWidth * (FlxG.height / FlxG.width);

		if (appliedHeight > FlxG.stage.stageHeight)
			appliedHeight = FlxG.stage.stageHeight;

		if (appliedWidth > FlxG.stage.stageWidth)
			appliedWidth = FlxG.stage.stageWidth;

		switch (Ind)
		{
			case 0:
				return Std.int(appliedWidth);
			case 1:
				return Std.int(appliedHeight);
		}

		return 0;
	}
    /**
	 * Alerts the system user abt important messages
	 * @param text the text to display
	 * @param title the title to use.
	 */
	public static function log(text:String, title:String) {
		Application.current.window.alert(text, LIB + " " + title);
	}
}