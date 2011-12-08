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

# Sequence pack(format, obj, ...)
# Returns a new Sequence with the values packed in.
# 
# 	Codes:
# 	
# 	*: (one at the beginning of the format string) declare format string as BigEndian
# 	B: unsigned byte
# 	b: byte
# 	C: unsigned char
# 	c: char
# 	H: unsigned short
# 	h: short
# 	I: unsigned int
# 	i: int
# 	L: unsigned long
# 	l: long
# 	f: float
# 	F: double
# 	s: string
# 
# 	A '*' at the begging of the format string indicates native types are to be treated as Big Endiand.
# 	
# 	A number preceding a code declares an array of that type.
# 	
# 	In the case of 's', the preceding number indicates the size of the string to be packed.
# 	If the string passed is shorter than size, 0 padding will be used to fill to size. If the
# 	string passed is longer than size, only size chars will be packed.
# 	
# 	The difference between b/B and c/C is in the values passed to pack. For b/B pack expects a number.
# 	For c/C pack expects a one-char-string (this is the same as '1s' or 's')
# 	
# 	Examples:
# 	
# 	s := Sequence pack("IC5s", 100, "a", "hello")
# 	s := Sequence pack("5c", "h", "e", "l", "l", "o")
# 	s := Sequence pack("I", 0x01020304)
# 	s := Sequence pack("*I", 0x01020304)

Object do(

  asDBus := method(type, endian,
    pack_prefix := endian switch(
      DBus BigEndian,    "*",
      DBus LittleEndian, "",
      if(DBus machineEndianness == DBus BigEndian, "*", "")
    )
    type switch(
      "i",
        Sequence pack(pack_prefix .. "i", self),
      "y",
        self asCharacter,
      "b",
        if(self, seq(0x0, 0x0, 0x0, 0x1), seq(0x0, 0x0, 0x0, 0x0)),
      type at(0) asCharacter switch(
        Error with("Cound not encode "..type)
      )
    )
  )

)

