#Requires -Version 7.5

# Linux-style listing
Set-Alias -Name ll -Value Get-ChildItem

# Cygnus Player Development Aliases
function ctest {
    adb shell input keyevent 224
    adb shell wm dismiss-keyguard
    ./gradlew test connectedDebugAndroidTest
}

function crun {
    adb shell input keyevent 224
    adb shell wm dismiss-keyguard
    ./gradlew installRelease
    adb shell am start -n com.festerhead.cygnusplayer/.MainActivity
}

function cdebug {
    adb shell input keyevent 224
    adb shell wm dismiss-keyguard
    ./gradlew installDebug
    adb shell am start -n com.festerhead.cygnusplayer/.MainActivity
}