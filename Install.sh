#!/bin/bash

# Set Variables Here
RED="\e[91m"
GREEN="\e[92m"
NORMAL="\e[0m"
COIN="\e[35m"
BLUE="\e[104m"
ccl="\e[1;49;93m"
Dossier=$(pwd)
DISTRO="unknown"

# Clear Terminal Window And Begin Installer Menu
clear
echo -e "$RED *********************************************************** $NORMAL"
echo -e "$RED This is the Antenna-One installer script for the following: $NORMAL"
echo -e "$RED *********************************************************** $NORMAL"
echo
echo -e "$GREEN *********************************************************** $NORMAL"
echo -e "$GREEN + ODR-mmbTools: 				            $NORMAL"
echo -e "$GREEN    + ODR-DabMux                                             $NORMAL"
echo -e "$GREEN    +  ODR-AudioEnc                                          $NORMAL"
echo -e "$GREEN    +  ODR-PadEnc                                            $NORMAL"
echo -e "$GREEN    +  ODR-DabMod                                            $NORMAL"
echo -e "$GREEN    +  HackRF drivers                                        $NORMAL"
echo -e "$GREEN    +  PadTool                                               $NORMAL"
echo -e "$GREEN    +  DABlin                                                $NORMAL"
echo -e "$GREEN    +  Auxiliary scripts                                     $NORMAL"
echo -e "$GREEN    +  The FDK-AACv2 library with DAB+ patch                 $NORMAL"
echo -e "$GREEN    +  Supervisor Tools (and automatisation of all tools)    $NORMAL"
echo -e "$GREEN *********************************************************** $NORMAL"
echo
echo -e "$GREEN *********************************************************** $NORMAL"
echo -e "$GREEN We then preconfigure the multiplex with DLS and SLS         $NORMAL"
echo -e "$GREEN (Slideshows)                                                $NORMAL"
echo -e "$GREEN *********************************************************** $NORMAL"
echo
echo -e "$RED *********************************************************** $NORMAL"
echo -e "$RED This script will make changes to the Operating System and   $NORMAL"
echo -e "$RED these changes cant be revered easily!  It will update all   $NORMAL"
echo -e "$RED packages and remove unwanted applications automatically.    $NORMAL"
echo -e "$RED *********************************************************** $NORMAL"


# Carry Out Operating System Checks
echo "Checking Operating System Type And Version... "
echo "Done...! "
echo "For us to add the correct source we will need to get "

if [ $(lsb_release -d | grep -c Ubuntu) -eq 1 ] && [ $(lsb_release -sc | grep -c focal) -eq 1 ] ; then
	DISTRO="focal"
echo -e  "deb-src http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse" | sudo tee /etc/apt/sources.list.d/odr.list
        LIST_APT="ok"
fi

echo
echo -e "$GREEN *********************************************************** $NORMAL"
echo -e "$GREEN We have detected you are using:                             $NORMAL"
echo -e "$GREEN $DISTRO                                                     $NORMAL"
echo -e "$GREEN *********************************************************** $NORMAL"
echo

if [ "$DISTRO" == "unknown" ] ; then
echo
echo -e "$RED *********************************************************** $NORMAL"
echo -e "$RED                         SORRY!                              $NORMAL"
echo -e "$RED This script is not yet compatible with the                  $NORMAL"
echo -e "$RED Operating System you are using...                           $NORMAL"
echo -e "$RED *********************************************************** $NORMAL"
    exit 1
fi

echo
echo -e "$RED *********************************************************** $NORMAL"
echo -e "$RED This script has carried out the necessary pre-checks and    $NORMAL"
echo -e "$RED things are looking good, we will use SUDO to install all    $NORMAL"
echo -e "$RED components, THERE IS NO UNDO FUNCTIONALITY!                 $NORMAL"
echo -e "$RED *********************************************************** $NORMAL"


# Check if the script is being run on Root and Sudo is installed
echo "Checking if you are a using SUDO..."
if [ "$UID" == "0" ]
then
    echo -e $RED
    echo "Do not run this script as root !"
    echo -e $NORMAL
    echo "Install sudo, and run this script as a normal user."
    exit 1
fi

which sudo
if [ "$?" == "0" ]
then
    echo "Checks Complete! We are about to begin..."
    echo "Press Ctrl-C to abort installation"
    echo "or Enter to proceed"
    read

else
    echo -e $RED
    echo -e "Please install sudo first $NORMAL using"
    echo " apt-get -y install sudo"
    exit 1
fi

# Fail on error
set -e


# Remove Unwanted Packages
echo -e "$GREEN ***************************** $NORMAL"
echo -e "$GREEN Removing unwated applications $NORMAL"
echo -e "$GREEN ***************************** $NORMAL"
sudo apt-get remove --auto-remove -y thunderbird \
firefox transmission-gtk \
gnome-mines pidgin sgt-puzzles simple-scan libreoffice* \
atril ristretto orage xfburn xfce4-dict \
xfce4-screenshooter xfce4-terminal parole xfce4-notes \ 
mousepad gnome-sudoku gimp info gigolo mate-calc atril


# Updating Repositories
echo -e "$GREEN ************************************ $NORMAL"
echo -e "$GREEN Updating Ubuntu package repositories $NORMAL"
echo -e "$GREEN ************************************ $NORMAL"
sudo apt-get -y update


# Adding Prerequisits
echo -e "$GREEN ********************************** $NORMAL"
echo -e "$GREEN Installing essential prerequisites $NORMAL"
echo -e "$GREEN ********************************** $NORMAL"
sudo apt-get -y install build-essential git wget \
sox alsa-tools alsa-utils \
automake libtool mpg123 \
libasound2 libasound2-dev \
libjack-jackd2-dev jackd2 \
ncdu vim ntp links cpufrequtils \
libfftw3-dev \
libcurl4-openssl-dev \
libmagickwand-dev \
libvlc-dev vlc-data \
libfaad2 libfaad-dev \
supervisor \
pulseaudio gqrx-sdr gr-osmosdr hackrf \
vlc-plugin-base libzmq3-dev libzmq5


# Adding Prerequistis for PadTool
echo -e "$GREEN ******************************** $NORMAL"
echo -e "$GREEN Installing PadTool prerequisites $NORMAL"
echo -e "$GREEN ******************************** $NORMAL"
sudo apt-get -y install python3 python3-pip chromium-browser chromium-chromedriver python3-pyscard

sudo pip3 install PyOpenSSL
sudo pip3 install selenium
sudo pip3 install imgkit
sudo pip3 install pillow
sudo pip3 install coverpy

# this will install boost, cmake and a lot more
sudo apt-get -y build-dep uhd

# stuff to install from source
if [ ! -d "/home/$USER/dab" ];then
echo "Creating the DAB Folder here ( /home/$USER/dab/ )!";
mkdir /home/$USER/dab
fi

cd /home/$USER/dab/

echo
echo -e "$GREEN *********************** $NORMAL"
echo -e "$GREEN PREREQUISITES INSTALLED $NORMAL"
echo -e "$GREEN PRESS ENTER TO CONTINUE $NORMAL"
echo -e "$GREEN *********************** $NORMAL"
### END OF PREREQUISITES

# Adding Read as a Pause
read


# Start Adding Applications
echo -e "$GREEN ******************************** $NORMAL"
echo -e "$GREEN Installing Applications          $NORMAL"
echo -e "$GREEN ******************************** $NORMAL"


# Install FDK-AAC
echo -e "$GREEN ******************************** $NORMAL"
echo -e "$GREEN Installing FDK-AAC               $NORMAL"
echo -e "$GREEN ******************************** $NORMAL"
if [ ! -d "/home/$USER/dab/fdk-aac" ];then
echo -e "$GREEN Compiling fdk-aac library $NORMAL"
git clone https://github.com/Opendigitalradio/fdk-aac.git -b dabplus2
pushd fdk-aac
./bootstrap
./configure
make
sudo make install
popd
fi


# Update LD Cache
echo -e "$GREEN ******************************** $NORMAL"
echo -e "$GREEN Updating LD Cache                $NORMAL"
echo -e "$GREEN ******************************** $NORMAL"
sudo ldconfig


# Install ODR-Audio-Enc
echo -e "$GREEN ******************************** $NORMAL"
echo -e "$GREEN Install ODR-Audio-Enc            $NORMAL"
echo -e "$GREEN ******************************** $NORMAL"
if [ ! -d "/home/$USER/dab/ODR-AudioEnc" ];then
echo -e "$GREEN Compiling ODR-AudioEnc $NORMAL"
git clone https://github.com/Opendigitalradio/ODR-AudioEnc.git
pushd ODR-AudioEnc
./bootstrap
./configure --enable-alsa --enable-jack --enable-vlc --disable-uhd
make
sudo make install
popd
fi


# Install ODR-DabMux
echo -e "$GREEN ******************************** $NORMAL"
echo -e "$GREEN Install ODR-DabMux               $NORMAL"
echo -e "$GREEN ******************************** $NORMAL"
if [ ! -d "/home/$USER/dab/ODR-DabMux" ];then
echo -e "$GREEN Compiling ODR-DabMux $NORMAL"
git clone https://github.com/Opendigitalradio/ODR-DabMux.git
pushd ODR-DabMux
./bootstrap.sh
./configure --with-boost-libdir=/usr/lib/i386-linux-gnu
fi
make
sudo make install
popd
fi


# Install ODR-DabMod
echo -e "$GREEN ******************************** $NORMAL"
echo -e "$GREEN Install ODR-DabMod               $NORMAL"
echo -e "$GREEN ******************************** $NORMAL"
if [ ! -d "/home/$USER/dab/ODR-DabMod" ];then
echo -e "$GREEN Compiling ODR-DabMod $NORMAL"
git clone https://github.com/Opendigitalradio/ODR-DabMod.git
pushd ODR-DabMod
./bootstrap.sh
./configure --with-debug-malloc=no --disable-debug --enable-fft-simd --enable-zeromq --disable-output-uhd
make
sudo make install
popd
fi


# Install ODR-PadEnc
echo -e "$GREEN ******************************** $NORMAL"
echo -e "$GREEN Install ODR-PadEnc               $NORMAL"
echo -e "$GREEN ******************************** $NORMAL"
if [ ! -d "/home/$USER/dab/ODR-PadEnc" ];then
echo -e "$GREEN Compiling ODR-PadEnc $NORMAL"
git clone https://github.com/Opendigitalradio/ODR-PadEnc.git
pushd ODR-PadEnc
./bootstrap
./configure --enable-jack --enable-vlc
make
sudo make install
popd
fi


# Install PadTool
echo -e "$GREEN ******************************** $NORMAL"
echo -e "$GREEN Install PadTool            $NORMAL"
echo -e "$GREEN ******************************** $NORMAL"
if [ ! -d "/home/$USER/dab/PadTool" ];then
echo -e "$GREEN Compiling PadTool $NORMAL"
git clone https://github.com/fabcd14/PadTool
pushd PadTool
chmod +x ./padtool.py
popd
fi



# end of Antenna Updates
echo -e "$GREEN *END END END END END END END END* $NORMAL"
echo -e "$GREEN *END END END END END END END END* $NORMAL"
echo -e "$GREEN *END END END END END END END END* $NORMAL"

READ














# THIS MODULE ERRORS
# if [ ! -d "/home/$USER/dab/mmbtools-aux" ];then
# echo -e "$GREEN Fetching mmbtools-aux $NORMAL"
# git clone https://github.com/mpbraendli/mmbtools-aux.git
# pushd mmbtools-aux
# cd zmqtest/zmq-sub/
# make
# popd
# fi

if [ ! -d "/home/$USER/dab/etisnoop" ];then
echo -e "$GREEN Fetching etisnoop $NORMAL"
git clone https://github.com/Opendigitalradio/etisnoop.git
pushd etisnoop
./bootstrap.sh
./configure
make
sudo make install
popd
fi




if [ ! -d "/home/$USER/dab/dablin" ];then
echo -e "$GREEN Compiling DABlin $NORMAL"
sudo apt-get -y install libmpg123-dev libfaad-dev libsdl2-dev libgtkmm-3.0-dev
git clone https://github.com/Opendigitalradio/dablin.git
pushd dablin
mkdir build
cd build
cmake ..
make
sudo make install 
cd
popd
fi
















clear
echo
echo -e "$GREEN Done installing all tools $NORMAL"
echo
echo
echo -e "$GREEN All the tools have been dowloaded to the /home/$USER/dab/ folder,"
echo -e "compiled and installed to /usr/local"
echo
echo -e "The stable versions have been compiled, i.e. the latest"
echo -e "'master' branch from the git repositories"
echo
echo -e "If you know there is a new release, and you want to update,"
echo -e "you have to go to the folder containing the tool, pull"
echo -e "the latest changes from the repository and recompile"
echo -e "it manually."
echo
echo -e "To pull the latest changes for ODR-DabMux, use:"
echo -e " cd $USER/dab/ODR-DabMux"
echo -e " git pull"
echo -e " ./bootstrap.sh"
echo -e " ./configure --enable-input-zeromq --enable-output-zeromq"
echo -e " make"
echo -e " sudo make install"
echo
echo -e "This example should give you the idea. For the options"
echo -e "for compiling the other tools, please see in the ODRinstaller.sh"
echo -e "script what options are used. Please also read the README"
echo -e "and INSTALL files in the repositories. $NORMAL"
echo -e $RED
read -r -p "Do you want to start configuration script? [Y/n]" response
response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
   set -e
echo -e $NORMAL
echo 
cd $Dossier
sudo /etc/init.d/supervisor stop
sudo cp -v supervisord.conf /etc/supervisor/supervisord.conf
echo -e "[$GREEN OK $NORMAL]"
echo

echo " Copy configuration files"
sudo cp -R config /home/$USER/dab/
sudo sudo chmod -R 777  /home/$USER/dab/config
echo
echo -e "[$GREEN OK $NORMAL]"
echo
echo -e "$GREEN FIFO file for HackRF $NORMAL"
# creating FIFO
sudo mkfifo /home/$USER/dab/config/ofdm.fifo
echo
echo "Supervisor is restarting..."
sudo /etc/init.d/supervisor start
echo
echo -e "[$GREEN OK $NORMAL]"
echo
echo "Modification of the USER variable of the configuration files"
echo
for file in /home/$USER/dab/config/*/*.conf
do
  echo "Treatment of $file ..."
  echo
  sudo sed -i -e "s/azerty/$USER/g" "$file"
done 
echo
for file in /home/$USER/dab/config/*/*.ini
do
sudo sed -i -e "s/azerty/$USER/g" "$file"
done
echo
for file in /home/$USER/dab/config/*.ini
do
sudo sed -i -e "s/azerty/$USER/g" "$file"
done
echo
echo -e "[$GREEN OK $NORMAL]"
echo
echo "Symbolic links creation"
if [ -f /etc/supervisor/conf.d/mux.conf ]
then
sudo rm /etc/supervisor/conf.d/enc-*.conf
sudo rm /etc/supervisor/conf.d/mux.conf
fi
sudo ln -s /home/$USER/dab/config/supervisor/ /etc/supervisor/conf.d/
sudo supervisorctl reread 
sudo supervisorctl update
echo
echo -e "$GREEN Successful configuration ! $NORMAL"
echo
echo -e "$ccl Opening your internet browser in 10 seconds"
echo -e "( http://localhost:8001 )"
echo
echo -e " User: $RED odr $ccl pass: $RED odr $ccl" 
echo 
echo " ctrl+c to exit"
echo
echo -e "$GREEN Remember to add this page to your favorites !"
sleep 10
sensible-browser http://localhost:8001 &
echo 
echo
echo -e "$NORMAL"
echo
fi
