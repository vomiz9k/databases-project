import numpy as np
import pandas as pd


def prepare_themes():
    df = pd.read_csv("../datasources/themes.csv.gz", compression='gzip')

    for i in range((len(df) + 19999) // 20000):
        with open("../insert_themes/insert_themes" + str(i + 1) + ".sql" , "w") as output:
            output.write("INSERT INTO lego.themes VALUES\n")
            count = min(20000, len(df) - i * 20000)
            for j in range(count):
                output.write("\t(" + str(df["id"][i * 20000 + j]) +
                             ", \'" + df["name"][i * 20000 + j].replace("\'", "\'\'") + "\', " +
                             (str(int(df["parent_id"][i * 20000 + j]))
                              if not np.isnan(df["parent_id"][i * 20000 + j]) else "NULL") + ")")
                if j < count - 1:
                    output.write(",\n")
                else:
                    output.write(";\n")


