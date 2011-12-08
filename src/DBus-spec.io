describe(DBus,
  describe(parseType, "parseType",
    describe(type, "simple types",
      type("BYTE",
        DBus parseType("y") verify(== "y")
      )
      type("BOOLEAN",
        DBus parseType("b") verify(== "b")
      )
      type("INT16",
        DBus parseType("n") verify(== "n")
      )
      type("UINT16",
        DBus parseType("q") verify(== "q")
      )
      type("INT32",
        DBus parseType("i") verify(== "i")
      )
      type("UINT32",
        DBus parseType("u") verify(== "u")
      )
      type("INT64",
        DBus parseType("x") verify(== "x")
      )
      type("UINT64",
        DBus parseType("t") verify(== "t")
      )
      type("DOUBLE",
        DBus parseType("d") verify(== "d")
      )
      type("STRING",
        DBus parseType("s") verify(== "s")
      )
      type("OBJECT_PATH",
        DBus parseType("o") verify(== "o")
      )
      type("SIGNATURE",
        DBus parseType("g") verify(== "g")
      )
    )
  )
)
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
    
#     describe(struct, "struct",
#       struct("one integer",
#         list(8) asDBus("(i)", DBus BigEndian)    verify(== seq(0x0, 0x00, 0x00, 0x8))
#         list(8) asDBus("(i)", DBus LittleEndian) verify(== seq(0x8, 0x00, 0x00, 0x0))
#       )
#       struct("one integer and one byte",
#         list(7, 4) asDBus("(iy)", DBus BigEndian)    verify(== seq(0x0, 0x00, 0x00, 0x7, 0x4))
#         list(7, 4) asDBus("(iy)", DBus LittleEndian) verify(== seq(0x7, 0x00, 0x00, 0x0, 0x4))
#       )
#       struct("one integer and one byte and one substructure aligned on 8 byte boundary",
#         list(7, 4, list(true))  asDBus("(iy(b))", DBus BigEndian)    verify(== seq(0x0, 0x00, 0x00, 0x7, 0x4, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0))
#         list(7, 4, list(false)) asDBus("(iy(b))", DBus LittleEndian) verify(== seq(0x7, 0x00, 0x00, 0x0, 0x4, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0))
#       )
#     )
  )
)
