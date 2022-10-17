/**************************************************************************************************************************
// Delete Selection Sets v1.2
// This script was made by Shagg_E, 2022
**************************************************************************************************************************/

global DSS_Rollout
callbacks.removeScripts id:#se_dssupdate

/*********************************************************************************************************************************************************************/
--// DELETE SELECTION SETS ROLLOUT
/*********************************************************************************************************************************************************************/

rollout DSS_Rollout "Delete Selection Sets" width:132 height:170
(
	group "Selection Sets:"
	(
		spinner spn_SelSetsFound "Found: " range:[-1, 100000, 0] type:#integer align:#left offset:[2,0] fieldwidth:45 across:2 enabled:false
		button btn_SelSetsFoundUpdate "Update!" width:50 height:18 pos:[114,25] tooltip:"Updates the numper of found Selection Sets in the scene."
	)	
	group "Delete Selection Sets:"
	(	
		spinner spn_SelSetsDeleteOnly "Delete only: " range:[-1, 100000, 20] type:#integer align:#left offset:[2,0] fieldwidth:45 across:2 --enabled:false
		button btn_SelSetsDeleteOnlyOk "Ok!" width:30 height:18 pos:[134,72] tooltip:"Deletes the selected amount of Selection Sets.\nUse this option if you have troubles with ''Delete ALL Selection Sets'' option."
		button btn_DeleteAllSelectionSets "Delete ALL Selection Sets" width:150 tooltip:"Deletes ALL Selection Sets in the scene."
		progressbar prgb_dss color:orange
	)
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	fn SelectionSetsCountFoundUpdate =
	(
		spn_SelSetsFound.value = selectionSets.count
	)
	
	fn DeleteSelectionSetsFunction sSCount =
	(
		if (sSCount > selectionSets.count) do sSCount = selectionSets.count
		local sSCurrent
		local sSErrorCount = 0
		local DSS_msg = "There're " + (selectionSets.count as string) + " selection sets in the scene!\nAre you sure you want to delete " + (sSCount as string) + " sets?"
		if (queryBox DSS_msg title:"WARNING") do
		(
			for i = 1 to sSCount do
			(
				prgb_dss.value = 100.*i/sSCount
				try (sSCurrent = selectionSets[1])
				catch (sSError = sSError + 1)
				if (isdeleted sSCurrent) == false do (deleteItem selectionSets sSCurrent)
			)
			DSS_msg = (sSCount as string) + " selection sets were deleted due this operation.\n" + (selectionSets.count as string) + " selection sets are left in the scene.\n\nThere were " + (sSErrorCount as string) + " errors due the operation.\nHave fun!"
			messagebox DSS_msg title:"You're welcome"
			prgb_dss.value = 0
		)
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/

	on DSS_Rollout  open do
	(
		callbacks.addScript #selectionSetChanged "DSS_Rollout.SelectionSetsCountFoundUpdate()" id:#se_dssupdate
		SelectionSetsCountFoundUpdate()
	)

	on DSS_Rollout  close do
	(
		callbacks.removeScripts id:#se_dssupdate
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	on btn_SelSetsFoundUpdate pressed do
	(
		SelectionSetsCountFoundUpdate()
	)	
	
	on btn_SelSetsDeleteOnlyOk pressed do
	(
		DeleteSelectionSetsFunction spn_SelSetsDeleteOnly.value
		SelectionSetsCountFoundUpdate()
	)
	
	on btn_DeleteAllSelectionSets pressed do
	(
		DeleteSelectionSetsFunction selectionSets.count
		SelectionSetsCountFoundUpdate()
	)
)

/*********************************************************************************************************************************************************************/
--// MACRO CALLS FOR UI
/*********************************************************************************************************************************************************************/

try (closeRolloutFloater SE_DSSWindow) catch ()
SE_DSSWindow = NewRolloutFloater "Delete Selection Sets" 190 170 50 100
addRollout DSS_Rollout SE_DSSWindow --rolledUp:true