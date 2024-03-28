#!/bin/bash

# Source Redis details
SOURCE_REDIS_HOST="localhost"
SOURCE_REDIS_PORT=8000
# Target Redis details
TARGET_REDIS_HOST="localhost"
TARGET_REDIS_PORT=8001

# Get all keys from the source Redis
REDIS_KEYS=$(redis-cli -h $SOURCE_REDIS_HOST -p $SOURCE_REDIS_PORT KEYS "*")

for key in $REDIS_KEYS; do
    # Determine the type of the key
    type=$(redis-cli -h $SOURCE_REDIS_HOST -p $SOURCE_REDIS_PORT TYPE "$key")

    echo "Processing $key of type $type..."

    case $type in
        string)
            value=$(redis-cli -h $SOURCE_REDIS_HOST -p $SOURCE_REDIS_PORT GET "$key")
            redis-cli -h $TARGET_REDIS_HOST -p $TARGET_REDIS_PORT SET "$key" "$value"
            ;;
        list)
            # For lists, iterate through each element
            redis-cli -h $SOURCE_REDIS_HOST -p $SOURCE_REDIS_PORT LRANGE "$key" 0 -1 | while read element; do
                redis-cli -h $TARGET_REDIS_HOST -p $TARGET_REDIS_PORT RPUSH "$key" "$element"
            done
            ;;
        set)
            # For sets, iterate through each member
            redis-cli -h $SOURCE_REDIS_HOST -p $SOURCE_REDIS_PORT SMEMBERS "$key" | while read member; do
                redis-cli -h $TARGET_REDIS_HOST -p $TARGET_REDIS_PORT SADD "$key" "$member"
            done
            ;;
        zset)
            # For sorted sets, get each member with its score
            redis-cli -h $SOURCE_REDIS_HOST -p $SOURCE_REDIS_PORT ZRANGE "$key" 0 -1 WITHSCORES | while read member; read score; do
                redis-cli -h $TARGET_REDIS_HOST -p $TARGET_REDIS_PORT ZADD "$key" "$score" "$member"
            done
            ;;
        hash)
            # For hashes, get each field with its value
            redis-cli -h $SOURCE_REDIS_HOST -p $SOURCE_REDIS_PORT HGETALL "$key" | while read field; read value; do
                redis-cli -h $TARGET_REDIS_HOST -p $TARGET_REDIS_PORT HSET "$key" "$field" "$value"
            done
            ;;
        *)
            echo "Unsupported key type: $type"
            ;;
    esac
done

echo "Migration completed."

