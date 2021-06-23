(function () {	
	GameEvents.Subscribe( "zpr_show_quest", OnShowQuest);
	//$.Schedule(0.3, function(){uhax(hax())})
})();

//hack
/*
function hax()
{
	var parent = $.GetContextPanel().GetParent();
	while(parent.id != "Hud")
		parent = parent.GetParent();

	return parent;
}
function uhax(parent)
{
	
	
	$.Schedule(0.5, function () {
		uhax(parent)
	})
}
*/
//

//CGE
function OnShowQuest(data)
{
	$("#quest_name").text = $.Localize("DOTA_Tooltip_ability_" + data["an"])
	$("#quest_desc").text = $.Localize("DOTA_Tooltip_ability_" + data["an"] + "_Description")
	$("#quest_req").text = $.Localize("DOTA_Tooltip_ability_" + data["an"] + "_value_required") + " " + data["rq"]
	$("#quest_exp").text = $.Localize("DOTA_Tooltip_ability_" + data["an"] + "_reward_exp") + " " + data["re"]
	$("#quest_gold").text = $.Localize("DOTA_Tooltip_ability_" + data["an"] + "_reward_gold") + " " + data["rg"]
	$("#QPanel").SetHasClass("hide", false)
}
//

//btns
function CloseQuest()
{
	$("#QPanel").SetHasClass("hide", true)
}
//