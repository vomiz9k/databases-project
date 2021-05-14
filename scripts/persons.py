import numpy as np
import pandas as pd


def prepare_persons():
    df = pd.read_csv("../datasources/minifigs.csv.gz", compression='gzip')
    for i in range((len(df) + 19999) // 20000):
        with open("../insert_persons/insert_persons" + str(i + 1) + ".sql" , "w") as output:
            output.write("INSERT INTO lego.persons VALUES\n")
            count = min(20000, len(df) - i * 20000)
            for j in range(count):
                output.write("\t(\'" + str(df["fig_num"][i * 20000 + j]) + '\'' +
                         ", \'" + df["name"][i * 20000 + j].replace("\'", "\'\'") +
                         "\', " + str(df["num_parts"][i * 20000 + j]) + ")"
                )
                if j < count - 1:
                    output.write(",\n")
                else:
                    output.write(";\n")