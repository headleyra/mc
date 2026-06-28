defmodule Mc.Behaviour.Modifier do
  @type modifier_module :: atom()
  @type error_type :: atom()
  @type error_message :: binary() | nil
  @type mini_error :: {modifier_module(), error_type(), error_message()}
  @type error_list :: [] | [mini_error(), ...]

  @type error :: {:error, modifier_module(), error_type(), error_message(), error_list()}
  @type result :: {:ok, binary()}

  @type buffer :: binary() | result() | error()
  @type args :: binary()
  @type mappings :: map()

  @callback m(buffer, args, mappings) :: result() | error()
end
