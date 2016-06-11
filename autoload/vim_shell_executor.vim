" --------------------------------
" Add our plugin to the path
" --------------------------------
 if has("python3")
     command! -nargs=1 Py py3 <args>
 else
     command! -nargs=1 Py py <args>
 endif
Py import sys
Py import vim
Py sys.path.append(vim.eval('expand("<sfile>:h")'))

" --------------------------------
"  Function(s)
" --------------------------------
function! LeftPad(s,amt,...)
    if a:0 > 0
        let char = a:1
    else
        let char = ' '
    endif
    return repeat(char,a:amt - len(a:s)) . a:s
endfunction

function! DisplayTimeDifference(time1,time2)
    let l:t1List = split( a:time1, ":" )
    let l:t2List = split( a:time2, ":" )
    let l:difference = abs((l:t1List[1] * 60 + l:t1List[2]) - (l:t2List[1] * 60 + l:t2List[2]))
    let l:minutesDifference = LeftPad(float2nr(floor(difference/60)), 2, "0")
    let l:secondsDifference = LeftPad(l:difference - (l:minutesDifference * 60), 2, "0")
    set cmdheight=2
    echo "Execution started at: " . a:time1 . " Successfully finished at: " . a:time2 . " Duration: 00:" . l:minutesDifference . ":" . l:secondsDifference
    set cmdheight=1
endfunction

function! vim_shell_executor#ExecuteWithShellProgram(selection_or_buffer)
let startExecutionTime = strftime("%T")
echo "Execution started at: " . startExecutionTime
Py << endPython
from vim_shell_executor import *

def create_new_buffer(contents):
    vim.command('normal! Hmx``')
    delete_old_output_if_exists()
    if int(vim.eval('exists("g:executor_output_win_height")')):
        vim.command('aboveleft {}split executor_output'.format(vim.eval("g:executor_output_win_height")))
    else:
        vim.command('aboveleft split executor_output')
    vim.command('normal! ggdG')
    vim.command('setlocal filetype=text')
    vim.command('setlocal buftype=nowrite')
    try:
        vim.command('call append(0, {0})'.format(contents))
    except:
        for index, line in enumerate(contents):
            vim.current.buffer.append(line)
    vim.command('execute \'wincmd j\'')
    vim.command('normal! `xzt``')

def delete_old_output_if_exists():
    if int(vim.eval('buflisted("executor_output")')):
        capture_buffer_height_if_visible()
        vim.command('bdelete executor_output')

def capture_buffer_height_if_visible():
    executor_output_winnr = int(vim.eval('bufwinnr(bufname("executor_output"))'))
    if executor_output_winnr > 0:
        executor_output_winheight = vim.eval('winheight("{}")'.format(executor_output_winnr))
        vim.command("let g:executor_output_win_height = {}".format(executor_output_winheight))

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

let endExecutionTime = strftime("%T")
call DisplayTimeDifference(startExecutionTime, endExecutionTime)

endfunction
