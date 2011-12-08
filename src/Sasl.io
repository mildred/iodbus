Sasl := Object clone do(

  getMethod := method(name,
    name switch(
      "ANONYMOUS", self Anonymous clone,
      Error with("no SASL method "..name.." available")
    )
  )

)

Sasl Method := Object clone do(

  init := method(
    self authenticated := false
    self finished      := false
  )

)

Sasl Anonymous := Object clone do(

  init := method(
    self trace_information ::= "anonymous"
    resend;
  )

  challenge := method(response,
    response isNil ifFalse (
      self trace_information = response
      self finished         := true
      self authenticated    := true
    )
    ""
  )
  
  response := method(challenge,
    self finished := true
    self trace_information
  )

)

