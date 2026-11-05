# Screenshot 8: mysqldump and restore check
. "$PSScriptRoot\_common.ps1"
$Host.UI.RawUI.WindowTitle = 'Begin_MySQL_1 | mysqldump + restore'

Show-Cmd 'mysqldump --defaults-file=my.local.ini -uroot -p123 sql_practice > dump.sql'
cmd /c "`"$Dump`" --defaults-file=my.local.ini -uroot sql_practice > dump.sql"

Show-Cmd 'mysqldump --defaults-file=my.local.ini -uroot -p123 --set-gtid-purged=OFF sql_practice > dump_clean.sql'
cmd /c "`"$Dump`" --defaults-file=my.local.ini -uroot --set-gtid-purged=OFF sql_practice > dump_clean.sql"

Write-Host ''
Write-Host "PS $Root> Get-Item dump.sql, dump_clean.sql | Select-Object Name, Length" -ForegroundColor Yellow
Get-Item dump.sql, dump_clean.sql | Select-Object Name, Length | Format-Table -AutoSize

Show-Cmd 'mysql --defaults-file=my.local.ini -uroot -p123 -e "DROP DATABASE IF EXISTS restore_test; CREATE DATABASE restore_test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"'
& $MySQL --defaults-file=my.local.ini -uroot -e "DROP DATABASE IF EXISTS restore_test; CREATE DATABASE restore_test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

Show-Cmd 'mysql --defaults-file=my.local.ini -uroot -p123 restore_test < dump_clean.sql'
cmd /c "`"$MySQL`" --defaults-file=my.local.ini -uroot restore_test < dump_clean.sql"

Show-Cmd 'mysql --defaults-file=my.local.ini -uroot -p123 -t -e "SELECT COUNT(*) AS users_rows FROM restore_test.users; SELECT COUNT(*) AS orders_rows FROM restore_test.orders;"'
& $MySQL --defaults-file=my.local.ini -uroot -t -e "SELECT COUNT(*) AS users_rows FROM restore_test.users; SELECT COUNT(*) AS orders_rows FROM restore_test.orders;"

Start-Sleep -Seconds 60
