defmodule PasswordGeneratorTest do
  use ExUnit.Case

  setup do
    options = %{
      "length" => "10",
      "numbers" => "false",
      "uppercase" => "false",
      "symbols" => "false"
    }

    options_type = %{
      lowercase: Enum.map(?a..?z, &<<&1>>),
      numbers: Enum.map(0..9, &Integer.to_string(&1)),
      uppercase: Enum.map(?A..?Z, &<<&1>>),
      symbol: String.split("!#$%&()*{}+-/<=>?@[]^_{|}", "", trim: true)
    }

    {:ok, result} = PasswordGenerator.generate(options, options_type)

    %{
      options_type: options_type,
      result: result
    }
  end

  test "returns a string", %{result: result} do
    assert is_binary(result)
  end

  test "returns error when no length is given" do
    options = %{"invalid" => "false"}

    assert {:error, _} = PasswordGenerator.generate(options)
  end

  test "returns error when length is not an integer" do
    options = %{"length" => "abc"}

    assert {:error, _} = PasswordGenerator.generate(options)
  end

  test "length of returned string is the option provided" do
    options = %{"length" => "5"}

    {:ok, result} = PasswordGenerator.generate(options)

    assert String.length(result) == 5
  end

  test "returns lowercase-only string", %{options_type: options} do
    options_input = %{"length" => "5"}

    {:ok, result} = PasswordGenerator.generate(options_input, options)

    chars = String.graphemes(result)

    assert Enum.all?(chars, &(&1 in options.lowercase))
    refute Enum.any?(chars, &(&1 in options.numbers))
    refute Enum.any?(chars, &(&1 in options.uppercase))
    refute Enum.any?(chars, &(&1 in options.symbol))
  end

  test "returns error when options values are not booleans" do
    options = %{
      "length" => "10",
      "numbers" => "invalid",
      "uppercase" => "0",
      "symbols" => "false"
    }

    assert {:error, _} = PasswordGenerator.generate(options)
  end

  test "returns error when options not allowed" do
    options = %{
      "length" => "5",
      "invalid" => "true"
    }

    assert {:error, _} = PasswordGenerator.generate(options)
  end

  test "returns error when mixed invalid option exists" do
    options = %{
      "length" => "5",
      "numbers" => "true",
      "invalid" => "true"
    }

    assert {:error, _} = PasswordGenerator.generate(options)
  end
end