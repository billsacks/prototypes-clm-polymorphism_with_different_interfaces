module fire_base
  implicit none

  type, abstract :: fire_base_type
     real :: fire
   contains
     procedure(do_fire_interface), deferred, public :: do_fire
  end type fire_base_type

  abstract interface

     subroutine do_fire_interface(this, precip, temperature, soil_moisture)
       import :: fire_base_type
       class(fire_base_type), intent(inout) :: this
       real, intent(in) :: precip
       real, intent(in) :: temperature
       real, intent(in) :: soil_moisture
     end subroutine do_fire_interface

  end interface

end module fire_base
