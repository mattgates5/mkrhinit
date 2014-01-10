# mkrhinit
#   a ruby script for generating sysv init script stubs.
#   2013 matt gates
#
# this program is free software: you can redistribute it and/or modify
# it under the terms of the gnu general public license as published by
# the free software foundation, either version 3 of the license, or
# (at your option) any later version.
#
# this program is distributed in the hope that it will be useful,
# but without any warranty; without even the implied warranty of
# merchantability or fitness for a particular purpose.  see the
# gnu general public license for more details.
#
# you should have received a copy of the gnu general public license
# along with this program.  if not, see <http://www.gnu.org/licenses/>.

require 'optparse'

def gen_script(options)

    # base program name
    prog = options[:program].split('/').last

    nocfg = false
    if options[:config].nil?
        nocfg = true
    end

    # print script header to terminal
    print "#!/bin/bash\n#\n"
    print "# #{prog}\t\tTODO: please put a brief description here\n#\n"
    print "# chkconfig: #{options[:levels]} 99 01\t# TODO: set priorities\n"
    print "# description: TODO: long form of description goes here \\\n"
    print "# and can be written on multiple lines \\\n"
    print "# like this.\n\n"

    # print function sourcing
    print "# source function library\n"
    print ". /etc/init.d/functions\n\n"

    # print variable declarations
    print "prog=#{prog}\n"
    print "lockfile=/var/lock/subsys/#{prog}\n"
    if !nocfg
        print "cfgfile=#{options[:config]}\n"
    end
    print "options=\"\" # TODO: put default options here\n\n"

    # sanity checks
    print "[ \"$euid\" != \"0\" ] && exit 4\n"

    # start function
    print "start() {\n"
    print "  [ -x #{options[:program]} ] || exit 6\n"
    if !nocfg
        print "  [ -f $cfgfile ] || exit 5\n"
        print "  . $cfgfile\n\n"
    end

    print "  # start daemons\n"
    print "  echo -n $\"starting $prog: \"\n"
    print "  daemon $prog $options\n"
    print "  retval=$?\n"
    print "  echo\n"
    print "  [ $retval -eq 0 ] && touch $lockfile\n"
    print "  return $retval\n}\n\n"

    # stop function
    print "stop() {\n"
    print "  # stop daemons\n"
    print "  echo -n $\"shutting down $prog: \"\n"
    print "  killproc $prog\n"
    print "  retval=$?\n"
    print "  echo\n"
    print "  [ $retval -eq 0 ] && rm -f $lockfile\n"
    print "  return $retval\n}\n\n"

    # case selection
    print "# see how we're called\n"
    print "case \"$1\" in\n"
    print "  start)\n"
    print "      start\n      ;;\n"
    print "  stop)\n"
    print "      stop\n      ;;\n"
    print "  status)\n"
    print "      status $prog\n      ;;\n"
    print "  restart|force-reload)\n"
    print "      stop\n      start\n      ;;\n"
    print "  condrestart)\n"
    print "      if status $prog > /dev/null; then\n"
    print "        stop\n        start\n"
    print "      fi\n      ;;\n"
    print "  *)\n"
    print "      echo $\"usage: $0 {start|stop|status|restart"
    print "|condrestart|force-reload}\"\n"
    print "      exit 2\nesac\n"

end

options = { :program    => nil,
            :config     => nil,
            :levels     => "-"}

opts = OptionParser.new do |opts|
    opts.banner = "Usage: mkinitscr [options]"
    opts.separator ""
    opts.separator "options:"

    # program name
    opts.on("-p program", "--program program", "program name") do |prog|
        options[:program] = prog
    end

    # configuration file
    opts.on("-c [file]", "--config [file]", "config file") do |config|
        options[:config] = config || ""
    end

    # runlevels
    opts.on("-l [levels]", "--levels [levels]", "runlevels") do |runlevels|
        options[:levels] = runlevels || "-"
    end

    # help
    opts.on_tail("-h","--help", "show this message") do
        puts opts
        exit
    end

    opts.parse!(ARGV)
end

# if no program given, exit with a warning.
if options[:program].nil?
    puts "ERROR: no program name specified."
    puts opts
    abort()
end

gen_script(options)
