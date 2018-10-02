#!/bin/bash

echo ''
echo 'In order to install JHPulse, you must have received upgraded security permissions, as described at'
echo ''
echo 'http://www.it.johnshopkins.edu/services/directoryservices/jhea/MFA/MFA_Instructions/'
echo ''
echo 'Hit return if you have already done this and successfully downloaded the Authenticator app'
read answer 

until [ -e ~/Downloads/*pulse*.deb ]; do
    echo ''
    echo ''
    echo 'The JHPulse Linux installer file is not in the ~/Downloads directory.'
    echo 'Download the JHPulse Linux installer following instructions at'
    echo ''
    echo 'https://wseit.engineering.jhu.edu/onboarding#howvpn'
    echo ''
    echo 'Part of the instructions will involve logging into http://my.jh.edu, going to the VPN tab, and downloading a PDF file.'
    echo 'The PDF file will have a link to the installer.'
    echo ''
    echo 'Hit return when installer is in ~/Downloads'
    read answer
done

sudo apt -y install ~/Downloads/*pulse*.deb

sudo /usr/local/pulse/PulseClient.sh install_dependency_packages

echo ''
echo 'Now please wait SEVERAL MINUTES while Pulse sets itself up.'
echo ''
echo 'Ignore any error messages you see during the setup period.'
echo ''

sudo /usr/bin/env LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/pulse /usr/local/pulse/pulseUi

echo ''
echo 'Now follow the remaining instructions from the PDF you downloaded from my.jh.edu to configure pulse.'
echo ''

read answer
