import pandas as pd
import json

def prepare_sets():
    df_csv = pd.read_csv("../datasources/sets.csv.gz", compression='gzip')
    themes = pd.read_csv("../datasources/themes.csv.gz", compression='gzip')
    f = open("../json/sets.json", 'r')
    js = json.load(f)
    df = pd.DataFrame().from_dict(js['sets'])
    with open("../insert_sets/insert_sets.sql", "w") as output:
        with open ("../insert_marketplaces/insert_marketplaces.sql", "w") as markets:
            output.write("INSERT INTO lego.sets VALUES\n")
            markets.write("INSERT INTO lego.marketplaces VALUES\n")
            for i in range(len(df)):
                theme_id = themes[themes['name'] == df['theme'][i]].head(1)['id']
                if (len(theme_id) == 0):
                    theme_id = 'NULL'
                else:
                    theme_id = str(int(theme_id))
                set_id = str(df["number"][i]) + '-' + str(df["numberVariant"][i])
                age = 'NULL, NULL'
                if ('min' in df['ageRange'][i].keys()):
                    if ('max' in df['ageRange'][i].keys()):
                        age = str(df['ageRange'][i]['min']) + ', ' + str(df['ageRange'][i]['max'])
                    else:
                        age = str(df['ageRange'][i]['min']) + ', ' + 'NULL'

                output.write("\t(\'" + set_id +
                             "\', \'" + df["name"][i].replace("\'", "\'\'") + "\', " +
                             str(df["year"][i]) + ", " +
                             age + ', ' + theme_id + ')'
                )

                countries = ('US', 'UK', 'CA', 'DE')
                for country in countries:
                    if ('retailPrice' in df['LEGOCom'][i][country] and "dateFirstAvailable" in df['LEGOCom'][i][country]):
                        markets.write("(\'" + set_id + "\', " + "\'LEGO.COM\', " +
                                      "\'https://lego.com/en-us/product/" + str(df['number'][i]) + '\', ' +
                                      str(df['LEGOCom'][i][country]['retailPrice']) + ')')
                        if i < len(df) - 1:
                            markets.write(",\n")
                        else:
                            markets.write(";\n")
                        break



                if i < len(df) - 1:
                    output.write(",\n")
                else:
                    output.write(";\n")
