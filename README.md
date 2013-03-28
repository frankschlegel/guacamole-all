guacamole-all
=============
Repo combining all guacamole components as submodules.

Installation
------------
For building and installing all necessary guacamole components, run

    sudo make

in the root directory of this repo.

You can change the install directory by setting the PREFIX variable:

    sudo make PREFIX=/your/path

For installing the guacamole **webapp** you need to copy the `.war` file from the main directory of this repo 
to the location directed in the instructions provided with your servlet container.
For tomcat that is `/var/lib/tomcat6/webapps`.

However, the guacamole installer usually places the `.war` in `/var/lib/guacamole` and creates a symbolic link to it in the tomcat directory.

The RDP client plugin of guacamole needs a FreeRDP plugin in order to support sound. This plugin is automatically installed with the RDP client plugin to `PREFIX/lib/freerdp`. However, if your FreeRDP installation is not in the same prefix you need to copy it to your FreeRDP installation folder (e.g., `/usr/lib/freerdp`).

If you want to use a custom **authentication provider** for guacamole you can do that by placing the `.jar` in `/var/lib/guacamole/classpath` and add the following line to the `guacamole.properties` file (see below):

	lib-directory: /var/lib/guacamole/classpath


Running
-------
You can start the guacamole deamon with

	sudo /etc/init.d/guac start

Maybe you need to run

    sudo ldconfig

first in order to enable guacd to find the guacamole libraries after the installation.


Configuration
-------------
The configuration files for the guacamole webapp are located in `/etc/guacamole`.
Refere to the [guacamole documentation](http://guac-dev.org/doc/gug/configuring-guacamole.html) for more information.