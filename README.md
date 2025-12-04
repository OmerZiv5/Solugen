This project takes a user question (regarding NBA players) and returns the 5 most similar entries from a prebuilt chromaDB.
How to use:
0. if you don't already have all of the packages installed on your computer you have to run the following command: pip install pandas kagglehub chromadb openai tiktoken flask
1. run the rag_download file - this downloads the data from kaggle.
2. run the rag_load file - this loads the data and stores it as a CSV file
3. run the rag_build file - this file builds the chromaDB and stores it locally on your machine
4. run the app file - this is the backend of the application, you need to run this before you go to the website
5. go to http://127.0.0.1:5000 - if you go to this address in your browser you will see a place to put your question, if you type the question you will get the top 5 most similar entries from the database.

Answers to the assignment's questions:
1. I chose this dataset because I love basketball and it seemed like a good topic to get asked about. In order to meet the requirments you have specified in the assignment I had to trim the dataset and take only the filrst 200 rows and 10 collumns.
2. I am expecting to be asked about NBA player's stats.
3. I chose chromaDB because it seemes like the easiest vectorDB to work with.

Notes:
1. The threshold similarity is 0.2.
2. I retrieve the top 5 answers from the database.
