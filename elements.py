import periodictable as pt 
# Looks up the element by symbol and returns it
def symbol_to_element(symbol):
    return [e for e in pt.elements if e.symbol == symbol][0]
def symbol_to_mass(symbol):
    return (symbol_to_element(symbol)).mass
def neutron_mass_contribution(sample_mass, symbol):
    element = symbol_to_element(symbol) 
    # this also happens to be the grams of neutrons per mole element
    neutrons = element.mass - element.number 
    moles = sample_mass / element.mass
    neutron_mass = moles * neutrons
    return neutron_mass