defmodule Mc.Mappings do
  defstruct [
    apps: {Mc.Modifier.App, :modify},
    add: {Mc.Modifier.Math, :add},
    app: {Mc.Modifier.App, :modifyr},
    append: {Mc.Modifier.Append, :modify},
    appendk: {Mc.Modifier.Kv, :appendk},
    buffer: {Mc.Modifier.Buffer, :modify},
    ccount: {Mc.Modifier.Ccount, :modify},
    delete: {Mc.Modifier.Delete, :modify},
    div: {Mc.Modifier.Math, :divide},
    email: {Mc.Modifier.Email, :deliver},
    error: {Mc.Modifier.Error, :modify},
    findk: {Mc.Modifier.Kv, :findk},
    findv: {Mc.Modifier.Kv, :findv},
    get: {Mc.Modifier.Kv, :get},
    getb: {Mc.Modifier.Getb, :modify},
    grep: {Mc.Modifier.Grep, :modify},
    grepv: {Mc.Modifier.Grep, :modifyv},
    head: {Mc.Modifier.Head, :modify},
    hsel: {Mc.Modifier.Hsel, :modify},
    hselc: {Mc.Modifier.Hselc, :modify},
    htab: {Mc.Modifier.Htab, :modify},
    ife: {Mc.Modifier.If, :modifye},
    ifl: {Mc.Modifier.If, :modifyl},
    ifg: {Mc.Modifier.If, :modifyg},
    invert: {Mc.Modifier.Invert, :modify},
    json: {Mc.Modifier.Json, :modify},
    jsona: {Mc.Modifier.Json, :modifya},
    lcase: {Mc.Modifier.Lcase, :modify},
    lcount: {Mc.Modifier.Lcount, :modify},
    login: {Mc.Modifier.Login, :modify},
    map: {Mc.Modifier.Map, :modify},
    mcast: {Mc.Modifier.Mcast, :modify},
    mcastk: {Mc.Modifier.Mcast, :modifyk},
    mul: {Mc.Modifier.Math, :multiply},
    prepend: {Mc.Modifier.Prepend, :modify},
    prependk: {Mc.Modifier.Kv, :prependk},
    range: {Mc.Modifier.Range, :modify},
    regex: {Mc.Modifier.Regex, :modify},
    replace: {Mc.Modifier.Replace, :modify},
    run: {Mc.Modifier.Run, :modify},
    runk: {Mc.Modifier.Run, :modifyk},
    set: {Mc.Modifier.Kv, :set},
    sort: {Mc.Modifier.Sort, :modify},
    sortv: {Mc.Modifier.Sort, :modifyv},
    sub: {Mc.Modifier.Math, :subtract},
    tail: {Mc.Modifier.Tail, :modify},
    trim: {Mc.Modifier.Trim, :modify},
    trimn: {Mc.Modifier.Trim, :modifyn},
    ucase: {Mc.Modifier.Ucase, :modify},
    url: {Mc.Modifier.Http, :get},
    urlp: {Mc.Modifier.Http, :post},
    ver: {Mc.Modifier.Version, :modify},
    wcount: {Mc.Modifier.Wcount, :modify},
    wrap: {Mc.Modifier.Wrap, :modify},
    zip: {Mc.Modifier.Zip, :modify},

    # Experiments
    alturl: {Mc.X.Alturl, :modify},
    date: {Mc.X.Date, :modify},
    font: {Mc.X.Font, :modify},
    iword: {Mc.X.Iword, :modify},
    rand: {Mc.X.Random, :modify},
    setkv: {Mc.X.Setkv, :modify},
    sleep: {Mc.X.Sleep, :modify},
    summarize: {Mc.X.Summarize, :modify},
    time: {Mc.X.Time, :modify},
    urlj: {Mc.X.Urlj, :modify},
    uuid: {Mc.X.Uuid, :modify},

    # Aliases
    a: {Mc.Modifier.App, :modifyr},
    b: {Mc.Modifier.Buffer, :modify},
    d: {Mc.Modifier.Delete, :modify},
    g: {Mc.Modifier.Grep, :modify},
    gv: {Mc.Modifier.Grep, :modifyv},
    m: {Mc.Modifier.Map, :modify},
    r: {Mc.Modifier.Replace, :modify}
  ]
end
