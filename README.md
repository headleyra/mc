# Mc

**ModifyChain &mdash; Code Like Lego<sup>&reg;</sup> Manual Free System<sup>&reg;</sup>**

A ***ModifyChain Script*** lists a 'chain' of 'modifiers' that, one by one, modify a
'buffer', eventually producing a result.

We've registered (:-P) two new terms to explain the project philosphy:

***Code Like Lego<sup>&reg;</sup>*** describes a programming technique/environment where code is packaged
into self-contained 'lego bricks' which can be easily configured, and assembled, to produce some useful result
'model'. Bricks and models (no matter how complex) are functionally indistinguishable, meaning
we can create ever more complex models by assembling any combination of bricks and other,
previously created, models.

***One Page Manual<sup>&reg;</sup>*** systems are operated in a consistent way (with no exceptions). All interactions with the system 'look and feel' the same. After a user becomes familiar with the basics they almost immediately become an expert &mdash; because there's nothing else to learn.  The clue's in the name &mdash; the manual literally fits on one page!

## Modifiers

Modifiers are functions that declare three arguments.  The first argument is the modified buffer from the
previous modifier (in the chain), the second argument contains the argument string for the modifier itself and the third
argument is a `Map` ('the mappings').  All modifiers must return either `{:ok, result}` or `{:error, reason}` and
must be called `modify`.

Let's say we have the following modifiers:

```elixir
defmodule Foo.Big do
  use Mc.Modifier

  def modify(buffer, _args, _mappings) do
    {:ok, String.upcase(buffer)}
  end
end

defmodule Bar.Replace do
  use Mc.Modifier

  def modify(buffer, args, _mappings) do
    {:ok, String.replace(buffer, "bar", args)}
  end
end

defmodule Boom do
  use Mc.Modifier

  def modify(_buffer, _args, _mappings) do
    {:error, "boom!"}
  end
end
```

In order to make use of them we create a mappings `Map` that specifies modifier names and modules.  One
such map might look like this:

```elixir
mappings =
  %{
    capify: Foo.Big,
    change: Bar.Replace,
    boom: Boom
  }
```

We've assigned the name 'capify' to the first modifier; 'change' to the second; 'boom' to
the third.

## Now we can modify stuff

```elixir
Mc.modify("wine bar", "change glass", mappings)
  #=> {:ok, "wine glass"}
```

The first argument is the *initial* buffer and the second argument is the ModifyChain Script.  We pass
the mappings as the third argument and they are made available to all modifiers (in the chain).

The result is obtained by transforming the initial buffer with the named modifier and its arguments.
Effectively we ran the following code:

```elixir
Bar.Replace.modify("wine bar", "glass", mappings)
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
{:ok, modified_buffer} = Bar.Replace.modify("wine bar", "bottle", mappings)
Foo.Big.modify(modified_buffer, "", mappings)
  #=> {:ok, "WINE BOTTLE"}
```

So, the output of one modifier is the input to the next, and so on.

If at any point a modifier returns an error tuple, the next modifier simply passes it on down the chain,
unchanged. For example:

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

## Standard mappings and modifiers

The `Mc.Mappings.standard/0` function returns standard mappings which reference basic (concept-prover) 
modifiers.  Feel free to create your own custom mappings and modifiers or mix and match as needed.

The snippet `use Mc.Modifier` appears at the top of all standard modifiers.  It creates functions that
implement the 'error short-circuiting' behaviour mentioned above (along with some simple utility functions).
