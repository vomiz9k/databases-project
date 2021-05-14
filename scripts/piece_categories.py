import numpy as np
import pandas as pd


def prepare_piece_categories():
    df = pd.read_csv("../datasources/part_categories.csv.gz", compression='gzip')
    for i in range((len(df) + 19999) // 20000):
        with open("../insert_piece_categories/insert_piece_categories" + str(i + 1) + ".sql" , "w") as output:
            output.write("INSERT INTO lego.piece_categories VALUES\n")
            count = min(20000, len(df) - i * 20000)
            for j in range(count):
                output.write("\t(" + str(df["id"][i * 20000 + j]) +
                             ", \'" + df["name"][i * 20000 + j].replace("\'", "\'\'") + "\')"
                             )
                if j < count - 1:
                    output.write(",\n")
                else:
                    output.write(";\n")
