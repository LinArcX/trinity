#!/bin/bash
#------------------------------------------------
if [ $# -ne 1 ]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi
input_file="$1"

if [ ! -f "$input_file" ]; then
  echo "Input file '$input_file' not found."
  exit 1
fi

#------------------------------------------------
level=1
font_size=28
input_text=$(cat "$input_file")
base_name=$(basename "$input_file" .txt)
gv_file="$base_name.gv"

#------------------------------------------------
print_inner_nodes() {
  # Extract all links inside current file ending with .txt and store them in an array
  txt_words=($(grep -o '\b[a-zA-Z0-9_]*\.txt\b' "$input_file" | sed 's/\.txt$//'))
  array_size=${#txt_words[@]}
  ((level++))
  ((font_size -= 4))

  echo -e "\n  node [fontsize=$font_size]" >> $gv_file
  echo "  $base_name -- {" >> $gv_file
  for link in "${txt_words[@]}"; do
    echo "    $link" >> $gv_file
  done
  echo "  }" >> $gv_file
}

#-----------------------------------------------------------
echo "graph $base_name {" >> $gv_file
echo "  layout=twopi;" >> $gv_file
echo "  edge [penwidth=5 color=\"#FFCC80\"]" >> $gv_file
echo "  node [style=\"filled\" penwidth=0 fillcolor=\"#D7CCC8\" fontcolor=\"#424242\"]" >> $gv_file

echo "  $base_name [fontsize=$font_size]" >> $gv_file

print_inner_nodes

echo -e "\n  graph [ranksep=$level];" >> $gv_file
echo "}" >> $gv_file

#----------------------------------------------------------
# generate a .png from .gv file
dot -Tpng $base_name.gv -o $base_name.png

# remove .gv file
rm $gv_file

# view it with default image viewer
xdg_open $base_name.png
