module fire
  use fire_method_base, only : fire_method_base_type
  use fire_method1, only : fire_method1_type
  use fire_method2, only : fire_method2_type
  
  implicit none

  type :: fire_type
     real :: fire
     class(fire_method_base_type), allocatable :: fire_method
   contains
     procedure, public :: do_fire
  end type fire_type

  interface fire_type
     module procedure constructor
  end interface fire_type

  ! In reality, this parameter would be read from a namelist file
  integer, parameter :: fire_method = 2
  
contains

  function constructor()
    type(fire_type) :: constructor

    constructor%fire = 0.
    
    select case (fire_method)
    case(1)
       allocate(constructor%fire_method, source = fire_method1_type())
    case(2)
       allocate(constructor%fire_method, source = fire_method2_type())
    end select
  end function constructor

  subroutine do_fire(this, precip, temperature, soil_moisture)
    class(fire_type), intent(inout) :: this
    real, intent(in) :: precip
    real, intent(in) :: temperature
    real, intent(in) :: soil_moisture

    ! This is kind of like the strategy pattern, but rather than each strategy having a
    ! common interface, we use a select type statement to dispatch to the appropriate
    ! method.
    associate(fire_method => this%fire_method)
    select type(fire_method)
    class is (fire_method1_type)
       call fire_method%do_fire(precip=precip, soil_moisture=soil_moisture, fire=this%fire)
    class is (fire_method2_type)
       call fire_method%do_fire(precip=precip, temperature=temperature, fire=this%fire)
    end select
    end associate
  end subroutine do_fire
  
end module fire
