""""""
function create_table_type_1(dbname, tablename)
    dbconn = SQLite.DB(dbname)
    SQLite.execute!(dbconn, """
        CREATE TABLE IF NOT EXISTS $tablename (
            id                  INTEGER PRIMARY KEY,
            link                TEXT NOT NULL,
            org_name            TEXT NOT NULL,
            org_website         TEXT NOT NULL,
            org_country         TEXT NOT NULL,
            org_city            TEXT NOT NULL,
            idea_title          TEXT NOT NULL,
            idea_subtitle       TEXT NOT NULL,
            idea_pitch          TEXT NOT NULL,
            topic               TEXT NOT NULL,
            other               TEXT,
            how                 TEXT NOT NULL,
            outcome             TEXT NOT NULL,
            importance          TEXT NOT NULL,
            for_whom            TEXT NOT NULL,
            uniqueness          TEXT NOT NULL,
            on_shortlist        INTEGER,
            is_winner           INTEGER,
            assessment_comment  TEXT,
            community_winner    INTEGER,
            created_at          TEXT NOT NULL,
            modified_at         TEXT NOT NULL,
            pos_ratings         INTEGER NOT NULL,
            neg_ratings         INTEGER NOT NULL,
            num_comments        INTEGER NOT NULL,
            comments            TEXT
        );
    """)
end

""""""
function create_table_type_2(dbname, tablename)
    dbconn = SQLite.DB(dbname)
    SQLite.execute!(dbconn, """
        CREATE TABLE IF NOT EXISTS $tablename (
            id              INTEGER PRIMARY KEY,
            ref             TEXT NOT NULL,
            link            TEXT NOT NULL,
            title           TEXT NOT NULL,
            description     TEXT NOT NULL,
            pos_ratings     INTEGER NOT NULL,
            neg_ratings     INTEGER NOT NULL,
            category        TEXT NOT NULL,
            features        TEXT,
            num_comments    INTEGER NOT NULL,
            long            REAL NOT NULL,
            lat             REAL NOT NULL,
            location        TEXT,
            mod_response    TEXT,
            off_response    TEXT,
            notice          TEXT,
            author          TEXT NOT NULL,
            created_at      TEXT NOT NULL
        );
    """)
end

""""""
function create_table_type_3(dbname, tablename)
    dbconn = SQLite.DB(dbname)
    SQLite.execute!(dbconn, """
        CREATE TABLE IF NOT EXISTS $tablename (
            id          INTEGER PRIMARY KEY,
            number      INTEGER NOT NULL,
            content     TEXT NOT NULL,
            created_at  TEXT NOT NULL,
            author      TEXT NOT NULL,
            link        TEXT NOT NULL,
            pos_ratings INTEGER NOT NULL,
            neg_ratings INTEGER NOT NULL,
            reply_to    INTEGER
        );
    """)
end

""""""
function load(file, dbname, tablename)
    df = DataFrame(XLSX.readtable(file, "Sheet1")...)
    insertcols!(df, 1, id=1:nrow(df))
    db = SQLite.DB(dbname)
    SQLite.load!(df, db, tablename)
end

""""""
function advocate_europe(fileroot)
    dbname = "liqd_advocate_europe.db"
    tablename = "contribution"
    create_table_type_1(dbname, tablename)
    load(fileroot * "/advocate_europe.xlsx", dbname, tablename)
end

""""""
function blankenburger_sueden(fileroot)
    dbname = "liqd_blankenburger_sueden.db"
    tablename = "comment"
    create_table_type_3(dbname, "$(tablename)_a")
    create_table_type_3(dbname, "$(tablename)_b")
    create_table_type_3(dbname, "$(tablename)_c")
    create_table_type_3(dbname, "$(tablename)_lob_und_kritik")
    create_table_type_3(dbname, "$(tablename)_uebergreifende_themen")
    load("$fileroot/blankenburger_sueden_alternative_a.xlsx", dbname, "$(tablename)_a")
    load("$fileroot/blankenburger_sueden_alternative_b.xlsx", dbname, "$(tablename)_b")
    load("$fileroot/blankenburger_sueden_alternative_c.xlsx", dbname, "$(tablename)_c")
    load("$fileroot/blankenburger_sueden_lob_und_kritik.xlsx", dbname, "$(tablename)_lob_und_kritik")
    load("$fileroot/blankenburger_sueden_uebergreifende_themen.xlsx", dbname, "$(tablename)_uebergreifende_themen")
end

""""""
function laermorte(fileroot)
    dbname = "liqd_laermorte_melden.db"
    create_table_type_2(dbname, "contribution")
    create_table_type_3(dbname, "comment")
    load("$fileroot/laermorte_melden.xlsx", dbname, "contribution")
    load("$fileroot/laermorte_melden_comments.xlsx", dbname, "comment")
end

""""""
function mauerpark(fileroot)
    dbname = "liqd_mauerpark.db"
    create_table_type_2(dbname, "contribution")
    create_table_type_3(dbname, "comment")
    load("$fileroot/mauerpark.xlsx", dbname, "contribution")
    load("$fileroot/mauerpark_comments.xlsx", dbname, "comment")
end

""""""
function liqd(fileroot)
    advocate_europe(fileroot)
    blankenburger_sueden(fileroot)
    laermorte(fileroot)
    mauerpark(fileroot)
end
