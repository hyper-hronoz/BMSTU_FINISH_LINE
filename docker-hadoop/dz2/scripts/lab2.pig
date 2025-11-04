-- Используем системные переменные Hadoop
%default CURRENT_DATE `date +%Y-%m-%d`

-- Загружаем файлы
file1 = LOAD '/datasets/file1.txt' AS (line:chararray);
file2 = LOAD '/datasets/file2.txt' AS (line:chararray);

-- Добавляем имена файлов вручную
file1_named = FOREACH file1 GENERATE line, 'file1.txt' AS filename;
file2_named = FOREACH file2 GENERATE line, 'file2.txt' AS filename;

-- Объединяем все файлы
all_files = UNION file1_named, file2_named;

-- Разбиваем строки на слова
words = FOREACH all_files GENERATE FLATTEN(TOKENIZE(line)) AS word, filename;

-- Длина каждого слова
word_lengths = FOREACH words GENERATE SIZE(word) AS length, filename;

-- Группируем по имени файла
grouped = GROUP word_lengths BY filename;

-- Средняя длина слов в каждом файле
avg_word_length = FOREACH grouped GENERATE ROUND_TO(AVG(word_lengths.length), 2) AS avg_len, group AS filename;

-- Форматируем вывод: "средняя_длина@имя_файла"
formatted = FOREACH avg_word_length GENERATE CONCAT((chararray)avg_len, CONCAT('@', filename));

-- Сохраняем результат
STORE formatted INTO '/output/lab2_$CURRENT_DATE' USING PigStorage();
