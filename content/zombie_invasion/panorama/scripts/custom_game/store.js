"use strict";

/** Панели этого layout: $("#…") из скрипта не всегда совпадает с контекстом Custom UI. */
function ZiPanels() {
	var ctx = $.GetContextPanel();
	return {
		root: ctx.FindChildTraverse("ZiStore"),
		container: ctx.FindChildTraverse("ZiStoreContainer"),
		shopInside: ctx.FindChildTraverse("ZiStoreShopInside"),
		donateInside: ctx.FindChildTraverse("ZiStoreDonateInside"),
		shopPromo: ctx.FindChildTraverse("ZiStoreShopPromo"),
		tabShop: ctx.FindChildTraverse("ZiStoreTabShop"),
		tabDonate: ctx.FindChildTraverse("ZiStoreTabDonate"),
		paymentModal: ctx.FindChildTraverse("ZiStorePaymentModal"),
		paymentDialog: ctx.FindChildTraverse("ZiStorePaymentDialog"),
		paymentTitle: ctx.FindChildTraverse("ZiStorePaymentTitle"),
		paymentUrl: ctx.FindChildTraverse("ZiStorePaymentUrl"),
		paymentCopied: ctx.FindChildTraverse("ZiStorePaymentCopied"),
		paymentOpen: ctx.FindChildTraverse("ZiStorePaymentOpen"),
		paymentCopy: ctx.FindChildTraverse("ZiStorePaymentCopy"),
		button: ctx.FindChildTraverse("ZiStoreButton"),
		shards: ctx.FindChildTraverse("ZiStoreShards"),
		refreshButton: ctx.FindChildTraverse("ZiStoreRefreshButton"),
	};
}

var ZiCurrentPaymentUrl = "";
var ZiHasPromo = false;

function attachStoreButton() {
	// Кнопка живёт в собственном layout рядом с DonateToggleButton — никуда не переносим.
}

function ZiStorePulseTick() {
	var btn = ZiPanels().button;
	if (btn && btn.IsValid()) {
		btn.ToggleClass("ZiStorePulseOn");
	}
	$.Schedule(0.9, ZiStorePulseTick);
}

function HideZiStore() {
	var c = ZiPanels().container;
	if (c) c.RemoveClass("is-active");
}

function ShowZiStore() {
	var c = ZiPanels().container;
	if (c) c.AddClass("is-active");
}

function ToggleZiStore() {
	var c = ZiPanels().container;
	if (c) c.ToggleClass("is-active");
}

function ZiStoreSelectTab(tab) {
	var p = ZiPanels();
	var isShop = tab === "shop";
	if (p.tabShop) p.tabShop.SetHasClass("IsActive", isShop);
	if (p.tabDonate) p.tabDonate.SetHasClass("IsActive", !isShop);
	if (p.shopInside) p.shopInside.SetHasClass("IsHidden", !isShop);
	if (p.donateInside) p.donateInside.SetHasClass("IsHidden", isShop);
	if (p.shopPromo) p.shopPromo.SetHasClass("IsHidden", !(isShop && ZiHasPromo));
}

function GetLocalEconomy() {
	var pid = Players.GetLocalPlayer();
	return CustomNetTables.GetTableValue("economy", pid.toString()) || null;
}

function GetCatalog() {
	return CustomNetTables.GetTableValue("economy", "catalog") || null;
}

function GetDonatePackages() {
	return CustomNetTables.GetTableValue("economy", "donate_packages") || null;
}

function IsOwned(econ, kind, name) {
	if (!econ) return false;
	if (kind === "hero") {
		return !!(econ.heroes && econ.heroes[name] != null);
	}
	return !!(econ.items && econ.items[name] != null);
}

function LocalizeItem(name) {
	var tryKeys = [
		"#DOTA_Tooltip_ability_" + name,
		"#DOTA_Tooltip_Ability_" + name,
		"#DOTA_Tooltip_Modifier_" + name,
		"#" + name,
	];
	for (var i = 0; i < tryKeys.length; i++) {
		var localized = $.Localize(tryKeys[i]);
		if (localized && localized !== tryKeys[i] && localized.charAt(0) !== "#") {
			return localized;
		}
	}
	return name;
}

function ToEntryList(section, kind) {
	var out = [];
	if (!section) return out;
	if (Array.isArray(section)) {
		for (var i = 0; i < section.length; i++) {
			var e = section[i];
			if (e && e.name) out.push({ name: e.name, price: e.price != null ? e.price : 0, kind: e.kind || kind });
		}
	} else {
		for (var key in section) {
			if (!Object.prototype.hasOwnProperty.call(section, key)) continue;
			var entry = section[key];
			if (entry && entry.name) out.push({ name: entry.name, price: entry.price != null ? entry.price : 0, kind: entry.kind || kind });
		}
	}
	return out;
}

/** NetTable доезжает до Panorama в виде map "0","1","2"... — собираем обратно в массив, сохраняя порядок индексов. */
function MapToOrderedList(section) {
	var out = [];
	if (!section) return out;
	if (Array.isArray(section)) {
		for (var i = 0; i < section.length; i++) {
			if (section[i]) out.push(section[i]);
		}
		return out;
	}
	var keys = [];
	for (var key in section) {
		if (Object.prototype.hasOwnProperty.call(section, key)) keys.push(key);
	}
	keys.sort(function (a, b) {
		return (parseInt(a, 10) || 0) - (parseInt(b, 10) || 0);
	});
	for (var k = 0; k < keys.length; k++) {
		var entry = section[keys[k]];
		if (entry) out.push(entry);
	}
	return out;
}

function BuildEntries(catalog) {
	if (!catalog) return [];
	var heroes = ToEntryList(catalog.heroes, "hero");
	var items = ToEntryList(catalog.items, "item");
	var combined = heroes.concat(items);
	combined.sort(function (a, b) {
		return (a.price || 0) - (b.price || 0);
	});
	return combined;
}

function UpdateCurrencyLabel(root, econ) {
	var currency = econ && econ.currency != null ? econ.currency : 0;
	if (root) root.SetDialogVariable("currency", String(currency));
}

function ZiFirstByClass(panel, className) {
	var found = panel.FindChildrenWithClassTraverse(className);
	return found && found.length ? found[0] : null;
}

function CreateShopCard(parent, entry, econ) {
	if (!parent) return;
	var card = $.CreatePanel("Panel", parent, "");
	card.BLoadLayoutSnippet("ZiShopItem");
	card.SetDialogVariable("name", LocalizeItem(entry.name));
	card.SetDialogVariable("price", String(entry.price));

	var img = ZiFirstByClass(card, "ZiShopItemCardImage");
	if (img) img.itemname = entry.name;

	var owned = IsOwned(econ, entry.kind, entry.name);
	var bottom = ZiFirstByClass(card, "ZiShopItemCardBottom");
	var ownedLabel = ZiFirstByClass(card, "ZiShopItemCardOwned");
	if (owned) {
		if (bottom) bottom.AddClass("IsHidden");
		if (ownedLabel) ownedLabel.RemoveClass("IsHidden");
	} else {
		if (bottom) bottom.RemoveClass("IsHidden");
		if (ownedLabel) ownedLabel.AddClass("IsHidden");
	}

	var buy = ZiFirstByClass(card, "ZiShopItemCardBuy");
	if (buy) {
		(function (kind, name) {
			buy.SetPanelEvent("onactivate", function () {
				if (IsOwned(GetLocalEconomy(), kind, name)) return;
				GameEvents.SendCustomGameEventToServer("economy_buy", {
					PlayerID: Players.GetLocalPlayer(),
					kind: kind,
					name: name,
				});
			});
		})(entry.kind, entry.name);
	}
}

function ClearShop(parent) {
	if (!parent) return;
	for (var i = parent.GetChildCount() - 1; i >= 0; i--) {
		var child = parent.GetChild(i);
		if (child) child.DeleteAsync(0);
	}
}

function UpdateShopStore() {
	var p = ZiPanels();
	if (!p.shopInside || !p.root) {
		$.Msg("[ZiStore] panels missing root=" + !!p.root + " shopInside=" + !!p.shopInside);
		return;
	}
	ClearShop(p.shopInside);
	var catalog = GetCatalog();
	var econ = GetLocalEconomy();
	UpdateCurrencyLabel(p.root, econ);
	var entries = BuildEntries(catalog);
	$.Msg("[ZiStore] catalog=" + (catalog ? "ok" : "null") + " entries=" + entries.length);
	if (entries.length === 0) {
		var hint = $.CreatePanel("Label", p.shopInside, "");
		hint.AddClass("ZiStoreEmptyHint");
		hint.text = catalog
			? "В каталоге нет позиций (проверь ответ /api/store/store_info)."
			: "Каталог не загружен: economy-сервер и ECONOMY_API_BASE; в консоли игры — [Economy] HTTP …";
		return;
	}
	for (var i = 0; i < entries.length; i++) {
		CreateShopCard(p.shopInside, entries[i], econ);
	}
}

function FormatNumber(value) {
	var n = Number(value);
	if (!isFinite(n)) return String(value || "");
	var s = String(Math.round(n));
	return s.replace(/\B(?=(\d{3})+(?!\d))/g, " ");
}

function CreateDonateCard(parent, pack) {
	if (!parent || !pack) return;
	var card = $.CreatePanel("Panel", parent, "");
	card.BLoadLayoutSnippet("ZiDonatePack");
	card.SetDialogVariable("title", String(pack.title || ""));
	card.SetDialogVariable("description", String(pack.description || ""));
	card.SetDialogVariable("price", String(pack.priceRub != null ? pack.priceRub : ""));
	card.SetDialogVariable("currency", FormatNumber(pack.currency || 0));
	var upgrade = Number(pack.upgradeCurrency || 0);
	card.SetDialogVariable("upgrade", FormatNumber(upgrade));
	card.SetDialogVariable("badge", String(pack.badge || ""));

	var badge = ZiFirstByClass(card, "ZiDonatePackBadge");
	if (badge) {
		if (!pack.badge || String(pack.badge).length === 0) badge.AddClass("IsHidden");
	}
	var upgradeRow = ZiFirstByClass(card, "ZiDonatePackUpgradeRow");
	if (upgradeRow && upgrade <= 0) upgradeRow.AddClass("IsHidden");

	var buy = ZiFirstByClass(card, "ZiDonatePackBuy");
	if (buy) {
		(function (packageId) {
			buy.SetPanelEvent("onactivate", function () {
				var localPid = Players.GetLocalPlayer();
				GameEvents.SendCustomGameEventToServer("donate_robokassa_buy", {
					PlayerID: localPid,
					id: localPid,
					packageId: packageId,
				});
				$.Msg("[ZiStore] donate_robokassa_buy packageId=" + packageId + " player=" + localPid);
				buy.AddClass("IsBusy");
				$.Schedule(2.5, function () {
					if (buy && buy.IsValid()) buy.RemoveClass("IsBusy");
				});
			});
		})(String(pack.id || ""));
	}
}

function UpdateShopPromo() {
	var p = ZiPanels();
	if (!p.shopPromo) return;
	var packs = MapToOrderedList(GetDonatePackages());
	if (packs.length === 0) {
		ZiHasPromo = false;
		p.shopPromo.AddClass("IsHidden");
		return;
	}
	var pack = packs[0];
	p.shopPromo.SetDialogVariable("title", String(pack.title || ""));
	p.shopPromo.SetDialogVariable("description", String(pack.description || ""));
	p.shopPromo.SetDialogVariable("priceRub", String(pack.priceRub != null ? pack.priceRub : ""));
	p.shopPromo.SetDialogVariable("currency", FormatNumber(pack.currency || 0));
	ZiHasPromo = true;
	var shopActive = p.tabShop && p.tabShop.BHasClass("IsActive");
	p.shopPromo.SetHasClass("IsHidden", !shopActive);
}

function UpdateDonatePacks() {
	var p = ZiPanels();
	if (!p.donateInside) return;
	ClearShop(p.donateInside);
	var raw = GetDonatePackages();
	var packs = MapToOrderedList(raw);
	$.Msg("[ZiStore] donate packs=" + packs.length);
	if (packs.length === 0) {
		var hint = $.CreatePanel("Label", p.donateInside, "");
		hint.AddClass("ZiStoreEmptyHint");
		hint.text = "Донат-паки ещё не загружены, попробуй позже.";
		return;
	}
	for (var i = 0; i < packs.length; i++) {
		CreateDonateCard(p.donateInside, packs[i]);
	}
}

/** Как в defension: ExternalBrowserGoToURL открывает системный браузер; DOTADisplayURL — запасной вариант. */
function ZiStoreOpenPaymentUrl(url) {
	if (!url) return;
	ZiCurrentPaymentUrl = String(url);
	$.DispatchEvent("ExternalBrowserGoToURL", ZiCurrentPaymentUrl);
}

function ZiStorePaymentShow(title, url) {
	var p = ZiPanels();
	if (!p.paymentModal) return;
	ZiCurrentPaymentUrl = String(url || "");
	if (p.paymentDialog) {
		p.paymentDialog.SetDialogVariable("title", String(title || ""));
		p.paymentDialog.SetDialogVariable("url", ZiCurrentPaymentUrl);
	}
	if (p.paymentCopied) p.paymentCopied.AddClass("IsHidden");
	p.paymentModal.AddClass("is-active");
}

function ZiStorePaymentHide() {
	var p = ZiPanels();
	if (p.paymentModal) p.paymentModal.RemoveClass("is-active");
}

function ZiStorePaymentOpen() {
	ZiStoreOpenPaymentUrl(ZiCurrentPaymentUrl);
}

function ZiStorePaymentCopy() {
	if (!ZiCurrentPaymentUrl) return;
	if (typeof $.SetClipboardText === "function") {
		$.SetClipboardText(ZiCurrentPaymentUrl);
	}
	var p = ZiPanels();
	if (p.paymentCopied) {
		p.paymentCopied.RemoveClass("IsHidden");
		$.Schedule(1.6, function () {
			if (p.paymentCopied && p.paymentCopied.IsValid()) p.paymentCopied.AddClass("IsHidden");
		});
	}
}

function ZiStoreSetupRefreshButton() {
	var p = ZiPanels();
	var refreshButton = p.refreshButton;
	if (!refreshButton) return;

	refreshButton.SetPanelEvent("onactivate", function () {
		if (refreshButton.BHasClass("is-disabled")) return;
		refreshButton.AddClass("is-disabled");
		var img = refreshButton.FindChildTraverse("ZiStoreRefreshImage");
		if (img) img.AddClass("is-spinning");
		if (p.shards) p.shards.AddClass("is-refreshing");

		var localPid = Players.GetLocalPlayer();
		GameEvents.SendCustomGameEventToServer("refresh_player_info", {
			PlayerID: localPid,
			id: localPid,
		});
	});
}

function ZiStoreOnRefreshDone() {
	var p = ZiPanels();
	var refreshButton = p.refreshButton;
	if (refreshButton) {
		refreshButton.RemoveClass("is-disabled");
		var img = refreshButton.FindChildTraverse("ZiStoreRefreshImage");
		if (img) img.RemoveClass("is-spinning");
	}
	if (p.shards) p.shards.RemoveClass("is-refreshing");
	UpdateCurrencyLabel(p.root, GetLocalEconomy());
	UpdateShopStore();
}

function ZiStoreShowDonateError(message) {
	var p = ZiPanels();
	if (!p.donateInside) return;
	var existing = p.donateInside.FindChild("ZiStoreDonateError");
	if (existing) existing.DeleteAsync(0);
	var label = $.CreatePanel("Label", p.donateInside, "ZiStoreDonateError");
	label.AddClass("ZiStoreDonateError");
	label.text = String(message || "Ошибка");
	$.Schedule(5.0, function () {
		if (label && label.IsValid()) label.DeleteAsync(0);
	});
}

function initStoreUi() {
	attachStoreButton();
	UpdateShopStore();
	UpdateDonatePacks();
	UpdateShopPromo();

	var p = ZiPanels();
	if (p.paymentOpen) p.paymentOpen.SetPanelEvent("onactivate", ZiStorePaymentOpen);
	if (p.paymentCopy) p.paymentCopy.SetPanelEvent("onactivate", ZiStorePaymentCopy);
	ZiStoreSetupRefreshButton();

	CustomNetTables.SubscribeNetTableListener("economy", function (_table, key, _value) {
		var keyStr = String(key);
		if (keyStr === "catalog" || keyStr === String(Players.GetLocalPlayer())) {
			UpdateShopStore();
		}
		if (keyStr === "donate_packages") {
			UpdateDonatePacks();
			UpdateShopPromo();
		}
	});

	GameEvents.Subscribe("donate_robokassa_payment_ready", function (data) {
		if (!data || !data.paymentUrl) return;
		ZiStoreOpenPaymentUrl(data.paymentUrl);
	});

	GameEvents.Subscribe("donate_robokassa_payment_error", function (data) {
		var msg = (data && data.message) || "Не удалось создать платёж. Попробуй позже.";
		$.Msg("[ZiStore] payment_error " + msg);
		ZiStoreShowDonateError(msg);
	});

	GameEvents.Subscribe("refresh_player_info_done", function (data) {
		ZiStoreOnRefreshDone();
		if (data && data.error) {
			ZiStoreShowDonateError(data.error);
		}
	});
}

$.Schedule(0, initStoreUi);
$.Schedule(0.2, attachStoreButton);
$.Schedule(1.0, ZiStorePulseTick);
