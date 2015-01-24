command! ExecuteBuffer call vim_shell_executor#ExecuteWithShellProgram("buffer")
command! -range ExecuteSelection call vim_shell_executor#ExecuteWithShellProgram("selection")
