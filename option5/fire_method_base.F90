module fire_method_base
  implicit none

  type, abstract :: fire_method_base_type
     ! Note that this does NOT define an interface for do_fire, because each
     ! implementation will have a different interface for that method.
     !
     ! It feels kind of weird to have an empty base type. In practice, there might be
     ! some subroutines shared between the different fire methods - at the very least, an
     ! init method.
  end type fire_method_base_type

end module fire_method_base
