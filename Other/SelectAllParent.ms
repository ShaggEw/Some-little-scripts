fn BSH_GEN_AddAllParents curNode srcArray =
(
	curNodePar = curNode.parent
	if curNodePar != undefined do
	(
		--appendIfUnique srcArray curNodePar
		append srcArray curNodePar
		BSH_GEN_AddAllParents curNodePar srcArray
	)
)

selArray = selection as array
selArray2 = #()
join selArray2 selArray
--selArray2 = copy selArray [#noMap]
--format "selArray:\n"
--print selArray
--format "selArray2:\n"
--print selArray2
for s in selArray do
(
	BSH_GEN_AddAllParents s selArray2
)
clearselection()
--print selArray2

for s in selArray2 do
(
	selectmore s
)