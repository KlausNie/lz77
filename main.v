module main

import os
import utils
import math

fn main() {
	mut uncompressed_text := os.read_file('main.v') or {
		println("couldn't read file")
		exit(1)
	}
	// uncompressed_text = uncompressed_text.repeat(100)
	println('size before: ${uncompressed_text.len}')

	// s1 := utils.to_array("caacab")
	// s2 := utils.to_array("caba")
	// longest_common_substring_prefix(s1, s2)

	// compressed := compress('aacaacabcabaaac')
	// TODO try different sizes
	compressed := compress(uncompressed_text, 512, 64)

	println("compressed: ${compressed.len}")
}

fn compress(text string, search_window_size int, look_ahead_window_size int) []RunePointer {
	mut compressed := []RunePointer{}

	rune_array := utils.to_rune_array(text)

	// loop
	mut pointer := 0
	for {
		if pointer > rune_array.len {
			break
		}

		search_buffer_start_index := math.max(0, pointer - search_window_size)
		search_buffer := rune_array[search_buffer_start_index..pointer]
		look_ahead_buffer_end_index := math.min(rune_array.len,pointer + look_ahead_window_size)
		look_ahead_buffer := rune_array[pointer..look_ahead_buffer_end_index]

		window_offset, duplication_length := longest_common_substring_prefix(search_buffer, look_ahead_buffer)
		next_rune := rune_array[math.min(pointer + duplication_length, rune_array.len - 1)]

		compressed << RunePointer{
			offset: window_offset
			length: duplication_length
			char: next_rune
		}

		pointer += duplication_length + 1
	}

	return compressed
}

fn longest_common_substring_prefix(str1 []rune, str2 []rune) (int, int) {
	str1_len := str1.len
	str2_len := str2.len

	mut offset := -1
	mut length := 0

	for i := 0; i < str1_len; i++ {
		for j := 0; j < str2_len; j++ {
			mut k := 0
			for {
				if i + k < str1_len && j + k < str2_len && str1[i + k] == str2[j + k] {
					k = k + 1
				} else {
					break
				}
			}

			if i + k > i && j == 0 && k >= length {
				offset = i
				length = k
			}
		}
	}

	mut start := 0
	if offset == -1 {
		start = 0
	} else {
		start = str1_len - offset
	}
	//println('---')
	//println('${offset}')
	// // println('${str1[offset..offset + length]}')
	//println('${start} ${length}')
	return start, length
}

struct RunePointer {
	offset int
	length int
	char rune
}
