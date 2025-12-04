import os
from flask import Flask, render_template, request
import chromadb
from chromadb.config import Settings, DEFAULT_TENANT, DEFAULT_DATABASE
from chromadb.utils import embedding_functions
from openai import OpenAI
import unicodedata

app = Flask(__name__)

# OpenAI API
api_key = os.getenv("OPENAI_API_KEY")
client = OpenAI(api_key=api_key)

# ChromaDB settings
PERSIST_DIR = "./chroma_db"
SIMILARITY_THRESHOLD = 0.01
TOP_K = 5

# Normalize text
def normalize_text(text):
    text = unicodedata.normalize("NFC", text)
    text = text.replace("\u2011", "-")
    return text

# Query function
def query_rag(question):
    chroma_client = chromadb.PersistentClient(
        path=PERSIST_DIR,
        settings=Settings(),
        tenant=DEFAULT_TENANT,
        database=DEFAULT_DATABASE
    )
    collection = chroma_client.get_or_create_collection("nba_rag")

    ef = embedding_functions.OpenAIEmbeddingFunction(
        api_key=api_key,
        model_name="text-embedding-3-small"
    )

    question = normalize_text(question)
    q_emb = ef([question])[0]

    results = collection.query(
        query_embeddings=[q_emb],
        n_results=TOP_K,
        include=["documents", "distances"]
    )

    filtered = []
    for doc, dist in zip(results["documents"][0], results["distances"][0]):
        similarity = 1 - dist
        if similarity >= SIMILARITY_THRESHOLD:
            filtered.append((similarity, doc))
    return filtered

# Flask routes
@app.route("/", methods=["GET", "POST"])
def index():
    results = []
    question = ""
    if request.method == "POST":
        question = request.form.get("question", "")
        results = query_rag(question)
    return render_template("index.html", question=question, results=results)

if __name__ == "__main__":
    app.run(debug=True)
