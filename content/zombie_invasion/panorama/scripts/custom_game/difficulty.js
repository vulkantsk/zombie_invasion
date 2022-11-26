const diffLabels = {};

const diff_text = (diff) => $.Localize(diff);

const select_difficulty = (diff) => {
  GameEvents.SendCustomGameEventToServer("invasion_select_difficulty", {
    diff: diff,
  });
};

const update_difficulty_selections = (data) => {
  for (let diff in data) {
    const value = data[diff];

    if (Number(value) > 0) {
      diffLabels[diff].text = (diff_text(diff) + " - " + value).toUpperCase();
    }
  }
};

(() => {
  const parent = $.GetContextPanel();

  for (let diff of ["normal", "medium", "hard"]) {
    const button = $.CreatePanel("Button", parent, "");
    button.AddClass(diff);
    const imgPanel = $.CreatePanel("Panel", button, "");
    const label = $.CreatePanel("Label", button, "");
    label.text = diff_text(diff);

    button.SetPanelEvent("onactivate", () => {
      select_difficulty(diff);
    });

    button.SetPanelEvent("onmouseover", () => {
      button.SetHasClass("Hovered", true);
      $.DispatchEvent(
        "UIShowTextTooltip",
        button,
        $.Localize("#difficulty_description_" + diff)
      );
    });

    button.SetPanelEvent("onmouseout", () => {
      button.SetHasClass("Hovered", false);
      $.DispatchEvent("UIHideTextTooltip", button);
    });

    diffLabels[diff] = label;
  }

  parent.GetParent().style.marginLeft = "0px";

  GameEvents.Subscribe(
    "update_difficulty_selections",
    update_difficulty_selections
  );
})();
