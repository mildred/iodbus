DBus := Object clone do(

  BigEndian := Object clone
  LittleEndian := Object clone
  
  BigEndian other := LittleEndian
  LittleEndian other := BigEndian
  
  machineEndianness := method(
    self machineEndianness := if(1 asUint32Buffer at(0) == 1, LittleEndian, BigEndian)
  )

)

Object seq := method(
  res := Sequence clone
  call message argsEvaluatedIn(call sender) foreach(n,
    res append(n)
  )
  res
)


Object do(

  asDBus := method(type, endian,
    type switch(
      "i",
        res := self asUint32Buffer
        endian switch(
          DBus machineEndianness,       res,
          DBus machineEndianness other, res reverse,
          res),
      "y",
        self asCharacter,
      "b",
        if(self, seq(0x0, 0x0, 0x0, 0x1), seq(0x0, 0x0, 0x0, 0x0)),
      ""
    )
  )

)

