import pyodbc
import time
import os
from openpyxl import load_workbook


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

path = get_path()
file = get_file(path)
workbook = load_workbook(filename=os.path.join(path, file), read_only=True, data_only=True)
worksheet = get_worksheet(workbook)

# TODO check_spreadsheet()
# spreadsheet_config.ini
# Python ConfigParser
# https://www.dev2qa.com/how-to-use-python-configparser-to-read-write-configuration-file/
# mandatory columns must exist
# only then should the survey record be added to CSP_Survey table

survey_id = db_new_survey(file)
