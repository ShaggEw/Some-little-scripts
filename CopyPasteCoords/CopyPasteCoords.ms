/**************************************************************************************************************************
// CopyPaste Coords v1.1
// This script was made by Shagg_E, 2022
**************************************************************************************************************************/

global CPC_Rollout
callbacks.removeScripts id:#se_cpcupdate

global status_PrcssCPC = 0
global status_PreviousNode
global status_PreviousCoords

/*********************************************************************************************************************************************************************/
--// COPYPASTE COORDS ROLLOUT
/*********************************************************************************************************************************************************************/

rollout CPC_Rollout "CopyPaste Coords" width:400 height:70
(
	edittext edt_Coords "Object coords:" text:"Select the object and paste the coords here" height:20 fieldWidth:350 labelOnTop:true enabled:false align:#left across:2
	button btn_ObjectCoordsUpdate "Update!" width:50 height:38 align:#right tooltip:"Updates the coordinates of the selected object if it doesn't worked automatically."
	label lbl_PrcssCPC "Status: Ready..." align:#left across:2 tooltip:"Current process info"
	button btn_ObjectCoordsUndo "Undo" width:40 height:18 align:#right enabled:false tooltip:"Returns the coordinates of the selected object to the previous ones (before the last change)."
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	fn ObjectCoordsUpdate =
	(
		if selection.count > 0 then
		(
			if selection.count == 1 then
			(
				edt_Coords.text = (in coordsys world $.position.x as string) + ", " + (in coordsys world $.position.y as string) + ", " + (in coordsys world $.position.z as string)
				edt_Coords.enabled = true
				if status_PrcssCPC == 0 or status_PreviousNode != $ do
				(
					lbl_PrcssCPC.text = "Status: One object selected"
					status_PreviousNode = $
					status_PreviousCoords = undefined
					btn_ObjectCoordsUndo.enabled = false
				)
			)
			else
			(
				edt_Coords.text = ">>> Select ONE object and paste the coords here <<<"
				edt_Coords.enabled = false
				lbl_PrcssCPC.text = "Status: " + selection.count as string + " objects selected"
				status_PrcssCPC = 0
				status_PreviousNode = undefined
			)
		)
		else
		(
			edt_Coords.text = ">>> Select the object and paste the coords here <<<"
			edt_Coords.enabled = false
			lbl_PrcssCPC.text = "Status: Ready!"
			status_PrcssCPC = 0
			status_PreviousNode = undefined
		)
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/

	on CPC_Rollout  open do
	(
		callbacks.addScript #selectionSetChanged "CPC_Rollout.ObjectCoordsUpdate()" id:#se_cpcupdate
		callbacks.addScript #manipulateModeOn "CPC_Rollout.ObjectCoordsUpdate()" id:#se_cpcupdate
		callbacks.addScript #manipulateModeOff "CPC_Rollout.ObjectCoordsUpdate()" id:#se_cpcupdate
		ObjectCoordsUpdate()
	)

	on CPC_Rollout  close do
	(
		callbacks.removeScripts id:#se_cpcupdate
	)
	
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------------------------*/
	
	on edt_Coords entered txt do
	(
		if selection.count > 0 then
		(
			if selection.count == 1 then
			(
				local fs
				try (fs = filterString edt_Coords.text ",") catch(lbl_PrcssCPC.text = "WARNING: WRONG coordinates!") --Parses string based on " , " and returns an array of strings
				status_PrcssCPC = 1
				status_PreviousNode = $
				if fs.count == 3 then
				(
					lbl_PrcssCPC.text = "Status: Input coords done!"
					status_PreviousCoords = (in coordsys world $.position.x as string) + ", " + (in coordsys world $.position.y as string) + ", " + (in coordsys world $.position.z as string)
					try (in coordsys world $.position.x = fs[1] as float) catch(lbl_PrcssCPC.text = "Status: x coord is broken!")
					try (in coordsys world $.position.y = fs[2] as float) catch(lbl_PrcssCPC.text = "Status: y coord is broken!")
					try (in coordsys world $.position.z = fs[3] as float) catch(lbl_PrcssCPC.text = "Status: z coord is broken!")
					btn_ObjectCoordsUndo.enabled = true
				)
				else
				(
					lbl_PrcssCPC.text = "WARNING: WRONG coordinates!"
					status_PreviousCoords = undefined
					btn_ObjectCoordsUndo.enabled = false
				)
			)
			else
			(
				edt_Coords.text = ">>> Select ONE object and paste the coords here <<<"
				edt_Coords.enabled = false
				lbl_PrcssCPC.text = "Status: " + selection.count as string + " objects selected"
				status_PrcssCPC = 0
				status_PreviousNode = undefined
				status_PreviousCoords = undefined
				btn_ObjectCoordsUndo.enabled = false
			)
		)
		else
		(
			edt_Coords.text = ">>> Select the object and paste the coords here <<<"
			edt_Coords.enabled = false
			lbl_PrcssCPC.text = "Status: Ready!"
			status_PrcssCPC = 0
			status_PreviousNode = undefined
		)
	)
	
	on btn_ObjectCoordsUpdate pressed do
	(
		ObjectCoordsUpdate()
	)
	
	on btn_ObjectCoordsUndo pressed do
	(
		if selection.count == 1 and status_PreviousCoords != undefined and status_PreviousNode != undefined do
		(
			local fs
			try (fs = filterString status_PreviousCoords ",") catch() --Parses string based on " , " and returns an array of strings
			if fs.count == 3 then
			(
				lbl_PrcssCPC.text = "Status: Undo coords done!"
				try (in coordsys world status_PreviousNode.position.x = fs[1] as float) catch(lbl_PrcssCPC.text = "Status: x coord is broken!")
				try (in coordsys world status_PreviousNode.position.y = fs[2] as float) catch(lbl_PrcssCPC.text = "Status: y coord is broken!")
				try (in coordsys world status_PreviousNode.position.z = fs[3] as float) catch(lbl_PrcssCPC.text = "Status: z coord is broken!")
				edt_Coords.text = status_PreviousCoords
				status_PreviousCoords = undefined
				btn_ObjectCoordsUndo.enabled = false
			)
		)
	)
)

/*********************************************************************************************************************************************************************/
--// MACRO CALLS FOR UI
/*********************************************************************************************************************************************************************/

try (closeRolloutFloater SE_CPCWindow) catch ()
SE_CPCWindow = NewRolloutFloater "CopyPaste Coords" 450 98 50 100
addRollout CPC_Rollout SE_CPCWindow --rolledUp:true