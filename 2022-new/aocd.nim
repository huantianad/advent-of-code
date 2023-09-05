import std/[
  appdirs,
  dirs,
  files,
  httpclient,
  monotimes,
  paths,
  strformat,
  strscans,
  strutils,
  tables,
  times,
]

proc p(path: string): Path = Path(path)
proc `$`(path: Path): string = path.string
proc `/`(path: Path, sub: string): Path = path / Path(sub)

proc readFile(path: Path): string = readFile($path)
proc writeFile(path: Path, content: string) = writeFile($path, content)

proc recursiveWriteFile*(path: Path, content: string) =
  ## Same as `syncio.writeFile`, but will recursively create directores up to `path`
  ## if they do not exist. Will not error if a file already exists at `path`.
  createDir(path.parentDir)
  path.writeFile(content)

template timed(code: typed): Duration =
  let start = getMonoTime()
  code
  let finish = getMonoTime()
  finish - start

proc getCookie(): string =
  ## Reads the user's AoC session cookie. Location is decided by `getConfigDir()`.
  let cookiePath = getConfigDir() / "aocd-nim" / "session"

  # Create a file if it doesn't exist yet, so the user can quickly paste their
  # session cookie there.
  if not fileExists cookiePath:
    cookiePath.recursiveWriteFile("")

  result = readFile(cookiePath).strip()

  if result == "":
    raise newException(IOError, fmt"Please write your AoC cookie to '{cookiePath}'.")

  # var token: int
  # if not result.scanf("session=$h$.", token):
  #   raise newException(
  #     ValueError,
  #     fmt"Session token should be of format 'session=128_CHAR_HEX_NUMBER', " &
  #     fmt"but got '{result}' instead."
  #   )

  # if token.len != 128:
  #   raise newException(
  #     ValueError,
  #     fmt"Session token should be a 128 character long hexadecimal number, " &
  #     fmt"but got '{token}' which is {token.len} characters long."
  #   )

proc getInput(year, day: int): string =
  ## Fetches the users input for a given year and day.
  ## Will cache the input after the first time this proc is called.
  let cachedInputPath = getCacheDir(p"aocd-nim") / $year / fmt"{day}.txt"
  if fileExists cachedInputPath:
    return readFile(cachedInputPath)

  echo fmt"Downloading input for year {year}, day {day}."
  let client = newHttpClient()
  defer: client.close()
  client.headers["cookie"] = getCookie()

  result = client.getContent(fmt"https://adventofcode.com/{year}/day/{day}/input")
  cachedInputPath.recursiveWriteFile(result)

proc printResults(day: int, answers: OrderedTable[int, string], time: Duration) =
  echo "Day " & $day
  for partNum, answer in answers.pairs:
    echo fmt" Part {partNum}: {answer}"
  echo fmt" Time: {time.inSeconds:.4} s"

template day*(year, day: int, solution: untyped): untyped =
  let input {.inject.} = getInput(year, day)
  var answers: OrderedTable[int, string]

  template part(partNum: int, answer: typed): untyped =
    answers[partNum] = $answer

  let time = timed:
    solution

  printResults(day, answers, time)
