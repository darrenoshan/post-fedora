#!/usr/bin/bash
#------------------------

# This project could save you alot of time on post-fedora installation.
# Fedora is one of the most popular Linux distributions. https://en.wikipedia.org/wiki/Fedora_Linux
clear
runstatus="Starting"
cd "$(dirname "$0")"

RUNTIME=`date +%Y_%m_%d_%H_%M_%S`
LOGFILE="logs/post_fedora_$RUNTIME.log"
ERRORLOGFILE="logs/post_fedora_$RUNTIME.errors.log"
mkdir -p logs

runstatus="Loading files"
source files/01*.source
source files/02*.source   >> $LOGFILE
source files/03*.source   >> $LOGFILE
source files/04*.source   >> $LOGFILE
source files/05*.source   >> $LOGFILE
source files/06*.source   >> $LOGFILE

 #-------------------------------------------------
run_00(){
    check_rootrun       # check if user is root
    check_fedora        # check if this is a feora linux
    check_gui           # check if this is a GUI/Workstation edition.
    check_dnfrpm        # check if dnf is reachable
    check_net           # check if system has internet
 }
run_01(){
    func_before_run             # 01 Check firewalld, semanage and deltarpm
    func_bashrc                 # 02 Set bashrc
    func_disable_se             # 03 Disables SELinux
    func_mkswap                 # 04 Makes SWAP File
    func_dnf_conf               # 05 Sets the DNF Config file
    func_ssh_client_config      # 06 Setups a sample ssh client config file
    func_repo_rpmfusion         # 07 Install/Configures the RPMFusion
    func_repo_gui               # 08 Install/Configures the GUI repos on GUI Workstation Edition ---ONLY--- checks inside function
 }
run_02(){
    func_pkg_cmd                # 01 Installs the textbase packages
    func_pkg_gui                # 02 Installs the graphical packages
    func_dockers                # 03 installs the docker related packages
 }
run_03(){
    func_pkg_cmd_force          # 01 Installs the textbase packages ONE-by-ONE
    func_pkg_gui_force          # 02 Installs the graphical packages ONE-by-ONE
    func_dockers                # 03 installs the docker related packages
 }
run_04(){
    func_gui_multimedia_fix     # 01 Installs and configures the GUI multimedia related pakages/groups
    func_disable_localdns       # 02 Disables the system local DNS Server
    func_gui_3rdp_apps          # 03 installs extra GUI 3rd party applications e.g: Winetricks,DBeaver,GNS3 (wine and skype are installed before.)
    func_post_sweep             # 04 Fixes some config files/services/permissions
    func_gui_post_gnome         # 05 Sets the Gnome Preffered settings
 }
main_normal(){
    run_00
    run_01
    run_02
    run_04
 }
main_force(){
    run_00
    run_01
    run_03
    run_04
 }
func_update_upgrade(){
    func_dnf_conf
    func_update
    func_hw_update
}
#

    if [ `echo $1 | grep -icw "force"` -ge 1 ] ; then
        main_force  >> $LOGFILE 2>> $ERRORLOGFILE
    else if [ `echo $1 | grep -icw "normal"` -ge 1 ] ; then
        main_normal >> $LOGFILE 2>> $ERRORLOGFILE
    else 
        echo -e "Error \n $0 missing operand "
        echo -e "Usage:\n\n\t $0 [ force|normal ]"
    fi
    fi
runstatus="finished"
