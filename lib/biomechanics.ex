defmodule Biomechanics do
  def open_port do
    :python.start()
  end

  def neutron_mass_contribution(pid, mass, symbol) do
    :python.call(pid, :elements, :neutron_mass_contribution,
    [mass, symbol])
  end
end
