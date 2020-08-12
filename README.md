# client-survey-processor
Store results from Client Surveys in a database.

## Description
ITRS runs annual Client Surveys, as well as ongoing transactional surveys (now both on our corporate website), to assess how happy our clients are with us and the services we provide.

The Client Survey Processor (CSP) involves a script to store the results from the surveys (existing as spreadsheets) into a database. The database acts as a historical record of all the survey responses, which may then be queried with SQL for analysis and calculating NPS.

https://ice.itrsgroup.com/display/support/Client+Survey+Processor

## Usage

### Prerequisites
- Python 3 https://www.python.org/downloads/
- If not on the London office network:
    - ITRS London New VPN - CheckPoint
    - Windows Remote Desktop Connection to itrspc152.ldn.itrs (ask Chun Lee for access)

### Installation and Setup

1\. Clone or download the repository to your machine.

2\. Open PowerShell and change to the CSP directory containing process.py.

3\. Create and activate a virtual environment:

    py -m venv venv

    venv\Scripts\activate

4\. Install the required modules within the virtual environment:

    pip install -r requirements.txt

5\. Test the setup by attempting to run the script:

    py process.py

If the setup was successful, you should see the following message:

    Enter directory path for survey results files:

### Running CSP

1\. Open spreadsheet_config.ini and edit the values according to your Client Survey results spreadsheet. Save and close both documents.

2\. Activate the virtual environment:

    venv\Scripts\activate

3\. Run the script:

    py process.py

4\. Enter the directory path containing the Client Survey results spreadsheet.

5\. Enter the number for the spreadsheet you would like to process into the database.

6\. Enter the number for the tab in the spreadsheet containing the set of results.

7\. Enter the number for the type of survey which the results are for.

The script will now process the results into the database. When complete, you should see the following message:

    <file> has been processed.
