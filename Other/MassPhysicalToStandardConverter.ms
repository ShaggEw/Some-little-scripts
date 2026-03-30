/**************************************************************************************************************************
// Mass Physical To Standard Material Converter v1.0
// This script was made by Shagg_E, 2024
// Based on kirilkalinoff's script from https://forums.autodesk.com/t5/3ds-max-forum/scene-converter-physical-material-to-standard-material/m-p/11153379/highlight/true#M201236
**************************************************************************************************************************/

theObjs = selection as array
doneObjects = 0
doneMM = 0

fn ConvertStdToPhysMtl mtlConv =
(
	---------------------------------------------
	--Actual conversion 
	---------------------------------------------
	format "Converting: %\n" mtlConv.name
	newMaterial = standardMaterial name:"Temp" diffuse:(color 255 255 255)

	--Rules:
	newMaterial.diffuse = mtlConv.Base_Color
	newMaterial.diffuseMap = mtlConv.Base_Color_Map
	newMaterial.opacityMap = mtlConv.trans_color_map

	--Add additional Rules here if you need them

	newMaterial.name = mtlConv.name+ "_standard"
	return newMaterial
)

for obj in theObjs do
(
    select obj
    mat = obj.material    --Get the material

    if classOf mat == PhysicalMaterial then    --Check if its a Physical Material
    (
        isNew = true
        exisitingMat = undefined
        for m in sceneMaterials do
        (
            if m.name == mat.name + "_standard" do  --Check to see if its already converted
            (
                isNew = false
                obj.material = m
                break
            )                
        )
        
        if isNew == false do 
        (
            
            continue
        )
        
		newMat = ConvertStdToPhysMtl mat
		obj.material = newMat
		doneObjects += 1
    )
	else if isKindOf mat Multimaterial do
	(
		--format "found you, beeeeaaaach\n"
		if (for m in mat.materialList where isKindOf m Standard collect m).count != 0 do
		(
			local mtlID = 0
			local oldDoneObj = doneObjects
			for m in mat.materialList do
			(
				mtlID += 1
				if classOf m == PhysicalMaterial do
				(
					newMat = ConvertStdToPhysMtl m
					mat.materialList[mtlID] = newMat
					doneObjects += 1
				)
			)
			if doneObjects > oldDoneObj do doneMM += 1
		)
	)
)

format "Materials Converted: %!\n" (doneObjects as string)
format "MultiMaterials Converted: %!\n\n" (doneMM as string)