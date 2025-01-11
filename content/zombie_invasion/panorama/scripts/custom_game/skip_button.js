(() => {
  const button = $("#MyCustomButton");
  const buttonLabel = button.GetChild(0);

  // Проверяем, является ли текущий игрок первым игроком (ID = 0)
  const isFirstPlayer = Game.GetLocalPlayerID() === 0;

  if (button) {
    // Если это не первый игрок, полностью скрываем кнопку
    if (!isFirstPlayer) {
      button.visible = false;
      return;
    }

    button.SetPanelEvent("onactivate", () => {
      Game.EmitSound("ui.button_click");

      // Функция проверки времени суток
      const checkTimeOfDay = () => {
        const gameTime = Math.floor(Game.GetDOTATime(false, false) / 60); // Делим на 60 для получения минут
        const isNightTime = gameTime % 10 === 5; // Ночь начинается на 5-й минуте каждого 10-минутного цикла
        const isDayTime = gameTime % 10 === 0; // День начинается на 0-й минуте

        if (isNightTime) {
          button.enabled = false;
          buttonLabel.text = $.Localize("#skip_night_not_available");
        } else if (isDayTime && button.enabled) {
          button.enabled = true;
          buttonLabel.text = $.Localize("#skip_night_pressed");
        } else if (isDayTime) {
          button.enabled = true;
          buttonLabel.text = $.Localize("#skip_night");
        }

        $.Schedule(3.22, checkTimeOfDay);
      };

      GameEvents.SendCustomGameEventToServer("skip_night", {
        player_id: Game.GetLocalPlayerID(),
      });
      buttonLabel.text = $.Localize("#skip_night_pressed");

      // Запускаем проверку времени
      checkTimeOfDay();
    });
  }
})();
