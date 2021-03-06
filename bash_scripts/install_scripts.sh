#!/usr/bin/env bash

green="\033[0;32m"
red="\033[0;31m"
cyan="\033[0;36m"
nc="\033[0m"
blue="\033[1;34m"
yellow="\033[1;33m"
lightPurple='\033[1;35m'

isTest=${1}
user_input=${2}

#echo -e "${lightPurple}
#    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#    Running Phase BRAVO Installation
#    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#    ${nc}"

#--------------------------------------------------------------------
#Discover -> parameter val 1
#SMBExec -> param val 2
#Veil -> Param 3
#PeepingTom -> param 4
#EyeWitness -> param 5
#PowerSploit -> param 6
#Responder -> param 7
#Social Engineering Toolkit (SET) -> param 8
#Fuzzling Lists (SecLists) -> param 9
#--------------------------------------------------------------------
function filePath() {
    if (( ${1} == 1 ));then
        #discover
        echo /opt/discover
    elif (( ${1} == 2 )); then
        #SMBExec
        echo /opt/smbexec
    elif (( ${1} == 3 )); then
        #Veil
        echo /opt/Veil
    elif (( ${1} == 4 )); then
        # Peeping Tom
        echo /opt/peepingtom
    elif (( ${1} == 5 )); then
        # Eye Witness
        echo /opt/EyeWitness
    elif (( ${1} == 6 )); then
        # PowerSploit
        echo /opt/PowerSploit
    elif (( ${1} == 7 )); then
        #Responder
        echo /opt/Responder
    elif (( ${1} == 8 )); then
        # Social Engineering ToolKit (SET)
        echo /opt/set
    elif (( ${1} == 9 )); then
        # Fuzzing Lists (SecLists)
        echo /opt/SecLists
    else
        # Invalid Parameter
        echo -e "${red}Invalid parameter for function!!${nc}"
        exit 255
    fi
}

#--------------------------------------------------------------------
# :param
# Parameter 1) script/filename. ${1}
# Parameter 2) filePath ${2}
# Parameter 3) url ${3}
# Parameter 4) extra message {during installation period}
# Parameter 5) Short name (For mentioning phases)
# Other files and installation will be done from the calling function.
# :return
# first install -> 0
# success (move on)[NO INSTALL] -> 10
# keep old, run the installation again -> 20
# rm old, fresh clone -> 30
#--------------------------------------------------------------------
function clone_script() {
    echo -e "
    ${yellow}#####################################${nc}
    Installing ${1}
    ${4}
    ${yellow}#####################################${nc}
    "
    local directory=$(filePath ${2})
    sleep 2s ## sleep sleep sleep
    if [ ! -d ${directory} ];then
        # install the script
        if (( ${2} == 8 )); then
            # Special Case
            # Social Engineering ToolKit (SET)
            cd /opt/ && git clone ${3} set/
            ## if the previous commit failed to run.
            if [ $? -ne 0 ];then
                echo -e "${red} Error installing ${short_name}${nc}"
                exit 255
            fi
        else
            cd /opt/ && git clone ${3}
            ## if the previous commit failed to run.
            if [ $? -ne 0 ];then
                echo -e "${red} Error installing ${short_name}${nc}"
                exit 255
            fi
        fi
        echo -e "${green}${5} installation is complete.${nc}"
        sleep 2s ## sleep sleep sleep

        return 0 ## fresh first install
    else
        # directory exists.
        if [ ${isTest} == 'True' ];then
            ### Testing running in 30 again.
            echo -e "Removing old directory of ${5}${nc}"
            rm -rf ${directory}
            ## if the previous commit failed to run.
            if [ $? -ne 0 ];then
                echo -e "${red} Error installing ${short_name}${nc}"
                exit 255
            fi
            # installing fresh
            cd /opt/ && git clone ${3}
            ## if the previous commit failed to run.
            if [ $? -ne 0 ];then
                echo -e "${red} Error installing ${short_name}${nc}"
                exit 255
            fi
            sleep 2s ## sleep sleep sleep
            return 30 ## cloned fresh, need to run installation again!
        else
            echo -e "A folder named ${5} already exist!Choose your options:
            ${blue}1)${nc} ${5} is already installed. Move on!
            ${blue}2)${nc} Run ${5} installation again.
            ${blue}3)${nc} Remove the ${5} and Clone again..
            "

            for (( ; ; )) do
                read -n1 -p "Please Choose between [1,2,3] : " user_option
                echo ""
                sleep 2s ## sleep sleep sleep
                if (( $user_option == 1 ));then
                    echo -e "${green}Moving on...${nc}"
                    sleep 1s ## sleep sleep sleep
                    return 10 # green green. nothing to do.
                    break
                elif (( $user_option == 2 ));then
                    return 20 ## running installation
                    break
                elif (( $user_option == 3 ));then
                    echo -e "Removing ${red}OLD ${5}${nc}"
                    rm -rf ${directory}
                    ## if the previous commit failed to run.
                    if [ $? -ne 0 ];then
                        echo -e "${red} Error installing ${short_name}${nc}"
                        exit 255
                    fi
                    # installing fresh
                    cd /opt/ && git clone ${3}
                    ## if the previous commit failed to run.
                    if [ $? -ne 0 ];then
                        echo -e "${red} Error installing ${short_name}${nc}"
                        exit 255
                    fi
                    sleep 2s ## sleep sleep sleep
                    return 30 ## cloned fresh, need to run installation again!
                    break
                else
                    echo -e "Wrong option : ${short_name}. Try again!${nc}"
                    sleep 2s ## boom boom booooooooom!
                    break
                fi
            done
        fi
    fi
}


function end_message() {
    #################################
    #### END MESSAGE ################
    #################################
    echo -e "${lightPurple}
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ~~~That's It! Happy hacking :)~~~
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ${nc}"
    sleep 2s ## sleep sleep sleep
    exit 0
}


#----------------------------------------
#TODO: crackstation need much error logging I guess.
#Downloading Different files using WGET
#----------------------------------------
function little_wget_magic() {
    echo -e "${yellow}-------------------------------
    ${blue} Running a little WGET magic to download ${cyan}WCE (Windows Credential Editor), Mimikatz, Custom Password Lists, PeepingTom, NMap Script, PowerSploit, Responder, SET (Social Engineering Toolkit), BypassUAC and Fuzzing Lists.
    ${blue} This list is so f**king long, I know....
    ${yellow}-------------------------------${nc}"

    backup_directory=~/backup_wget
    sleep 5s #### why NOT!

    # ---------------------------------------------------------
    # WCE
    # ---------------------------------------------------------
    echo -e "${blue} Download WCE (Windows Credential Editor) ${nc}.
    Windows Credential Editor will be used to pull password from memory."
    cd ~/Desktop/ && wget http://www.ampliasecurity.com/research/wce_v1_41beta_universal.zip
    unzip -d ~/Desktop/wce wce_v1_41beta_universal.zip
    if [ ! -d ${backup_directory} ];then
        mkdir ~/backup_wget
    fi
    mv ~/Desktop/wce_v1_41beta_universal.zip ~/backup_wget/
    echo -e "${green}WCE is downloaded and unzipped in ~/Desktop/wce. zipped backup is kept in ~/backup_wget/ directory${nc}"
    sleep 2s


    # ---------------------------------------------------------
    #Mimikatz
    # ---------------------------------------------------------
    echo -e "
    ${yellow}-------------------------------${nc}
    ${blue} Download Mimikatz ${nc}.
    Mimikatz will be used to pull password from memory.
    ${yellow}-------------------------------${nc}"
    cd ~/Desktop/ && wget http://blog.gentilkiwi.com/downloads/mimikatz_trunk.zip
    unzip -d ~/Desktop/mimikatz mimikatz_trunk.zip
    if [ ! -d ${backup_directory} ];then
        mkdir ~/backup_wget
    fi
    mv ~/Desktop/mimikatz_trunk.zip ~/backup_wget/
    echo -e "${green}Mimikatz is downloaded and unzipped. A backup is kept as well.${nc}"
    sleep 2s

    # ---------------------------------------------------------
    # --------- Custom Password list ---------
    # Skill Security
    # ---------------------------------------------------------

    custom_password_directory=~/Desktop/password_list/
    custom_password_bk=~/backup_wget/password_list/
    echo -e "${yellow}-------------------------------${nc}
    ${blue}Download Custom Password list.${nc}
    First. Rock you of Skull Security
    ${yellow}-------------------------------${nc}"
    if [ ! -d ${custom_password_directory} ];then
        mkdir ~/Desktop/password_list/
    fi
    cd ~/Desktop/password_list && wget http://downloads.skullsecurity.org/passwords/rockyou.txt.bz2
    bzip2 ~/Desktop/password_list/rockyou.txt.bz2
    if [ ! -d ${custom_password_bk} ];then
        mkdir ~/backup_wget/password_list/
    fi
    mv ~/Desktop/password_list/rockyou.txt.bz2 ~/backup_wget/password_list/
    sleep 2s

    # ---------------------------------------------------------
    # ---------------------------------------------------------
    # CrackStation Portion.
    # ---------------------------------------------------------
    echo -e "${green}Downloaded Rock you file of Skull Security${nc}


    ${yellow}-------------------------------${nc}
    ${blue}Downloading Human password list of CrackStation using HTTP Mirror${nc}
    The list is free however, CrackStation has a donation page running for ANY amount you wish. If you feel, follow this url: ${yellow} https://crackstation.net/buy-crackstation-wordlist-password-cracking-dictionary.htm${nc}
    ${yellow}-------------------------------${nc}"

    echo -e "${green} Downloading Crackstation password list via HTTP Mirror. ${yellow}It might take awhile.. ${nc}"
    sleep 2s

    if [ ! -d ${custom_password_directory} ];then
        mkdir ~/Desktop/password_list/
    fi
    cd ~/Desktop/password_list/ && wget https://crackstation.net/files/crackstation-human-only.txt.gz
    gzip ~/Desktop/password_list/crackstation-human-only.txt.gz
    mv ~/Desktop/password_list/crackstation-human-only.txt.gz ~/backup_wget/password_list/

    echo -e "
    ${yellow}------------------------------------------
    ${blue} CrackStation has a rather long (15 gigs uncompressed) password. Check them out on their website
    ${yellow}------------------------------------------${nc}"
    sleep 5s

    # ---------------------------------------------------------
    # ---------------------------------------------------------
    # NMAP Scripts
    # ---------------------------------------------------------
    echo -e "
    ${yellow}#####################################
    ${blue}Downloading Banner Plus Script
    ${nc}Banner Plus Script will be used for quicker scanning and smarter identification.
    ${yellow}###################################### ${nc}
    "
    cd /usr/share/nmap/scripts/ && wget http://raw.github.com/hdm/scan-tools/master/nse/banner-plus.nse

    ## if the previous commit failed to run.
    if [ $? -ne 0 ];then
        echo -e "${red}Error downloading and copying Nmap script${nc}"
        exit 255
    fi

    sleep 2s # wait b4 next shot.
}



#----------------------------------------
#Fuzzing List----------------------------
#----------------------------------------
function fuzzing() {
    script_name="Fuzzing Lists (SecLists)"
    extra_message="SET will be used for Social Engineering Campaign"
    short_name="Fuzzing Lists"

    #calling clone script with addition parameters
    clone_script "${script_name}" 9 http://github.com/danielmiessler/SecLists.git "${extra_message}" "${short_name}"

    sleep 2s #almost there
}

#exit 255
#----------------------------------------
#Installing Beef and Fuzzing List--------
#----------------------------------------
function beEF() {
    echo -e "
    ${yellow}#####################################
    ${blue}Installing BeEF
    ${nc}BeFF will be used as an cross-site scripting attack framework
    "
    sudo apt install software-properties-common
    ## if the previous commit failed to run.
    if [ $? -ne 0 ];then
        echo -e "${red}Error in downloading necessary software${nc}"
        exit 255
    fi
    sleep 2s
    sudo apt-add-repository -y ppa:brightbox/ruby-ng
    ## if the previous commit failed to run.
    if [ $? -ne 0 ];then
        echo -e "${red} Error adding the Ruby repository${nc}"
        exit 255
    fi
    sleep 2s
    sudo apt update
    ## if the previous commit failed to run.
    if [ $? -ne 0 ];then
        echo -e "${red} Error in system update${nc}"
        exit 255
    fi
    sleep 2s
    git clone https://github.com/beefproject/beef
    ## if the previous commit failed to run.
    if [ $? -ne 0 ];then
        echo -e "${red} Error in beef cloning from github${nc}"
        exit 255
    fi
    sleep 2s
    cd beef && ./install
    ## if the previous commit failed to run.
    if [ $? -ne 0 ];then
        echo -e "${red} Error installing beEF${nc}"
        exit 255
    fi
    sleep 2s
    echo -e "${green} beEF installation is complete"
}
#----------------------------------------
#Installing bypassUAC--------------------
#TODO -> need testng in real. Old command wont work.
#TODO -> Metasploit probably come with this exploit by default in v4
#----------------------------------------
function bypassUAC() {
    echo -e "
    ${lightPurple}#####################################
    #####################################
    #####################################
    ${cyan}# Skipping bypassUAC on this version ##
    ${lightPurple}#####################################
    #####################################
    #####################################
    ${nc}"
    sleep 2s
}

#----------------------------------------
#Installing Social Engineering Toolkit---
#----------------------------------------
function social_engineering_toolkit() {
    script_name="Social Engineering Toolkit [SET]"
    extra_message="SET will be used for Social Engineering Campagin"
    short_name="SET"

    #calling clone script with addition parameters
    clone_script "${script_name}" 8 http://github.com/trustedsec/social-engineer-toolkit/ "${extra_message}" "${short_name}"

    status=$?
    ## install for 0, 20, 30
    ## no install for 10
    if (( ${status} == 0 )) || (( ${status} == 20 )) || (( ${status} == 30 ));then
        cd /opt/set/ && chmod a+x setup.py
        ## if the previous commit failed to run.
        if [ $? -ne 0 ];then
            echo -e "${red} Error installing ${short_name}${nc}"
            exit 255
        fi

        cd /opt/set/ && python setup.py install
        ## if the previous commit failed to run.
        if [ $? -ne 0 ];then
            echo -e "${red} Error installing ${short_name}${nc}"
            exit 255
        fi
    fi

    sleep 2s # sleeping 2s b4 doing anything else.
}


#----------------------------------------
#Installing PowerSploit
#----------------------------------------
function responder() {
    script_name="Responder"
    extra_message="Responder will be used to gain NTLM challenge/response hashes"
    short_name="Responder"

    #calling clone script with addition parameters
    clone_script "${script_name}" 7 http://github.com/lgandx/Responder.git "${extra_message}" "${short_name}"

    sleep 2s #sleeping....
}



#----------------------------------------
#Installing PowerSploit
#----------------------------------------
function powersploit() {
    script_name="PowerSploit"
    extra_message="PowerSploit are PowerShell scripts for post exploitation"
    short_name="PowerSploit"

    #calling clone script with addition parameters
    clone_script "${script_name}" 6 http://github.com/mattifestation/PowerSploit.git "${extra_message}" "${short_name}"

    status=$?
    ## install for 0, 20, 30
    ## no install for 10
    if (( ${status} == 0 )) || (( ${status} == 20 )) || (( ${status} == 30 ));then
        cd /opt/PowerSploit/ && wget http://raw.github.com/obscuresec/random/master/StartListener.py
        ## if the previous commit failed to run.
        if [ $? -ne 0 ];then
            echo -e "${red} Error installing ${short_name}${nc}"
            exit 255
        fi
        cd /opt/PowerSploit/ && wget http://raw.github.com/darkoperator/powershell_scripts/master/ps_encoder.py
        ## if the previous commit failed to run.
        if [ $? -ne 0 ];then
            echo -e "${red} Error installing ${short_name}${nc}"
            exit 255
        fi
        echo -e "${green}${script_name} installation is complete${nc}"
    fi

    sleep 2s #wait 2seconds b4 doing anything stupid! :p
}

#----------------------------------------
#Peeping Tom
#----------------------------------------
function install_peeping_tom() {
    echo -e "Ignoring Peeping Tom for now! Error in PhantomJS installation!"
    sleep 2s # sleep 2s before doing anything else
    return 0
}

#----------------------------------------
#Eye Witness
#----------------------------------------
function install_eye_witness() {
    script_name="Eye Witness"
    extra_message="PeepingTom will be used to take snapshots of Webpages"
    short_name="Eye Witness"

    #calling clone script with addition parameters
    clone_script "${script_name}" 5 https://github.com/ChrisTruncer/EyeWitness.git "${extra_message}" "${short_name}"

    status=$?
    ## install for 0, 20, 30
    ## no install for 10
    if (( ${status} == 0 )) || (( ${status} == 20 )) || (( ${status} == 30 ));then
        chmod a+x /opt/EyeWitness/setup/setup.sh
        ## if the previous commit failed to run.
        if [ $? -ne 0 ];then
            echo -e "${red} Error installing ${short_name}${nc}"
            exit 255
        fi

        cd /opt/EyeWitness/setup && ./setup.sh

        ## if the previous commit failed to run.
        if [ $? -ne 0 ];then
            echo -e "${red} Error installing ${short_name}${nc}"
            exit 255
        fi
        echo -e "${green}${script_name} installation is complete${nc}"
    fi

    sleep 2s # sleep 2s before doing anything else
    return 0
}

#----------------------------------------
#Peeping Tom or Eye Witness
#@caution: Peeping Tom is unsupported for over a year!
#----------------------------------------
function peeping_tom_issue() {
    if [ ${isTest} == 'True' ];then
        ## force Upgrades can break things. Use this on your own risk.
        ## This does not run properly in travisCI
        install_peeping_tom
        install_eye_witness
    else
        echo -e "
         Peeping Tom is no Longer supported from July 01, 2016.
        ${blue}1)${nc} Would you like to continue installing Peeping Tom?$
        ${blue}2)${nc} Would you like to install Eye Witness instead?
        ${blue}3)${nc} Would you like to install both?$
        Both Peeping Tom and Eye Witness does the same job.
        "

        for (( ; ; )) do
            read -n1 -p "Please Choose between [1,2,3] : " user_choice
            echo ""

            if (( $user_choice == 1 ));then
                echo -e "${red}CAUTION ${nc} You are installing PeepingTom which is out of support for a long time."
                peeping_tom_issue
                break
            elif (( $user_choice == 2 ));then
                echo -e "Installing ${cyan}Eye Witness${nc}"
                install_eye_witness
                break
            elif (( $user_choice == 3 ));then
                echo -e "Installing BOTH ${cyan}Eye Witness${nc} and ${cyan}Peeping Tom.${red}You really should not play around with OLD tools${nc}"
                install_peeping_tom
                install_eye_witness
                break
            else
                echo -e "${red}Wrong choice.${nc} Please try again!"
            fi
        done
    fi
    sleep 2s # sleep 2s before doing anything else
}


#----------------------------------------
#Veil version 3.0 Installation!
#----------------------------------------
function Veil() {
    echo -e "${yellow}Veil Evasion is no Longer supported, Installing Veil 3.0 instead. Cloning from ${blue} https://github.com/Veil-Framework/Veil${nc}"

    script_name="Veil"
    extra_message="Veil will be used to create Python based Meterpreter executable"
    short_name="Veil 3.0"
    #calling clone script with addition parameters
    clone_script "${script_name}" 3 https://github.com/Veil-Framework/Veil "${extra_message}" "${short_name}"

    status=$?
    ## install for 0, 20, 30
    ## no install for 10
    if (( ${status} == 0 )) || (( ${status} == 20 )) || (( ${status} == 30 ));then
        echo -e "${green}Successfully cloned Veil.${nc} Running Installation  now..."
        chmod a+x /opt/Veil/config/setup.sh
        ## if the previous commit failed to run.
        if [ $? -ne 0 ];then
            echo -e "${red} Error installing ${short_name}${nc}"
            exit 255
        fi
        cd /opt/Veil/config && ./setup.sh --force --silent ##force overwrite everything, silent does not user attention (worth to take a look later)
        ## if the previous commit failed to run.

        if [ $? -ne 0 ];then
            echo -e "${red} Error installing ${short_name}${nc}"
            exit 255
        fi

        if [ ${isTest} == 'True' ];then
            ## force Upgrades can break things. Use this on your own risk.
            ## This does not run properly in travisCI
            cd /opt/Veil/ && ./Veil.py --setup
            if [ $? -ne 0 ];then
                echo -e "${red} Error installing ${short_name}${nc}"
                exit 255
            fi
        else
            echo -e "If there's an ${red}error${nc}, do you want to ${blue} nuke the wine folder option?${nc}"
            echo ""
            sleep 1s
            read -n1 -p "Confirm [y/n] : " user_choice
            echo ""

            if [ "${user_choice}" == "Y" ] || [ "${user_choice}" == "y" ];then
                echo -e "${blue}Nuking the wine..${nc}"
                cd /opt/Veil/ && ./Veil.py --setup

                if [ $? -ne 0 ];then
                    echo -e "${red} Error installing ${short_name}${nc}"
                    exit 255
                fi
            fi
            sleep 1s
        fi

        echo -e "${green}${short_name} Complete.${nc}"
    fi

    sleep 2s
}


#----------------------------------------
#SMBExec Installation!
#----------------------------------------
function SMBExec() {
    script_name="SMBExec"
    extra_message="SMBExec will be used to grab hashes out of Domain Controller and reverse shells"
    short_name="SMBExec"

    #calling clone script with addition parameters
    clone_script "${script_name}" 2 https://github.com/brav0hax/smbexec.git "${extra_message}" "${short_name}"

    status=$?
    ## install for 0, 20, 30
    ## no install for 10
    if (( ${status} == 0 )) || (( ${status} == 20 )) || (( ${status} == 30 ));then
        chmod a+x /opt/smbexec/install.sh
        ## if the previous commit failed to run.
        if [ $? -ne 0 ];then
            echo -e "${red} Error installing ${short_name}${nc}"
            exit 255
        fi
        echo -e "Follow the ${blue}book for Installation Procedure"

        cd /opt/smbexec && ./install.sh
        ## if the previous commit failed to run.
        if [ $? -ne 0 ];then
            echo -e "${red} Error installing ${short_name}${nc}"
            exit 255
        fi
        echo -e "Installing ${short_name} -- ${green} DONE$ ${nc}"
    fi
    sleep 2s
}


#----------------------------------------
#Discover Installation!
#----------------------------------------
function discover() {
    script_name="Discover Scripts (Formerly known as backtrack Scripts)"
    extra_message="Discover is used for Passive Enumeration!"
    short_name="Discover"

    #calling clone script with addition parameters
    clone_script "${script_name}" 1 https://github.com/leebaird/discover.git "${extra_message}" "${short_name}"

    status=$?
    ## install for 0, 20, 30
    ## no install for 10

    if (( ${status} == 0 )) || (( ${status} == 20 )) || (( ${status} == 30 ));then
        #nothing to do
        chmod a+x /opt/discover/update.sh
        ## if the previous commit failed to run.
        if [ $? -ne 0 ];then
            echo -e "${red} Error installing ${short_name}${nc}"
            exit 255
        fi

        cd /opt/discover && ./update.sh
        ## if the previous commit failed to run.
        if [ $? -ne 0 ];then
            echo -e "${red} Error installing ${short_name}${nc}"
            exit 255
        fi
        echo -e "Installing ${short_name} -- ${green} DONE$ ${nc}"
    fi

    sleep 2s # Wait 2 seconds before Running SMBExec
}


#---------------------------------------------------------------
#---------------------------------------------------------------
#---------------------------------------------------------------
#---------------------------------------------------------------
if [ ${isTest} == 'True' ];then
    exit 0
else
    which -a msfconsole > /dev/null
    if [ $? -eq 0 ];then
        ## Metasploit is installed.
        if [[ $EUID -ne 0 ]];then
            echo -e "${cyan}This script needs to run in super-user mode... ${nc}"
            sudo su # script will ask user for password to sudo mode.
        fi

        which -a psql > /dev/null
        if [ $? -eq 0 ];then
            #### -------------------------------------------------
            #### -------------------------------------------------
            #### -------------------------------------------------
            #### -------------------------------------------------
            if (( ${user_input} == 1 ));then
                discover
                clear
                exit 0
            elif (( ${user_input} == 2 )); then
                SMBExec
                clear
                exit 0
            elif (( ${user_input} == 3 )); then
                Veil
                clear
                exit 0
            elif (( ${user_input} == 4 )); then
                install_peeping_tom
                clear
                exit 0
            elif (( ${user_input} == 5 )); then
                install_eye_witness
                clear
                exit 0
            elif (( ${user_input} == 6 )); then
                powersploit
                clear
                exit 0
            elif (( ${user_input} == 7 )); then
                responder
                clear
                exit 0
            elif (( ${user_input} == 8 )); then
                social_engineering_toolkit
                clear
                exit 0
            elif (( ${user_input} == 9 )); then
                bypassUAC
                clear
                exit 0
            elif (( ${user_input} == 10 )); then
                beEF
                clear
                exit 0
            elif (( ${user_input} == 11 )); then
                fuzzing
                clear
                exit 0
            elif (( ${user_input} == 12 )); then
                little_wget_magic
                clear
                exit 0
            elif (( ${user_input} == 13 )); then
                end_message
                exit 0
            else
                # Invalid Parameter
                echo -e "${red}Invalid parameter for function!!${nc}"
                exit 0
            fi
            #### -------------------------------------------------
            #### -------------------------------------------------
            #### -------------------------------------------------
            #### -------------------------------------------------
        else
            echo -e "${red} There might be some issue with PostgreSQL connection creation!${nc}. Terminating the script....
            "
            sleep 5s # wait before doing.
            exit 255
        fi
    else
        echo -e "Metasploit is not installed properly! or not found${blue} "$(which -a msfconsole)".${nc}Terminating script..."
        sleep 5s ## boom boom
        exit 255
    fi
fi



##TODO: Task at hand.
##Install or Write code for the following in Kali machine -> BypassUAC & Peeping Tom{Important}
##Implement Silent mode first.
##Implement Setup steps. > DONE.
##Implement network connection availability timer. > NOT NECESSARY
##Implement timer. > NOT NECESSARY
##Implement logging the entire process to a separate file.
##Implement check if all tools are installed or how many are missing {generic location first (opt)}
