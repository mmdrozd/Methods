How to get Stata working in Ubuntu/Xubuntu/Kubuntu:

0. Install VPN from JHU:

	0. MFA “MyIT Login Code” must be enabled 
	0. Follow this link to download the required packages https://vpn.jh.edu/JHPulse/PulseSecure/,DanaInfo=portalcontent.johnshopkins.edu,SSL+LinuxClients
	0. To install the packages run: sudo dpkg –I pulse‐8.2R5.i386.deb
	0. After Install APT‐GET Dependencies:
		0. apt‐get install lib32z1 
		0. apt‐get install libc6‐i386 
		0. apt‐get install libwebkitgtk‐1.0‐0:i386 
		0. apt‐get install libproxy1‐plugin‐gsettings:i386 
		0. apt‐get install libproxy1‐plugin‐webkit:i386 
		0. apt‐get install libdconf1:i386 
		0. apt‐get install dconf‐gsettings‐backend:i386

0. Open VPN and add a new connection (using the + icon) using the following settings:
	0. Name: vpn.jh.edu
	0. URL: https://vpn.jh.edu/linux

0. Now login with JHED ID, Password and MyITLoginCode

0. Install Citrix:
	0. Install necessary dependencies (if you're trying to install it on a 64bit computer):
		0. sudo dpkg --add-architecture i386
		0. sudo apt-get update
	0. Follow this URL and download Citrix for 64bit Debian Linux: https://www.citrix.com/downloads/citrix-receiver/linux/receiver-for-linux-latest.html
	0. Install the receiver with these commands:
		0. sudo dpkg -i ~/Downloads/icaclient_*.deb ctxusb_*.deb
		0. sudo apt-get -f install
	0. By default, Citrix Receiver only trusts a few root CA certificates, which causes connections to many Citrix servers to fail with an SSL error. The 'ca-certificates' package (already installed on most Ubuntu systems) provides additional CA certificates in /usr/share/ca-certificates/mozilla/ that can be conveniently added to Citrix Receiver to avoid these errors:
		0. sudo ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/
		0. sudo c_rehash /opt/Citrix/ICAClient/keystore/cacerts/
	0. To map drives (to allow access to files on your local Ubuntu machine via a share drive in the remote Windows session) run: /opt/Citrix/ICAClient/util/configmgr &
	0. To use Citrix Receiver in Chrome and/or Chromium, run: xdg-mime default wfica.desktop application/x-ica

0. Go to: myjlab.jhu.edu (using Chrome)
	0. Click on `Skip to log on`
	0. Log in using your JHUID and password

0. Go to Statistical Software, find and run Stata.

















