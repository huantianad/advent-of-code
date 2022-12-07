include aoc

type
  Node = ref object
    parent: Node
    size: int

    case isFolder: bool
    of true: children: Table[string, Node]
    of false: discard

proc parse(lines: seq[string]): Node =
  result = Node(isFolder: true)
  var current = result

  for line in lines[1..^1]:
    var name: string
    var size: int

    if line == "$ cd ..":
      current = current.parent
      assert current != nil
    elif line.scanf("$$ cd $+", name):
      current = current.children[name]
    elif line == "$ ls":
      discard
    elif line.scanf("dir $+", name):
      current.children[name] = Node(isFolder: true, parent: current)
    elif line.scanf("$i $+", size, name):
      current.children[name] = Node(isFolder: false, size: size, parent: current)
    else:
      assert false

proc addSizeToParent(node: Node) =
  if node.isFolder:
    for child in node.children.values:
      addSizeToParent(child)

  node.parent.size += node.size

proc sumWithPredicate(node: Node, predicate: Node -> int): int =
  if node.isFolder:
    for child in node.children.values:
      result += child.sumWithPredicate(predicate)

  result += predicate(node)

day 7:
  let root = lines.parse()
  for child in root.children.values:
    addSizeToParent(child)

  echo root[]

  part 1:
    root.sumWithPredicate(node => (if node.size <= 100000: node.size else: 0))
  part 2:
    "2"
