module lz77

fn to_rune_array(text string) []rune {
	return text.runes()
}

fn to_string(array [] rune) string {
	return array.string()
}
