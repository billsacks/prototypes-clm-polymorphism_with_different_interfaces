# prototypes-clm-polymorphism\_with\_different\_interfaces
Prototypes for how to handle polymorphism when different implementations have
different interfaces

Overview of the problem
-----------------------

How can we handle the situation where two implementations (e.g., for fire
parameterizations) have different interfaces, in terms of the input variables
they require? I cannot see a straightforward way to do this using
polymorphism. These prototypes explore some alternatives.

I am most inclined towards Option #1 or Option #2. These are the two I provide
examples for. I am including other options here for completeness, but right now
I feel that the downsides of the other options outweigh the upsides.



General notes about the examples here
-------------------------------------

For simplicity, I am making objects that contain scalar quantities, and am just
passing scalar quantities as inputs to subroutines. In CLM, these would be
arrays.
  

Option 1: Have the argument list for all implementations contain all arguments needed for any implementation
------------------------------------------------------------------------------------------------------------

**Example implementation: See the option1 directory**

**Pros:**

1. Probably the simplest to implement.

**Cons:**

1. When adding a new implementation, or changing the argument list of an existing
implementation, you need to modify all other implementations.

2. You cannot see at a glance which arguments are actually used by each
implementation

**Possible variant:** The common routine (with unused arguments) could simply be
  a wrapper to the real routine in each implementation. This real routine would
  contain only the arguments that are actually needed by this
  implementation. This would do away with con #2, for the most part.

e.g., in the fire example, this would mean that, for fire_method1, we would
have:

    subroutine do_fire(this, precip, temperature, soil_moisture)
      class(fire_method1_type), intent(inout) :: this
      real, intent(in) :: precip
      real, intent(in) :: temperature   ! IGNORED!
      real, intent(in) :: soil_moisture

      call this%do_fire_method1(precip=precip, soil_moisture=soil_moisture)
    end subroutine do_fire

    subroutine do_fire_method1(this, precip, soil_moisture)
      class(fire_method1_type), intent(inout) :: this
      real, intent(in) :: precip
      real, intent(in) :: soil_moisture

      this%fire = precip + soil_moisture
    end subroutine do_fire_method1



Option 2: Use a non-object-oriented wrapper that accepts all possible arguments, but then dispatches to the correct method using a 'select type' statement
----------------------------------------------------------------------------------------------------------------------------------------------------------

**Example implementation: See the option2 directory**

From the point of view of the caller, this is similar to option 1, except now
the call would not use object-oriented syntax; i.e., rather than calling:

    call some_inst%do_something(...)

callers would call:

    call do_something_wrapper(some_inst, ...)

and then do\_something\_wrapper would have code like:

    select type (some_inst)
    class is (some_type1)
      call some_inst%do_something([args needed by type1's do_something routine])
    class is (some_type2)
      call some_inst%do_something([args needed by type2's do_something routine])

This would also look similar to the non-object-oriented solution that we were
gravitating towards in CLM, for supporting multiple implementations of things
like the soil water retention curve method. (In that solution there was a
wrapper routine that dispatched to the correct actual routine based on the value
of some control flag.) In fact, that old solution is probably preferable in
cases where we are selecting between state-less routines, since it doesn't
require invoking object orientation at all. But the solution here may be
preferable when there is some attached state ('fire' in the provided example.)

The wrapper can go in the same module that provides the factory method, since
this module already needs to know about the individual types (and is the ONLY
module in the system that needs to know about these individual types).

Note that, in this solution, the do\_something routine is NOT part of the base
class interface. Instead, each type provides its own implementation of
do\_something, and the interfaces can differ between them. The base class is
then mainly there for the sake of defining public data that can be accessed by
other parameterizations. (And there could still be some routines shared between
the different implementations, if they could agree on an interface for these
routines.)

**Pros:**

1. It's easy to see what each implementation depends on (by avoiding unused
arguments).

2. When introducing a new parameterization, or changing the input argument
   requirements of an existing parameterization, you do not need add arguments
   to other parameterizations.

**Cons:**

1. Requires some extra logic (including a select type statement) in some
   separate dispatcher module. (However, note that a wrapper module is needed
   anyway for the factory method, so in my mind this is not a huge downside.)

2. The calling style differs depending on whether you are using this extra
   wrapper level (i.e., a procedural calling style vs. an object-oriented
   calling style). I feel like there could be a way around this, but all of the
   simple solutions I can think of introduce circular dependencies (or require
   that you combine multiple classes into a single module, which I view as a
   significant step backwards).

3. Select type statements are generally considered evil in object-oriented
   programming. This makes me worry that there may be some practical issues that
   I am overlooking here.

4. Since the common routine (do\_something) is no longer declared in the base
   class, it may not be quite as obvious that each implementation is still
   supposed to implement this do\_something routine.


Option 3: Have the argument list contain only things that are in common between all implementations, storing pointers to other things that are needed
-----------------------------------------------------------------------------------------------------------------------------------------------------

**Example implementation: NOT YET PROVIDED**

Arguments unique to a given implementation could then be handled in one of a few
ways, all of which involve storing pointers to things this implementation needs
(either via the constructor / init method [probably ideal], or via setter
methods that are called when the instance is created):

1. Store a pointer to the whole model instance that contains this particular
object

    However, this feels like a back-door way to get global access to everything
    without being more explicit about what you're using.

2. Store pointers to each derived type that this implementation depends on

3. Store pointers to individual arrays that are needed

    Storing pointers directly in the object would be problematic, because there
    would be nothing to signal that these are pointers to external things,
    rather than an inherent member of this class. However, we could introduce a
    sub-component of the class (e.g., named external_stuff) which is a derived
    type that contains pointers to these various individual arrays.

    But this still would have some problems:

  * You need to write this%external_stuff%foo
  * It's harder to find where the various external stuff came from
  * Using pointers carries a performance penalty
  * The array pointed to needs to be a target

**Pros:**

1. I feel like this represents a compromise solution in some sense.

**Cons:**

1. Figuring out the interface (input arguments) to a given routine becomes more
   complex, because you need to consider pointers stored in initialization. This
   is especially true if there are multiple subroutines in a class, some of
   which use one set of pointers stored in initialization, and some of which use
   a different set of pointers.

2. Storing pointers to individual arrays is awkward, as noted above.

3. It would be impossible to use this strategy if some implementations depend on
   a subroutine local variable in the caller (which therefore could not be
   passed in to the constructor at initialization time).

4. Unless we use this scheme pro-actively all the time, it would require a
   significant rework of a class's interface whenever we first introduce an
   alternative parameterization that has a different interface: We would need to
   strip down the subroutine interface, and add a bunch of pointers that are set
   in initialization.

5. It is awkward to have some parameters passed in explicitly as arguments, and
   others accessed as pointers set in initialization. So we may want to set ALL
   argumetns to such subroutines as pointers in initialization. (Also, if we had
   a mix of explicit arguments and pointers-set-in-initialization, then we could
   have a similar problem to the one in option #1: If a new parameterization is
   introduced that has a smaller set of input arguments, then we need to rework
   all of the implementations to move more things out of the argument list.)


Option 4: Reduce our use of explicit arguments, instead accessing inputs via 'use' statements.
----------------------------------------------------------------------------------------------

This would represent an abandonment of explicit arguments, and the benefits
gained from them. However, it would **not** mean needing to abandon modularity:
we could have 'use' statements that use particular objects that are needed as
inputs in this implementation.

Mariana has cast a resounding NO vote against this option.

