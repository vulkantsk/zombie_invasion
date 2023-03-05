const diffLabels = {};

const diff_text = (diff) => $.Localize(diff);

const select_heroes = (diff) => {
  GameEvents.SendCustomGameEventToServer('invasion_select_one_down', {
    diff: diff,
  });
};

(() => {
  const parent = $.GetContextPanel();

  for (let diff of ['onedown']) {
    const button = $.CreatePanel('Button', parent, '');
    // button.AddClass(diff);
    const imgPanel = $.CreatePanel('Panel', button, '');
    const label = $.CreatePanel('Label', button, '');

    button.AddClass('but');

    button.SetPanelEvent('onactivate', () => {
      button.AddClass('on');
      select_heroes(diff);
    });

    button.SetPanelEvent('onmouseover', () => {
      button.SetHasClass('Hovered', true);
      $.DispatchEvent(
        'UIShowTextTooltip',
        button,
        $.Localize('#difficulty_description_' + diff)
      );
    });

    button.SetPanelEvent('onmouseout', () => {
      button.SetHasClass('Hovered', false);
      $.DispatchEvent('UIHideTextTooltip', button);
    });

    diffLabels[diff] = label;
  }
})();
