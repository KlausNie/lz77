module main

import os
import lz77

fn main() {
	// newlines
	mut uncompressed_text := os.read_file('main.v') or {
		println("File could not be read")
		exit(1)
	}
	//uncompressed_text = uncompressed_text.replace(uncompressed_text, '')
	// uncompressed_text = uncompressed_text.repeat(100)
	uncompressed_text = 'abadakadabra'.repeat(2)

	// different sizes yield different compression results
	// these sizes are independent on the uncompression

	// TODO
	// as seen with this example 'abadakadabra', the compression algo does not yet
	// fully work. culprit is the longest_common_substring_prefix part
	compressed := lz77.compress(uncompressed_text, 256, 128)

	reconstructed_text := lz77.uncompress(compressed)

	println('size before: ${uncompressed_text.len}')
	println('uncompressed_text:  ${uncompressed_text}')
	println("compressed: ${lz77.rune_pointer_array_to_string(compressed)}")
	println("compressed size: ${compressed.len}")
	println("uncompressed_text2: ${reconstructed_text}")
}

