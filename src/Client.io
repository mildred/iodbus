Client := Object clone do(

  init := method(
    self address ::= nil
    self authenticated := false
    self auth_methods  := list()
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
    self socket connect returnIfError
    self socket write("\0")
    self socket write("AUTH\r\n")
    self auth_methods := self socket readUntilSeq("\r\n") split(" ") exSlice(1)
    self
  )
  
  authenticate := method(sasl_method, trace,
    if(trace isNil, trace := method(a, a))
    if(trace == true, trace := method(a, a println; a))

    m := Sasl getMethod(sasl_method) returnIfError
    
    command_raw ::= ""
    command     ::= list()
    
    receive := method(
      command_raw = self socket readUntilSeq("\r\n")
      trace(command_raw)
      command     = command_raw split(" ")
    )
    
    send := method(cmd,
      cmd := cmd remove(nil) join(" ")
      trace(cmd)
      self socket write(cmd .. "\r\n")
    )
    
    waitingForData := method(
      receive
      command at(0) switch(
        "DATA",
          resp := m response(command at(2) fromHex)
          if(resp isError)
          then(send(list("ERROR", resp message)))
          else(send(list("DATA", resp asHex)))
          if(m finished)
          then(return(waitingForOk))
          else(return(waitingForData)),
        "REJECTED",
          return(Error with(command_raw)),
        "ERROR",
          send(list("CANCEL"))
          return(waitingForReject),
        "OK",
          send(list("BEGIN"))
          return(command at(1)),
        send(list("ERROR"))
        return(waitingForOk)
      )
    )
    
    waitingForOk := method(
      receive
      command at(0) switch(
        "OK",
          send(list("BEGIN"))
          return(command at(1)),
        "REJECTED",
          return(Error with(command_raw)),
        "DATA",
          send(list("CANCEL"))
          return(waitingForReject),
        "ERROR",
          send(list("CANCEL"))
          return(waitingForReject),
        send(list("ERROR"))
        return(waitingForOk)
      )
    )
    
    waitingForReject := method(
      receive
      command at(0) switch(
        "REJECTED",
          return(Error with(command_raw)),
        return(Error with("SASL transaction failed"))
      )
    )
    
    initial_resp := m response
    send(list("AUTH", sasl_method, if(initial_resp isNil, nil, initial_resp asHex)))
    if(m finished, waitingForOk, waitingForData)
  )
  
  disconnect := method(
    self socket close
    self
  )

)

# Patching Sequence

Sequence fromHex := method(
  res := Sequence clone;
  for(i, 1, self size, 2,
    res append(self exSlice(i-1, i+1) fromBase(16))
  );
  res
)
