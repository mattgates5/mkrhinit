## Description
Mkrhinit creates a basic [SysV Init](http://en.wikipedia.org/wiki/Sysvinit) script stub for Red Hat-based distributions. It's intended to help streamline the process of creating init scripts for services that didn't come packaged with their own.

`TODO:` marks places that necessarily require modification in order to turn the stub into a complete init script.

### Usage
    # ruby mkrhinit.rb [OPTIONS]
        -p, --program PROGRAM            Program name
        -c, --config [FILE]              Config file
        -l, --levels [LEVELS]            Runlevels
        -h, --help                       Print help


### Examples
    # ruby mkrhinit.rb --program /usr/bin/appd --config /etc/sysconfig/appd -levels 2345 >> appd
    # chmod -c +x appd
    # cp -p appd /etc/init.d/
    # chkconfig --add appd

### Caveat
The output is a basic version of an init script, which the user can then expand upon. However, this is not an [LSB compliant](http://refspecs.linuxbase.org/LSB_3.1.1/LSB-Core-generic/LSB-Core-generic/iniscrptact.html) stub. This script is designed as a training tool and should only be used in production after configuration and proper testing.

Where compatibility is concerned, most modern versions of any Red Hat-based distribution should suffice as long as SysV init scripts are still supported. RHEL 5 and 6 still use SysV but it is purported that [RHEL 7 will use systemd](http://www.h-online.com/open/slideshow/bilderstrecke_1631968.html?back=1631791;back_page=1;image=5).

While systemd still provides some compatibility for SysV init, I cannot guarantee that that scripts generated using this script will be supported. **Use at your own risk.**

## Requirements

**[Ruby](http://www.ruby-lang.org/en/)**

Any of the Red Hat-based distributions. Major ones are listed here for reference:

<table>
	<tr><td><a href="http://www.redhat.com/">Red Hat Enterprise Linux</a></td></tr>
	<tr><td><a href="http://centos.org/">CentOS</a></td></tr>
	<tr><td><a href="https://www.scientificlinux.org/">Scientific Linux</a></td></tr>
	<tr><td><a href="http://linux.oracle.com/">Oracle Linux</a></td></tr>
	<tr><td><a href="http://fedoraproject.org/">Fedora</a></td></tr>
</table>
