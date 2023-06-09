module lz77

import math

// compress
//
// text: the input text
// search_window_size: the bigger the text, the bigger search_window_size helps
// look_ahead_window_size:
pub fn compress(text string, search_window_size int, look_ahead_window_size int) []RunePointer {
	mut compressed := []RunePointer{}

	rune_array := to_rune_array(text)

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

// longest_common_substring_prefix
// highly inefficient algorithm to find the longest matching prefix 🤷
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
