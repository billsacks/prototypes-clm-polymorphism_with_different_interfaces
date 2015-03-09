module fire_method2
  use fire_method_base
  implicit none

  type, extends(fire_method_base_type) :: fire_method2_type
   contains
     procedure, public :: do_fire
  end type fire_method2_type

contains

  subroutine do_fire(this, precip, temperature, fire)
    class(fire_method2_type), intent(in) :: this
    real, intent(in) :: precip
    real, intent(in) :: temperature
    real, intent(out) :: fire
    
    fire = precip + temperature
  end subroutine do_fire
end module fire_method2
