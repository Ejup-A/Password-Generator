# PasswordGenerator

PasswordGenerator is a simple Elixir module that generates random passwords based on user-defined options such as length, numbers, uppercase letters, and symbols. It is designed to demonstrate clean functional programming, input validation, and test-driven development using ExUnit.

The generator ensures that input is properly validated before password creation. It enforces a required length, restricts invalid option keys, and ensures option values are strictly boolean-like strings ("true" or "false"). The output is a randomly generated string that always includes lowercase letters and optionally includes other character sets depending on the provided configuration.

## Features

- Generate random passwords with a configurable length
- Optional inclusion of numbers, uppercase letters, and symbols
- Always includes lowercase letters for baseline character safety
- Strict validation of input parameters
- Clear error handling using {:ok, result} and {:error, reason} tuples
- Fully tested using ExUnit

## How It Works

The password generation process follows these steps:

1. The input map is validated to ensure a "length" key exists.
2. The length value is checked to confirm it is a valid integer.
3. Optional parameters (numbers, uppercase, symbols) are validated to ensure they are either "true" or "false".
4. Enabled character sets are collected based on the options.
5. A password is constructed by randomly selecting characters from the allowed pool.
6. The result is shuffled to ensure randomness and returned as a string.

## Usage

```elixir
iex> PasswordGenerator.generate(%{"length" => "10"})
{:ok, "aB3xkL9pQz"}

iex> PasswordGenerator.generate(%{"length" => "8", "numbers" => "true"})
{:ok, "a3b1c9d2"}