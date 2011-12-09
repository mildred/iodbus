describe(DBus AddressParser,

  describe(parse, "parse",
    setup(
      p := DBus AddressParser clone
    )
    
    describe(unixSocket, "unixSocket",
      unixSocket("default unix socket",
        p parse("unix:path=/tmp/dbus-lZebuFbqhr,guid=2a113c4df97dd7ca7d6d2d1f00000029")
        p type verify(== "unix")
        p path verify(== "/tmp/dbus-lZebuFbqhr")
        p guid verify(== "2a113c4df97dd7ca7d6d2d1f00000029")
        p asString verify(== "unix:path=%2Ftmp%2Fdbus-lZebuFbqhr,guid=2a113c4df97dd7ca7d6d2d1f00000029")
      )
    )

    describe(abstractSocket, "abstractSocket",
      abstractSocket("default abstract linux socket",
        p parse("unix:abstract=/tmp/dbus-lZebuFbqhr,guid=2a113c4df97dd7ca7d6d2d1f00000029")
        p type verify(== "unix")
        p path verify(== "\0/tmp/dbus-lZebuFbqhr")
        p guid verify(== "2a113c4df97dd7ca7d6d2d1f00000029")
        p asString verify(== "unix:abstract=%2Ftmp%2Fdbus-lZebuFbqhr,guid=2a113c4df97dd7ca7d6d2d1f00000029")
      )
    )
  )
)
