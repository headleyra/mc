# Mc

**Code like Lego(tm)**

A *ModifyChain* 'script' specifies a 'chain' of 'modifiers' (functions) that, one by one, transform a
'buffer', eventually producing a result.

## Installation

## Example

### Modifiers

All modifiers declare two arguments and return either `{:ok, result}` or `{:error, reason}`.  The first
argument will be passed the *modified* buffer from the previous modifier (in the chain).  The second
argument will be passed the arguments for the modifier itself.

```elixir
defmodule Foo.Big do
  use Mc.Railway, [:capify]
  def capify(buffer, _args), do: {:ok, String.upcase(buffer)}
end

defmodule Bar.Replace do
  use Mc.Railway, [:edit]
  def edit(buffer, args), do: {:ok, String.replace(buffer, "bar", args)}
end

defmodule Biz.Boom do
  use Mc.Railway, [:crash]
  def crash(_buffer, _args), do: {:error, "boom!"}
end
```

### Mappings

To use the modifiers, above, we need to create a `Map` that defines their names and specifies their
locations.  This map is said to define the 'mappings'.  One such map might look like this:

```elixir
mappings =
  %{
    capify: {Foo.Big, :capify},
    change: {Bar.Replace, :edit},
    boom: {Biz.Boom, :crash}
  }
```

We've assigned the name 'capify' to the first modifier; 'change' to the second; 'boom' to the third.
Next we start the ModifyChain server, passing it the mappings:

```elixir
Mc.start_link(mappings)
```

### Now we can modify stuff

```elixir
Mc.modify("wine bar", "change glass")
  #=> {:ok, "wine glass"}
```

The first argument is the *initial* buffer and the second is the modify script.  The result is obtained by
transforming the initial buffer with the appropriate modifier and its arguments.  Effectively we ran the
following code:

```elixir
Bar.Replace.edit("wine bar", "glass")
  #=> {:ok, "wine glass"}
```

But we can chain modifiers together by listing them in the script, like so:

```elixir
script = """
change bottle
capify
"""

Mc.modify("wine bar", script)
  #=> {:ok, "WINE BOTTLE"}
```

This effectively runs the following code:

```elixir
{:ok, new_buffer} = Bar.Replace.edit("wine bar", "bottle")
Foo.Big.capify(new_buffer, "")
  #=> {:ok, "WINE BOTTLE"}
```

So, the output of one modifier is the input to the next, and so on.  If at any point a modifier returns
an error tuple, the whole process is short-circuited and the error tuple is returned immediately.  This
is the default behaviour (for the standard modifiers, see below) and is handled by the `use Mc.Railway`
code:

```elixir
script = """
change code
boom
capify
"""

Mc.modify("bar chart", script)
  #=> {:error, "boom!"}
```

### Standard mappings

The `%Mc.Mappings{}` struct defines the standard mappings and references basic, concept-prover
modifiers.  Feel free to use your own custom mappings, or (perhaps) create a tweaked version of the standard
ones.

### Infinite Lego(tm)

Now you can think about coding in the same way you think about Lego -- all modifiers are automatically
compatible with all other modifiers.  And you can write modifiers to do absolutely anything.  Have fun!

<!--
Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/mc](https://hexdocs.pm/mc).
-->
