module fire_dispatcher
  use fire_base, only : fire_base_type
  use fire_method1, only : fire_method1_type
  use fire_method2, only : fire_method2_type
  implicit none

  ! This "dispatcher" module is the only place that knows about the individual
  ! implementations of the fire base class.

  ! In reality, this parameter would be read from a namelist file
  integer, parameter :: fire_method = 2
  
contains

  function create_fire_type()
    class(fire_base_type), allocatable :: create_fire_type
    
    select case (fire_method)
    case(1)
       allocate(create_fire_type, source = fire_method1_type(fire=0.))
    case(2)
       allocate(create_fire_type, source = fire_method2_type(fire=0.))
    end select
  end function create_fire_type

  subroutine do_fire(fire_inst, precip, temperature, soil_moisture)
    class(fire_base_type), intent(inout) :: fire_inst
    real, intent(in) :: precip
    real, intent(in) :: temperature
    real, intent(in) :: soil_moisture

    select type(fire_inst)
    class is (fire_method1_type)
       call fire_inst%do_fire(precip=precip, soil_moisture=soil_moisture)
    class is(fire_method2_type)
       call fire_inst%do_fire(precip=precip, temperature=temperature)
    end select
  end subroutine do_fire
end module fire_dispatcher

