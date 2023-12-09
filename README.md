# Mc

**ModifyChain. Code like Lego(tm)**

A *ModifyChain Script* lists a 'chain' of 'modifiers' that, one by one, modify a
'buffer', eventually producing a result.

## Modifiers

Modifiers are functions that declare three arguments.  The first is the modified buffer from the previous
modifier (in the chain), the second contains the arguments for the modifier itself and the third
is a `Map` ('the mappings').  All modifiers should return either `{:ok, result}` or
`{:error, reason}`.

Let's say we have the following modifiers:

```elixir
defmodule Foo.Big do
  use Mc.Railway, [:capify]

  def capify(buffer, _args, _mappings) do
    {:ok, String.upcase(buffer)}
  end
end

defmodule Bar.Replace do
  use Mc.Railway, [:edit]

  def edit(buffer, args, _mappings) do
    {:ok, String.replace(buffer, "bar", args)}
  end
end

defmodule Boom do
  use Mc.Railway, [:crash]

  def crash(_buffer, _args, _mappings) do
    {:error, "boom!"}
  end
end
```

In order to use them we create a `Map` (the mappings) that defines their names and specifies their
locations.  One such map might look like this:

```elixir
mappings =
  %{
    capify: {Foo.Big, :capify},
    change: {Bar.Replace, :edit},
    boom: {Boom, :crash}
  }
```

We've assigned the name 'capify' to the first modifier; 'change' to the second; 'boom' to the third.

## Now we can modify stuff

```elixir
Mc.modify("wine bar", "change glass", mappings)
  #=> {:ok, "wine glass"}
```

The first argument is the *initial* buffer and the second argument is the ModifyChain Script.  We pass
the mappings as the third argument and they are made available to any modifier (in the chain) that has an
interest in using them.

The result is obtained by transforming the initial buffer with the named modifier and its arguments.
Effectively we ran the following code:

```elixir
Bar.Replace.edit("wine bar", "glass", mappings)
  #=> {:ok, "wine glass"}
```

But we can chain modifiers together by listing them in the script, like so:

```elixir
script = """
change bottle
capify
"""

Mc.modify("wine bar", script, mappings)
  #=> {:ok, "WINE BOTTLE"}
```

This effectively runs the following code:

```elixir
{:ok, modified_buffer} = Bar.Replace.edit("wine bar", "bottle", mappings)
Foo.Big.capify(modified_buffer, "", mappings)
  #=> {:ok, "WINE BOTTLE"}
```

So, the output of one modifier is the input to the next, and so on.

If at any point a modifier returns an error tuple the next modifier simply passes it on down the chain,
unchanged.  For example:

```elixir
script = """
change code
boom
capify
"""

Mc.modify("bar chart", script, mappings)
  #=> {:error, "boom!"}
```

This is the default behaviour for the 'standard modifiers' but modifiers you create can behave
however they like.

## Standard modifiers

The `%Mc.Mappings{}` struct defines standard mappings which reference basic (concept-prover) 
modifiers.  Feel free to use your own custom mappings or (perhaps) create a tweaked version of
`%Mc.Mappings{}`.

The snippet `use Mc.Railway` appears at the top of all standard modifiers.  It creates functions that
implement the 'error short-circuiting' behaviour mentioned above (along with some simple utility functions).
