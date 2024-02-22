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
  //-- GameEvents.Subscribe("zpr_time", OnTime);
  $.Schedule(0.3, function () {
    uhax(hax());
  });
})();
//--

//hack
function hax() {
  var parent = $.GetContextPanel().GetParent();
  while (parent.id != 'Hud') parent = parent.GetParent();

  return parent;
}
function uhax(parent) {
  //-- parent.FindChildTraverse("GameTime").text = time;

  $.Schedule(0.5, function () {
    uhax(parent);
  });
}
//

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
  time = SecondsToMinsNSecs(data['time']);
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


 
// const UpdateTopBar = () => {
//   const cards = dotaHud.FindChildrenWithClassTraverse("TopBarPlayerSlot");

//   cards.forEach((element) => { 
//     const player_id = Number(element.id.match(/-?\d+(\.\d+)?/g)[0]);
//     if (player_id < 0) return;  
//     const hero = Players.GetPlayerHeroEntityIndex( player_id )
//     const heroName = Entities.GetUnitName( hero )

//     const panel = element.FindChildTraverse("SlantedContainerPanel")

//     const imageExist = element.FindChildTraverse("HeroImage")

//     if (!imageExist.BHasClass("__hasImage__")) {
//         const image = $.CreatePanel("Image", panel, "HeroImage", {
//             class: "TopBarHeroImage __hasImage__",
//             src: `file://{resources}/images/heroes/${heroName}.png`,
//         });   
//       const heroImage = element.FindChildTraverse("HeroImage")
//       heroImage.DeleteAsync(0) 
//     } else {
//       const heroImage = element.FindChildTraverse("HeroImage")
//       heroImage.DeleteAsync(0) 
//         const image = $.CreatePanel("Image", panel, "HeroImage", {
//             class: "TopBarHeroImage __hasImage__",
//             src: `file://{resources}/images/heroes/${heroName}.png`,
//         });         
//     }
 
//   })     
// }

// //UpdateTopBar()

// GameEvents.Subscribe("update_top_bar", () => UpdateTopBar())