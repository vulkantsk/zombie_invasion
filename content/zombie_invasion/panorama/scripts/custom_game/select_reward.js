const necrImage = $('#reward__necr');

let uiScaleNecr = 70;

const giveReward = (props) => {
  const rewards = Object.values(props.rewards);
  uiScaleNecr = 70;
  necrImage.style.uiScale = `70%`;

  const mainPanel = $('#reward');
  const bodyContainer = $('#reward__body');
  mainPanel.RemoveClass('is-hide');

  rewards.map((element) => {
    const button = $.CreatePanel('Button', bodyContainer, '');
    const item = $.CreatePanel('DOTAItemImage', button, '');
    item.itemname = element;
    button.AddClass('reward__button');
    item.AddClass('reward__reward');

    button.SetPanelEvent('onactivate', () => {
      mainPanel.AddClass('is-hide');
      bodyContainer.RemoveAndDeleteChildren();
      GameEvents.SendCustomGameEventToServer('get_reward', {
        id: Players.GetLocalPlayer(),
        item: element,
        
      });
    });
  });
};

necrImage.SetPanelEvent('onactivate', () => {
  uiScaleNecr = uiScaleNecr + 1;
  necrImage.style.uiScale = `${Math.min(80, uiScaleNecr)}%`;
  Game.EmitSound('anime_chan');
});

GameEvents.Subscribe('give_reward', giveReward);
