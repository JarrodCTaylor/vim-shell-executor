import os
import stat
import unittest
import vim_shell_executor as sut

INPUT_FILE = "/tmp/input"
ERROR_LOG = "/tmp/error.log"
RESULTS_FILE = "/tmp/results"


class VimShellExecutorTests(unittest.TestCase):

    def tearDown(self):
        self.delete_if_present(ERROR_LOG)
        self.delete_if_present(INPUT_FILE)
        self.delete_if_present(RESULTS_FILE)

    def test_get_program_output_from_buffer_contents_returns_properly_formatted_results_when_given_valid_python_input(self):
        buffer_contents = ["python", "name = 'Jarrod'", "", "def hello():", "    print('Hello {0}'.format(name))", "", "hello()"]
        return_result = sut.get_program_output_from_buffer_contents(buffer_contents)
        expected_result = ["Hello Jarrod"]
        self.assertEqual(expected_result, return_result)

    def test_get_program_output_from_buffer_contents_returns_expected_error_when_given_invalid_input(self):
        buffer_contents = ["not_a_program", "fail = 27"]
        expected_error = ['/bin/sh: 1: not_a_program: not found']
        returned_buffer = sut.get_program_output_from_buffer_contents(buffer_contents)
        self.assertEqual(expected_error, returned_buffer)

    def test_get_program_output_from_buffer_contents_returns_expected_content_when_error_and_std_out_are_produced(self):
        buffer_contents = ["python", "print('This is good')", "raise Exception('This is bad')"]
        expected_error = ['Traceback (most recent call last):', '  File "<stdin>", line 2, in <module>', 'Exception: This is bad', 'This is good']
        returned_buffer = sut.get_program_output_from_buffer_contents(buffer_contents)
        self.assertEqual(expected_error, returned_buffer)

    def test_write_buffer_contents_to_file_writes_correct_contents_to_desired_file(self):
        buffer_contents = ["var example = function() {", "    console.log('this is an example');", "}"]
        sut.write_buffer_contents_to_file(RESULTS_FILE, buffer_contents)
        with open(RESULTS_FILE, "r") as f:
            self.assertEqual(f.readlines(), [line + "\n" for line in buffer_contents])

    def test_execute_file_with_specific_shell_program_populates_an_error_file_when_given_invalid_input_for_specified_shell_command(self):
        sut.write_buffer_contents_to_file(INPUT_FILE, ["(def name 'Jarrod')", "(println name)"])
        sut.execute_file_with_specified_shell_program('python')
        self.assertTrue(os.stat(ERROR_LOG)[stat.ST_SIZE] > 0)

    def read_file_to_string(self, file_to_read):
        with open(file_to_read, "r") as f:
            return f.readlines()

    def delete_if_present(self, file_name):
        if os.path.exists(file_name):
            os.remove(file_name)
