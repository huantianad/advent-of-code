include prelude
import re, macros, httpclient, net, algorithm

var solutions*: Table[int, proc (x: string): Table[int, string]]

template day*(day: int, solution: untyped): untyped =
    ## Defines a solution function, if isMainModule, runs it.
    block:
        solutions[day] = proc (input: string): Table[int, string] =
            var inputRaw {.inject.} = input
            var input {.inject.} = input.strip
            var ints {.inject.} = input.ints
            var lines {.inject.} = input.splitLines
            var parts {.inject.}: OrderedTable[int, proc (): string]
            solution
            for k, v in parts:
                result[k] = $v()

    if isMainModule:
        run day

template part*(p: int, solution: untyped): untyped =
    ## Defines a part solution function.
    parts[p] = proc (): string =
        proc inner(): auto =
            solution
        return $inner()

## Common direction vectors
const
    directions8* = [(-1, -1), (0, -1), (1, -1), (1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0)]
    directions4* = [(0, -1), (1, 0), (0, 1), (-1, 0)]


func drop*[T](s: seq[T], d: int): seq[T] =
    ## Returns s with d initial elements dropped
    s[d..^1]

func grid*(data: string, sep: string = ""): seq[seq[string]] =
    ## Splits input into 2D grid, rows separated by NL,
    ## columns separated by sep - whitespace by default.
    if sep == "":
        return data.splitLines.mapIt(it.splitWhitespace)
    return data.splitLines.mapIt(it.split(sep))

func ints*(data: string): seq[int] =
    ## Returns all ints < 10^9 present in the input text.
    data.findAll(re"-?\d+").filterIt(it.len <= 18).map(parseInt)

func intgrid*(data: string): seq[seq[int]] =
    ## Returns a matrix of ints present in the input text
    data.splitLines.map(ints)

proc getInput(day: int): string =
    ## Downloads an input for given day, saves it on disk and returns it,
    ## unless it's been downloaded before, in which case loads it from the disk.
    let filename = fmt"./aocNim/inputs/day{day}.in"
    if fileExists filename:
        return readFile filename

    echo fmt"Downloading input for day {day}."
    let ctx = newContext(cafile = "./aocNim/cacert.pem")
    let client = newHttpClient(sslContext = ctx)
    client.headers["cookie"] = readFile "./aocNim/session"

    let input = client.getContent(fmt"https://adventofcode.com/2021/day/{day}/input")
    filename.writeFile(input)

    return input

proc run*(day: int) =
    let start = cpuTime()
    let results = solutions[day](getInput day)
    let finish = cpuTime()
    echo "Day " & $day
    for k in results.keys.toSeq.sorted:
        echo fmt" Part {k}: {results[k]}"
    echo fmt" Time: {finish-start:.2} s"
