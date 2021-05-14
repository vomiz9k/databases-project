import pandas as pd


def prepare_pieces():
    df = pd.read_csv("../datasources/parts.csv.gz", compression='gzip').drop_duplicates('part_num', ignore_index=True)
    for i in range((len(df) + 19999) // 20000):
        with open("../insert_pieces/insert_pieces" + str(i + 1) + ".sql" , "w") as output:
            output.write("INSERT INTO lego.pieces VALUES\n")
            count = min(20000, len(df) - i * 20000)
            for j in range(count):
                output.write("\t('" + str(df["part_num"][i * 20000 + j]) + '\''+
                             ", \'" + df["name"][i * 20000 + j].replace("\'", "\'\'") + "\')"
                )
                if j < count - 1:
                    output.write(",\n")
                else:
                    output.write(";\n")