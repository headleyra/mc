# Mc

A **Modify Chain Script** (aka **MC Script**) lists a 'chain' of 'modifiers' that, one by one, modify a
'buffer', eventually producing a result.

We've registered (:-p) two new terms to explain the project philosphy:

**Code Like Lego<sup>&reg;</sup>** describes a programming technique/environment where code is packaged
into self-contained 'lego bricks' which can be easily configured, and assembled, to produce some useful result
'model'. Bricks and models (no matter how complex) are functionally indistinguishable, meaning
we can create ever more complex models by assembling any combination of bricks and other,
previously created, models.

**One Page Manual<sup>&reg;</sup>** systems are operated in a consistent way (with no exceptions). All interactions with the system 'look and feel' the same. After a user becomes familiar with the basics they almost immediately become an expert &mdash; because there's nothing else to learn.  The clue's in the name &mdash; the manual literally fits on one page!

## MC Script

MC Script is based around a single, simple 'runner function'.  It's essentially a map/reduce.  To arrive at a result, modifiers are called in sequence.

The runner function looks like this:

`Mc.m(buffer, script, mappings)`

`buffer` is the initial value for the map/reduce.  It's a string.

Each line in `script` references a modifier along with its arguments.  Let's say we have the following script:

```elixir
script =
  """
  replace foo bar
  casel
  """
```

The first modifier is 'replace' and its arguments are 'foo' and 'bar'.  The second modifier is 'casel' and it has no arguments.

To map modifiers to the actual code that's executed when they are invoked, we use a `Map` ('the mappings').  Let's say we have:

```elixir
mappings = %{
  casel: Mc.Modifier.CaseL,
  range: Mc.Modifier.Range,
  replace: Mc.Modifier.Replace
}
```

When 'replace' is encountered in a script we know that we should execute a function in the `Mc.Modifier.Replace` module.  This works in the same way for 'casel' and 'range'.  As dictated by the `use Mc.Modifier` snippet, we expect that function to be called `m`.  All modifiers should use this snippet (unless they have a good reason not to).

## Modifiers

A typical modifier might look something like this:

```elixir
defmodule Echo.Args do
  use Mc.Modifier

  def m(buffer, args, _mappings) do
    {:ok, args}
  end
end
```

The runner function calls modifiers with the following values: the current buffer, the arguments for the modifier, and lastly, the mappings.  With these values at hand a modifier has all it needs to do useful stuff.

## OK Tuples And Error Tuples

Modifiers return one of two things: 'OK tuples' or 'error tuples'.

As you'd expect, an OK tuple signals that 'all went well' and an error tuple indicates that something went wrong.

OK tuples look like this:

`{:ok, result}`

So, we might have something like:

`{:ok, "foo bar"}`

The runner function passes these values onto the next modifier (as the `buffer` argument, see Modifiers, above).

Error tuples look like this:

`{:error, modifier_module, error_type, error_message, list_of_errors}`

The `modifier_module` is the module of the modifier where the error occurred.  The `error_type` is an atom that describes the overall error type.  `error_message` is a string that provides more detail about the error, and `list_of_errors` is a list of (previous) modifier errors (like a stacktrace).

If at any point a modifier returns an error tuple, the expectation is that the next modifier 'in the chain' returns that error tuple unchanged, or more likely, and more desirably, that it 'wraps' it in its own error and returns that instead.  This short-circuiting behaviour is facilatated by the `use Mc.Modifier` snippet.

So, we might have something like:

`{:error, Car.Computer, :petrol, "low", [{Fuel.Tank, :problem, "leak"}]}`

## An Example

The `Mc.Mappings.standard/0` function returns standard mappings which reference basic (concept-prover) 
modifiers.  Consider the following code:

```elixir
mappings = Mc.Mappings.standard()

script =
  """
  replace FOO BAR
  casel
  """

Mc.m("FOO", script, mappings)
```

The 'replace' modifier does a search/replace, so, in the script above, where we see 'FOO' we replace it with 'BAR'.  The 'casel' modifier lower-cases its input.

Therefore, after running `Mc.m("FOO", script, mappings)` we get `{:ok, "bar"}`

Consider a different script:

```elixir
script =
  """
  buffer stuff in the buffer
  error we got a problem
  """
```

The 'buffer' modifier puts something in the buffer.  So, after 'buffer stuff in the buffer' is executed, we get `{:ok, "stuff in the buffer"}`.

The 'error' modifier unconditionally returns an error tuple.  This short-circuits the modify chain, and so, after running 'error we got a problem', we get `{:error, Mc.Modifier.Error, :error, "we got a problem", []}`

## Standard Mappings

The standard mappings (`Mc.Mappings.standard()`) are a great place to start but they can be mixed and matched to suit your needs, like so:

```elixir
defmodule Add.Ingredient do
  use Mc.Modifier

  def m(buffer, args, _mappings), do: {:ok, "#{buffer} with #{args}"}
end

defmodule Lemonade do
  use Mc.Modifier

  def m(buffer, _args, _mappings), do: {:ok, "lemonade"}
end

my_fantastic_modifier_mappings = %{
  add: Add.Ingredient,
  lemonade: Lemonade
}

mappings =
  Mc.Mappings.standard()
  |> Map.merge(my_fantastic_modifier_mappings)

