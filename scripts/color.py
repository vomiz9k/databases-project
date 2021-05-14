import numpy as np
import pandas as pd


def prepare_colors():
    df = pd.read_csv("../datasources/colors.csv.gz", compression='gzip')
    for i in range((len(df) + 19999) // 20000):
        with open("../insert_colors/insert_colors" + str(i + 1) + ".sql", "w") as output:
            output.write("INSERT INTO lego.colors VALUES\n")
            count = min(20000, len(df) - i * 20000)
            for j in range(count):
                output.write("\t(" + str(df["id"][i * 20000 + j]) +
                                 ", \'" + df["name"][i * 20000 + j].replace("\'", "\'\'") + "\')"
                )
                if j < count - 1:
                    output.write(",\n")
                else:
                    output.write(";\n")