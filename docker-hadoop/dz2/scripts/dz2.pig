-- Используем системные переменные Hadoop
%default CURRENT_DATE `date +%Y-%m-%d`

-- Загружаем пользователей и фильтруем некорректные данные
users_raw = LOAD '/datasets/users.csv' USING PigStorage(',') AS (login:chararray, user_name:chararray, state:chararray);
users = FILTER users_raw BY login != 'login' AND login != 'state' AND login IS NOT NULL;

-- Загружаем твиты и фильтруем некорректные данные
tweets_raw = LOAD '/datasets/tweets.csv' USING PigStorage(',') AS (tweet_id:int, tweet:chararray, login:chararray);
tweets = FILTER tweets_raw BY login != 'login' AND login IS NOT NULL;

-- Считаем длину каждого твита
tweets_len = FOREACH tweets GENERATE tweet_id, login, tweet, SIZE(tweet) AS tweet_length;

-- Присоединяем пользователей
joined = JOIN tweets_len BY login, users BY login;

-- Находим самый длинный твит в каждом штате
grouped_by_state = GROUP joined BY users::state;

max_tweets = FOREACH grouped_by_state {
    sorted = ORDER joined BY tweets_len::tweet_length DESC;
    top1 = LIMIT sorted 1;
    GENERATE FLATTEN(top1);
};

-- Получаем пользователей, написавших самые длинные твиты
top_users = FOREACH max_tweets GENERATE 
    users::login AS login, 
    users::state AS state;

-- Снова соединяем с твитами, чтобы найти среднюю длину твитов этих пользователей
top_users_tweets = JOIN top_users BY login, tweets_len BY login;

-- Переименовываем поля для удобства
top_users_tweets_clean = FOREACH top_users_tweets GENERATE
    top_users::login AS login,
    top_users::state AS state,
    tweets_len::tweet_length AS tweet_length;

-- Считаем среднюю длину твитов этих пользователей
grouped_top_users = GROUP top_users_tweets_clean BY state;

avg_tweet_len = FOREACH grouped_top_users GENERATE
    group AS state,
    ROUND_TO(AVG(top_users_tweets_clean.tweet_length), 2) AS avg_tweet_len;

-- Сохраняем результат с автоматической датой
STORE avg_tweet_len INTO '/output/dz2_$CURRENT_DATE' USING PigStorage(',');
