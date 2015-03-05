# prototypes-clm-polymorphism\_with\_different\_interfaces
Prototypes for how to handle polymorphism when different implementations have
different interfaces

Overview of the problem
-----------------------

How can we handle the situation where two implementations (e.g., for fire
parameterizations) have different interfaces, in terms of the input variables
they require? I cannot see a straightforward way to do this using
polymorphism. These prototypes explore some alternatives.

I am most inclined towards Option #1 or Option #4. These are the two I provide
examples for. I am including other options here for completeness, but right now
I feel that the downsides of the other options outweigh the upsides.



General notes about the examples here
-------------------------------------

* For simplicity, I am making objects that contain scalar quantities, and am
  just passing scalar quantities as inputs to subroutines. In CLM, these would
  be arrays.
  

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


Option 2: Have the argument list contain only things that are in common between all implementations, storing pointers to other things that are needed
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
    rather than an inherent member of this class.



What is my preference?
----------------------

Hover over this to see my current preference. I'm doing this as a spoiler,
because I'd like you to formulate your own opinions first.



>!I lean towards Option 4 right now. This prevents the need for having lots of
>!unused arguments in each implementation, and needing to keep the interfaces in
>!sync between all of the implementations. The main downside is that you need to
>!put a wrapper in a separate module. However, a wrapper module is needed anyway
>!for the factory method, so I do not feel that this is too big of a downside.
