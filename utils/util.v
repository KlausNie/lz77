module utils

pub fn to_rune_array(text string) []rune {
	return text.runes()
}

pub fn to_string(array [] rune) string {
	return array.string()
}
