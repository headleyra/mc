defmodule Mc.UriTest do
  use ExUnit.Case, async: true
  alias Mc.Uri

  describe "decode/1" do
    test "URI-decodes its input" do
      assert Uri.decode("%0a") == {:ok, "\n"}
      assert Uri.decode("%20") == {:ok, " "}
      assert Uri.decode("%09") == {:ok, "\t"}
      assert Uri.decode("%25") == {:ok, "%"}
      assert Uri.decode("%") == {:ok, "%"}
      assert Uri.decode("%e") == {:ok, "%e"}
      assert Uri.decode("ok: %0a, oops: %%") == {:ok, "ok: \n, oops: %%"}
    end
  end
end
