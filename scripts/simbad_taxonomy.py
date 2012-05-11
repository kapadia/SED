def simbad_taxonomy():
    """
    Parse the SIMBAD taxonomy.
    """

    f = open('../public/SimbadTaxonomy.csv', 'r')
    data = f.read().split('\r')
    f.close()

    coffee = open('../app/modules/SimbadTaxonomy.coffee', 'w')
    coffee.write("SimbadTaxonomy =")
    coffee.write("\n")
    for item in data:
        print item
        symbol, description = item.split(",", 1)
        symbol = symbol.strip()
        description = description.strip()

        if len(symbol) > 0:
            coffee.write("  '%s': '%s'\n" % (symbol, description.title()))
    
    coffee.write("\n")
    coffee.write("module.exports = SimbadTaxonomy")
    coffee.close()

if __name__ == '__main__':
    simbad_taxonomy()