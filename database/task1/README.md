
# Movie Recommendation SQL Functions and Performance Optimization

## Task Overview

The task involves creating two SQL functions for fetching movie recommendations. These functions exclude movies that are present in the `reaction` table. We are also tasked with optimizing the performance of these functions and analyzing how different strategies (such as indexes, partitioning, caching, and connection pooling) impact query performance.

## Functions

### 1. `get_recommendations_by_device_id`

This function returns movie recommendations for a user based on their `device_id`, excluding movies that are listed in the `reaction` table.

```sql
CREATE FUNCTION get_recommendations_by_device_id(device_id INT) 
RETURNS TABLE (movie_id INT, title VARCHAR, genre VARCHAR, release_date DATE) AS $$
BEGIN
    RETURN QUERY
    SELECT m.movie_id, m.title, m.genre, m.release_date
    FROM public.movie m
    WHERE m.device_id = device_id
      AND m.movie_id NOT IN (SELECT movie_id FROM public.reaction r WHERE r.device_id = device_id);
END;
$$ LANGUAGE plpgsql;
```

### 2. `get_recommendations_by_user_id`

This function returns movie recommendations for a user based on their `user_id`, excluding movies that are listed in the `reaction` table.

```

## Performance Optimization Approach

### 1. PostgreSQL Configuration Tweaks

Initially, optimizations were focused on adjusting the PostgreSQL configuration settings for **memory**, **CPU**, and **max-connections**.

#### Results

- **First Test (1000 users, 20 users/sec)**:
  - **Average RPS**: 381
  - **Response Time (95%)**: 1400ms
  - **CPU Usage**: 50-80%

- **Second Test (10,000 users, 50 users/sec)**:
  - **Result**: Unable to handle the load, CPU usage reached 90% at 2000 users.

### 2. Implementing pgBouncer (Connection Pooling)

To reduce the overhead of establishing new database connections, `pgBouncer` was introduced as a connection pooler.

#### Results

- **First Test (1000 users, 20 users/sec)**:
  - **Average RPS**: 512
  - **Response Time (95%)**: 890ms
  - **CPU Usage**: 30-40%

- **Second Test (10,000 users, 50 users/sec)**:
  - **Result**: Unable to handle the load, CPU usage reached 90% at 3500 users.

### 3. Indexing Strategy

Indexes were added on the `movie_id` column in the `reaction` table and the `device_id` and `user_id` columns in the `movie` table to optimize the `NOT IN` subqueries.

#### Results

- **Indexing Impact**: Indexing did not improve the performance significantly. The `SELECT` statement still took around **0.3s** to execute, and no substantial improvement was observed in load testing.

### 4. Query Optimization: Limit/Offset Strategy

Using a `LIMIT` and `OFFSET` strategy in the query helped to speed up the execution by reducing the amount of data fetched in each query.

#### Results

- **Query Performance**: The query performance improved by approximately **20-30x** in terms of execution time, but the overall load test performance did not show a significant change in RPS.

## Performance Analysis

- **PostgreSQL Configuration**: Adjusting memory and connection settings improved performance, but PostgreSQL still struggled with scaling beyond a few thousand concurrent users.
  
- **pgBouncer**: Introducing a connection pooler significantly reduced the load on the database and lowered CPU usage, though it still couldn’t handle the full 10,000 RPS load.

- **Indexing**: While indexes can improve query performance, they didn’t provide noticeable improvements due to the complexity of the `NOT IN` subquery and the volume of data.

- **Query Optimization**: Using `LIMIT`/`OFFSET` helped speed up individual queries, but it didn’t provide a significant improvement in overall RPS for the load test.

## Recommendations for Further Optimization

1. **Partitioning**: Consider partitioning large tables like `movie` or `reaction` by date or device/user ID to improve performance when dealing with large datasets.
   
2. **Caching**: Implement caching solutions (e.g., **Redis**) to cache frequently accessed movie recommendations and reduce database load.

3. **Parallel Execution**: Consider parallelizing queries for different segments of users or devices to speed up the recommendation process.

4. **Hardware Scaling**: If needed, scale the database vertically (adding more CPU/RAM) or horizontally (adding more database replicas) to handle higher load.

5. **Sharding**: For very large datasets, sharding might help distribute the load across multiple servers, reducing the burden on a single database instance.
