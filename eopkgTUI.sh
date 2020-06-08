#!/bin/bash

# Dont wanna add any fancy ascii logo
 
function findHistory(){
    declare -i HS=$(eopkg hs | grep 'Operation' | wc -l)
    declare -i IN=$(echo $1 | cut -c2- | cut -d: -f1)
    declare -i HS1=$HS-$IN
    declare -i HS2=$HS1+1
    eopkg hs -l $HS2
}
export -f findHistory


function eopkgUpdate
{
	sudo eopkg ur
}
function eopkgUpgrade
{
	sudo eopkg up
}

function eopkgInstall 
{
	package="$( eopkg la | fzf -i -e --multi --no-sort --cycle --ansi \
                        --preview 'eopkg info {1} '\
                        --header="Press TAB to (Un)Select, ENTER to install and  ESC to menu." \
                        --prompt="Search > " | awk '{print $1}'                                                  
            )"
            if [[ -n "$package" ]]
            then 
            sudo eopkg it $package
            fi
}

function eopkgRemove
{
	package="$( eopkg li | fzf -i -e --multi --no-sort --cycle --reverse  \
                        --preview 'eopkg bl {1} '\
                        --header="Press TAB to (Un)Select, ENTER to remove and ESC to menu." \
                        --prompt="Search > " | awk '{print $1}'                                                  
            )"
            if [[ -n "$package" ]]
            then 
            sudo eopkg rm $package
            fi
}

function eopkgDeleteCache
{
	sudo eopkg dc
}

function eopkgDeleteOrphans
{
	sudo eopkg rmo
}

function eopkgBlame
{   
	eopkg li | fzf -i --preview 'eopkg bl {1}' --cycle --header="Press Esc to menu" \
                      --prompt="Search  > "                                                  
} 

function eopkgInfo
{
	eopkg li | fzf -i --preview 'eopkg info {1}' --cycle --header="Press Esc to menu" \
                      --prompt="Search  > "
}

function eopkgHistory
{
    eopkg hs | grep 'Operation' | fzf -i -e --no-sort --select-1 --cycle \
                    --preview "findHistory {2}" --header="Press Esc to menu" \
                    --prompt="Search > "
}

function eopkgHelp
{
	eopkg ? | fzf -i --preview 'eopkg {1} --help' --header-lines=4 --cycle \
                     --header="Press Esc to menu" --prompt="Search  > "
}

function eopkgDevTools
{
	sudo eopkg install -c system.devel
}

function eopkgSystemCheck
{
    sudo eopkg check | grep Broken | awk '{print $4}' | xargs sudo eopkg it --reinstall
}


function eopkgTui
{
while true
do
clear
echo
    
    echo "                                               Solus eopkg TUI "
    echo "
  ┌───────────────────────────────────────────────────────────────────────────────────────────────┐
  │                                                                                               │
  │            1   Update repo [ur]                       2   Upgrade package [up]                │
  │            3   Install package(s) [it]                4   Remove package(s) [rm]              │
  │            5   Delete cache [dc]                      6   Remove orphans [rmo]                │
  │            7   Package details [bl]                   8   Package info [info]                 │
  │            9   History [hs]                          10   Help [h]                            │
  │           11   Install dev tool [tools]              12   System Check [ch]                   │
  │                                                                                               │ 
  └───────────────────────────────────────────────────────────────────────────────────────────────┘
    
    "
    echo -e "Enter the number or squared letters   -   0 or q to Quit "
    read -r choice
    choice="$(echo "$choice" | tr '[:upper:]' '[:lower:]' )"
    echo
    
    case "$choice" in
        1|ur)
            eopkgUpdate                                                                 
            echo
            echo -e "Repositories updated. Press ENTER "
            read
            ;;
        2|up)
            eopkgUpgrade                                                                 
            echo
            echo -e "Packages upgraded. Press ENTER "
            read
            ;;
        3|it)
            eopkgInstall
            echo
            echo -e "Package(s) installed. Press ENTER "
            read
            ;;
        4|rm)
            eopkgRemove
            echo
            echo -e "Package(s) removed. Press ENTER "
            read
            ;;
        5|dc )
            eopkgDeleteCache
            echo
            echo -e "Cached packages deleted. Press ENTER "
            read
            ;;
        6|rmo )
            eopkgDeleteOrphans
            echo
            echo -e "Orphan packages deleted. Press ENTER "
            read
            ;;
        7|bl )
            eopkgBlame
            echo
            echo -e "Press ENTER "
            read
            ;;
        8|info )
            eopkgInfo
            echo
            echo -e "Press ENTER "
            read
            ;;
        9|hs )
            eopkgHistory
            echo
            echo -e "Press ENTER "
            read
            ;;
        10|h )
            eopkgHelp
            echo
            echo -e "Press ENTER "
            read
            ;;
       11|tools )
            eopkgDevTools
            echo
            echo -e "Base development tools installed. Press ENTER "
            read
            ;;
       12|ch )
            eopkgSystemCheck
            echo
            echo -e "System check done. Press ENTER "
            read
            ;;
        0|q|Q|quit|$'\e'|$'\e'$'\e' )
        clear && exit
            ;;
            
            * )                                                                         
            echo -e "Idiot!!! try again."
            sleep 2
            ;;
            
      esac   
      done
}
	
eopkgTui
