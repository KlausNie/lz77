module lz77

import math

pub fn uncompress(compressed_array []RunePointer) string {
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

	return to_string(rune_array)
}
