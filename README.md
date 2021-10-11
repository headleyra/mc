# Mc

**ModifyChain. Code like Lego(tm)**

A *ModifyChain Script* lists a 'chain' of 'modifiers' (functions) that, one by one, modify a
'buffer' (a string), eventually producing a result.

## Modifiers

All modifiers declare two arguments.  The first argument receives the modified buffer from the previous
modifier (in the chain) and the second argument receives the arguments for the modifier itself.  All
modifiers return either `{:ok, result}` or `{:error, reason}` (where 'result' and 'reason' are strings).

Let's say we have the following modifiers:

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

In order to use them we create a `Map` ('the mappings') that defines their names and specifies their
locations.  One such map might look like this:

```elixir
mappings =
  %{
    capify: {Foo.Big, :capify},
    change: {Bar.Replace, :edit},
    boom: {Biz.Boom, :crash}
  }
```

We've assigned the name 'capify' to the first modifier; 'change' to the second; 'boom' to the third.
Next we start the ModifyChain server and pass it the mappings:

```elixir
Mc.start_link(mappings: mappings)
```

## Now we can modify stuff

```elixir
Mc.modify("wine bar", "change glass")
  #=> {:ok, "wine glass"}
```

The first argument is the *initial* buffer and the second argument is the ModifyChain Script.  The
result is obtained by transforming the initial buffer with the named modifier and its arguments.
Effectively we ran the following code:

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

So, the output of one modifier is the input to the next, and so on.

If at any point a modifier returns an error tuple the next modifier simply passes it on down the chain,
unchanged.  This is the default behaviour for all of the 'standard modifiers'.  For example:

```elixir
script = """
change code
boom
capify
"""

Mc.modify("bar chart", script)
  #=> {:error, "boom!"}
```

## Standard modifiers

The `%Mc.Mappings{}` struct defines the standard mappings which reference basic (concept-prover) standard
modifiers.  Feel free to use your own custom mappings or (perhaps) create a tweaked version of
`%Mc.Mappings{}`.

The snippet `use Mc.Railway` appears at the top of all standard modifiers.  It creates functions that
implement the 'error short-circuiting' behaviour mentioned above (along with a few utility functions for
building error tuples).

## Infinite Lego(tm)

Now you can think about coding in the same way you think about building a Lego model: all newly purchased
bricks (modifiers you create) are automatically compatible with the bricks you already have.  And you can
purchase bricks that do absolutely anything.

Have fun!

<!--
Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/mc](https://hexdocs.pm/mc).
-->
