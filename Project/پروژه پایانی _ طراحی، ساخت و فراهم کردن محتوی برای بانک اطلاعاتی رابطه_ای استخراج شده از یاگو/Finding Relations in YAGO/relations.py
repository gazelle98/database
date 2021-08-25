import csv
import os
from pathlib import Path

def find_relations(file_name, index):
    relations = set()
    i = 0
    extracted_path = "test/" + file_name + ".txt"
    data_path = "data/" + file_name + ".tsv"
    if not Path(extracted_path).is_file():
        with open(data_path) as fd:
            rd = csv.reader(fd, delimiter="\t", quotechar='"')
            for row in rd:
                if(row[2]=="<isPoliticianOf>" and row[3]=="<Iran>"):
                    relations.add(row[index])
                i += 1
                if(i % 1000000 == 0):
                    print(str(i) + " data are proccessed")
        file = open(extracted_path, 'w')
        file.write(repr(relations))
        print(file_name + " proccessed")
    else:
        print(extracted_path + "exist!")



data_files = ["yagoFacts",
 "yagoConteXtFacts_fa",
  "yagoGeonamesOnlyData",
   "yagoGeonamesTypes",
    "yagoInfoboxAttributes_fa",
    "yagoLabels",
    "yagoRedirectLabels_fa",
    "yagoSchema",
    "yagoSimpleTaxonomy",
    "yagoTaxonomy",
    "yagoTypes",
    "yagoWikipediaInfo_fa"]

for data in data_files:
    find_relations(data, 1)