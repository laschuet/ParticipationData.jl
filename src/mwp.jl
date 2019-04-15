""""""
function curl(process, downloadpath)
    mkpath(downloadpath)
    cookiepath = joinpath(downloadpath, "cookie.txt")
    searchpath = joinpath(downloadpath, "search.html")

    cookiecmd = `curl http://awd.mv-regierung.de/$process/index.php -c $cookiepath`
    searchpagecmd = `curl http://awd.mv-regierung.de/$process/anz_abschn.php -b $cookiepath`

    run(cookiecmd)
    run(pipeline(searchpagecmd; stdout=searchpath))

    open(searchpath) do f
        doc = parsehtml(read(f, String))
        options = eachmatch(Selector("select option"), doc.root)
        for option in options
            id = getattr(option, "value")
            id == "" && continue
            pagecmd = `curl http://awd.mv-regierung.de/$process/anz_abschn.php --compressed --data auswahl=$id -b $cookiepath`
            run(pipeline(pagecmd; stdout=joinpath(downloadpath, "$id.html")))
        end
    end
end

""""""
function create(dbname, tablename)
    dbconn = SQLite.DB("$dbname.db")
    SQLite.execute!(dbconn, """
        CREATE TABLE IF NOT EXISTS $tablename (
            id                  INTEGER PRIMARY KEY,
            number              INTEGER,
            author              TEXT,
            ref                 TEXT,
            content             TEXT NOT NULL,
            assessment_content  TEXT
        );
    """)
end

""""""
function transform(path)
    values = []

    open(path) do f
        doc = parsehtml(read(f, String))
        tables = eachmatch(Selector(".table_wrap"), doc.root)
        if length(tables) != 3
            return values
        end

        contributions = eachmatch(Selector(".tblrow"), tables[2])
        for i in 2:length(contributions)
            contribution = contributions[i]
            parts = eachmatch(Selector(".listitem"), contribution)

            participant = nodeText(parts[1])
            ref = nodeText(parts[2])
            content = nodeText(parts[3])
            assessment = nodeText(parts[4])

            m = match(r"(lfd.-Nr.: )(\d+)(.*)", participant)
            if m == nothing
                continue
            end

            push!(values, m[2], m[3], ref, content, assessment)
        end
    end

    return values
end

""""""
function save(values, dbname, tablename; batchsz=50)
    nvalues = length(values)
    (nvalues > 0 && nvalues % 5 == 0) || return

    ncontribs = div(nvalues, 5)
    niter = div(ncontribs, batchsz)
    restsz = ncontribs % batchsz
    placeholder = "(?, ?, ?, ?, ?)"
    dbconn = SQLite.DB("$dbname.db")
    for i in 1:niter
        SQLite.Query(dbconn, """
            INSERT INTO $tablename (number, author, ref, content, assessment_content)
            VALUES $(((placeholder * ", ") ^ (batchsz - 1)) * placeholder);
        """; values=values[1 + 5 * batchsz * (i - 1):5 * batchsz * i])
    end
    if restsz > 0
        SQLite.Query(dbconn, """
            INSERT INTO $tablename (number, author, ref, content, assessment_content)
            VALUES $(((placeholder * ", ") ^ (restsz - 1)) * placeholder);
        """; values=values[end - 5 * restsz + 1:end])
    end
end

""""""
function transformall(path, dbname, tablename)
    relativepath = relpath(path)
    paths = map(p -> joinpath(relativepath, p), readdir(relativepath))
    filter!(p ->
        isfile(p) && endswith(p, ".html") && !occursin("search", p)
    , paths)
    for p in paths
        trans = transform(p)
        save(trans, dbname, tablename)
    end
end

""""""
function scrape(process, downloadpath, dbname, tablename;
                dodownload=true, docreate=true, dotransform=true)
    dodownload && curl(process, downloadpath)
    docreate && create(dbname, tablename)
    dotransform && transformall(downloadpath, dbname, tablename)
end

""""""
function mwp(download=true, create=true, transform=true)
    processes = ["lep_2009_01", "rrep_2010_wm2", "rrep_2011_wm_3",
            "rrep_2011_wm_4", "rrep_2015_01", "lep_2009_03", "rrep_2011_mm_1",
            "lep_2009_02", "rrep_2010_mv_2", "rrep_2010_ms_3", "rrep_2011_ms_1",
            "lep_2008_01", "rrep_2009_02", "rrep_2013_01", "rrep_2015_02",
            "rrep_2015_03", "lep_2014_01", "lep_2016_01"]
    for p in processes
        scrape(p, "data/mwp/$p", p, "mwp_$p"; dodownload=download,
                docreate=create, dotransform=transform)
    end
end
