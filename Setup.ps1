if(Test-Path .\Nuke.Unreal) {
    "Nuke.Unreal is already set up for this project. Enjoy!"
}
else {
    if(-not (Test-Path .\.nuke)) {
        "Fetching Nuke.Unreal boilerplate."
        Import-Module BitsTransfer

        $downloadDir = ".\.temp"
        $zipFile = "$downloadDir\Nuke.Unreal.Workflow.zip"

        mkdir $downloadDir

        Start-BitsTransfer `
            -Source "https://github.com/microdee/Nuke.Unreal.WorkflowTemplate/archive/refs/heads/main.zip" `
            -Destination $zipFile `
            -ErrorAction Stop `
            -Dynamic
        Expand-Archive -Path $zipFile -DestinationPath $downloadDir -ErrorAction Stop
        
        Robocopy.exe "$downloadDir\Nuke.Unreal.WorkflowTemplate-main" . * `
            /S /njh /njs /ndl /xf Setup.ps1

        if(Test-Path .\.git) {
            git.exe submodule add https://github.com/microdee/Nuke.Unreal.git Nuke.Unreal
        }
        else {
            $zipFile = "$downloadDir\Nuke.Unreal.zip"
            Start-BitsTransfer `
                -Source "https://github.com/microdee/Nuke.Unreal/archive/refs/heads/main.zip" `
                -Destination $zipFile `
                -ErrorAction Stop `
                -Dynamic
            Expand-Archive -Path $zipFile -DestinationPath $downloadDir -ErrorAction Stop
            
            Robocopy.exe "$downloadDir\Nuke.Unreal-main" .\Nuke.Unreal * `
                /S /njh /njs /ndl /xf
        }

        Remove-Item $downloadDir -Force -ErrorAction Stop -Recurse
    }
}

