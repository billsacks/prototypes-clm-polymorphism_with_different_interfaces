module fire_method1
  use fire_base
  implicit none

  type, extends(fire_base_type) :: fire_method1_type
   contains
     procedure, public :: do_fire
  end type fire_method1_type

contains

  subroutine do_fire(this, precip, soil_moisture)
    class(fire_method1_type), intent(inout) :: this
    real, intent(in) :: precip
    real, intent(in) :: soil_moisture

    this%fire = precip + soil_moisture
  end subroutine do_fire
end module fire_method1
