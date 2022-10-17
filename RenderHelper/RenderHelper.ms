/**************************************************************************************************************************
// Render Helper v0.01
// This script was made by Shagg_E, 2022
**************************************************************************************************************************/

/*********************************************************************************************************************************************************************/
--// RENDER SETTINGS ROLLOUT
/*********************************************************************************************************************************************************************/

rollout RenderSettings_Rollout "Render settings"
(
	group "Gamma settings"
	(
		spinner spn_InputGamma "File Input Gamma" range:[0,3,FileInGamma] type:#float align:#right fieldWidth:40
		spinner spn_OutputGamma "File Output Gamma" range:[0,3,FileOutGamma] type:#float align:#right fieldWidth:40
		button btn_GammaApply "Apply" align:#right
	)
	
	
	on btn_GammaApply pressed do 
	(
		FileInGamma = spn_InputGamma.value
		FileOutGamma = spn_OutputGamma.value
	)

)--end rollout

/*********************************************************************************************************************************************************************/
--// MACRO CALLS FOR UI
/*********************************************************************************************************************************************************************/

try (closeRolloutFloater SE_RHWindow) catch ()
SE_RHWindow = NewRolloutFloater "Render helper" 190 125 50 100
addRollout RenderSettings_Rollout SE_RHWindow --rolledUp:true