package {
	
	import flash.display.*;
	import flash.media.*;
	import sfx.*;
	
	public class SoundHandler {
		
		public static var titleMUS:Sound;
		public static var game1MUS:Sound;
		public static var game2MUS:Sound;
		public static var game3MUS:Sound;
		public static var armor1SND:Sound;
		public static var armor2SND:Sound;
		public static var bowFireSND:Sound;
		public static var hit1SND:Sound;
		public static var hit2SND:Sound;
		public static var hit3SND:Sound;
		public static var hit4SND:Sound;
		public static var hit5SND:Sound;
		public static var hit6SND:Sound;
		public static var ice1SND:Sound;
		public static var ice2SND:Sound;
		public static var ice3SND:Sound;
		public static var flesh1SND:Sound;
		public static var flesh2SND:Sound;
		public static var flesh3SND:Sound;
		public static var levelUpSND:Sound;
		public static var thunderClapSND:Sound;
		public static var wallCrumble1SND:Sound;
		public static var buySND:Sound;
		public static var clickSND:Sound;
		public static var startWaveSND:Sound;
		public static var waveDoneSND:Sound;
		public static var deathSND:Sound;
		//public static var deathMUS:Sound;
		
		public static var musicChannel:SoundChannel;
		public static var playingMusic:String = "none";
		public static var playingMusicO:Sound;
		public static var SOUNDS_LOADED:Boolean = false;
		
		public function SoundHandler() {}
		public static function playSound(_sound:String) {
			SoundHandler[_sound + "SND"].play();
			return;
		}
		public static function playMusic(_sound:String) { trace(playingMusic);
			if(playingMusic != _sound) {
				if(playingMusic != "none") musicChannel.stop();
				musicChannel = SoundHandler[_sound + "MUS"].play(0, 0x99);
				playingMusic = _sound;
			}
			return;
		}
		public static function playMusicO(_sound:*) {
			if(playingMusicO != _sound) { 
				musicChannel = _sound.play(0, 0x99);
				playingMusicO = _sound;
			}
			return;
		}
		public static function stopMusic() {
			if(playingMusic != "none") {
				musicChannel.stop();
				playingMusic = "none";
			}
			return;
		}
		public static function stopMusicO(_sound:Sound) {
			if(playingMusicO != null) {
				musicChannel.stop();
				playingMusicO = null;
			}
			return;
		}
		public static function loadSounds() {
			titleMUS = new TitleSND();
			game1MUS = new Game1SND();
			game2MUS = new Game2SND();
			game3MUS = new Game3SND();
			armor1SND = new Armor1SND();
			armor2SND = new Armor2SND();
			bowFireSND = new BowFireSND();
			hit1SND = new Hit1SND();
			hit2SND = new Hit2SND();
			hit3SND = new Hit3SND();
			hit4SND = new Hit4SND();
			hit5SND = new Hit5SND();
			hit6SND = new Hit6SND();
			ice1SND = new Ice1SND();
			ice2SND = new Ice2SND();
			ice3SND = new Ice3SND();
			flesh1SND = new Flesh1SND();
			flesh2SND = new Flesh2SND();
			flesh3SND = new Flesh3SND();
			deathSND = new DeathSND();
			levelUpSND = new LevelUpSND();
			thunderClapSND = new ThunderClapSND();
			wallCrumble1SND = new WallCrumble1SND();
			clickSND = new ClickSND();
			buySND = new BuySND();
			startWaveSND = new StartWaveSND();
			waveDoneSND = new WaveDoneSND();
			SOUNDS_LOADED = true;
			return;
		}
		
	}
	
}
