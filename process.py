import pyodbc
import time


# DEVELOPMENT
db_credentials = ('Driver={SQL Server};' +
                  'Server=(local);' +
                  'Database=Zendesk;' +
                  'UID=zendesk_csp;' +
                  'PWD=xUG3y=4zp<sr?f>/;')

connection = pyodbc.connect(db_credentials)
cursor = connection.cursor()


def timestamp():
    return '[' + time.strftime('%H:%M:%S', time.localtime()) + '] '


def get_user_id(email):
    return cursor.execute("select id from users where email like '" + email + "'").fetchval()


def select_top(table):
    return cursor.execute("select top 1 * from " + table).fetchall()


print(timestamp() + ' ' + str(get_user_id('clee@itrsgroup.com')))
print(timestamp() + ' ' + str(select_top('CSP_Question')))
