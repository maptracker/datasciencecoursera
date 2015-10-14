
* [Set and get](./Rnotes.md#setget) methods are generally written the
  same but are different underlying code.
* Be alert for [recycling](./Rnotes.md#recycling). This is where R
  needs additional data, so keeps looping through a "too short" input
  to make sure it has enough entries (like rectangularizing a
  matrix). You will be warned that recycling happens only if there is
  a modulus.
* The modulus operator is `%%`
* R will work to coerce modes for you to "make things work." This
  occurs transparently and may take you places you don't want to be.
* [NA](./Rnotes.md#NA) carries with it a specific mode, and can be any
  of the other modes.
* If you mistype the name of an argument in a
  [... function](./Rnotes.md#dotdotdot), the argument will be clumped
  into the generic pool of arguments specified by ... (and of course
  your intended named argument won't get set).
* There is a [bewildering array](./Rnotes.md#import) of low-level
  import / export functions.
* [read.table()](./Rnotes.md#import) will by default factorize
  character data. Use `stringsAsFactors = F` to prevent, or specify
  `colClasses` explicitly.
* There is no `strict` mode in R. It will work tierelessly to help
  you, even if it kills you in the process. Code defensively.
* [class() and data.class()](./Rnotes.md#dataclassweird) return
  different modes for integer vecors (integer and numeric,
  respectively).
* Argument parsing in [functions](./Rnotes.md#functions) is weird.
  * R can use partial matching in many places, including argument
    names. This is dangerous, aspire to use full argument names.
* Functions with the same name in different namespaces will
  [mask](./Rnotes.md#masking) each other. Use `conflicts()` to get a
  list of currently masked functions and `find()` to determine the
  packages they're in.
* [Symbol scoping](./Rnotes.md#scoping) is kind of weird.]
  * Scope is associated with **functions**, not the call stack.
* Don warns that R sometimes unexpectedly vectorizes output. If the
  output had a column header, then in the process of forcing a vector
  R might coerce all your values to character to accomodate the
  header.
* `:::` is not the same as `::`!