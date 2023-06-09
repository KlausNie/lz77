module lz77

pub struct RunePointer {
	offset int
	length int
	char rune
}

pub fn rune_pointer_array_to_string(array []RunePointer) string {
	mut ret_str := []string{}
	for rune_pointer in array {
		ret_str << rune_pointer_to_string(rune_pointer)
	}
	return ret_str.join(',')
}
pub fn rune_pointer_to_string(rune_pointer RunePointer) string {
	return "(${rune_pointer.length}:${rune_pointer.offset}:${rune_pointer.char.str()})"
}
