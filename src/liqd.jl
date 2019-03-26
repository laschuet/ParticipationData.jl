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
