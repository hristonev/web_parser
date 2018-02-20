defmodule Mix.Tasks.Salute do
  use Mix.Task

  @shortdoc "Salute you to stdio."
  def run(_) do
    IO.puts "You, foolish soul!"
  end
end
