//--constants
const GUIDE_BASIC_PAGE_COUNT = 3;
const GUIDE_ADVANCED_PAGE_COUNT = 5;
//--

//--variables
var selectedPage = null;
var selectedPageId = 1;
var selectedGuide = '';
var time = '00:00';
//--

//--init
(function () {
  GameEvents.Subscribe('zpr_show_quest', OnShowQuest);
 GameEvents.Subscribe("zpr_time", OnTime);
 
})();
//--
  var parent = $.GetContextPanel().GetParent();
  while (parent.id != 'Hud') parent = parent.GetParent();

 

//--CGE
function OnShowQuest(data) {
  const questItem = $('#quest_item-current');
  const countQuestItem = $('#quest_item-count');
  const rewardItem = $('#quest_item-reward');
  questItem.itemname = data['quest_item'];
  rewardItem.itemname = data['reward_item'];
  countQuestItem.text = data['value'];

  $('#quest_name').text = $.Localize('#DOTA_Tooltip_ability_' + data['an']);
  $('#quest_desc').text = $.Localize(
    '#DOTA_Tooltip_ability_' + data['an'] + '_Description'
  );
  if (data['rg'] === 0 && data['re'] === 0) {
    $('#quest_exp').text = '';
    $('#quest_gold').text = '';
  } else {
    $('#quest_exp').text =
      $.Localize('#DOTA_Tooltip_ability_' + data['an'] + '_reward_exp') +
      ' ' +
      data['re'];
    $('#quest_gold').text =
      $.Localize('#DOTA_Tooltip_ability_' + data['an'] + '_reward_gold') +
      ' ' +
      data['rg'];
  }

  $('#QPanel').SetHasClass('hide', false);
}

function OnTime(data) {
     const timePanel = parent.FindChildTraverse("TimeOfDay")
   timePanel.hittest = false
     const timePanelText= parent.FindChildTraverse("GameTime")

       if (data.isDevil) {
    time = "Edgard";
  } else {
    time = "66:66";
  }
   timePanelText.text = time;
   timePanelText.style.color = "#bf0000"
   timePanelText.style.textShadow = "20px 20px 80px 3.0 #333333b0"

 
}
//--

//--btns
function CloseQuest() {
  $('#QPanel').SetHasClass('hide', true);
}
//--

//--guide
function ToggleHTPPanel() {
  $('#HTPPanel').ToggleClass('hide');
  BasicGuide();
}

function GuideOpenPage(page, previous) {
  if (previous != null) {
    previous.SetHasClass('hide', true);
  }

  page.SetHasClass('hide', false);
  selectedPage = page;
}

function GuideNextPage() {
  if (selectedPageId < GetSelectedGuideMaxPagesCount()) {
    selectedPageId = selectedPageId + 1;
    GuideOpenPage($('#' + selectedGuide + selectedPageId), selectedPage);

    UpdatePageNumbDisplayer();
  }
}

function GuidePreviousPage() {
  if (selectedPageId > 1) {
    selectedPageId = selectedPageId - 1;
    GuideOpenPage($('#' + selectedGuide + selectedPageId), selectedPage);

    UpdatePageNumbDisplayer();
  }
}

function UpdatePageNumbDisplayer() {
  $('#PageNumb').text = selectedPageId + '/' + GetSelectedGuideMaxPagesCount();
}

function BasicGuide() {
  $('#basicguidebtn').SetHasClass('guideSelected', true);
  $('#advancedguidebtn').SetHasClass('guideSelected', false);

  selectedGuide = 'basic';
  selectedPageId = 1;
  GuideOpenPage($('#basic1'), selectedPage);
  UpdatePageNumbDisplayer();
}

function AdvancedGuide() {
  $('#basicguidebtn').SetHasClass('guideSelected', false);
  $('#advancedguidebtn').SetHasClass('guideSelected', true);

  selectedGuide = 'advanced';
  selectedPageId = 1;
  GuideOpenPage($('#advanced1'), selectedPage);
  UpdatePageNumbDisplayer();
}

function GetSelectedGuideMaxPagesCount() {
  if (selectedGuide == 'basic') return GUIDE_BASIC_PAGE_COUNT;
  if (selectedGuide == 'advanced') return GUIDE_ADVANCED_PAGE_COUNT;
}
//--

//--utils
function SecondsToMinsNSecs(seconds) {
  var mins = Math.floor(seconds / 60);
  var secs = Math.floor(seconds % 60);

  if (mins < 10) {
    mins = '0' + mins;
  }
  if (secs < 10) {
    secs = '0' + secs;
  }

  return mins + ':' + secs;
}
//--

 const dotaHud = (() => {
    let panel = $.GetContextPanel();
    while (panel) {
        if (panel.id === "DotaHud")
            return panel;
        panel = panel.GetParent();
    }
    return panel;
})();


const heroIconChange = ["npc_dota_hero_axe", "npc_dota_hero_bloodseeker","npc_dota_hero_bristleback","npc_dota_hero_crystal_maiden","npc_dota_hero_drow_ranger","npc_dota_hero_huskar","npc_dota_hero_juggernaut","npc_dota_hero_legion_commander","npc_dota_hero_medusa","npc_dota_hero_nevermore","npc_dota_hero_phantom_assassin","npc_dota_hero_phantom_lancer","npc_dota_hero_rubick","npc_dota_hero_sniper","npc_dota_hero_templar_assassin","npc_dota_hero_tidehunter","npc_dota_hero_treant","npc_dota_hero_troll_warlord","npc_dota_hero_tusk"]

const UpdateTopBar = () => {
  const cards = dotaHud.FindChildrenWithClassTraverse("TopBarPlayerSlot");

  cards.forEach((element) => { 
    const player_id = Number(element.id.match(/-?\d+(\.\d+)?/g)[0]);
    if (player_id < 0) return;  
    const hero = Players.GetPlayerHeroEntityIndex( player_id )
    const heroName = Entities.GetUnitName( hero )
    $.Msg("32")
    const heroImageDota = element.FindChildTraverse("HeroImage")
    if (!heroIconChange.find((element) => element === heroName)) {

          const heroImage = element.FindChildTraverse("HeroImageCustom")
          if (heroImage) heroImage.DeleteAsync(0) 
      return null
    } 
    const panel = element.FindChildTraverse("SlantedContainerPanel")


    const imageExist = element.FindChildTraverse("HeroImageCustom")

    if (!imageExist) {
        const image = $.CreatePanel("Image", panel, "HeroImageCustom", {
            class: "TopBarHeroImage __hasImage__",
            src: `file://{resources}/images/heroes/${heroName}_custom.png`,
            hittest: false
        });   
        image.style.zIndex = "4"
    } else {
      const heroImage = element.FindChildTraverse("HeroImageCustom")
      heroImage.DeleteAsync(0) 
        const image = $.CreatePanel("Image", panel, "HeroImageCustom", {
            class: "TopBarHeroImage __hasImage__",
            src: `file://{resources}/images/heroes/${heroName}_custom.png`,
                        hittest: false

        });      
                image.style.zIndex = "4"
   
    }
 
  })     
}

const Init = () => {
  const cards = dotaHud.FindChildrenWithClassTraverse("HeroImage");

    if (cards) {
       $.Schedule(2, () => UpdateTopBar())  
        return;
    } else {
       $.Schedule(0.03, () => Init());
    }
}


Init()
 

GameEvents.Subscribe("update_top_bar", () => UpdateTopBar()) 

const showBlackshopTooltip = () => {
  const hasPanel = $.GetContextPanel().FindChildTraverse("QPanelBlackshop")
  if (hasPanel) return null
  const snippet = $.CreatePanel("Panel", $.GetContextPanel(), "QPanelBlackshop")
  snippet.BLoadLayoutSnippet("blackShopTooltip")

  const button = snippet.FindChildTraverse("BlackshoopCloseButton")

  button.SetPanelEvent("onactivate", () => {
    snippet.DeleteAsync(0)
  })

  const buttonRefresh = snippet.FindChildTraverse("BlackshoopRefreshButton")
  buttonRefresh.SetPanelEvent("onactivate", () => {
    GameEvents.SendCustomGameEventToServer("refresh_blackshop", { 
      player: Players.GetLocalPlayer(),
    });
  })  
}

GameEvents.Subscribe('show_blackshop_tooltip', showBlackshopTooltip);


 
 
const opacityChange = (panel, opacity,up) => {
  if (opacity >= 0.7) up = false
  if (opacity <= 0.02) return panel.DeleteAsync(0)
  opacity = up ? opacity + 0.01 : opacity - 0.01
  panel.style.opacity = `${opacity}`

  $.Schedule(0.08, () => opacityChange(panel, opacity, up))
} 

const wakeUp = () => {
      Game.EmitSound("wake_up")
    const image = $.CreatePanel("Image", $.GetContextPanel(), "", { 
        src:`file://{resources}/images/custom_game/wake_up.png`, 
        class: "imageHorror",
        hittest: false, 
    }); 
    let opacity = 0.11
    let up = true
    opacityChange(image, opacity, up)
}

const wakeUpCicle = () => {
    wakeUp()

    $.Schedule(Math.floor(Math.random() * (60 - 20)) + 20, wakeUpCicle)
}

GameEvents.Subscribe("edgard_disable_exit", () => {
    dotaHud.FindChildTraverse("DashboardButton").style.visibility = "collapse";

    wakeUpCicle()
 
})

GameEvents.Subscribe("edgard_end", () => {
    dotaHud.GetChild(0).style.visibility = "collapse"
          const label = $.CreatePanel("Label", dotaHud, "", { 
        text: "ВЫ И ВПРАВДУ ДУМАЛИ ЧТО СМОЖЕТЕ ИЗГНАТЬ МЕНЯ???",
        class: "text__edgard",
        style: `font-size: 80px;ui-scale:200%;vertical-align:center;horizontal-align:center;text-align:center;`
    }); 

    let margin = -50
        $.Schedule(9, () => spamLaugh(margin))

     
})
 
const spamLaugh = (margin) => {
      const label = $.CreatePanel("Label", dotaHud, "", { 
        text: "АХАХАХАХАХАХХАХААХАХАХАХАХАХХАХААХАХАХАХАХАХХАХААХАХАХАХАХАХХАХААХАХАХАХАХАХХАХААХАХАХАХАХАХХАХААХАХАХАХАХАХХАХААХАХАХАХАХАХХАХА",
        class: "text__edgard",
        style: `font-size: 80px;ui-scale:200%;margin-top:${margin}px;margin-left: ${Math.floor(Math.random() * (60 - -30)) + -30}px;`
    }); 
      margin += 15

    $.Schedule(0.03, () => spamLaugh(margin))
}

GameEvents.Subscribe("wait_player", () => {
    dotaHud.GetChild(0).style.visibility = "collapse"
    Game.EmitSound("Scary")
    const image = $.CreatePanel("Image", dotaHud, "wait_player", { 
          src:`file://{resources}/images/custom_game/wait_cup.png`, 
        style: `height: 100%;width:100%;`
    }); 
})

GameEvents.Subscribe("disable_wait_player", () => {
    Game.StopSound("Scary")
    dotaHud.GetChild(0).style.visibility = "visibility"
    dotaHud.FindChildTraverse("wait_player").DeleteAsync(0)
})