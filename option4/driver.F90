program driver
  use fire_dispatcher, only : create_fire_type, do_fire
  use fire_base, only : fire_base_type
  implicit none

  ! In practice, this would reside somewhere else (e.g., clm_instMod)
  class(fire_base_type), allocatable :: fire_inst

  ! In practice, the following would be done in initialization
  allocate(fire_inst, source = create_fire_type())

  ! The call from the driver would look like this:
  call do_fire(fire_inst, precip = 1.0, temperature = 2.0, soil_moisture = 3.0)

  ! This confirms that the code worked as expected
  print *, fire_inst%fire
end program driver
