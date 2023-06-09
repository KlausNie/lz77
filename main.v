module main

import os
import utils
import math

fn main() {
	println("------- new run -------")
	mut uncompressed_text := os.read_file('main.v') or {
		println("couldn't read file")
		exit(1)
	}
	// uncompressed_text = uncompressed_text.repeat(100)
	// uncompressed_text = 'abadakadabra'
	println('size before: ${uncompressed_text.len}')
	println('uncompressed_text: ${uncompressed_text}')

	// TODO try different sizes
	compressed := compress(uncompressed_text, 4, 4)

	// println("compressed: ${rune_pointer_array_to_string(compressed)}")
	println("compressed size: ${compressed.len}")

	uncompressed_text2 := uncompress(compressed)
	println("uncompressed_text2: ${uncompressed_text2}")
}

fn uncompress(compressed_array []RunePointer) string {
	mut rune_array := []rune{}

	for i := 0; i < compressed_array.len; i++ {
		rune_pointer := compressed_array[i]
		offset := rune_pointer.offset
		length := rune_pointer.length
		next_char := rune_pointer.char

		// TODO consider removing the first if condition and its content completely
		if rune_array.len == 0 {
			rune_array << next_char
		} else {
			for l := 0; l < length; l++ {
				rune_array << rune_array[math.max(-offset, 0)]
			}

			rune_array << next_char
		}
	}

	return utils.to_string(rune_array)
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
		search_buffer_end_index := pointer
		look_ahead_buffer_start_index := pointer
		look_ahead_buffer_end_index := math.min(rune_array.len,pointer + look_ahead_window_size)

		search_buffer := rune_array[search_buffer_start_index..search_buffer_end_index]
		look_ahead_buffer := rune_array[look_ahead_buffer_start_index..look_ahead_buffer_end_index]

		window_offset, duplication_length := longest_common_substring_prefix(search_buffer, look_ahead_buffer)
		next_rune := rune_array[math.min(pointer + duplication_length, rune_array.len - 1)]

		pointer += duplication_length + 1
		if pointer > rune_array.len {
			rune_pointer := RunePointer{
				offset: 0
				length: 0
				char: next_rune
			}
			compressed << rune_pointer
			break
		}

		rune_pointer := RunePointer{
			offset: window_offset
			length: duplication_length
			char: next_rune
		}
		compressed << rune_pointer
	}

	return compressed
}

// longest_common_substring_prefix highly algorithm to find the longest matching prefix 🤷
// TODO make efficient
fn longest_common_substring_prefix(str1 []rune, str2 []rune) (int, int) {
	str1_len := str1.len
	str2_len := str2.len

	mut offset := 0
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

			if i + k > i && j == 0 && k > length {
				offset = i
				length = k
			}
		}
	}

	// this works, but it is not a nice solution
	mut start := 0
	if offset == 0 {
		start = offset
	} else {
		start = str1_len - offset
	}
	return start, length
}

fn rune_pointer_array_to_string(array []RunePointer) string {
	mut ret_str := []string{}
	for rune_pointer in array {
		ret_str << rune_pointer_to_string(rune_pointer)
	}
	return ret_str.join(',')
}
fn rune_pointer_to_string(rune_pointer RunePointer) string {
	return "(${rune_pointer.length}:${rune_pointer.offset}:${rune_pointer.char.str()})"
}
struct RunePointer {
	offset int
	length int
	char rune
}
