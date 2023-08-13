<h1 align="center">
	<img width="500" src="assets/matrix.png" alt="matrix.png"></img>
	<br>
</h1>

# Trinity
Generate link network image from text files.

# Idea
I developed trinity since i need a tool represent all the links between my files. (i use these linked notes to make a second brain.)

The idea is simple. i have bunch of simple `.txt` files in a flat hierarchy structure that can refer to each other.(like in **docs** directory)

to create a graph of links:
`./trinity.sh docs/matrix.txt > /dev/null  2>&1`

it will create two files in output directory:
1. matrix.gv
2. matrix.png

actually i converted all links that i find inside input file to [dot language](https://en.wikipedia.org/wiki/DOT_(graph_description_language)) and then create an image from it.

this is the content of auto-generated `.gv` file:
```
graph matrix {
  layout=sfdp;
  edge [penwidth=5 color="#FFCC80"]
  node [style="filled" penwidth=0 fillcolor="#D7CCC8" fontcolor="#424242"]
  matrix [fontsize=30]

  node [fontsize=25]
  matrix -- {
    neo
    mouse
    cypher
    trinity
    morpheus
    boy
    oracle
    smith
    merovingian
    architect
  }

  graph [ranksep=2];
}
```

now you can open the image:
`xdg-open output/matrix.png`

## dependencies
- [graphviz](https://graphviz.org/)

## Who is Trinity
<h1 align="center">
	<img width="500" src="assets/trinity.gif" alt="trinity.gif">
	<br>
</h1>

## License
![License](https://img.shields.io/github/license/LinArcX/trinity.svg?style=flat-square)
