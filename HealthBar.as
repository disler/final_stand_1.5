package  {
	
	import flash.display.MovieClip;
	
	/*
		Represents and handles health bar
	*/
	public class HealthBar extends MovieClip {
		
		public var health:Number, healthMax:Number;
		public function HealthBar() {}
		
		/*
			Initialize hp bar
		*/
		public function loadBar(_healthMax:Number = 3, _health:Number = 3):void {
			this.bar0_mc.visible = this.bar1_mc.visible = this.bar2_mc.visible = this.bar3_mc.visible = this.bar4_mc.visible = this.bar5_mc.visible = false;
			setHealthMax(healthMax = _healthMax);
			setHealth(health = _health);
			return;
		}
		
		/*
			SETS HEALTH, AND DISPLAYS health's current value and the right bar type.
		*/
		public function setHealth(HEALTH:Number):void {
			health = HEALTH;
			hp_txt.text = String(health);
			this.bar0_mc.visible = this.bar1_mc.visible = this.bar2_mc.visible = this.bar3_mc.visible = this.bar4_mc.visible = this.bar5_mc.visible = false;
			if(HEALTH > 0) {
				this.bar0_mc.visible = true;
				if(healthMax > 0 && healthMax < 6 || health < 6)
				this.bar0_mc.scaleX = (health / healthMax);
				else
				this.bar0_mc.scaleX = 1;
				if(HEALTH > 5) {
					this.bar1_mc.visible = true;
					this.bar1_mc.scaleX = 1.0;
					//this.bar1_mc.scaleX = ( (health-5) / (5 * Math.floor(healthMax/5)) );
					//this.bar1_mc.scaleX = ( (health-5) / ((1 * Math.ceil(health/5)) + (healthMax-(5 * Math.ceil(healthMax / 5)) + 5) );
					if(health < 10)
					this.bar1_mc.scaleX = ( (health-5) / 5);
					if(HEALTH > 10) {		
						this.bar2_mc.visible = true;
						this.bar2_mc.scaleX = 1.0;
						if(health < 15)
						this.bar2_mc.scaleX = ( (health-10) / 5);
						if(HEALTH > 15) {
							this.bar3_mc.visible = true;
							this.bar3_mc.scaleX = 1.0;
							if(health < 20)
							this.bar3_mc.scaleX = ( (health-15) / 5);
							if(HEALTH > 20) {
								this.bar4_mc.visible = true;
								this.bar4_mc.scaleX = 1.0;
								if(health < 25)
								this.bar4_mc.scaleX = ( (health-20) / 5 );
								if(HEALTH > 25) {
									this.bar5_mc.visible = true;
									this.bar5_mc.scaleX = 1.0;
									if(health < 30)
									this.bar5_mc.scaleX = ( (health-25) / 5 );
								}
							}
						}
					}
				}
			}
			return;
		}
		
		/*
			DISPLAY health max. Sets the top frame bar divisors
		*/
		public function setHealthMax(MAX:Number):void {
			if(MAX > 0 && MAX < 6) {
				this.topFrame_mc.gotoAndStop(MAX);
			} else if(MAX > 5) this.topFrame_mc.gotoAndStop(5);
			return;
		}
		
	}
	
}
