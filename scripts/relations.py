import pandas as pd
import json

def prepare_relations():
    inv_set = pd.read_csv("../datasources/inventories.csv.gz", compression='gzip')
    inv_piece = pd.read_csv("../datasources/inventory_parts.csv.gz", compression='gzip')
    inv_person = pd.read_csv("../datasources/inventory_minifigs.csv.gz", compression='gzip')

    f = open("../json/sets.json", 'r')
    js = json.load(f)
    df = pd.DataFrame().from_dict(js['sets'])
    sets = set()
    for i in range(len(df)):
        sets.add(str(df['number'][i]).replace("\'", "\'\'") + '-' + str(df["numberVariant"][i]))

    pieces = set()
    df = pd.read_csv("../datasources/parts.csv.gz", compression='gzip')
    for i in range(len(df)):
        pieces.add(df["part_num"][i])

    set_piece = inv_piece.merge(inv_set, how='outer', left_on='inventory_id', right_on='id')[
        ['part_num', 'set_num', 'quantity']]

    set_piece['set_num'] = set_piece['set_num'].apply(lambda x: x if x in sets else None)
    set_piece['part_num'] = set_piece['part_num'].apply(lambda x: x if x in pieces else None)
    set_piece = set_piece.dropna().reset_index()

    for i in range((len(set_piece) + 19999) // 20000):
        with open("../insert_pieces_count/insert_pieces_count" + str(i + 1) + ".sql" , "w") as output:
            output.write("INSERT INTO lego.pieces_counts VALUES\n")
            count = min(20000, len(set_piece) - i * 20000)
            for j in range(count):
                output.write("\t(\'" + set_piece["set_num"][i * 20000 + j] + "\'" +
                                 ", \'" + set_piece["part_num"][i * 20000 + j] +
                                 "\', " + str(set_piece["quantity"][i * 20000 + j]) + ")"
                )
                if j == count - 1:
                    output.write(";\n")
                else:
                    output.write(",\n")

    set_person = inv_person.merge(inv_set, how='outer', left_on='inventory_id', right_on='id')[
        ['fig_num', 'set_num', 'quantity']]

    persons = set()
    df = pd.read_csv("../datasources/minifigs.csv.gz", compression='gzip')
    for i in range(len(df)):
        persons.add(df["fig_num"][i])

    set_person['set_num'] = set_person['set_num'].apply(lambda x: x if x in sets else None)
    set_person['fig_num'] = set_person['fig_num'].apply(lambda x: x if x in persons else None)
    set_person = set_person.dropna().reset_index()

    for i in range((len(set_person) + 19999) // 20000):
        with open("../insert_persons_count/insert_persons_count" + str(i + 1) + ".sql" , "w") as output:
            output.write("INSERT INTO lego.persons_counts VALUES\n")
            count = min(20000, len(set_person) - i * 20000)
            for j in range(count):
                output.write("\t(\'" + set_person["set_num"][i * 20000 + j] + "\'" +
                                 ", \'" + set_person["fig_num"][i * 20000 + j] +
                                 "\', " + str(set_person["quantity"][i * 20000 + j]) + ")"
                )

                if j == count - 1:
                    output.write(";\n")
                else:
                    output.write(",\n")



