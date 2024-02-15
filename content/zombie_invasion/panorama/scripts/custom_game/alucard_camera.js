const dotaHud = (() => {
    let panel = $.GetContextPanel();
    while (panel) {
        if (panel.id === "DotaHud")
            return panel;
        panel = panel.GetParent();
    }
    return panel;
})();

GameEvents.Subscribe("alucard_camera", function(data) {
	dotaHud.style.visibility = "collapse";

GameUI.SetCameraDistance( 600   )
const dsa = 50
 
GameUI.SetCameraPitchMin( dsa )
GameUI.SetCameraPitchMax( dsa )

})

GameEvents.Subscribe("alucard_yaw", function(data) {

 GameUI.SetCameraYaw(Math.floor(Math.random() * (360 - 0)) + 0)
})


GameEvents.Subscribe("camera_comback", function(data) {
 GameUI.SetCameraYaw(0)
GameUI.SetCameraDistance( 1200 )
const dsa = 0
dotaHud.style.visibility = "visible";

GameUI.SetCameraPitchMin( dsa )
GameUI.SetCameraPitchMax( dsa )
})