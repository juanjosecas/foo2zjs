INSTALLATION
------------
Unpack:

    $ wget -O foo2zjs.tar.gz http://foo2zjs.rkkda.com/foo2zjs.tar.gz
    $ tar zxf foo2zjs.tar.gz
    $ cd foo2zjs

Compile:

    $ make

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

Create printers (Ubuntu 5.10/6.06/6.10/7.04)
    
    $ sudo gnome-cups-manager
    $ sudo make cups		# Ubuntu has a bug in gnome-cups-manager

NOTE: to edit a queue hit "Properties" (click right mouse button).

Create printers (Debian)
Connect with a web browser to:
    
	http://localhost:631

And configure printer (HP example shown) to:

HP LaserJet 2600n, Foomatic + foo2zjs (en)

Then edit "Manage Printers->Configure Printer" to suit you, such as "Page Size" or "Color Mode".

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


