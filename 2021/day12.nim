include aoc

type
  Node = ref object of RootObj
    name: string
    children: HashSet[Node]

proc `$`(node: Node): string =
  let childrenNames = node.children.mapIt(it.name).join(", ")
  &"Node(name: \"{node.name}\", children: {childrenNames})"

proc isLower(node: Node): bool =
  # We can do this because all the letters in the name have same case
  node.name[0].isLowerAscii

proc hasDupeLower(nodes: seq[Node]): bool =
  var iterated = initHashSet[Node]()
  for node in nodes:
    if node.isLower and node in iterated:
      return true
    iterated.incl(node)

proc traverse(node: Node, part2: bool, traversed: seq[Node] = @[]): int =
  if node.name == "end":
    return 1

  let newTraversed = traversed & @[node]

  # Only allow duplicate small caves if this is part2, and there isn't already a dupe.
  let allowADupe = not hasDupeLower(newTraversed) and part2

  for child in node.children:
    if not child.isLower or child notin newTraversed or allowADupe:
      result += traverse(child, part2, newTraversed)


day 12:
  var parsedNodes = initTable[string, Node]()
  var allNodeNames = initHashSet[string]()

  let rawNodes = collect:
    for line in lines:
      let (success, start, finish) = line.scanTuple("$+-$+")
      if success:
        allNodeNames.incl(start)
        allNodeNames.incl(finish)
        (start, finish)

  for name in allNodeNames:
    parsedNodes[name] = Node(name: name)

  for start, finish in rawNodes.items:
    # Make sure that no node points back to the start, so we won't return there.
    if finish != "start":
      parsedNodes[start].children.incl(parsedNodes[finish])
    if start != "start":
      parsedNodes[finish].children.incl(parsedNodes[start])

  part 1:
    traverse(parsedNodes["start"], false)
  part 2:
    traverse(parsedNodes["start"], true)
