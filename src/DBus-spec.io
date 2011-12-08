DBus
describe(Object,

  describe(asDBus, "asDBus",

    describe(integer, "integer",
      integer("integer",
        3 asDBus("i") verify(== 3 asDBus("i", DBus machineEndianness))
      )
      integer("integer LE",
        3 asDBus("i", DBus LittleEndian) verify(== seq(0x3, 0x0, 0x0, 0x0))
      )
      integer("integer BE",
        3 asDBus("i", DBus BigEndian) verify(== seq(0x0, 0x0, 0x0, 0x3))
      )
    )

    describe(byte, "byte",
      byte("byte",
        3 asDBus("y") verify(== seq(0x3))
      )
    )

    describe(boolean, "boolean",
      boolean("true",
        true asDBus("b") verify(== seq(0x0, 0x0, 0x0, 0x1))
      )
      boolean("false",
        false asDBus("b") verify(== seq(0x0, 0x0, 0x0, 0x0))
      )
    )
  )
)
