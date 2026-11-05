# Begin_MySQL_1

**Интерактивная работа с MySQL в изолированном окружении № 1**

Учебное задание: запустить «чистый» сервер MySQL (движок InnoDB), подключиться к нему,
выполнить основные операции с базами данных и таблицами, посмотреть журнал `general_log`
и сделать дамп базы данных.

> Методичка: [Begin_MySQL_1.md](https://github.com/rurewa/imfua/blob/main/content/Courses/Basics_database_design/content/bd/Begin_MySQL_1.md)

---

## Кратко

| Параметр | Значение |
|---|---|
| СУБД | MySQL Community Server **8.4.6**, движок InnoDB |
| Платформа | Windows Server (Docker на машине отсутствует) |
| Порт | `3307` |
| Кодировка | `utf8mb4` / `utf8mb4_unicode_ci` |
| Учебный пароль `root` | `123` |
| Результат | база + таблицы, CRUD, журнал, дамп и проверка восстановления |

---

## Окружение выполнения

В среде, где выполнялось задание, **Docker не установлен**: нет `docker` CLI, WSL-дистрибутивы
не установлены. Поэтому «чистый» сервер был поднят из официального ZIP-архива
MySQL Community Server 8.4.6 — без установки в систему, с отдельным каталогом данных.

Конфигурация полностью повторяет `my.cnf` из задания (InnoDB, `utf8mb4`, `general_log`);
отличаются только пути и порт, чтобы ничего не задеть на хосте.

| Шаг методички (Docker) | Локальный аналог |
|---|---|
| `docker run --name my-mysql ... mysql:latest` | `mysqld --defaults-file=my.local.ini` |
| `docker exec -it my-mysql mysql -uroot -p` | `mysql --defaults-file=my.local.ini -uroot -p123` |
| `docker exec my-mysql ls -la /var/lib/mysql` | `Get-ChildItem data` |
| `docker cp my-mysql:/var/lib/mysql/general.log ./general.log` | журнал сразу пишется в `general.log` |
| `docker stop / start my-mysql` | `scripts\stop-local.ps1` / `scripts\start-local.ps1` |
| `docker logs my-mysql` | `general.log` |

---

## Структура репозитория

```
Begin_MySQL_1/
├── my.cnf                  # конфиг из задания (для Docker, пути /var/lib/mysql)
├── my.local.ini            # тот же конфиг для локального запуска на Windows
├── sql/                    # SQL-сценарии по шагам задания
│   ├── 00_help.sql         # справка клиента mysql
│   ├── 01_basics.sql       # кодировка, БД, таблица, первые данные
│   ├── 02_crud.sql         # INSERT / SELECT / UPDATE / DELETE / DROP
│   ├── 03_dump_setup.sql   # база sql_practice для дампа
│   ├── 04_general_log.sql  # разбор журнала
│   ├── 05_restore_check.sql# проверка восстановления дампа
│   └── 06_sql_log_off.sql  # отключение журналирования сессии
├── outputs/                # фактический вывод каждого шага
├── dump.sql                # дамп БД sql_practice
├── dump_clean.sql          # дамп с --set-gtid-purged=OFF
├── general.log             # журнал general_log сервера
├── scripts/
│   ├── start-local.ps1     # запуск локального сервера
│   └── stop-local.ps1      # остановка локального сервера
└── data/                   # файлы БД (исключены из репозитория)
```

---

## Ход выполнения

### Шаг 1. Запуск «чистого» сервера

Каталог проекта и конфигурация:

```shell
mkdir my-mysql
cd my-mysql
```

`my.cnf` — в точности как в методичке (используется при запуске в Docker):

```ini
[mysqld]
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
general_log = 1
general_log_file = /var/lib/mysql/general.log
log_output = FILE

[client]
default-character-set = utf8mb4

[mysql]
default-character-set = utf8mb4
```

Для локального запуска добавлены только абсолютные пути, порт и отключён X Protocol
(`my.local.ini`):

```ini
[mysqld]
basedir = C:/Users/Administrator/source/check/mysql-8.4.6-winx64
datadir = C:/Users/Administrator/source/check/my-mysql/data
port = 3307
mysqlx = 0
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
general_log = 1
general_log_file = C:/Users/Administrator/source/check/my-mysql/general.log
log_output = FILE
```

Инициализация чистого каталога данных и первый запуск:

```powershell
mysqld --defaults-file=my.local.ini --initialize-insecure --console
Start-Process mysqld -ArgumentList "--defaults-file=my.local.ini" -WindowStyle Hidden
mysqladmin --defaults-file=my.local.ini -uroot ping
# mysqld is alive
```

Проверка версии:

```
+---------+---------------------------------+
| version | comment                         |
+---------+---------------------------------+
| 8.4.6   | MySQL Community Server - GPL    |
+---------+---------------------------------+
```

### Шаг 2. Подключение

```shell
mysql --defaults-file=my.local.ini -uroot -p123 --default-character-set=utf8mb4
```

Сразу проверяем кодировку (`SHOW VARIABLES LIKE 'character_set%';`):

| Variable_name | Value |
|---|---|
| character_set_client | utf8mb4 |
| character_set_connection | utf8mb4 |
| character_set_database | utf8mb4 |
| character_set_filesystem | binary |
| character_set_results | utf8mb4 |
| character_set_server | utf8mb4 |
| character_set_system | utf8mb3 |

Клиентская и серверная кодировки совпадают — кириллица не искажается.

### Шаг 3. Основные операции с БД и таблицами

#### 3.1. Справка и список баз

```sql
help;
```

```
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
...
exit      (\q) Exit mysql. Same as quit.
quit      (\q) Quit mysql.
```

```sql
SHOW DATABASES;
```

```
information_schema
mysql
performance_schema
sys
```

#### 3.2. Создание базы и таблицы

```sql
CREATE DATABASE my_database
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE my_database;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

INSERT INTO users (name, email) VALUES
  ('Иван Иванов', 'ivan@example.com'),
  ('Пётр Петров', 'petr@example.com'),
  ('Мария Сидорова', 'maria@example.com');

SELECT * FROM users;
```

```
+----+-----------------------------+-------------------+
| id | name                        | email             |
+----+-----------------------------+-------------------+
|  1 | Иван Иванов                 | ivan@example.com  |
|  2 | Пётр Петров                 | petr@example.com  |
|  3 | Мария Сидорова              | maria@example.com |
+----+-----------------------------+-------------------+
```

#### 3.3. Вставка данных

```sql
INSERT INTO users (name, email) VALUES ('Павел Иванов', 'pavel@example.com');
INSERT INTO users (name, email) VALUES ('Марк Аврелий', 'mark@example.com');

SELECT name, HEX(name) FROM users WHERE id = 1;
```

```
+-----------------------+--------------------------------------------+
| name                  | HEX(name)                                  |
+-----------------------+--------------------------------------------+
| Иван Иванов           | D098D0B2D0B0D0BD20D098D0B2D0B0D0BDD0BED0B2 |
+-----------------------+--------------------------------------------+
```

Байты `D0 98 D0 B2 ...` — это UTF-8 для «Иван Иванов», то есть данные действительно
хранятся в `utf8mb4`, а не в однобайтовой кодировке.

После вставки в таблице 5 строк (`id = 4`, `5` — новые).

#### 3.4. Обновление и выборка

```sql
UPDATE users SET name = 'Иван Петров' WHERE id = 1;
UPDATE users SET name = 'Vasya' WHERE id = 1;

SELECT * FROM users WHERE id = 1;
SELECT name, email FROM users;
SELECT name FROM users;
SELECT name, email FROM users WHERE id = 1;
```

Вертикальный вывод (`\G` вместо `;`):

```sql
SELECT * FROM users WHERE id = 1\G
```

```
*************************** 1. row ***************************
   id: 1
 name: Vasya
email: ivan@example.com
```

#### 3.5. Удаление данных, таблицы и базы

```sql
DELETE FROM users WHERE id = 2;
SELECT * FROM users;
```

```
+----+-----------------------------+-------------------+
| id | name                        | email             |
+----+-----------------------------+-------------------+
|  1 | Vasya                       | ivan@example.com  |
|  3 | Мария Сидорова              | maria@example.com |
|  4 | Павел Иванов                | pavel@example.com |
|  5 | Марк Аврелий                | mark@example.com  |
+----+-----------------------------+-------------------+
```

```sql
DROP TABLE users;
SHOW TABLES;          -- пусто

DROP DATABASE my_database;
SHOW DATABASES;       -- остались только системные БД
```

### Шаг 4. Журнал `general_log`

Все команды пишутся в `general.log`. Последние команды `root`:

```sql
SELECT event_time, command_type, argument
FROM mysql.general_log
WHERE user_host LIKE 'root%'
ORDER BY event_time DESC
LIMIT 5;
```

Пример результата:

```
| 2026-11-05 10:21:38 | Query | SET GLOBAL log_output = 'FILE,TABLE' |
| 2026-11-05 10:21:21 | Query | SET GLOBAL log_output = 'FILE'       |
| 2026-11-05 10:20:59 | Query | INSERT INTO orders (user_id, amount) ... |
```

Дополнительно проверено отключение журналирования для сессии:

```sql
SET SESSION sql_log_off = ON;
SELECT 'SQL_LOG_OFF_ON_MARKER' AS marker;
SET SESSION sql_log_off = OFF;
SELECT 'SQL_LOG_OFF_OFF_MARKER' AS marker;
```

В `general.log` попал только второй маркер:

```
... Query  SELECT 'SQL_LOG_OFF_OFF_MARKER' AS marker
```

### Шаг 5. Дамп базы данных

```shell
mysqldump --defaults-file=my.local.ini -uroot -p123 sql_practice > dump.sql
mysqldump --defaults-file=my.local.ini -uroot -p123 --set-gtid-purged=OFF sql_practice > dump_clean.sql
```

| Файл | Размер |
|---|---|
| `dump.sql` | 3 288 байт |
| `dump_clean.sql` | 3 288 байт |

Дамп содержит `CREATE TABLE` и `INSERT` для таблиц `users` (5 строк) и `orders` (3 строки),
кодировка — `utf8mb4_unicode_ci`, движок — InnoDB.

Проверка восстановления:

```shell
mysql --defaults-file=my.local.ini -uroot -p123 -e \
  "CREATE DATABASE restore_test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql --defaults-file=my.local.ini -uroot -p123 restore_test < dump_clean.sql
```

```
+------------+             +-------------+
| users_rows |             | orders_rows |
+------------+             +-------------+
|          5 |             |           3 |
+------------+             +-------------+
```

Все строки и кириллица восстановились без потерь.

### Шаг 6. Управление сервером

```powershell
# остановка
.\scripts\stop-local.ps1
# запуск
.\scripts\start-local.ps1
```

---

## Замечания к методичке

При выполнении обнаружились четыре расхождения, которые пришлось учесть:

1. **Имя базы в команде дампа.** По тексту создаётся `my_database`, а дампится `sql_practice`.
   Чтобы команда из методички работала без изменений, после удаления `my_database` была создана
   учебная БД `sql_practice` (`sql/03_dump_setup.sql`), и дамп снят именно с неё.
2. **`mysql.general_log` пуста при `log_output = FILE`.** Таблица заполняется только если в
   `log_output` есть `TABLE`. Для демонстрации на время включался режим `FILE,TABLE`
   (`SET GLOBAL log_output = 'FILE,TABLE'`), затем возвращался `FILE`.
3. **Фильтр `user_host LIKE 'root@%'` не срабатывает.** В MySQL 8.4 значение имеет вид
   `root[root] @ localhost [::1]`, поэтому используется шаблон `root%`.
4. **`help` в неинтерактивном режиме.** При перенаправлении ввода клиент печатает собственные
   опции; справка сервера/клиента выводится с флагом `--named-commands`.

---

## Воспроизведение в Docker

Если Docker доступен, достаточно команд из методички:

```shell
docker run --name my-mysql \
  -e MYSQL_ROOT_PASSWORD=123 \
  -e LANG=C.UTF-8 \
  -v mysql_data:/var/lib/mysql \
  -v $(pwd)/my.cnf:/etc/mysql/conf.d/my.cnf \
  -d mysql:latest

docker exec -it my-mysql mysql --default-character-set=utf8mb4 -uroot -p
```

Скрипты из `sql/` можно выполнить по порядку:

```shell
docker exec -i my-mysql mysql -uroot -p123 --default-character-set=utf8mb4 < sql/01_basics.sql
```

---

## Выводы

- «Чистый» сервер MySQL 8.4.6 (InnoDB) поднят и успешно отработал все шаги задания.
- Проверено создание БД и таблиц, вставка, выборка, обновление и удаление данных,
  удаление таблицы и базы.
- Кодировка `utf8mb4` подтверждена как на уровне переменных сервера, так и по HEX-дампам
  кириллицы.
- Журнал `general_log` пишется в файл, фильтруется по пользователю; `sql_log_off`
  действительно исключает команды сессии из журнала.
- Дамп снят, сохранён в репозитории и проверен обратным импортом: 5 пользователей и 3 заказа
  восстановлены полностью.
