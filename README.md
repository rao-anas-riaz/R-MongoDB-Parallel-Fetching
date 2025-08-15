# R MongoDB Parallel Fetching

### Project Overview

This project provides a robust and efficient R script, `mongodb_fetch_data_parallel.R`, designed to **extract data from MongoDB in a parallel using multiple CPU cores**. The primary purpose of this script is to overcome the limitations of single-threaded data retrieval by leveraging parallel processing, which significantly reduces the time required to fetch large datasets.

The script is built to handle various data fetching strategies through different "modes," allowing for flexible data extraction based on date ranges, numeric intervals, or specific values. This functionality is crucial for data science and analytics workflows that rely on large-scale data ingestion and require a performant, scalable solution.

The `fetch_data_parallel` function is a comprehensive and resilient data profiling tool. It's built with professional best practices in mind, incorporating robust features for error handling, logging, and performance.

### Public MongoDB Database for Testing

To help users test the `mongodb_fetch_data_parallel` function, a public MongoDB database is available with read-only access. You can use the following details to connect and try out the script:

* **URL**: `mongodb+srv://githubuser:gituser1234@github-test-mongo-clust.rpqe46b.mongodb.net/`
* **Database Name**: `projects`
* **Collection Name**: `parallel_data_extract`
* **User Permissions**: The user `githubuser` has read-only access to this specific collection, ensuring data integrity and security.

When working with large databases, traditional fetching methods can be slow and often lead to system crashes due to memory limitations. Our approach addresses these challenges with three core principles:

1.  **Parallelization:** Instead of fetching the entire dataset in a single, monolithic request, this script breaks the data into smaller, logical chunks. These chunks are then requested and processed simultaneously across multiple CPU cores. The `future` and `future.apply` packages are used to manage this concurrency, allowing us to leverage the power of multi-core processors. 

2.  **Fault Tolerance:** What happens if a single data chunk fails to fetch due to a network hiccup or a timeout? In a single-threaded process, the entire job would fail. Our parallel approach isolates the problem. If a chunk fails, the error is logged, and the script moves on to the next chunk. The main process can complete successfully, and you'll have a clear record of any failed chunks, which can be re-run later. This is handled by a robust `tryCatch` block and a custom logging function.

3.  **Dynamic Modes:** The script is not a one-size-fits-all solution. It offers three distinct modes—`date`, `numeric`, and `values`—to dynamically chunk data based on the most relevant field in your collection. This flexibility means you can optimize the fetching process for any type of data, from time-series to user-specific records.


### How the Script Works: Functionalities and Purpose

The core of this project is the `mongodb_fetch_data_parallel` function. It solves the problem of slow data extraction from large MongoDB collections by dividing the workload across multiple CPU cores. It utilizes the R `future` and `future.apply` packages to execute queries in parallel, which is much faster than a sequential approach.

The script's functionality is broken down into three distinct modes, each designed to address a common data fetching challenge:

* **Date Mode**: This mode is ideal for fetching time-series data or data within a specific time frame. It automatically calculates date intervals based on the start date, end date, and a defined step size (e.g., "1 day," "1 month") and creates a separate query for each interval. The parallel fetching then retrieves data for each interval simultaneously.

* **Numeric Mode**: This mode is for fetching data based on a numeric field (e.g., user ID, a score, a price). It works by splitting the data into chunks based on a minimum value, a maximum value, and a step size. Each chunk is then queried in parallel, making it highly effective for numerical data ranges.

* **Values Mode**: This is a direct approach for fetching data corresponding to a list of specific values (e.g., a list of specific product IDs). The script constructs a separate query for each value in the provided list and executes them in parallel, which is much more efficient than looping through a list of values sequentially.

### Function Call and Parameters

The `mongodb_fetch_data_parallel` function is called by specifying a `mode` and a set of required parameters for that mode.

#### Common Parameters for All Modes:

* `mode`: Character string, must be one of `"date"`, `"numeric"`, or `"values"`. This determines the fetching strategy.
* `collection_name`: Character string, the name of the collection to query.
* `db_name`: Character string, the name of the database.
* `url`: Character string, the MongoDB connection URL.
* `num_cores`: Optional integer, the number of cores to use for parallel processing. Defaults to one less than the number of available cores.

#### Date Mode:

This mode requires three additional parameters:
* `date_field_name`: Character string, the name of the date field in the collection.
* `start_date`: Date or character string, the beginning of the date range.
* `end_date`: Date or character string, the end of the date range.
* `date_step`: numeric, the step size (e.g., `"10 days"`). Defined the number os days data that needs to be fetched per core.

Example Call:
```R
mongodb_fetch_data_parallel(
    mode = "date",
    date_field_name = "date_col",
    start_date = "2024-01-01",
    end_date = "2024-12-31",
    date_step = "10",
    collection_name = "parallel_data_extract",
    db_name = "projects",
    url = "mongodb+srv://githubuser:gituser1234@github-test-mongo-clust.rpqe46b.mongodb.net/"
)
```

#### Numeric Mode:

This mode requires four additional parameters:
* `numeric_field_name`: Character string, the name of the numeric field.
* `min_value`: Numeric, the minimum value to start fetching from.
* `max_value`: Numeric, the maximum value to fetch up to.
* `num_step`: Numeric, the size of each numeric chunk that needs to be fetched for each core.

Example Call:
```R
mongodb_fetch_data_parallel(
    mode = "numeric",
    numeric_field_name = "float_num_col",
    min_value = 1,
    max_value = 100,
    num_step = 10,
    collection_name = "parallel_data_extract",
    db_name = "projects",
    url = "mongodb+srv://githubuser:gituser124@github-test-mongo-clust.rpqe46b.mongodb.net/"
)
```

#### Values Mode:

This mode requires two additional parameters:
* `value_field_name`: Character string, the name of the field containing the values to query.
* `value_list`: A list of values to query for per each CPU core.

```R
mongodb_fetch_data_parallel(
    mode = "values",
    value_field_name = "country",
    value_list = list("USA", "Canada", "UK"),
    collection_name = "parallel_data_extract",
    db_name = "projects",
    url = "mongodb+srv://githubuser:gituser1234@github-test-mongo-clust.rpqe46b.mongodb.net/"
)
```

### License

This project is made available for informational purposes only. The intellectual property and source code remain the exclusive property of the author. No part of the source code may be copied, distributed, or modified without explicit permission.

