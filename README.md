<h1> hxWave </h1>
<h3> A multiplatform media library built with HxCodecPlus and LibVLC++ </h3>

--------------------------

Designed to seamlessly integrate with Haxe, HaxeFlixel, OpenFL, and Lime

[libVLC](https://www.videolan.org/vlc/libvlc.html), allows hxWave to play many media codecs while streaming the data to haxe or playing directly in the window container. 

--------------------------

## Getting Started With HxWave!

### 1. Installing the library
You can install the library by running this command:
```
haxelib install hxWave
```

but if you wish to have the latest and greatest changes along with new upcoming features, run this instead:
```
haxelib git hxWave https://github.com/RapperGF/hxWave
```

### 2. Include the library
add it to the Project.xml file:
```xml
<haxelib name="hxWave" />
```

--------------------------

## Using HxWave

HxWave makes playing media types extremely easy!

### Audio
```hx
import wave.sound.Audio;
```
```hx
sound = new Audio(path);
sound.play();
```

### Video
```hx
import wave.video.Player;
```
```hx
container = new Player(path);
container.play();
```
### Haxe Flixel State Playback

HxWave has a special state included on the player class allowing playback as a cutscene in haxe flixel without importing anything extra!!
```hx
FlxG.switchState(new PlayerState('assets/video.mp4'));
```

--------------------------

## Extra Features!

HxWave has the ability to decode multiple formats through haxe.io Bytes. 

```hx
import _backend.format.MP3;
import _backend.format.RIFF4;
```

HxWave also can stream natively or with its respective handles. 
This means libVLC is not required for all stream handles. 

HxWave has the ability to play 16Bit, 24Bit or even 32Bit WAVE files.

HxWave can even playFiles in reverse!!

HxWave will expose the audio samples and bytes from channels so you can easily manipulate the data in real-time!

--------------------------

## Supported Formats. 

Currently supported formats are :

# VIDEO

| Format | Description | Stream (WEB) | Stream (WINDOWS) |
|---|---|---|---|
| MP4 | MPEG-4 Video | ☑ | ☑ |
| MP4V | MPEG-4 Visual | ☑ | ☑ |
| M4V | MPEG-4 Video | ☑ | ☑ |
| MKV | Matroska Video | ☑ | ☑ |
| MOV | QuickTime Video | ☑ | ☑ |
| WEBM | WebM Video | ☑ | ☑ |
| F4V | Flash Video | ☑ | ☑ |
| 3GP | 3GPP Multimedia | ☑ | ☑ |
| 3G2 | 3GPP2 Multimedia | ☑ | ☑ |
| OGV | Ogg Video | ☑ | ❌ |
| WMV | Windows Media Video | ❌ | ☑ |
| AVI | Audio Video Interleave | ❌ | ☑ |

# AUDIO 

| Format | Description | Stream (WEB) | Native (WEB) | Stream (WINDOWS) | Native (WINDOWS) |
|---|---|---|---|---|---|
| OGG | OGGS Header | ☑ | ☑ | ☑ | ☑ |
| MP3 | LAME ID3 | ☑ | ☑ | ☑ | ☑ |
| WAVE | PCM RAW  | ☑ | ☑ | ☑ | ☑ |
| RIFF | PCM RIFF | ☑ | ☑ | ☑ | ☑ |
| FLAC | FRAME SUBCHUNK | ☑ | ☑ | ☑ | ❌ |
| AAC | ADVANCED AUDIO CODEC | ☑ | ❌ | ☑ | ❌ |
| AC3 | ADVANCED CODEC | ☑ | ❌ | ☑ | ❌ |
| M4A | MPEG-4 Audio | ☑ | ❌ | ☑ | ❌ |
| WMA | Windows Media Audio | ❌ | ❌ | ☑ | ❌ |


--------------------------
