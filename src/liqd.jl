#=
features for participation process

"advocate_europe"

link
organization name
organization website
irganization country
organization city
idea title
idea subtitle
idea pitch
topic
other
How will your idea strengthen democracy in Europe?
hat would be a successful outcome for your idea?
Why is this idea important to you?
Who are you doing it for and/or with?
What makes your idea stand apart?
is on shortlist
is winner
Why this idea?
community award winner
created
modified
Positive ratings
Negative ratings
Comment count
Comments
=#

#=
features for participation process

"laermorte_melden"
"mauerpark"

Referenznr.
Link
Titel
Beschreibung
Positive Bewertungen
Negative Bewertungen
Kategorie
Merkmale
Anzahl Kommentare
Ort (Längengrad)
Ort (Breitengrad)
Ortsbezeichnung
Rückmeldung der Moderation
Offizielle Rückmeldung
Notiz
Urheber
Erstellt
=#

#=
features for participation processes

"blankenburger_sueden_alternative_a"
"blankenburger_sueden_alternative_b"
"blankenburger_sueden_alternative_c"
"blankenburger_sueden_alternative_lob_und_kritik"
"blankenburger_sueden_alternative_uebergreifende_themen"
"laermorte_melden_comments"
"mauerpark_comments"

ID
Kommentar
Erstellt
Urheber
Link
Positive Bewertungen
Negative Bewertungen
Antwort auf
=#

""""""
function advocate_europe()
end

""""""
function blankenburger_sueden()
end

""""""
function laermorte()
end

""""""
function mauerpark()
end

""""""
function liqd(file)
    df = DataFrame(XLSX.readtable(file, "Sheet1")...)
    display(df)
    db = SQLite.DB("test.sqlite")
    SQLite.load!(df, db, "liqd_tbl")

    advocate_europe()
    blankenburger_sueden()
    laermorte()
    mauerpark()
end
