Client := Object clone do(

  init := method(
    address ::= nil
  )

  setSession := method(
    self address = AddressParser fromSession
    self
  )

  setSystem := method(
    self address = AddressParser fromSystem
    self
  )
  
  socket := method(
    self socket := self address asSocket
  )

  connectSession := method(
    self setSession
    self connect
  )
  
  connectSystem := method(
    self setSystem
    self connect
  )
  
  connect := method(
    ("Connect to " .. (self address path)) println
    self socket connect returnIfError
    self socket write("\0")
    self socket write("AUTH\r\n")
    self socket readUntilSeq("\r\n") println
    self
  )
  
  disconnect := method(
    self socket close
    self
  )

)
