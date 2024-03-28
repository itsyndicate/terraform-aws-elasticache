## Description
dump and restore redis

## Before using script specify these variable:
### Source Redis details
```
SOURCE_REDIS_HOST="localhost"`
SOURCE_REDIS_PORT=8000`
```
### Target Redis details
```
TARGET_REDIS_HOST="localhost"
TARGET_REDIS_PORT=8001
```

### Useful commands
```
connect to redis: redis-cli -h localhost -p 8001  
show all keys: KEYS *
show type of specified key: TYPE key
get content from zset: ZRANGE KEY_PATTERN start_int end_int
show string value of key: GET KEY_PATTERN
```