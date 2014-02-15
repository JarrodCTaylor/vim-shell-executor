import subprocess
import os
import stat

INPUT_FILE = "/tmp/input"
ERROR_LOG = "/tmp/error.log"
RESULTS_FILE = "/tmp/results"


def get_program_output_from_buffer_contents(buffer_contents):
    write_buffer_contents_to_file(INPUT_FILE, buffer_contents[1:])
    execute_file_with_specified_shell_program(buffer_contents[0])
    if has_errors():
        new_buf = read_file_lines(ERROR_LOG)
        return new_buf
    new_buf = read_file_lines(RESULTS_FILE)
    return new_buf


def write_buffer_contents_to_file(file_name, contents):
    with open(file_name, "w") as f:
        for line in contents:
            f.write(line + "\n")


def execute_file_with_specified_shell_program(shell_command):
    try:
        subprocess.check_call("{0} {1} {2} > {3} 2> {4}".format(
            shell_command,
            redirect_or_arg(shell_command),
            INPUT_FILE,
            RESULTS_FILE,
            ERROR_LOG),
            shell=True
        )
    except:
        pass


def redirect_or_arg(shell_command):
    redirect_or_agr = "<"
    if shell_command == "coffee":
        redirect_or_agr = ""
    return redirect_or_agr


def has_errors():
    if os.stat("/tmp/error.log")[stat.ST_SIZE]:
        return True
    return False


def read_file_lines(file_to_read):
    with open(file_to_read, "r") as f:
        return [l.rstrip('\n') for l in f.readlines()]
