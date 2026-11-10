# Linux-style listing
Set-Alias -Name ll -Value Get-ChildItem

# Cygnus Player Development Aliases (v1.5 - Sanitized & Multi-device)
# Usage: crun (defaults to phone) or crun emu

function ctest {
    param([string]$target = "44201JEKB09382")
    if ($target -eq "emu") { $target = "emulator-5554" }

    $oldGradle = $env:GRADLE_HOME; $oldJava = $env:JAVA_HOME
    $env:GRADLE_HOME = $null; $env:JAVA_HOME = $null

    adb -s $target shell input keyevent 224
    adb -s $target shell wm dismiss-keyguard
    adb -s $target uninstall com.festerhead.cygnusplayer
    try {
        $env:ANDROID_SERIAL = $target
        ./gradlew test connectedDebugAndroidTest --no-configuration-cache
    } finally {
        $env:ANDROID_SERIAL = $null
    }

    $env:GRADLE_HOME = $oldGradle; $env:JAVA_HOME = $oldJava
}

function crun {
    param([string]$target = "44201JEKB09382")
    if ($target -eq "emu") { $target = "emulator-5554" }

    $oldGradle = $env:GRADLE_HOME; $oldJava = $env:JAVA_HOME
    $env:GRADLE_HOME = $null; $env:JAVA_HOME = $null

    adb -s $target shell input keyevent 224
    adb -s $target shell wm dismiss-keyguard
    adb -s $target uninstall com.festerhead.cygnusplayer
    try {
        $env:ANDROID_SERIAL = $target
        ./gradlew installRelease --no-configuration-cache
    } finally {
        $env:ANDROID_SERIAL = $null
    }
    adb -s $target shell am start -n com.festerhead.cygnusplayer/.MainActivity

    $env:GRADLE_HOME = $oldGradle; $env:JAVA_HOME = $oldJava
}

function cdebug {
    param([string]$target = "44201JEKB09382")
    if ($target -eq "emu") { $target = "emulator-5554" }

    $oldGradle = $env:GRADLE_HOME; $oldJava = $env:JAVA_HOME
    $env:GRADLE_HOME = $null; $env:JAVA_HOME = $null

    adb -s $target shell input keyevent 224
    adb -s $target shell wm dismiss-keyguard
    adb -s $target uninstall com.festerhead.cygnusplayer
    try {
        $env:ANDROID_SERIAL = $target
        ./gradlew installDebug --no-configuration-cache
    } finally {
        $env:ANDROID_SERIAL = $null
    }
    adb -s $target shell am start -n com.festerhead.cygnusplayer/.MainActivity

    $env:GRADLE_HOME = $oldGradle; $env:JAVA_HOME = $oldJava
}

function cauto {
    param([string]$target = "44201JEKB09382")
    if ($target -eq "emu") { $target = "emulator-5554" }

    # 1. Kill existing DHU on PC
    taskkill /IM desktop-head-unit.exe /F /T 2>$null

    # 2. Sanitize environment
    $oldGradle = $env:GRADLE_HOME; $oldJava = $env:JAVA_HOME
    $env:GRADLE_HOME = $null; $env:JAVA_HOME = $null

    # 3. Prepare phone
    adb -s $target shell input keyevent 224
    adb -s $target shell wm dismiss-keyguard
    adb -s $target uninstall com.festerhead.cygnusplayer
    adb -s $target forward tcp:5277 tcp:5277

    # 4. Build and Install
    try {
        $env:ANDROID_SERIAL = $target
        ./gradlew installDebug --no-configuration-cache
    } finally {
        $env:ANDROID_SERIAL = $null
    }

    # 5. Restore environment
    $env:GRADLE_HOME = $oldGradle; $env:JAVA_HOME = $oldJava

    # 6. Launch DHU as an independent process
    Write-Host "App installed. Launching DHU..." -ForegroundColor Cyan
    $dhuPath = "$env:LOCALAPPDATA\Android\Sdk\extras\google\auto\desktop-head-unit.exe"
    Start-Process -FilePath $dhuPath
}

function csync {
    git fetch origin
    git checkout main; git pull origin main
    git checkout develop; git merge main
    git push origin develop
}
