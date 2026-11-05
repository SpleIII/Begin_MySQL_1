# Screenshot 2: create database and table
. "$PSScriptRoot\_common.ps1"
$Host.UI.RawUI.WindowTitle = 'Begin_MySQL_1 | CREATE DATABASE / CREATE TABLE'

Show-Cmd 'mysql --defaults-file=my.local.ini -uroot -p123 -t < scripts/scenes/sql/02-create.sql'
Invoke-SqlFile 'scripts/scenes/sql/02-create.sql'

Start-Sleep -Seconds 60

