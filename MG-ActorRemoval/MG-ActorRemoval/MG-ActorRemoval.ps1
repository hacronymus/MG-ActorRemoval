#
# Script.ps1
#
# Reads in Actor.txt list
# User selects Actor from list
# Searches through videoFile folder for all instances of files that match Actor
# Asks user to confirm move of files to Archive folder

param($actorList,$videoFolder,$archiveFolder)

if(!$actorList) {$actorList = "D:\d3 projects\meangirls_BWAY\objects\table\Actors.txt"}
if(!$videoFolder) {$videoFolder = "D:\d3 projects\meangirls_BWAY\objects\videofile"}
if(!$archiveFolder) {$archiveFolder = "D:\d3 projects\meangirls_BWAY\archive"}

$actors = Get-Content -Path $actorList

$i = 0

foreach ($actor in $actors) {

	Write-Host ($i,"$actor")
	$i++
}
$chosenActor = Read-Host -Prompt "Enter number of actor to delete"

$chosenActor = $actors[$chosenActor]

Write-Debug ($chosenActor)

$files = Get-ChildItem -Path $videoFolder -Name *$chosenActor* -Recurse

Write-Debug ($files)

Write-Host("These files will be moved to Archive:")
foreach($file in $files){
	Write-Host($file)
}

$proceed = Read-Host -Prompt "Proceed with archiving? (Y/N)"
$proceed.ToUpper()

if($proceed -eq "Y") {
	$archiveFolder = $archiveFolder +"\" + $chosenActor

	Write-Debug $archiveFolder

	# Create Actor folder within archive folder

	if((Test-Path $archiveFolder)-eq $false) {
		Write-Host("Creating archive directory for $chosenActor")
		New-Item $archiveFolder -ItemType Directory
	}
	else {Write-Debug("Folder already exists")}

	Write-Host("Moving files to archive...")

	foreach($file in $files){

		Write-Host("Moving $file to $archiveFolder")

		Move-Item $videoFolder"\"$file -Destination $archiveFolder
	}

	Write-Host("Complete!") -ForegroundColor Green
	

}

else {
	Write-Host("Aborting.")-ForegroundColor Red
}

#Get-Content -Path $actorList | Where ($_ -ne $chosenActor) | Out-File "actors.txt" -Force
#$actorList -notmatch $chosenActor | Out-File "actors.txt" -Force


Read-Host -Prompt "Press Any Key to Exit"