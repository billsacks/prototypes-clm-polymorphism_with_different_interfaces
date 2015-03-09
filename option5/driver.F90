program driver
  use fire, only : fire_type
  implicit none

  ! In practice, this would reside somewhere else (e.g., clm_instMod)
  type(fire_type) :: fire_inst

  ! In CLM, this would probably be done via an %Init call rather than a constructor
  fire_inst = fire_type()

  ! The call from the driver would look like this:
  call fire_inst%do_fire(precip = 1.0, temperature = 2.0, soil_moisture = 3.0)

  ! This confirms that the code worked as expected
  print *, fire_inst%fire
end program driver
