import sqlite3
import csv
import os.path 
from pathlib import Path

def string_check(text):
    text = text.replace('_', ' ')
    text = text.replace("'", "")
    text = text.replace("<", "")
    text = text.replace(">", "")
    text = text.replace("\\u200c", "")
    text = text.replace("fa/", "")
    text = text.replace("@fas", "")
    text = text.replace("-"," ")
    text = text.replace("de/","")
    text = text.replace("fr/", "")
    text = text.replace("ar/", "")
    return text

fact_path = "data/yagoFacts.tsv"
label_path = "data/yagoLabels.tsv"
type_path = "data/yagoTypes.tsv"

###################################################################################

#PRISON TABLE
prisoner_name = set()

conn = sqlite3.connect("PoliticsOfIran.db")
c = conn.cursor()
c.execute('''CREATE TABLE Prisoners(id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(250), fa_label VARCHAR(200))''')

with open(type_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if "Prisoners" in word[3] and "Iran" in word[3]:
                prisoner_name.add(word[1])

with open(label_path) as lp:
    rd = csv.reader(lp, delimiter="\t", quotechar='"')
    for word in rd:
        if word[2] == "rdfs:label" and word[1] in prisoner_name and "@fas" in word[3]:
                c.execute("INSERT INTO Prisoners(name, fa_label) VALUES('{}', '{}')".format(string_check(word[1]), string_check(word[3])))
        
print("Prisoners table is done.")


#DEATH IN PRISON RELATION
c.execute('''CREATE TABLE DeathInPrison(id INTEGER, FOREIGN KEY(id) REFERENCES Prisoners(id))''')

with open(type_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if "Prisoners" in word[3] and "Iran" in word[3] and "death" in word[3]:
                for row in c.execute('SELECT name,id FROM Prisoners'):
                    if string_check(word[1]) in row:
                        c.execute("INSERT INTO DeathInPrison(id) VALUES('{}')".format(row[1]))

print("Deaths in prison is done.")


#EVENTS IN IRAN TABLE
c.execute('''CREATE TABLE Events(id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(250), fa_label VARCHAR(200))''')

event_name = set()

with open(fact_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if "<happenedIn>"==word[2] and "Iran" in word[3]:
                event_name.add(word[1])

with open(label_path) as lp:
    rd = csv.reader(lp, delimiter="\t", quotechar='"')
    for word in rd:
        if word[2] == "rdfs:label" and word[1] in event_name and "@fas" in word[3]:
                c.execute("INSERT INTO Events(name, fa_label) VALUES('{}', '{}')".format(string_check(word[1]), string_check(word[3])))
print("Events in prison is done.")


#POLITICIANS TABLE
politician_name = set()

c.execute('''CREATE TABLE Politicians(id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(250), 
gender VARCHAR(200), born_in VARCHAR(200), die_in VARCHAR(200), fa_label VARCHAR(200))''')

with open(fact_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if word[2] == "<isPoliticianOf>" and word[3] == "<Iran>":
                politician_name.add(word[1])
            if word[2] == "<isLeaderOf>" and "Iran" in word[3]:
                politician_name.add(word[1])

with open(type_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if word[3] == "<wikicat_Iranian_Majlis_Representatives>" or \
            word[3] == "<wikicat_Iranian_politicians>" or \
            word[3] == "<wikicat_Iranian_diplomats>" or \
            word[3] == "<wikicat_Iranian_governors>":
                politician_name.add(word[1])

with open(label_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if word[2] == "rdfs:label" and "@fas" in word[3] and word[1] in politician_name:
                c.execute("INSERT INTO Politicians(name, fa_label) VALUES('{}', '{}')".format(string_check(word[1]), string_check(word[3])))

with open(fact_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if word[1] in politician_name:
                if word[2]=="<hasGender>":
                    c.execute("UPDATE Politicians SET gender = '{}' WHERE name = '{}'".format(string_check(word[3]), string_check(word[1])))

with open(fact_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if word[1] in politician_name:
                if word[2]=="<wasBornIn>":
                    c.execute("UPDATE Politicians SET born_in = '{}' WHERE name = '{}'".format(string_check(word[3]), string_check(word[1])))

with open(fact_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if word[1] in politician_name:
                if word[2]=="<diedIn>":
                    c.execute("UPDATE Politicians SET die_in = '{}' WHERE name = '{}'".format(string_check(word[3]), string_check(word[1])))
print("Politician is done.")


#LEADERS RELATION
c.execute('''CREATE TABLE LeaderGuys(id INTEGER, leader_of VARCHAR(256), FOREIGN KEY(id) REFERENCES Politicians(id))''')

with open(fact_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if "<isLeaderOf>"==word[2] and "Iran" in word[3]:
                for row in c.execute('SELECT name,id FROM Politicians'):
                    if string_check(word[1]) in row:
                        c.execute("INSERT INTO LeaderGuys(id, leader_of) VALUES('{}', '{}')".format(row[1], string_check(word[3])))
print("Leaders is done.")


#Majlis Relation
c.execute('''CREATE TABLE MajlisGuys(id INTEGER, FOREIGN KEY(id) REFERENCES Politicians(id))''')

with open(type_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if "<wikicat_Iranian_Majlis_Representatives>" == word[3]:
                for row in c.execute('SELECT name, id FROM Politicians'):
                    if string_check(word[1]) in row:
                        c.execute("INSERT INTO MajlisGuys(id) VALUES('{}')".format(row[1]))
print("Majlis is done.")


#REVOLUTIONISTS TABLE
c.execute('''CREATE TABLE RevolutionGuys(id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(250), fa_label VARCHAR(200))''')

rev_name = set()

with open(type_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if "Revolution" in word[3] and "Iranian" in word[3] and "People" in word[3]:
                rev_name.add(word[1])

with open(label_path) as lp:
    rd = csv.reader(lp, delimiter="\t", quotechar='"')
    for word in rd:
        if word[2] == "rdfs:label" and word[1] in rev_name and "@fas" in word[3]:
                c.execute("INSERT INTO RevolutionGuys(name, fa_label) VALUES('{}', '{}')".format(string_check(word[1]), string_check(word[3])))
print("Revolution is done.")
    

#REVOLUTIONIST_POLITIOCIANS RELATION
c.execute('''CREATE TABLE Rev_Pol_Rel(rev_id INTEGER, pol_id INTEGER, FOREIGN KEY(rev_id) REFERENCES RevolutionGuys(id),
FOREIGN KEY(pol_id) REFERENCES Politicians(id))''')

for row1 in c.execute('SELECT name, id FROM RevolutionGuys'):
    for row in c.execute('SELECT name, id FROM Politicians'):
        if row1[0]==row[0]:
            c.execute("INSERT INTO Rev_Pol_Rel(rev_id, pol_id) VALUES('{}', '{}')".format(row1[1], row[1]))
print("Rev_Pol is done.")


#AYATOLLAHS TABLE
ayat_name = set()

c.execute('''CREATE TABLE Ayatollahs(id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(250), fa_label VARCHAR(200))''')

with open(type_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if "ayatollahs" in word[3] and "Iranian" in word[3]:
                ayat_name.add(word[1])

with open(label_path) as lp:
    rd = csv.reader(lp, delimiter="\t", quotechar='"')
    for word in rd:
        if word[2] == "rdfs:label" and word[1] in ayat_name and "@fas" in word[3]:
                c.execute("INSERT INTO Ayatollahs(name, fa_label) VALUES('{}', '{}')".format(string_check(word[1]), string_check(word[3])))
print("Ayatollahs is done.")
 

#AYATOLLAHS_POLITICIANS RELATION
c.execute('''CREATE TABLE Aya_Pol_Rel(aya_id INTEGER, pol_id INTEGER, FOREIGN KEY(aya_id) REFERENCES Ayatollahs(id),
FOREIGN KEY(pol_id) REFERENCES Politicians(id))''')

for row1 in c.execute('SELECT name, id FROM Ayatollahs'):
    for row in c.execute('SELECT name, id FROM Politicians'):
        if row1[0]==row[0]:
            c.execute("INSERT INTO Aya_Pol_Rel(aya_id, pol_id) VALUES('{}', '{}')".format(row1[1], row[1]))
print("Rev_Pol is done.")


#AMBASSADORS TABLES
ambass_name = set()

c.execute('''CREATE TABLE Ambassadors(id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(250), fa_label VARCHAR(200))''')

with open(type_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if "Ambassadors" in word[3] and "Iran" in word[3]:
                ambass_name.add(word[1])

with open(label_path) as lp:
    rd = csv.reader(lp, delimiter="\t", quotechar='"')
    for word in rd:
        if word[2] == "rdfs:label" and word[1] in ambass_name and "@fas" in word[3]:
                c.execute("INSERT INTO Ambassadors(name, fa_label) VALUES('{}', '{}')".format(string_check(word[1]), string_check(word[3])))
print("Ambassadors is done.")

#PARTICIPATION OF IRAN TABLES
parti_name = set()

c.execute('''CREATE TABLE Participation(id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(250), fa_label VARCHAR(200))''')

with open(fact_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if "<participatedIn>" == word[2] and "Iran" in word[1]:
                parti_name.add(word[3])
    
with open(label_path) as lp:
    rd = csv.reader(lp, delimiter="\t", quotechar='"')
    for word in rd:
        if word[2] == "rdfs:label" and word[1] in parti_name and "@fas" in word[3]:
                c.execute("INSERT INTO Participation(name, fa_label) VALUES('{}', '{}')".format(string_check(word[1]), string_check(word[3])))
print("Participation is done.")


#COUNTRIES TABLE
country_name2 = set()
country_name3 = set()

c.execute('''CREATE TABLE Countries(id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(250), fa_label VARCHAR(200),
capital VARCHAR(100), currency VARCHAR(100), language VARCHAR(100))''')

with open(fact_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if "<dealsWith>" == word[2] and word[1] == "<Iran>":
                country_name2.add(word[3])
            if "<hasNeighbor>" == word[2] and word[1] == "<Iran>":
                country_name3.add(word[3])

with open(label_path) as lp:
    rd = csv.reader(lp, delimiter="\t", quotechar='"')
    for word in rd:
        if word[2] == "rdfs:label" and (word[1] in country_name2 or word[1] in country_name3) and "@fas" in word[3]:
                c.execute("INSERT INTO Countries(name, fa_label) VALUES('{}', '{}')".format(string_check(word[1]), string_check(word[3])))

with open(fact_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if word[1] in country_name2 or word[1] in country_name3:
                if word[2]=="<hasCurrency>":
                    c.execute("UPDATE Countries SET currency = '{}' WHERE name = '{}'".format(string_check(word[3]), string_check(word[1])))

with open(fact_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if word[1] in country_name2 or word[1] in country_name3:
                if word[2]=="<hasOfficialLanguage>":
                    c.execute("UPDATE Countries SET language = '{}' WHERE name = '{}'".format(string_check(word[3]), string_check(word[1])))

with open(fact_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if word[1] in country_name2 or word[1] in country_name3:
                if word[2]=="<hasCapital>":
                    c.execute("UPDATE Countries SET capital = '{}' WHERE name = '{}'".format(string_check(word[3]), string_check(word[1])))
print("Countries is done.")

#IRAN'S NEIGHBORS RELATION
c.execute('''CREATE TABLE Neighbors(id INTEGER, FOREIGN KEY(id) REFERENCES Politicians(id))''')

with open(fact_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if "<hasNeighbor>" == word[2] and word[1] == "<Iran>":
                for row in c.execute('SELECT name, id FROM Countries'):
                    if string_check(word[3]) in row:
                        c.execute("INSERT INTO Neighbors(id) VALUES('{}')".format(row[1]))
print("Neighbors is done.")

#IRAN DEALS_WITH RELATION
c.execute('''CREATE TABLE Deals(id INTEGER, FOREIGN KEY(id) REFERENCES Countries(id))''')

with open(fact_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if "<dealsWith>" == word[2] and word[1] == "<Iran>":
                for row in c.execute('SELECT name, id FROM Countries'):
                    if string_check(word[3]) in row:
                        c.execute("INSERT INTO Deals(id) VALUES('{}')".format(row[1]))
print("Deals is done.")

##GROUPS THAT HAVE SAME PARTICIPATION OF IRAN
#gp_name = list()
#par_name = set()
#par2_name = set()
#
#c.execute('''CREATE TABLE Groups(id INTEGER, name VARCHAR(250), fa_label VARCHAR(200), FOREIGN KEY(id) REFERENCES Participation(id))''')
#
#with open(fact_path) as fd:
#        rd = csv.reader(fd, delimiter="\t", quotechar='"')
#        for word in rd:
#            if"<participatedIn>" == word[2] and "<Iran>" == word[1]:
#                par_name.add(word[3])
#
#with open(label_path) as lp:
#    rd = csv.reader(lp, delimiter="\t", quotechar='"')
#    for word in rd:
#        if word[2] == "rdfs:label" and word[1] in par_name and "@fas" in word[3]:
#            par2_name.add(word[1])
#
#with open(fact_path) as fd:
#        rd = csv.reader(fd, delimiter="\t", quotechar='"')
#        for word in rd:
#            if"<participatedIn>" == word[2] and word[3] in par2_name:
#                gp_name.append(word[1])
#
#with open(label_path) as lp:
#    rd = csv.reader(lp, delimiter="\t", quotechar='"')
#    for word in rd:
#        for i in range(0,len(gp_name)):
#            if word[2] == "rdfs:label" and word[1] == gp_name[i] and "@fas" in word[3]:
#                c.execute("INSERT INTO Groups(name, fa_label) VALUES('{}', '{}')".format(string_check(word[1]), string_check(word[3])))
#
#with open(fact_path) as fd:
#        rd = csv.reader(fd, delimiter="\t", quotechar='"')
#        for word in rd:
#            if"<participatedIn>" == word[2] and word[3] in par2_name:
#                for row in c.execute('SELECT name,id FROM Participation'):
#                    if string_check(word[3]) in row:
#                        c.execute("UPDATE Groups SET id = '{}' WHERE name = '{}' LIMIT 1".format(row[1], string_check(word[1])))
#print("Groups is done.")

#PARTIES TABLE
parties_name = set()

c.execute('''CREATE TABLE Parties(id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(250), fa_label VARCHAR(200))''')

with open(type_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if "Iran" in word[3] and "parties" in word[3]:
                parties_name.add(word[1])

with open(type_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if "Iran" in word[3] and "parties" in word[3] and "<isAffiliatedTo>" == word[2]:
                parties_name.add(word[1])

with open(label_path) as fd:
        rd = csv.reader(fd, delimiter="\t", quotechar='"')
        for word in rd:
            if word[2] == "rdfs:label" and "@fas" in word[3] and word[1] in parties_name:
                c.execute("INSERT INTO Parties(name, fa_label) VALUES('{}', '{}')".format(string_check(word[1]), string_check(word[3])))
print("Parties is done.")


conn.commit()
conn.close()