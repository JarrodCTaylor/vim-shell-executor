" --------------------------------
" Add our plugin to the path
" --------------------------------
python import sys
python import vim
python sys.path.append(vim.eval('expand("<sfile>:h")'))

" --------------------------------
"  Function(s)
" --------------------------------
function! ExecuteWithShellProgram(selection_or_buffer)
python << endPython
from vim_shell_executor import *

def create_new_buffer(contents):
    delete_old_output_if_exists()
    vim.command('aboveleft split executor_output')
    vim.command('normal! ggdG')
    vim.command('setlocal filetype=text')
    vim.command('setlocal buftype=nowrite')
    vim.command('call append(0, {0})'.format(contents))

def delete_old_output_if_exists():
    if int(vim.eval('buflisted("executor_output")')):
        vim.command('bdelete executor_output')

def get_visual_selection():
    buf = vim.current.buffer
    starting_line_num, col1 = buf.mark('<')
    ending_line_num, col2 = buf.mark('>')
    return vim.eval('getline({}, {})'.format(starting_line_num, ending_line_num))

def get_correct_buffer(buffer_type):
    if buffer_type == "buffer":
        return vim.current.buffer
    elif buffer_type == "selection":
        return get_visual_selection()

def execute():
    buf_type = get_correct_buffer(vim.eval("a:selection_or_buffer"))
    shell_program_output = get_program_output_from_buffer_contents(buf_type)
    create_new_buffer(shell_program_output)

execute()

endPython
endfunction

" --------------------------------
"  Expose our commands to the user
" --------------------------------
command! ExecuteBuffer call ExecuteWithShellProgram("buffer")
command! -range ExecuteSelection call ExecuteWithShellProgram("selection")
