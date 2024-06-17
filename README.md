INSTALLATION
------------
Unpack:

    $ wget -O foo2zjs.tar.gz http://foo2zjs.rkkda.com/foo2zjs.tar.gz
    $ tar zxf foo2zjs.tar.gz
    $ cd foo2zjs

Compile:

    $ make

Get extra files from the web, such as .ICM profiles (for color correction)
and firmware.  Select the model number for your printer:

    $ ./getweb 1025     # Get HP LaserJet Pro CP1025nw .ICM files
    $ ./getweb 1215	# Get HP Color LaserJet CP1215 .ICM files
    $ ./getweb 1500	# Get HP Color LaserJet 1500 .ICM files
    $ ./getweb 1600	# Get HP Color LaserJet 1600 .ICM files
    $ ./getweb 2600n	# Get HP Color LaserJet 2600n .ICM files

    $ ./getweb 1600w    # Get Konica Minolta magicolor 1600W .ICM files
    $ ./getweb 1680     # Get Konica Minolta magicolor 1680MF .ICM files
    $ ./getweb 1690     # Get Konica Minolta magicolor 1690MF .ICM files
    $ ./getweb 2480	# Get Konica Minolta magicolor 2480 MF .ICM files
    $ ./getweb 2490	# Get Konica Minolta magicolor 2490 MF .ICM files
    $ ./getweb 2530	# Get Konica Minolta magicolor 2530 DL .ICM files
    $ ./getweb 4690     # Get Konica Minolta magicolor 4690MF .ICM files
    $ ./getweb 110      # Get Oki C110 .ICM files
    $ ./getweb 6115	# Get Xerox Phaser 6115MFP .ICM files
    $ ./getweb 6121     # Get Xerox Phaser 6121MFP.ICM files

    $ ./getweb cpwl	# Get Minolta Color PageWorks/Pro L .ICM files
    $ ./getweb 2200	# Get Minolta/QMS magicolor 2200 DL .ICM files
    $ ./getweb 2300	# Get Minolta/QMS magicolor 2300 DL .ICM files
    $ ./getweb 2430	# Get Konica Minolta magicolor 2430 DL .ICM files

    $ ./getweb 300      # Get Samsung CLP-300 .ICM files
    $ ./getweb 315      # Get Samsung CLP-315 .ICM files
    $ ./getweb 325      # Get Samsung CLP-325 .ICM files
    $ ./getweb 360      # Get Samsung CLP-360 .ICM files
    $ ./getweb 365      # Get Samsung CLP-365 .ICM files
    $ ./getweb 600      # Get Samsung CLP-600 .ICM files
    $ ./getweb 610      # Get Samsung CLP-610 .ICM files
    $ ./getweb 2160     # Get Samsung CLX-2160 .ICM files
    $ ./getweb 3160     # Get Samsung CLX-3160 .ICM files
    $ ./getweb 3175     # Get Samsung CLX-3175 .ICM files
    $ ./getweb 3185     # Get Samsung CLX-3185 .ICM files
    $ ./getweb 6110     # Get Xerox Phaser 6110 and 6110MFP .ICM files

    $ ./getweb 500      # Get Lexmark C500 .ICM files

    $ ./getweb 301      # Get Oki C301dn .ICM files
    $ ./getweb c310     # Get Oki C310dn .ICM files
    $ ./getweb c511     # Get Oki C511dn .ICM files
    $ ./getweb c810     # Get Oki C810 .ICM files
    $ ./getweb 3200     # Get Oki C3200 .ICM files
    $ ./getweb 3300     # Get Oki C3300 .ICM files
    $ ./getweb 3400     # Get Oki C3400 .ICM files
    $ ./getweb 3530     # Get Oki C3530 MFP .ICM files
    $ ./getweb 5100     # Get Oki C5100 .ICM files
    $ ./getweb 5200     # Get Oki C5200 .ICM files
    $ ./getweb 5500     # Get Oki C5500 .ICM files
    $ ./getweb 5600     # Get Oki C5600 .ICM files
    $ ./getweb 5800     # Get Oki C5800 .ICM files

    $ ./getweb 160	# Get Olivetti d-Color P160W .ICM files

    $ ./getweb 1000	# Get HP LaserJet 1000 firmware file
    $ ./getweb 1005	# Get HP LaserJet 1005 firmware file
    $ ./getweb 1018	# Get HP LaserJet 1018 firmware file
    $ ./getweb 1020	# Get HP LaserJet 1020 firmware file

    $ ./getweb P1005	# Get HP LaserJet P1005 firmware file
    $ ./getweb P1006	# Get HP LaserJet P1006 firmware file
    $ ./getweb P1007	# Get HP LaserJet P1007 firmware file
    $ ./getweb P1008	# Get HP LaserJet P1008 firmware file
    $ ./getweb P1505	# Get HP LaserJet P1505 firmware file

Install driver, foomatic XML files, PPD files, and extra files:

    $ su		OR	$ sudo make install
    # make install

(Optional) Install hotplug (for HP LJ 1000/1005/1018/1020/P100[5678]/P1505):

    $ su		OR	$ sudo make install-hotplug
    # make install-hotplug

Unplug and re-plug the USB printer

If you use CUPS to manage your printers, you must restart cupsd:

    # make cups		OR	$ sudo make cups

Test operation of programs. Skip this if you don't have the exact same
version of Ghostscript that I have, Fedora ghostscript 8.71-16.fc14, because
it will not pass since different versions of Ghostscript generate different
raster images:

    # make test

Create printers (Fedora 6/7/8/.../16 and Ubuntu 7.10/8.x/9.x/10.x/11.x):

    # system-config-printer

Create printers (Redhat 7.2/7.3/8.0/9.0, Fedora Core 1-5):
    
    # printconf-gui

Create printers (Mandrake/Manrivia)
    
    # printerdrake

Create printers (openSUSE 10.x/11.x)
    
    # yast2 printer

Create printers (Ubuntu 5.10/6.06/6.10/7.04)
    
    $ sudo gnome-cups-manager
    $ sudo make cups		# Ubuntu has a bug in gnome-cups-manager

NOTE: to edit a queue hit "Properties" (click right mouse button).

Create printers (Debian)
Connect with a web browser to:
    
	http://localhost:631

And configure printer (HP example shown) to:
	HP LaserJet 2600n, Foomatic + foo2zjs (en)
    Then edit "Manage Printers->Configure Printer" to suit you,
    such as "Page Size" or "Color Mode".

Create printers (Solaris 11+)

    # printmgr

Create printers (command line using CUPS)
    
    # lpadmin -p "NAME" -v "URI" -E -P file.ppd.gz
    
i.e.

	# lpadmin -p hp1020 -v "usb://HP/LaserJet%201020" -E -P /usr/share/cups/model/HP-LaserJet_1020.ppd.gz
 
Set the default:

	# lpadmin -d "NAME"

Create at least one queue for monochrome, and another queue
for color printing.  Create the queues, then edit them and
set the "device options" as desired.

For a networked Minolta/QMS 2300 DL, I used a "Queue Type"
of "Unix Printer (LPD)", and set the "Server" to the IP address
of the printer, and the "Queue" to "lp".

For a networked HP Color Laserjet 2600n, I used a "Queue Type"
of "Networked JetDirect", and set the "Printer" to the IP address
of the printer, and the "Port" to "9100".


UBUNTU NOTES
------------

Install build-essential, tix, foomatic-filters, groff, dc FIRST:

 	$ sudo apt-get install build-essential tix foomatic-filters groff dc

	$ wget -O foo2zjs.tar.gz http://foo2zjs.rkkda.com/foo2zjs.tar.gz
	$ tar zxf foo2zjs.tar.gz
	$ cd foo2zjs
	$ sudo make uninstall
	$ make
	$ ./getweb 1020
	    OR other printer
	$ sudo make install install-hotplug cups

	For 7.10 and later users:
	    $ sudo system-config-printer

	For 5.10/6.06/6.10/7.04 users:
	    $ sudo gnome-cups-manager
	    [configure ColorMode = Color if a color printer]
	    $ sudo make cups

	    Ubuntu has a bug in gnome-cups-manager with Color, so you must
	    restart cups.  No other distro has this bug.

    If that doesn't work, then fire up:
	$ firefox http://localhost:631

	And click on:
	    Printers -> Set Printer Options -> Color Mode -> Color
	Then click on:
	    Set Printer Options



HP SMART INSTALL NOTES
----------------------
    The printers HP LaserJet Pro P1102, HP LaserJet Pro CP1025, and simliar
    models have a virtual CD-ROM (a fake USB CD drive) in USB mode.  You can
    disable this three ways:

    Method 1:
	NOTE: this is a non-open-source method!
	- Connect the printer to a Windows PC and turn it on.
	  The fake CD-ROM appears on Windows.
	- Insert the original Driver CD that ships with the printer
	- Run SIUtility.exe or SIUtility64.exe from the UTIL folder and
	  COMPLETELY DISABLE THIS "HP SMART INSTALL" FEATURE. 

    Method 2:
	- Install usb_modeswitch and usb_modeswitch-data from your distro's
	  repository. I.E.:
	    # yum install usb_modeswitch usb_modeswitch-data
	  OR
	    $ sudo apt-get install usb-modeswitch-data
	  OR
	    Surf to: http://www.draisberghof.de/usb_modeswitch/
	- Power cycle the printer.

    Method 3:
	NOTE: this is a non-open-source method!
	- Execute:
	    $ wget http://hplipopensource.com/hplip-web/smartinstall/\
		SmartInstallDisable-Tool.run
	    $ sh SmartInstallDisable-Tool.run

PSUTILS AND 2/4-UP CAPABILITY
-----------------------------
    If you would like to use the 2-up/4-up capability, then you need to
    get and install Angus Duggan's excellent psutils package.  You can
    find the source code for psutils here:

	http://knackered.knackered.org/angus/psutils/index.html

    Or an RPM here:

	http://rpmfind.net/linux/rpm2html/search.php?query=psutils

CUSTOM PAGE SIZE
----------------

    Append "PageSize=Custom.MMMxNNNin" to the lpr command.  E.G.

    $ lpr -P hp2600 -o media=letter -o PageSize=Custom.4x6in ~/testpage.ps
    $ lpr -P hp2600 -o media=letter -o PageSize=Custom.10x15cm ~/testpage.ps
    $ lpr -P hp1020 -o media=letter -o PageSize=Custom.4x6in ~/testpage.ps

    Or, use a GUI that allows the custom size parameters, e.g.
    "evince" - PostScript and PDF File Viewer.

LANDSCAPE ORIENTATION
---------------------
    This driver just prints Postscript and doesn't know what the
    orientation is (*).  Other higher level programs format your
    data into Postscript, e.g CUPS. 

    The CUPS -o landscape option will rotate the page 90 degrees to print
    in landscape orientation:

    $ lp -o landscape filename
    $ lpr -o landscape filename

    (*) except for N-up printing, because psnup (from psutils) requires it!

SET DEFAULT MEDIA WITH CUPS
---------------------------
    $ sudo
    # lpoptions -o media=A4
	-OR-
    # lpoptions -o media=Letter


