module fire_method2
  use fire_base
  implicit none

  type, extends(fire_base_type) :: fire_method2_type
   contains
     procedure, public :: do_fire
  end type fire_method2_type

contains

  subroutine do_fire(this, precip, temperature)
    class(fire_method2_type), intent(inout) :: this
    real, intent(in) :: precip
    real, intent(in) :: temperature

    this%fire = precip + temperature
  end subroutine do_fire
end module fire_method2
