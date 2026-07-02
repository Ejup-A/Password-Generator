defmodule PasswordGenerator do
  @moduledoc """
  Generates a random password based on options:
  - length (required)
  - numbers (true/false)
  - uppercase (true/false)
  - symbols (true/false)
  """

  @symbols String.split("!#$%&()*{}+-/<=>?@[]^_{|}", "", trim: true)

  @spec generate(map(), map()) :: {:ok, String.t()} | {:error, String.t()}
  def generate(options, _types \\ %{}) do
    with {:ok, length} <- validate_length(options),
         {:ok, flags} <- validate_flags(options) do
      {:ok, build_password(length, flags)}
    end
  end

  defp validate_length(%{"length" => length}) do
    case Integer.parse(length) do
      {int, ""} when int > 0 -> {:ok, int}
      _ -> {:error, "Only integers allowed for length."}
    end
  end

  defp validate_length(_),
    do: {:error, "Length option is required."}

  defp validate_flags(options) do
    allowed = MapSet.new(["numbers", "uppercase", "symbols"])

    invalid =
      options
      |> Map.delete("length")
      |> Map.keys()
      |> Enum.any?(&(&1 not in MapSet.to_list(allowed)))

    cond do
      invalid ->
        {:error, "Invalid options provided. Allowed options are: length, numbers, uppercase, symbols."}

      not Enum.all?(Map.delete(options, "length"), fn {_k, v} ->
        v in ["true", "false"]
      end) ->
        {:error, "Only booleans allowed for options."}

      true ->
        {:ok, normalize_flags(options)}
    end
  end

  defp normalize_flags(options) do
    %{
      numbers: Map.get(options, "numbers", "false") == "true",
      uppercase: Map.get(options, "uppercase", "false") == "true",
      symbols: Map.get(options, "symbols", "false") == "true"
    }
  end

  defp build_password(length, flags) do
    pool =
      [
        lowercase: true,
        numbers: flags.numbers,
        uppercase: flags.uppercase,
        symbols: flags.symbols
      ]
      |> Enum.flat_map(fn
        {:lowercase, true} -> Enum.map(?a..?z, &<<&1>>)
        {:numbers, true} -> Enum.map(0..9, &Integer.to_string(&1))
        {:uppercase, true} -> Enum.map(?A..?Z, &<<&1>>)
        {:symbols, true} -> @symbols
        _ -> []
      end)

    # always ensure at least lowercase is included
    lowercase = Enum.map(?a..?z, &<<&1>>)

    base_pool = pool ++ lowercase

    # ensure at least one character is present
    first = Enum.random(base_pool)

    rest =
      Enum.map(1..(length - 1), fn _ ->
        Enum.random(base_pool)
      end)

    ( [first] ++ rest )
    |> Enum.shuffle()
    |> Enum.join("")
  end
end
