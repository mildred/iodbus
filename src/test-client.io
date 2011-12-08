# printf "\0AUTH\r\nAUTH ANONYMOUS toto\r\n" | socat STDIO ABSTRACT-CONNECT:${${DBUS_SESSION_BUS_ADDRESS%,*}#*=}

bus := Client clone setSession
bus socket println
bus connect println
bus authenticate("ANONYMOUS") println
bus disconnect

