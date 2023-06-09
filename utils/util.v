module utils

pub fn to_rune_array(text string) []rune {
	mut arr := []rune{}
	for i := 0; i < text.len; i++ {
		arr << text[i]
	}
	return arr
}
