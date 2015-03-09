module fire_method1
  use fire_method_base
  implicit none

  type, extends(fire_method_base_type) :: fire_method1_type
   contains
     procedure, public :: do_fire
  end type fire_method1_type

contains

  subroutine do_fire(this, precip, soil_moisture, fire)
    class(fire_method1_type), intent(in) :: this
    real, intent(in) :: precip
    real, intent(in) :: soil_moisture
    real, intent(out) :: fire

    fire = precip + soil_moisture
  end subroutine do_fire
end module fire_method1
