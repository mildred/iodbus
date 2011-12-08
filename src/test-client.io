# printf "\0AUTH\r\n" | socat STDIO ABSTRACT-CONNECT:/tmp/dbus-lZebuFbqhr

bus := Client clone setSession
bus socket println
bus connect println
bus disconnect

