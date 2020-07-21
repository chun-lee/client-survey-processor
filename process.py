import pyodbc
import time
import os
from openpyxl import load_workbook
# from openpyxl.utils.cell import column_index_from_string
# config_column_email = column_index_from_string(config['mandatory_columns']['email'])
import configparser
import sys
import datetime


####################
# CONFIG: DATABASE #
####################

# DEVELOPMENT
db_credentials = ("Driver={SQL Server};" +
                  "Server=(local);" +
                  "Database=Zendesk;" +
                  "UID=zendesk_csp;" +
                  "PWD=xUG3y=4zp<sr?f>/;")

connection = pyodbc.connect(db_credentials)
cursor = connection.cursor()


######################
# FUNCTIONS: UTILITY #
######################

def timestamp():
    return "[" + time.strftime("%H:%M:%S", time.localtime()) + "] "


def ask(msg):
    return input(timestamp() + msg)


def out(msg):
    print(timestamp() + msg)


##################
# FUNCTIONS: SQL #
##################

def sql_get_user_id(email):
    return cursor.execute("select id from Users where email like '" + email + "'").fetchval()


def sql_get_last_id(table):
    last_id = cursor.execute("select max(id) from " + table).fetchval()
    if last_id is None:
        return 0
    return last_id


def sql_select_top(table):
    return cursor.execute("select top 1 * from " + table).fetchall()


###################
# FUNCTIONS: MAIN #
###################

def check_spreadsheet_config():
    # check if config file exists
    try:
        f = open('spreadsheet_config.ini')
    except IOError:
        out('Error: spreadsheet_config.ini: cannot open file\n'
            + 'Are you running process.py from the directory containing spreadsheet_config.ini?\n'
            + 'Please check that spreadsheet_config.ini exists and is named correctly')
        sys.exit(1)
    f.close()

    config = configparser.ConfigParser()
    config.read('spreadsheet_config.ini')

    # check if section exists
    if 'mandatory_columns' not in config:
        out('Error: spreadsheet_config.ini: missing section [mandatory_columns]')
        sys.exit(1)

    # check if keys in section exist
    if 'email' not in config['mandatory_columns']:
        out('Error: spreadsheet_config.ini: missing key "email" in section [mandatory_columns]')
        sys.exit(1)
    if 'end_date' not in config['mandatory_columns']:
        out('Error: spreadsheet_config.ini: missing key "end_date" in section [mandatory_columns]')
        sys.exit(1)

    # check if keys have values
    if config['mandatory_columns']['email'] == '':
        out('Error: spreadsheet_config.ini: no value for key "email" in section [mandatory_columns]')
        sys.exit(1)
    if config['mandatory_columns']['end_date'] == '':
        out('Error: spreadsheet_config.ini: no value for key "end_date" in section [mandatory_columns]')
        sys.exit(1)

    # check if key values are alphabetic only
    if not config['mandatory_columns']['email'].isalpha():
        out('Error: spreadsheet_config.ini: non-alphabetic value for key "email" in section [mandatory_columns]\n'
            + 'Value for "email": ' + config['mandatory_columns']['email'] + '\n'
            + 'Please enter alphabetic-only values e.g. "AF" to indicate email column')
        sys.exit(1)
    if not config['mandatory_columns']['end_date'].isalpha():
        out('Error: spreadsheet_config.ini: non-alphabetic value for key "end_date" in section [mandatory_columns]\n'
            + 'Value for "end_date": ' + config['mandatory_columns']['end_date'] + '\n'
            + 'Please enter alphabetic-only values e.g. "AF" to indicate end_date column')
        sys.exit(1)

    # config file is fine
    return


def get_path():
    user_input = ask("Enter directory path for survey results files: ")
    if os.path.exists(user_input):
        return user_input
    else:
        out("Invalid path: " + user_input)
        return get_path()


def get_file(path):
    print()
    directory_list = os.listdir(path)
    for i in range(len(directory_list)):
        print(" " + str(i) + " : " + directory_list[i])
    print()
    user_input = ask("Enter number for file to process: ")
    try:
        if 0 <= int(user_input) < len(directory_list):
            file_name = directory_list[int(user_input)]
            out("File: " + file_name)
            return file_name
        else:
            out("Invalid input: " + user_input)
            return get_file(path)
    except Exception:
        out("Invalid input: " + user_input)
        return get_file(path)


def get_worksheet(workbook):
    sheets = workbook.sheetnames
    print()
    for i in range(len(sheets)):
        print(" " + str(i) + " : " + sheets[i])
    print()
    user_input = ask("Enter number for results worksheet: ")
    try:
        if 0 <= int(user_input) < len(sheets):
            worksheet_name = sheets[int(user_input)]
            out("Worksheet: " + worksheet_name)
            return workbook.worksheets[int(user_input)]
        else:
            out("Invalid input: " + user_input)
            return get_worksheet(workbook)
    except Exception:
        out("Invalid input: " + user_input)
        return get_worksheet(workbook)


def get_survey_type():
    print()
    print(" 0: Transactional (NPS)")
    print(" 1: Annual")
    print()
    user_input = ask("Enter number for type of survey: ")
    try:
        if 0 <= int(user_input) <= 1:
            return int(user_input)
        else:
            out("Invalid input: " + user_input)
            return get_survey_type()
    except Exception:
        out("Invalid input: " + user_input)
        return get_survey_type()


def check_spreadsheet_columns(worksheet):
    config = configparser.ConfigParser()
    config.read('spreadsheet_config.ini')

    # check email column contains emails
    # looks for '@' in the first cell with a value
    config_column_email = config['mandatory_columns']['email']
    for row in range(2, worksheet.max_row+1):
        cell = str(config_column_email) + str(row)
        value = worksheet[cell].value
        if value is None:
            continue
        if '@' not in value:
            out('Error: spreadsheet: email column ' + config_column_email + ' does not contain valid emails\n'
                + 'Cell value: ' + value + '\n'
                + 'Cell values in this column should contain the "@" symbol\n'
                + 'Please check that the email column is set correctly in the config file')
            sys.exit(1)
        else:  # value contains '@'
            break

    # check end_date column contains dates
    # checks data type of first cell with a value
    config_column_end_date = config['mandatory_columns']['end_date']
    for row in range(2, worksheet.max_row+1):
        cell = str(config_column_end_date) + str(row)
        value = worksheet[cell].value
        if value is None:
            continue
        if not isinstance(value, datetime.date):
            out('Error: spreadsheet: end_date column ' + config_column_end_date + ' does not contain dates\n'
                + 'Cell value: ' + value + '\n'
                + 'Cell values in this column should be a date e.g. "01/09/2016"\n'
                + 'Please check that the end_date column is set correctly in the config file')
            sys.exit(1)
        else:  # value is datetime type
            break


def db_new_survey(file):
    file_name = file[:len(file) - 5]  # remove .xlsx extension
    survey_type = get_survey_type()
    cursor.execute("insert into CSP_Survey(name, upload_date, type_annual) values (" +
                   repr(file_name) + ", " +
                   "getDate()" + ", " +
                   repr(survey_type) +
                   ")")
    connection.commit()
    return sql_get_last_id("CSP_Survey")


################
# MAIN PROGRAM #
################

check_spreadsheet_config()

# DEVELOPMENT
path = 'C:\\Users\\slowden\\ITRS Group Ltd\\ITRS Group Ltd Team Site - Intern\\Client Survey Processor\\Input Spreadsheets'
file = '181018 ITRS Client Survey Analysis Sep18.xlsx'
workbook = load_workbook(filename=os.path.join(path, file), read_only=True, data_only=True)
worksheet = workbook.worksheets[8]
# PRODUCTION
# path = get_path()
# file = get_file(path)
# workbook = load_workbook(filename=os.path.join(path, file), read_only=True, data_only=True)
# worksheet = get_worksheet(workbook)

check_spreadsheet_columns(worksheet)

survey_id = db_new_survey(file)
