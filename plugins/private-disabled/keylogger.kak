hook global RawKey (?!\x1b)(.+) %{
	nop %sh{
		echo "$kak_hook_param_capture_1" >> /tmp/kak_keylogger
	}
}
