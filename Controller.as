package  {
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import fl.controls.List;
	import flash.ui.*;
	/*
		Controls all interface, players, and clicking
	*/
	public class Controller{
		public var myLoot:Loot = null;
																																																
		public var shopItems:Array = new Array(["glyph of accuracy", Const.SHOP_UNLOCK_WAVES[0]], 				["glyph of health", Const.SHOP_UNLOCK_WAVES[1]], ["steel arrow", Const.SHOP_UNLOCK_WAVES[2]], ["guardian bow", Const.SHOP_UNLOCK_WAVES[3]], ["glyph of health regeneration", Const.SHOP_UNLOCK_WAVES[4]],
										  ["ice arrow", Const.SHOP_UNLOCK_WAVES[5]], 							["absolute bow", Const.SHOP_UNLOCK_WAVES[6]], 	["glyph of haste", Const.SHOP_UNLOCK_WAVES[7]], ["glyph of power", Const.SHOP_UNLOCK_WAVES[8]], ["mithril arrow", Const.SHOP_UNLOCK_WAVES[9]], 
										  ["glyph of multishot", Const.SHOP_UNLOCK_WAVES[10]], 					["glyph of bow speed", Const.SHOP_UNLOCK_WAVES[11]], ["fire arrow", Const.SHOP_UNLOCK_WAVES[12]], ["sonic bow", Const.SHOP_UNLOCK_WAVES[13]], ["earth arrow", Const.SHOP_UNLOCK_WAVES[14]], 
										  ["agile bow", Const.SHOP_UNLOCK_WAVES[15]], 							["glyph of penetration", Const.SHOP_UNLOCK_WAVES[16]], ["vicious bow", Const.SHOP_UNLOCK_WAVES[17]], ["glyph of collision", Const.SHOP_UNLOCK_WAVES[18]], ["glyph of fortitude", Const.SHOP_UNLOCK_WAVES[19]], 
										  ["thunder arrow", Const.SHOP_UNLOCK_WAVES[20]], 						["glyph of war", Const.SHOP_UNLOCK_WAVES[21]], ["glyph of death", Const.SHOP_UNLOCK_WAVES[22]], ["glyph of limbo", Const.SHOP_UNLOCK_WAVES[23]], ["dark arrow", Const.SHOP_UNLOCK_WAVES[24]]);



		public var shopToolTip:MovieClip = null;
		public var shopSelectID:Number = -1;
		public var shopSelectID2:Number = -1;
		
		public var gameState:String = "gameStart";
		public var m:MovieClip;
		public var toggleArrowLockTimeout:uint;
		public var toggleArrowLock:Boolean = false;
		public var artifactList_ref:List;
		private var equippedArtifactSlot:Number;
		private var arrowLock:Boolean = false;
		private var lClicks:Number = 0;
		private var projCount:Number = 0;
		/*
			Attaches listener events
		*/
		public function Controller(M:MovieClip, _gameState:String) {
			m = M;
			//inGameControllerFactory(_gameState);
		}
		/*
			Attaches listener events
		*/
		public function inGameControllerFactory(_gameState:String):void {
			gameState = _gameState;
			//remove all events to refresh for new gameState
			m.removeEventListener(Event.ENTER_FRAME, controllerEnterFrameHandler);
			m.removeEventListener(Event.ENTER_FRAME, intermissionEnterFrameHandler);
			m.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandlerInGame);
			m.stage.removeEventListener(MouseEvent.CLICK, stageClickHandler);
			
			if(m.scene_mc.skip_mc != null)
			{
				m.scene_mc.skip_mc.removeEventListener(MouseEvent.CLICK, skipScene);
			}


			//in combat events
			if(_gameState == "inGame") {
				Mouse.hide();
				m.addEventListener(Event.ENTER_FRAME, controllerEnterFrameHandler);
				m.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandlerInGame);
				m.stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
				m.stage.focus = null;
			}

			//between wave events
			else if(_gameState == "intermission") {
				Mouse.hide();
				m.addEventListener(Event.ENTER_FRAME, intermissionEnterFrameHandler);
				m._interface.proceed_mc.addEventListener(MouseEvent.CLICK, clickProceedToBattleEvent);
				m.stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
				displayPrimaryInterface();
			}

			//go to gameover
			else if(_gameState == "gameOver")
			{
				Mouse.show();
				m.setWasDead(true);
				m.waveHandler.endWaves();
				removeAllMC();
				m.gotoAndStop("gameOver");
				m.tryAgain_mc.addEventListener(MouseEvent.CLICK, restartGameEvent);
				m.quit_mc.addEventListener(MouseEvent.CLICK, quitGameEvent);
			}

			else if(_gameState == "cutscene")
			{
				m.scene_mc.skip_mc.addEventListener(MouseEvent.CLICK, skipScene);
			}

			return;
		}

		/*
			Skip button
		*/
		private function skipScene(e:MouseEvent)
		{
			var scene:String = m.scene_mc.currentLabel;
			m.scene_mc.gotoAndStop("none");
			m.initFromScene(scene);
		}

		/*
			Sets up functionality for new loot
		*/
		public function handleNewLoot(loot:Loot):void
		{
			loot.timeout(m);
			loot.addEventListener(MouseEvent.CLICK, mouseTheLoot);
		}

		/*
			display primary interface
		*/
		public function displayPrimaryInterface():void
		{
			//add events
			m._interface.primaryInterface_mc.primaryInterfaceIn_mc.artifact_mc.addEventListener(MouseEvent.CLICK, displayArtifactInterfaceEvent);
			m._interface.primaryInterface_mc.primaryInterfaceIn_mc.shop_mc.addEventListener(MouseEvent.CLICK, displayShopEvent);
			m._interface.primaryInterface_mc.primaryInterfaceIn_mc.bow_mc.addEventListener(MouseEvent.CLICK, toggleBowDisplayEvent);
		}

		/*
			Responsible for closing all intermission menus
		*/
		public function closeAllIntermissionMenus():void
		{
			m._interface.proceed_mc.gotoAndPlay("out");
			exitArtifactInterface();
			m._interface.closePrimaryInterface();
			closeBowDisplay();

		}

		/*
			Open artifact interface
		*/
		public function displayArtifactInterface():void
		{
			var reference:MovieClip = m._interface.artifact_mc;
			var arr:Array = m.player.getStats().getEquippedArtifacts();
			for(var i:Number = 0; i < 16; i++)
			{
				if(arr[i].getArtifact() != "locked")
				{
					reference.artifactSquare_mc["_" + i].addEventListener(MouseEvent.CLICK, clickArtifactEvent);
				}
				reference.artifactSquare_mc["_" + i].addEventListener(MouseEvent.ROLL_OVER, rollOverArtifactEvent);
				reference.artifactSquare_mc["_" + i].addEventListener(MouseEvent.ROLL_OUT, rollOutArtifactEvent);
			}


			//clear all button
			reference.clear_mc.addEventListener(MouseEvent.CLICK, clearArtifactsEvent);
			reference.auto_mc.addEventListener(MouseEvent.CLICK, autoFillArtifactsEvent);
			reference.exit_mc.addEventListener(MouseEvent.CLICK, exitArtifactInterfaceEvent);

		}

		/*
			Flags Keys which are pressed
		*/
		public function playerShootArrow():void { 
			
			//count multi shot glyph
			var arr:Projectile;
			var occ:Number = m.player.getStats().occurrence("glyph of multishot"); 
			if(occ > 0)
			{
				for(var i:Number = 0; i < m.player.getStats().multiShot(occ); i++)
				{
					arr = new Projectile();
					arr.loadProjectile(m.player.x + (5*i), m.player.y - (5*i), m, m.player.rotation, m.player.getStats().getBattleStats(), m._interface.getSelectedArrow());
					m.arrows_mc.addChild(arr);
					arr.name = "proj" + projCount;
					projCount++;
				}
			}
			else
			{
				arr = new Projectile();
				arr.loadProjectile(m.player.x, m.player.y, m, m.player.rotation, m.player.getStats().getBattleStats(), m._interface.getSelectedArrow());
				m.arrows_mc.addChild(arr);
				arr.name = "proj" + projCount;
				projCount++;
			}

			return;
		}
		
		/*	
			Click the stage and shoot an arrow in that direction
		*/
		private function stageClick():void
		{
			if(gameState == "inGame") {
				if(!arrowLock)
				{
					if(m.player.getStats().canShootArrow(m._interface.getSelectedArrowIndex()))
					{
						m.player.gotoAndStop("shoot");
						m.player.getStats().resetArrowTimer(m._interface.getSelectedArrowIndex());
						playerShootArrow();
						SoundHandler.playSound("bowFire");
					}
				}
			}
			if( myLoot != null) {
				if(++lClicks > 1) {
					myLoot.x = m.mouseX - 30;
					myLoot.y = m.mouseY - 30;
					(myLoot as MovieClip).visible = true;
					m.interface_mc.mouse_mc.loot_mc.visible = false;
					m.interface_mc.treasure_mc.gotoAndStop(1);
					m.interface_mc.arrowSelect_mc.gotoAndStop(1);
					myLoot = null; arrowLock = false;
					displayGeneralLooting(false);
					lClicks = 0;
					//myLoot.remove(m); 
				}
			}
		}

		/*
			Proceed to the next wave
		*/
		private function clickProceedToBattle():void
		{
			m._interface.proceed_mc.removeEventListener(MouseEvent.CLICK, clickProceedToBattleEvent);
			
			closeAllIntermissionMenus();

			//some delay
			var quickTimeout:uint = setTimeout(function()
			{
				clearTimeout(quickTimeout);
				m.changeGameState("inGame");	
			}, 1000);
			m.waveHandler.startWave();
			SoundHandler.playSound("startWave");
		}

		/*
			Click an artifact and display list
		*/
		private function clickArtifact(mc:DisplayObject):void
		{
			//display
			artifactList_ref = m._interface.artifact_mc.unequippedList_list;
			artifactList_ref.dataProvider.removeAll();
			artifactList_ref.visible = true;
			//render font
			var myTextFormat:TextFormat = new TextFormat();
			myTextFormat.size = 17;
			myTextFormat.font = "Garamond_e*";
			artifactList_ref.setRendererStyle("textFormat", myTextFormat);
			

			//trim slot name
			equippedArtifactSlot = Number(mc.name.split("_").join(""));

			//add labeling to list menu
			var unequippedArtifacts:Array = m.player.getStats().getUnequippedArtifacts();
			if(m.player.getStats().getEquippedArtifacts()[equippedArtifactSlot].getArtifact() != "empty")
			{
				artifactList_ref.addItem( { label : "remove" } );
			}
			for(var i:Number = 0; i < unequippedArtifacts.length; i++)
			{
				artifactList_ref.addItem( { label : m.utility.upperCaseFirst(unequippedArtifacts[i].getArtifact()), ind : i } );
			}

			//add event
			artifactList_ref.addEventListener(Event.CHANGE, clickUnequippedArtifactEvent);

		}

		/*
			Swap selected artifact with clicked one based on label
		*/
		public function clickUnequippedArtifact(artifactIndex:Number):void
		{

			var fromSlot = equippedArtifactSlot;
			equippedArtifactSlot = -1;

			m.player.getStats().equipArtifact(fromSlot, artifactIndex);

			closeUnequippedArtifacts();
			m._interface.loadArtifact();
			SoundHandler.playSound("click");
		}

		/*
			Resets unequipped artifacts
		*/
		public function closeUnequippedArtifacts():void
		{
			artifactList_ref = m._interface.artifact_mc.unequippedList_list;
			artifactList_ref.visible = false;
			artifactList_ref.removeEventListener(Event.CHANGE, clickUnequippedArtifactEvent);
			artifactList_ref.dataProvider.removeAll();
		}

		/*
			Clear artifacts
		*/
		public function clearArtifacts():void
		{
			m.player.getStats().removeAllArtifacts();
			m._interface.loadArtifact();
		}

		/*
			Auto fill in artifacts
		*/
		public function autoFillArtifacts():void
		{
			m.player.getStats().autoFillArtifacts();
			m._interface.loadArtifact();
		}

		/*
			When hover over an artifact, display the hover message and contents of artifact
		*/
		public function rollOverArtifact(mc:DisplayObject):void
		{
			m._interface.toggleInterfaceArtifactMessage(true, Number(mc.name.split("_").join("")));
		}

		/*
			When you hover out an artifact, remove the hover message
		*/
		public function rollOutArtifact():void
		{
			m._interface.toggleInterfaceArtifactMessage(false, -1);
		}

		/*
			Exit artifact interface
		*/
		public function exitArtifactInterface():void
		{
			closeUnequippedArtifacts();

			var reference:MovieClip = m._interface.artifact_mc;
			reference.clear_mc.removeEventListener(MouseEvent.CLICK, clearArtifactsEvent);
			reference.auto_mc.removeEventListener(MouseEvent.CLICK, autoFillArtifactsEvent);
			reference.exit_mc.removeEventListener(MouseEvent.CLICK, exitArtifactInterfaceEvent);
			m._interface.closeArtifactInterface();
		}
		


		/*
			Sets controls for displaying shop
		*/
		public function displayShop():void
		{
			//close handle bow interface
			closeBowDisplay();
			


			if(m._interface.shop_mc.currentFrame == 1) {
				m._interface.shop_mc.gotoAndPlay(2);
				m._interface.shop_mc.shopIn_mc.purchase_btn.addEventListener(MouseEvent.CLICK, shopPurchase);
				m._interface.shop_mc.shopIn_mc.exit_btn.addEventListener(MouseEvent.CLICK, shopExit);
				
				for(var i:Number = 0; i < 25; i++) {
					var SI:MovieClip = m._interface.shop_mc.shopIn_mc["s" + i]; 
					SI.locked_mc.visible = new Boolean(m.waveHandler.getWave() < shopItems[i][1]);
					if(!SI.locked_mc.visible) SI.item_mc.gotoAndStop(shopItems[i][0]); else SI.item_mc.gotoAndStop("locked");
					SI.addEventListener(MouseEvent.MOUSE_OVER, shopItemOver);
					SI.addEventListener(MouseEvent.MOUSE_OUT, shopItemOut);
					SI.addEventListener(MouseEvent.MOUSE_DOWN, shopItemDown);
					SI.addEventListener(MouseEvent.MOUSE_UP, shopItemUp);
					SI.id = i;
					SI.mouseChildren = false;
				}
			}
			return;
		}
		
		/*
			Hoverng over any shop item.
		*/
		public function shopItemOver(e:MouseEvent):void
		{
			if(!e.currentTarget.locked_mc.visible) {
				e.currentTarget.bg_mc.gotoAndStop(2);
				shopToolTip = m._interface.shop_mc.shopIn_mc.toolTip_mc;
				shopToolTip.x = m._interface.shop_mc.shopIn_mc.mouseX + 20;
				shopToolTip.y = m._interface.shop_mc.shopIn_mc.mouseY + 20;
				setShopTip(shopItems[e.currentTarget.id][0]);
			}
			return;
		}
		/*
		(["glyph of haste", 1], ["glyph of power", 1], ["glyph of health", 1], ["glyph of accuracy", 3], ["glyph of bow speed", 3],
										  ["glyph of health regeneration", 4],
		*/
		public function setShopTip(_shopItem:String):void {
			var STT:MovieClip = m._interface.shop_mc.shopIn_mc.toolTip_mc;
			var IO:Object = Item.getObj(_shopItem);
			STT.title_txt.text = IO.name;
			STT.description_txt.text = IO.description;
			STT.cost_txt.text = "Cost: " + IO.cost;
			return;
		}
		/*
			Purchases item
		*/
		public function shopItemOut(e:MouseEvent):void
		{
			if(!e.currentTarget.locked_mc.visible) {
				e.currentTarget.bg_mc.gotoAndStop(1);
				shopToolTip.y = -550; 
				shopToolTip = null;
			}
			return;
		}
		/*
			Purchases item
		*/
		public function shopItemDown(e:MouseEvent):void
		{
			if(!e.currentTarget.locked_mc.visible) {
				e.currentTarget.bg_mc.gotoAndStop(3);
			}
			return;
		}
		/*
			Release click on shop items
		*/
		public function shopItemUp(e:MouseEvent):void
		{
			// set target item
			if(!e.currentTarget.locked_mc.visible) {
				var IO:Object = Item.getObj(shopItems[e.currentTarget.id][0]);
				shopSelectID = e.currentTarget.id;
				if(shopSelectID2 == -1) {
					shopSelectID2 = e.currentTarget.id;
				} else {
					m._interface.shop_mc.shopIn_mc["s" + shopSelectID2].frame_mc.gotoAndStop(1);
					shopSelectID2 = e.currentTarget.id;
				}
				m._interface.shop_mc.shopIn_mc.title_txt.text = "Item: " + IO.name + ", Buy: " + IO.cost;
				e.currentTarget.frame_mc.gotoAndStop(2);
				e.currentTarget.bg_mc.gotoAndStop(2);
			}
			return;
		}
		/*
			Purchases item
		*/
		public function shopPurchase(e:MouseEvent):void
		{
			if(shopSelectID != -1) {
				var IO:Object = Item.getObj(shopItems[shopSelectID][0]);
				var alreadyOwn:Boolean = false;
				if(m.player.getStats().getGold() >= IO.cost) {
					if(IO.type == "artifact")
					{
						m.player.getStats().addArtifact(new Artifact(IO.nam));
						m._interface.shop_mc.shopIn_mc.title_txt.text = "You have purchased " + IO.name + ".";
						SoundHandler.playSound("buy");
					}
					else if(IO.type == "bow")
					{
						var bow:Bow = new Bow(IO.nam);

						if( m.player.getStats().containsBow(bow) )
						{
							alreadyOwn = true;
						}
						else
						{
							m._interface.shop_mc.shopIn_mc.title_txt.text = "You have purchased " + IO.name + ".";
							SoundHandler.playSound("buy");
							m.player.getStats().addBow(bow);
						}
					}
					else//arrow
					{
						var arrow:ArrowType = new ArrowType(IO.nam);
						if(m.player.getStats().containsArrow(arrow))
						{
							alreadyOwn = true;
						}
						else
						{
							var loot:Loot = new Loot(IO.nam, Const.LOOT_ARROW);
							selectLootFromBattleField(loot, true);
							SoundHandler.playSound("buy");
							closeShop();
						}
					}	

					//if we don't own this item, buy it
					if(!alreadyOwn)
					{
						m.player.getStats().spendGold(IO.cost);
						m._interface.primaryInterface_mc.primaryInterfaceIn_mc.gold_txt.text = m.player.getStats().getGold();
					}
					//if we own this item buy it
					else{
						m._interface.shop_mc.shopIn_mc.title_txt.text = "You already own that item!";
					}

				} else { 
					m._interface.shop_mc.shopIn_mc.title_txt.text = "Not enough gold, friend.";
				}
			} else { }
			return;
		}
		
		/*
			Purchases item
		*/
		public function shopExit(e:MouseEvent):void
		{
			closeShop();
			return;
		}

		/*
			Close shop
		*/
		private function closeShop()
		{
			m._interface.shop_mc.gotoAndPlay("out");
		}


		/*
			Displays arrow looting interface (arrows only)
		*/
		public function displayArrowLooting(toggleOn:Boolean):void
		{
			if(toggleOn)
			{
				m._interface.arrowSelect_mc.gotoAndStop("show");
			}
			else
			{
				m._interface.arrowSelect_mc.gotoAndStop("hide");
			}
		}

		/*
			Displays general looting interface (gold, bows, artifacts)
		*/
		public function displayGeneralLooting(toggleOn:Boolean):void
		{
			if(toggleOn)
			{
				m._interface.treasure_mc.gotoAndStop("show");
			}
			else
			{
				m._interface.treasure_mc.gotoAndStop("hide");
			}
		}

		public function treasureClick(e:MouseEvent):void {
			if(e.currentTarget.currentFrame != 1) {
				switch(myLoot.getType())
					{
						case Const.LOOT_ARTIFACT:
							m.player.getStats().addArtifact(new Artifact(myLoot.getTitle()));
							Messenger.lootMessage("Looted " + m.utility.upperCaseFirst(myLoot.getTitle()), Const.LOOT_MESSAGE_DEFAULT);
							//dropped = false;
						break;
						case Const.LOOT_GOLD:
							var gold:Gold = myLoot as Gold;
							m.player.getStats().addGold(gold.getAmount());
							Messenger.lootMessage("Looted " + gold.getAmount() + " " + m.utility.upperCaseFirst(myLoot.getTitle()), Const.LOOT_MESSAGE_DEFAULT);
							//dropped = false;
						break;
						case Const.LOOT_BOW:
							m.player.getStats().addBow(new Bow(myLoot.getTitle()));
							Messenger.lootMessage("Looted " + m.utility.upperCaseFirst(myLoot.getTitle()), Const.LOOT_MESSAGE_BOW);
							//dropped = false;
						break;
					}
					m.interface_mc.mouse_mc.loot_mc.visible = false;
				myLoot.remove(m); myLoot = null; 

				var qTimeout = setTimeout(function() { arrowLock = false; clearTimeout(qTimeout); }, 250);
				displayGeneralLooting(false); 
			}
			return;
		}
		public function arrowClick(e:MouseEvent):void {
			if(m.interface_mc.arrowSelect_mc.currentFrame != 1) {
				if(e.currentTarget == m._interface.inGameInterface_mc.arrow1_mc)
				{
					//equip to arrow slot 1
					m.player.getStats().equipArrow(myLoot.getTitle(), 0);
					Messenger.lootMessage("Looted " + m.utility.upperCaseFirst(myLoot.getTitle()), Const.LOOT_MESSAGE_ARROW);
					try{
						myLoot.remove(m);
					} catch (e:Error) {}
				}
				else if(e.currentTarget == m._interface.inGameInterface_mc.arrow2_mc)
				{
					//2
					m.player.getStats().equipArrow(myLoot.getTitle(), 1);
					Messenger.lootMessage("Looted " + m.utility.upperCaseFirst(myLoot.getTitle()), Const.LOOT_MESSAGE_ARROW);
					try{
						myLoot.remove(m);
					} catch (e:Error) {}
				}
				else if(e.currentTarget == m._interface.inGameInterface_mc.arrow3_mc)
				{
					//3
					m.player.getStats().equipArrow(myLoot.getTitle(), 2);
					Messenger.lootMessage("Looted " + m.utility.upperCaseFirst(myLoot.getTitle()), Const.LOOT_MESSAGE_ARROW);
					try{
						myLoot.remove(m);
					} catch (e:Error) {}
				}
				m.interface_mc.mouse_mc.loot_mc.visible = false;
				myLoot.remove(m); myLoot = null;  arrowLock = false;
				displayArrowLooting(false); 
			}
			return;
		}
		/*
			Toggles bow container display
		*/
		private function toggleBowDisplay():void
		{
			var ref:MovieClip = m._interface.primaryInterface_mc.primaryInterfaceIn_mc.bowContainer_mc;

			//if the bow display is currently hidden, open it
			if(ref.currentLabel == "hidden")
			{
				ref.gotoAndPlay("show");

				for(var i:Number = 0; i < 5; i++)
				{
					if(m.player.getStats().getBowContainer()[i] != null)
					{
						ref.bowContainerIn_mc["_" + i].gotoAndStop(m.player.getStats().getBowContainer()[i].getName());
						ref.bowContainerIn_mc["_" + i].addEventListener(MouseEvent.CLICK, equipSelectedBowEvent);
						ref.bowContainerIn_mc["_" + i].addEventListener(MouseEvent.ROLL_OVER, bowDescriptionEventOver);
						ref.bowContainerIn_mc["_" + i].addEventListener(MouseEvent.ROLL_OUT, bowDescriptionEventOut);
					}
					//all other unequipped bows will stay on 'empty'
				}
			}
			//iif the bow display is currently open, close it
			else if(ref.currentLabel == "showing")
			{
				closeBowDisplay();
			}
		}

		/*
			Close bow container display
		*/
		private function closeBowDisplay():void
		{
			if(m._interface.primaryInterface_mc.primaryInterfaceIn_mc.bowContainer_mc.currentLabel == "showing" ||
				m._interface.primaryInterface_mc.primaryInterfaceIn_mc.bowContainer_mc.currentLabel == "show")
			{
				m._interface.primaryInterface_mc.primaryInterfaceIn_mc.bowContainer_mc.gotoAndPlay("hide");
			}
		}


		/*
			Handlers firing enemy projectile
		*/
		var enemyProjectile:Array = [];
		public function fireEnemyProjectile(type:String, _x:Number, _y:Number, rot:Number,stats:StatisticEnemy)
		{
			var proj:EnemyProjectile = new EnemyProjectile(type, _x, _y, rot, stats, m);
			proj.name = "eProj" + EnemyProjectile.projCount;
			EnemyProjectile.projCount++;
			enemyProjectile.push(proj);
			m.arrows_mc.addChild(proj);
		}


		/*
			Restart game
		*/
		private function restartGame():void
		{
			m.gotoAndStop("game");
		}

		/*
			Quit game
		*/
		private function quitGame():void
		{
			m.gotoAndStop("title");
			m.player = null;
		}

		/*
			Remove all movie clips
		*/
		public function removeAllMC():void
		{
			//remove all enemies
			var numEnemies:Number = m.enemies_mc.numChildren;
			var numArrows:Number = m.arrows_mc.numChildren;
			var numLoot:Number = m.loot_mc.numChildren;
			
			//enemies
			for(var i:Number = 0; i < numEnemies; i++)
			{
				(m.enemies_mc.getChildAt(0)).unloadByDeath();
			}

			//projectiles
			for(i = 0; i < numArrows; i++)
			{
				try{
					(m.arrows_mc.getChildAt(0) as Projectile).kill();
					(m.arrows_mc.getChildAt(0) as EnemyProjectile).kill();
				} catch(e:Error) {}
			}

			//loot
			for(i = 0; i < numLoot; i++)
			{

				m.loot_mc.removeChild(m.loot_mc.getChildAt(0));
			}

		}



		/*________________________________________EVENTS_________________________________________*/



		/*
			Event that handles restarting the game after death
		*/
		public function restartGameEvent(e:Event):void
		{
			restartGame();
		}

		/*
			Event that handles restarting the game after death
		*/
		public function quitGameEvent(e:Event):void
		{
			quitGame();
		}



		/*
			event for displaying bow description whne mouse hovers over
		*/	
		public function bowDescriptionEventOver(e:MouseEvent):void
		{
			var trimRef:Number = Number(e.currentTarget.name.split("_").join(""));
			
			var bowConRef:MovieClip = m._interface.primaryInterface_mc.primaryInterfaceIn_mc.bowContainer_mc;
			bowConRef.hover_mc.x = bowConRef.mouseX - 225;
			bowConRef.hover_mc.y = bowConRef.mouseY - 200;

			var bow:Bow = m.player.getStats().getBowContainer()[trimRef];
			bowConRef.hover_mc.header_txt.text = m.utility.upperCaseFirst(bow.getName());
			bowConRef.hover_mc.body_txt.text = m.utility.upperCaseFirst(bow.getDescription());
		}

		/*
			event for hiding bow description when mouse hovers out
		*/	
		public function bowDescriptionEventOut(e:MouseEvent):void
		{
			var bowConRef:MovieClip = m._interface.primaryInterface_mc.primaryInterfaceIn_mc.bowContainer_mc;
			bowConRef.hover_mc.x = 256.1;
			bowConRef.hover_mc.y = -75.7;
		}

		/*
			Event for equipping a new bow
		*/
		public function equipSelectedBowEvent(e:MouseEvent):void
		{
			//trim name '_1' -> '1'
			m.player.getStats().equipBow(Number(e.currentTarget.name.split("_").join("")));

			//reload visuals
			for(var i:Number = 0; i < 5; i++)
			{
				if(m.player.getStats().getBowContainer()[i] != null)
				{
					m._interface.primaryInterface_mc.primaryInterfaceIn_mc.bowContainer_mc.bowContainerIn_mc["_" + i].gotoAndStop(m.player.getStats().getBowContainer()[i].getName());
				}
			}
		}


		/*
			Displays bows to be equipped
		*/
		public function toggleBowDisplayEvent(e:MouseEvent):void
		{
			toggleBowDisplay();
		}

		/*
			Event for undragging and dropping loot
		*/
		public function unDragLootEvent(e:MouseEvent):void
		{
			var dropped:Boolean = true;
			//unlock arrows, with slight delay
			var lockTimer:uint = setTimeout(function()
			{
				arrowLock = false;
			}, 250);

			//start drag
			e.currentTarget.stopDrag();

			//obtain loot object
			var loot:Loot = e.currentTarget as Loot;

			//if these things are at the correct loot location given it's type (arrow ELSE general)
			if(loot.getType() == Const.LOOT_ARROW)
			{
				if(loot.hitTestObject(m._interface.inGameInterface_mc.arrow1_mc))
				{
					//equip to arrow slot 1
					m.player.getStats().equipArrow(loot.getTitle(), 0);
					Messenger.lootMessage("Looted " + m.utility.upperCaseFirst(loot.getTitle()), Const.LOOT_MESSAGE_ARROW);
					loot.remove(m);
					dropped = false;
				}
				else if(loot.hitTestObject(m._interface.inGameInterface_mc.arrow2_mc))
				{
					//2
					m.player.getStats().equipArrow(loot.getTitle(), 1);
					Messenger.lootMessage("Looted " + m.utility.upperCaseFirst(loot.getTitle()), Const.LOOT_MESSAGE_ARROW);
					loot.remove(m);
					dropped = false;
				}
				else if(loot.hitTestObject(m._interface.inGameInterface_mc.arrow3_mc))
				{
					//3
					m.player.getStats().equipArrow(loot.getTitle(), 2);
					Messenger.lootMessage("Looted " + m.utility.upperCaseFirst(loot.getTitle()), Const.LOOT_MESSAGE_ARROW);
					loot.remove(m);
					dropped = false;
				}

				//close arrow looting interface
				displayArrowLooting(false);
			}
			else
			{
				if(loot.hitTestObject(m._interface.treasure_mc))
				{
					//loot the correct item based on it's type
					switch(loot.getType())
					{
						case Const.LOOT_ARTIFACT:
							m.player.getStats().addArtifact(new Artifact(loot.getTitle()));
							Messenger.lootMessage("Looted " + m.utility.upperCaseFirst(loot.getTitle()), Const.LOOT_MESSAGE_DEFAULT);
							dropped = false;
						break;
						case Const.LOOT_GOLD:
							var gold:Gold = loot as Gold;
							m.player.getStats().addGold(gold.getAmount());
							Messenger.lootMessage("Looted " + gold.getAmount() + " " + m.utility.upperCaseFirst(loot.getTitle()), Const.LOOT_MESSAGE_DEFAULT);
							dropped = false;
						break;
						case Const.LOOT_BOW:
							m.player.getStats().addBow(new Bow(loot.getTitle()));
							Messenger.lootMessage("Looted " + m.utility.upperCaseFirst(loot.getTitle()), Const.LOOT_MESSAGE_BOW);
							dropped = false;
						break;
					}
					
					//visually remove loot
					loot.remove(m);
				}

				//close general looting interface
				displayGeneralLooting(false);
			}

			//if loot was picked up and dropped, reset the timer
			/**/
			if(dropped)
			{
				loot.timeout(m);
			}
			

		}

		/*
			Event for dragging loot, displays loot drop
		*/
		public function dragLootEvent(e:MouseEvent):void
		{
			//lock shotting arrows
			arrowLock = true;

			//start drag
			e.currentTarget.startDrag();

			//increase depth

			//obtain loot object
			var loot:Loot = e.currentTarget as Loot;

			if(loot.getType() == Const.LOOT_ARROW)
			{
				displayArrowLooting(true);
			}
			else
			{
				displayGeneralLooting(true);
			}

			loot.clearTimeoutTimer();

		}

		/*
			Adds mouse to the loot area.
		*/
		public function mouseTheLoot(e:MouseEvent):void
		{
			selectLootFromBattleField(e.currentTarget as Loot, false);
		}

		/*
			Click dropped loot
		*/
		private function selectLootFromBattleField(_loot:Loot, fromShop:Boolean):void
		{
			//lock shotting arrows
			arrowLock = true;
			//obtain loot object
			var loot:Loot = _loot;
			myLoot = loot;
			if(!fromShop)
			{
				myLoot.visible = false;
			}
			m._interface.mouse_mc.loot_mc.visible = true;
			lClicks = 0;
			if(loot.getType() == Const.LOOT_ARROW)
			{
				displayArrowLooting(true);
			}
			else
			{
				displayGeneralLooting(true);
			}
			return;
		}



		/*
			Event for opening hsop
		*/
		public function displayShopEvent(e:Event):void
		{ 
			displayShop();
		}

		/*
			Event for opening artifact interface
		*/
		public function displayArtifactInterfaceEvent(e:Event):void
		{
			displayArtifactInterface();
			m._interface.displayArtifactInterface();
		}










		/*
			event for exiting artifact interface
		*/
		public function exitArtifactInterfaceEvent(e:Event):void
		{
			exitArtifactInterface();
		}

		/*
			event for rollling over equipped artifact
		*/
		public function rollOverArtifactEvent(e:Event):void
		{
			rollOverArtifact(e.target as DisplayObject);
		}
		
		/*
			event for rollling over equipped artifact
		*/
		public function rollOutArtifactEvent(e:Event):void
		{
			rollOutArtifact();
		}

		/*
			Event for auto filling artifacts
		*/
		public function autoFillArtifactsEvent(e:Event):void
		{
			autoFillArtifacts();
		}
		/*
			event for clearing artifacts 
		*/
		public function clearArtifactsEvent(e:Event):void
		{
			clearArtifacts();
		}

		/*
			event for clicking unequipped artifact
		*/
		public function clickUnequippedArtifactEvent(e:Event)
		{
			clickUnequippedArtifact(e.target.selectedItem.ind);
		}

		/*
			Event for clicking artifact
		*/
		public function clickArtifactEvent(e:MouseEvent):void
		{
			clickArtifact((e.target as DisplayObject));
		}

		/*
			Clicked 'proceed to battle'
		*/
		public function clickProceedToBattleEvent(e:MouseEvent):void
		{
			clickProceedToBattle();
		}

		/*
			Mouse is pressed anywhere
		*/
		public function stageClickHandler(e:MouseEvent):void {
			stageClick();
			return;
		}
		/*
			Flags Keys which are pressed
		*/
		public function keyDownHandlerInGame(e:KeyboardEvent):void {
			var canSelectArrowBool:Boolean = false;
			switch(e.keyCode)
			{
				case 81:
					canSelectArrowBool = m._interface.toggleArrow(0);
				break;
				case 87:
					canSelectArrowBool = m._interface.toggleArrow(1);
				break;
				case 69:
				 	canSelectArrowBool = m._interface.toggleArrow(2);
				break;
			}

			if(!canSelectArrowBool)
			{
				if(!toggleArrowLock)
				{
					toggleArrowLock = true;
					Messenger.alertMessage("You cannot select that");
					
					toggleArrowLockTimeout = setTimeout(function()
												{
													clearTimeout(toggleArrowLockTimeout);
													toggleArrowLock = false;
												}, Const.WARNING_MESSAGE_SPAM_TIMER);
				}
			}
			return;
		}
		/*
			Flags Keys which are released
		*/
		public function keyUpHandler(e:KeyboardEvent):void {
			return;
		}
		/*
			Controls the player on every frame.
		*/
		public function playerHandler():void {
		// Handling Rotation - SOH CAH TOA
			m.player.rotation = (Math.atan2(m.mouseY - m.player.y, m.mouseX - m.player.x) * (180 / Math.PI)) + 90;
			return;
		}
		public function interfaceHandler():void {
			Mouse.hide();
			if(m.interface_mc != null) {
				m.interface_mc.mouse_mc.x = m.interface_mc.mouseX;
				m.interface_mc.mouse_mc.y = m.interface_mc.mouseY;
			}
			return;
		}
		/*
			Controls game-wide events every frame.
		*/
		public function controllerEnterFrameHandler(e:Event):void {
			playerHandler();
			interfaceHandler();
			return;
		}
		public function intermissionEnterFrameHandler(e:Event):void {
			if(m.interface_mc != null) {
				m.interface_mc.mouse_mc.x = m.interface_mc.mouseX;
				m.interface_mc.mouse_mc.y = m.interface_mc.mouseY;
			}
			if(shopToolTip != null) {
				shopToolTip.x = m._interface.shop_mc.shopIn_mc.mouseX + 15;
				shopToolTip.y = m._interface.shop_mc.shopIn_mc.mouseY + 15;
			}
			return;
		}
		
	}
	
}
