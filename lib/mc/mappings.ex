defmodule Mc.Mappings do
  defstruct [
    *: Mc.Modifier.Multiply,
    +: Mc.Modifier.Add,
    -: Mc.Modifier.Subtract,
    /: Mc.Modifier.Divide,
    app: Mc.Modifier.App,
    append: Mc.Modifier.Append,
    appendk: Mc.Modifier.AppendK,
    apps: Mc.Modifier.AppS,
    buffer: Mc.Modifier.Buffer,
    casel: Mc.Modifier.CaseL,
    caseu: Mc.Modifier.CaseU,
    countc: Mc.Modifier.CountC,
    countl: Mc.Modifier.CountL,
    countw: Mc.Modifier.CountW,
    delete: Mc.Modifier.Delete,
    email: Mc.Modifier.Email,
    error: Mc.Modifier.Error,
    find: Mc.Modifier.FindK,
    findv: Mc.Modifier.FindV,
    get: Mc.Modifier.Get,
    getm: Mc.Modifier.GetM,
    getb: Mc.Modifier.GetB,
    grep: Mc.Modifier.Grep,
    grepv: Mc.Modifier.GrepV,
    head: Mc.Modifier.Head,
    hsel: Mc.Modifier.Hsel,
    hselc: Mc.Modifier.HselC,
    htab: Mc.Modifier.Htab,
    if: Mc.Modifier.If,
    ifk: Mc.Modifier.IfK,
    invert: Mc.Modifier.Invert,
    iword: Mc.Modifier.Iword,
    join: Mc.Modifier.Join,
    json: Mc.Modifier.Json,
    jsona: Mc.Modifier.JsonA,
    map: Mc.Modifier.Map,
    mapc: Mc.Modifier.MapC,
    prepend: Mc.Modifier.Prepend,
    prependk: Mc.Modifier.PrependK,
    range: Mc.Modifier.Range,
    regex: Mc.Modifier.Regex,
    replace: Mc.Modifier.Replace,
    run: Mc.Modifier.Run,
    runk: Mc.Modifier.RunK,
    set: Mc.Modifier.Set,
    setm: Mc.Modifier.SetM,
    sort: Mc.Modifier.Sort,
    sortv: Mc.Modifier.SortV,
    split: Mc.Modifier.Split,
    squeeze: Mc.Modifier.Squeeze,
    tail: Mc.Modifier.Tail,
    trim: Mc.Modifier.Trim,
    url: Mc.Modifier.Url,
    urlp: Mc.Modifier.UrlP,
    version: Mc.Modifier.Version,
    zip: Mc.Modifier.Zip,

    # Aliases
    a: Mc.Modifier.App,
    b: Mc.Modifier.Buffer,
    d: Mc.Modifier.Delete,
    g: Mc.Modifier.Grep,
    m: Mc.Modifier.Map,
    r: Mc.Modifier.Replace
  ]
end
