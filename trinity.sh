#!/bin/bash
usage() {
  echo "trinity.sh: generating a graph based on links among files."
  echo -e "\n\t --input-dir <DIR>: where trinity should looks for files"
  echo -e "\n\t --output-dir <DIR>: put the final image and .gv file here"
  echo -e "\n\t --input-file <FILE.txt>: trinity will generate links graph based on this file"
  echo -e "\n\t --remove-gv-file: remove temporary generated .gv file after image generation"
  echo -e "\n\t --open-img: open the final image with xdg-open"
  echo -e "\n\t --help: show this help"
  exit 1
}

level=0
font_size=0
input_file=""
input_dir=""
output_dir=""
open_img=0
remove_gv_file=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --input-dir)
      input_dir="$2"
      shift 2
      ;;
    --output-dir)
      output_dir="$2"
      shift 2
      ;;
    --input-file)
      input_file="$2"
      shift 2
      ;;
    --font-size)
      font_size="$2"
      shift 2
      ;;
    --remove-gv-file)
      remove_gv_file=1
      shift
      ;;
    --open-img)
      open_img=1
      shift
      ;;
    --help)
      usage
      ;;
    *)
      usage
      ;;
  esac
done

if [ -d $output_dir ]; then rm -r $output_dir; fi
mkdir -p $output_dir

input_text=$(cat "$input_dir/$input_file")
base_name=$(basename "$input_dir/$input_file" .txt)
gv_file="$output_dir/$base_name.gv"

#=------------- recursive function to generate nodes -------------=#
print_inner_nodes() {
  if [ ! -f "$input_dir/${1}.txt" ]; then
    echo "File: '$input_dir${1}.txt' not found."
    exit 1
  else
    local node="$1"
    local fathers=($(grep -o '\b[a-zA-Z0-9_]*\.txt\b' "$input_dir/${node}.txt" | sed 's/\.txt$//'))
    local fathers_size=${#fathers[@]}

    if [ "${fathers_size}" -gt 0 ]; then
      echo -e "\n  node [fontsize=$font_size]" >> "$gv_file"
      echo "  $node -- {" >> "$gv_file"

      for son in "${fathers[@]}"; do
        echo "    $son" >> "$gv_file"
      done

      echo "  }" >> "$gv_file"

      ((level++))
      ((font_size -= 4))

      for son in "${fathers[@]}"; do
        print_inner_nodes "$son"
      done
    fi
  fi
}

#=------------- generate .gv file -------------=#
echo "graph $base_name {" >> $gv_file
echo "  layout=sfdp;" >> $gv_file
echo "  edge [penwidth=5 color=\"#FFCC80\"]" >> $gv_file
echo "  node [style=\"filled\" penwidth=0 fillcolor=\"#D7CCC8\" fontcolor=\"#424242\"]" >> $gv_file

if [ "${font_size}" -eq "0" ]; then
  font_size=34
fi

echo -e "\n  $base_name [fontsize=$font_size]" >> $gv_file

((level++))
((font_size -= 4))
print_inner_nodes $base_name

echo -e "\n  graph [ranksep=$level];" >> $gv_file
echo "}" >> $gv_file

#=------------- generate a .png from .gv file -------------=#
dot -Tpng $gv_file -o $output_dir/$base_name.png

if [ "${remove_gv_file}" -gt 0 ]; then
  rm $gv_file
fi

if [ "${open_img}" -gt 0 ]; then
  xdg-open $output_dir/$base_name.png > /dev/null 2>&1
fi
