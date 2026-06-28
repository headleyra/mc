# Mc

An **MC Script** lists a 'chain' of 'modifiers' that, one by one, modify a
'buffer', eventually producing a result.

We've registered (:-P) two new terms to explain the project philosphy:

**Code Like Lego<sup>&reg;</sup>** describes a programming technique/environment where code is packaged
into self-contained 'lego bricks' which can be easily configured, and assembled, to produce some useful result
'model'. Bricks and models (no matter how complex) are functionally indistinguishable, meaning
we can create ever more complex models by assembling any combination of bricks and other,
previously created, models.

**One Page Manual<sup>&reg;</sup>** systems are operated in a consistent way (with no exceptions). All interactions with the system 'look and feel' the same. After a user becomes familiar with the basics they almost immediately become an expert &mdash; because there's nothing else to learn.  The clue's in the name &mdash; the manual literally fits on one page!

## MC Script

MC Script is based around a single, simple 'runner' function.  It's essentially a 'map/reduce'.  To arrive at a final result, 'modifiers' (see below), are called in sequence.

The 'runner' function signature looks like this:

`Mc.m(buffer, script, mappings)`

`buffer` is the 'initial value' of the 'map/reduce'.  It's a string.

Each line in `script` references a 'modifier' along with its corresponding arguments.  Let's say we have the following script:

```elixir
script =
  """
  replace foo bar
  casel
  """
```

The first modifier referenced is 'replace' and its arguments are 'foo bar'.  The second modifier is 'casel' and it has no arguments.

To map modifiers to the actual code that's executed when they are invoked, we use a `Map` ('the mappings').  Let's say we have:

```elixir
mappings = %{
  casel: Mc.Modifier.CaseL,
  range: Mc.Modifier.Range,
  replace: Mc.Modifier.Replace
}
```

Any time 'replace' is encountered in a script we know we should execute a function in the `Mc.Modifier.Replace` module.  This works in the same way for 'casel' and 'range'.  As dictated by the `use Mc.Modifier` snippet, we expect the function (within the relevant module) to be called `m`.  All modifiers should use this snippet.

## Modifiers

A typical modifier signature looks like this:

`SomeModule.m(buffer, args, mappings)`

The 'runner' (mentioned above) 'map/reduces' its initial `buffer` by calling out to the modifiers in its script, passing them their arguments.

## OK Tuples And Error Tuples

Modifiers only return 'OK tuples' or 'Error tuples'.

As you'd expect, an OK tuple signals that 'all went well' and an error tuple indicates that something went wrong.

OK tuples they look like this:

`{:ok, result}`

The 'runner' passes these values onto the next modifier in the script (for further modification).

Error tuples look like this:

`{:error, modifier_module, error_type, error_message, list_of_errors}`

The `modifier_module` is the module of the modifier where the error occurred.  The `error_type` is an atom that describes the overall error type.  `error_message` is a string that provides more detail about the error and `list_of_errors` is a list of (previous) modifier errors (like a stacktrace).

If at any point a modifier returns an error tuple, the expectation is that the next modifier 'in the chain'   returns that error tuple unchanged, or more likely, and more desirably, that it wraps it in its own error and returns that instead.  This 'short-circuiting' behaviour is facilatated by the `use Mc.Modifier` snippet.

## An Example

The `Mc.Mappings.standard/0` function returns standard mappings which reference basic (concept-prover) 
modifiers.  Consider the following code:

```elixir
mappings = Mc.Mappings.standard()

script =
  """
  replace FOO bar
  caseu
  """

Mc.m("FOO", script, mappings)
```

The 'replace' modifier does a 'search/replace', so, in the script above, where we see 'FOO' we replace it with 'bar'.  The 'caseu' modifier 'upper-cases' its input.

Therefore, after running `Mc.m("FOO", script, mappings)` we get `{:ok, "BAR"}`

Consider a different script:

```elixir
script =
  """
  buffer stuff in the buffer
  error we gotta problem
  """
```

The 'buffer' modifier puts something in the buffer to be modified 'downstream'.  So, after 'buffer stuff in the buffer' is executed, we get `{:ok, "stuff in the buffer"}`.

The 'error' modifier, unconditionally returns an error tuple.  This 'short-circuits' everything, and so after running 'error we gotta problem', we get `{:error, Mc.Modifier.Error, :error, "we gotta a problem", []}`

## Standard Mappings

The standard mappings (`Mc.Mappings.standard()`) are a great place to start but they can be mixed and matched to suit your needs, like so:

```elixir
defmodule Foo do
  use Mc.Modifier

  def m(buffer, _args, _mappings), do: {:ok, "foo"}
end

defmodule Orange.Lemon do
  use Mc.Modifier

  def m(buffer, _args, _mappings), do: {:ok, "oranges and lemons"}
end

my_fantastic_modifier_mappings = %{
  foo: Foo,
  fruit: Orange.Lemon
}

mappings =
  Mc.Mappings.standard()
  |> Map.merge(my_fantastic_modifier_mappings)
```
