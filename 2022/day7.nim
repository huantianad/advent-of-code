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
      child.addSizeToParent()

  node.parent.size += node.size

proc getFolderSizes(node: Node): seq[int] =
  if node.isFolder:
    for child in node.children.values:
      result &= child.getFolderSizes()

    result.add node.size

day 7:
  let root = lines.parse()

  for child in root.children.values:
    child.addSizeToParent()

  let folderSizes = root.getFolderSizes()

  part 1:
    folderSizes.filterIt(it < 100000).sum()
  part 2:
    let minSize = 30000000 - (70000000 - root.size)
    folderSizes.filterIt(it > minSize).sorted()[0]
