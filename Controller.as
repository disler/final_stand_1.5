package  {
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import fl.controls.List;
	/*
		Controls all interface, players, and clicking
	*/
	public class Controller{
		public var shopItems:Array = new Array(["glyph of haste", 1], ["glyph of power", 1], ["glyph of health", 1], ["glyph of accuracy", 3], ["glyph of bow speed", 3],
										  ["glyph of regeneration", 4], ["glyph of power", 5], ["glyph of health", 5], ["glyph of accuracy", 5], ["glyph of bow speed", 4], 
										  ["glyph of regeneration", 4], ["glyph of power", 5], ["glyph of health", 5], ["glyph of accuracy", 5], ["glyph of bow speed", 4], 
										  ["glyph of regeneration", 4], ["glyph of power", 5], ["glyph of health", 5], ["glyph of accuracy", 5], ["glyph of bow speed", 4], 
										  ["glyph of regeneration", 4], ["glyph of power", 5], ["glyph of health", 5], ["glyph of accuracy", 5], ["glyph of bow speed", 4]
										  );
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
		/*
			Attaches listener events
		*/
		public function Controller(M:MovieClip, _gameState:String) {
			m = M;
			inGameControllerFactory(_gameState);
		}
		/*
			Attaches listener events
		*/
		public function inGameControllerFactory(_gameState:String):void {
			//remove all events to refresh for new gameState
			m.removeEventListener(Event.ENTER_FRAME, controllerEnterFrameHandler);
			m.removeEventListener(Event.ENTER_FRAME, intermissionEnterFrameHandler);
			m.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandlerInGame);
			m.stage.removeEventListener(MouseEvent.CLICK, stageClickHandler);


			//in combat events
			if(_gameState == "inGame") {
				m.addEventListener(Event.ENTER_FRAME, controllerEnterFrameHandler);
				m.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandlerInGame);
				m.stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
				m.stage.focus = null;
			}

			//between wave events
			else if(_gameState == "intermission") {
				m.addEventListener(Event.ENTER_FRAME, intermissionEnterFrameHandler);
				m._interface.proceed_mc.addEventListener(MouseEvent.CLICK, clickProceedToBattleEvent);
				displayPrimaryInterface();
			}
			return;
		}

		/*
			Sets up functionality for new loot
		*/
		public function handleNewLoot(loot:Loot):void
		{
			loot.timeout(m);
			loot.addEventListener(MouseEvent.MOUSE_DOWN, dragLootEvent);
			loot.addEventListener(MouseEvent.MOUSE_UP, unDragLootEvent);
		}

		/*
			display primary interface
		*/
		public function displayPrimaryInterface():void
		{
			//add events
			m._interface.primaryInterface_mc.primaryInterfaceIn_mc.artifact_mc.addEventListener(MouseEvent.CLICK, displayArtifactInterfaceEvent);
			m._interface.primaryInterface_mc.primaryInterfaceIn_mc.shop_mc.addEventListener(MouseEvent.CLICK, displayShopEvent);
		}

		/*
			Responsible for closing all intermission menus
		*/
		public function closeAllIntermissionMenus():void
		{
			m._interface.proceed_mc.gotoAndPlay("out");
			exitArtifactInterface();
			m._interface.closePrimaryInterface();

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
			var arr:Projectile = new Projectile();
			arr.loadProjectile(m.player.x, m.player.y, m, m.player.rotation, m.player.getStats().getBattleStats(), m._interface.getSelectedArrow());
			m.arrows_mc.addChild(arr);
			return;
		}
		
		/*	
			Click the stage and shoot an arrow in that direction
		*/
		private function stageClick():void
		{
			if(!arrowLock)
			{
				if(m.player.getStats().canShootArrow(m._interface.getSelectedArrowIndex()))
				{
					m.player.gotoAndStop("shoot");
					m.player.getStats().resetArrowTimer(m._interface.getSelectedArrowIndex());
					playerShootArrow();
				}
			}
		}

		/*
			Proceed to the next wave
		*/
		private function clickProceedToBattle():void
		{
			m._interface.proceed_mc.removeEventListener(MouseEvent.CLICK, clickProceedToBattle);
			
			closeAllIntermissionMenus();

			//some delay
			var quickTimeout:uint = setTimeout(function()
			{
				clearTimeout(quickTimeout);
				m.changeGameState("inGame");	
			}, 1000);
			m.waveHandler.startWave();
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
										  ["glyph of regeneration", 4],
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
				if(m.player.getStats().getGold() >= IO.cost) {
					m.player.getStats().spendGold(IO.cost);
					m.player.getStats().addArtifact(new Artifact(IO.nam));
					m._interface.primaryInterface_mc.primaryInterfaceIn_mc.gold_txt.text = m.player.getStats().getGold();
					m._interface.shop_mc.shopIn_mc.title_txt.text = "You have purchased " + IO.name + "."; // alternative send message?
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
			m._interface.shop_mc.gotoAndPlay("out");
			return;
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


		/*________________________________________EVENTS_________________________________________*/


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
		/*
			Controls game-wide events every frame.
		*/
		public function controllerEnterFrameHandler(e:Event):void {
			playerHandler();
			return;
		}
		public function intermissionEnterFrameHandler(e:Event):void {
			if(shopToolTip != null) {
				shopToolTip.x = m._interface.shop_mc.shopIn_mc.mouseX + 15;
				shopToolTip.y = m._interface.shop_mc.shopIn_mc.mouseY + 15;
			}
			return;
		}
		
	}
	
}
