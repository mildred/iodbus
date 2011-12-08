Regex

AddressParser := Object clone do(

  init  := method(
    type ::= "none"
    path ::= ""
    guid ::= ""
  )
  
  parse := method(address,
    res := address findRegex("^([^:]*):(.*)$")
    self type = res at(1)
    res at(2) split(",") foreach(str,
      pair := str findRegex("^([^=]*)=(.*)$")
      pair at(1) switch(
        "path",     self path = pair at(2) urlDecoded,
        "abstract", self path = "\0" .. pair at(2) urlDecoded,
        "guid",     self guid = pair at(2) urlDecoded
      )
    )
    self
  )
  
  asString := method(
    self type switch(
      "unix",
        "unix:" ..
        if(self path at(0) == 0,
           "abstract=" .. self path exSlice(1) urlEncoded,
           "path=" .. self path urlEncoded) ..
        ",guid=" .. self guid urlEncoded,
      self type .. ":"
    )
  )
  
  asSocket := method(
    Socket clone setPath(self path)
  )
  
  fromSession := method(
    self clone parse(System getEnvironmentVariable("DBUS_SESSION_BUS_ADDRESS"))
  )
  
  fromSystem := method(
    env := System getEnvironmentVariable("DBUS_SYSTEM_BUS_ADDRESS")
    self clone parse(if(env, env, "unix:path=/var/run/dbus/system_bus_socket"))
  )
)
