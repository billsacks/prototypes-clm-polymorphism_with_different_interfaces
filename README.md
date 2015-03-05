# prototypes-clm-polymorphism\_with\_different\_interfaces
Prototypes for how to handle polymorphism when different implementations have
different interfaces

Overview of the problem
=======================

How can we handle the situation where two implementations (e.g., for fire
parameterizations) have different interfaces, in terms of the input variables
they require? I cannot see a straightforward way to do this using
polymorphism. These prototypes explore some alternatives.

General notes about the examples here
=====================================

* For simplicity, I am making objects that contain scalar quantities, and am
  just passing scalar quantities as inputs to subroutines. In CLM, these would
  be arrays.
  

Option 1: Have the argument list for all implementations contain all arguments needed for any implementation
============================================================================================================

**See the option1 directory for an example**


