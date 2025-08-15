# ------------------- Pre-requisites -------------------
# Install mongolite if not already installed
if (!requireNamespace("mongolite", quietly = TRUE)) {
  install.packages("mongolite")
}

library(mongolite)

# ------------------- MongoDB Fetch Function -------------------

fetch_mongodb_data <- function(collection_name,
                               db_name,
                               uri) {
  tryCatch({
    cat(sprintf("📡 Connecting to MongoDB collection: %s\n", collection_name))
    
    # Create connection
    mongo_conn <- mongo(collection = collection_name, db = db_name, url = uri)
    
    # Fetch all data (use query if you want filtering)
    data <- mongo_conn$find()
    
    cat(sprintf("✅ Fetched %d records from '%s' collection.\n", nrow(data), collection_name))
    return(data)
  }, error = function(e) {
    cat(sprintf("❌ Error: %s\n", e$message))
    return(NULL)
  })
}

result <- fetch_mongodb_data(collection_name = "parallel_data_extract",
                             db_name = "projects",
                             uri = "mongodb+srv://<username>:<passsword>@github-test-mongo-clust.rpqe46p.mongodb.net/")

