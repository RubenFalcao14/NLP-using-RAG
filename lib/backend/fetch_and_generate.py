from langchain_community.vectorstores import Chroma
from langchain_chroma import Chroma
from langchain_openai import ChatOpenAI, OpenAIEmbeddings
from langchain.load import dumps, loads
from langchain.prompts import PromptTemplate
from langchain.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
import sqlite3


persist_directory = "chroma_db"

embeddings = OpenAIEmbeddings(check_embedding_ctx_length=False,  openai_api_key="sk-1234", base_url="http://localhost:8080/v1",model="text-embedding-nomic-embed-text-v1.5-GGUF")

loaded_vectordb = Chroma(embedding_function=embeddings, persist_directory=persist_directory) 

retriever=loaded_vectordb.as_retriever(search_kwargs={"k": 3})

# LLM
llm = ChatOpenAI(base_url="http://127.0.0.1:8080/v1",model="llama-3.2-1b-instruct", api_key="LM")

question = "upgrading outparse code"

# RAG-Fusion: Related
template = """You are a helpful assistant that generates multiple search queries based on a single input query. \n
Generate multiple search queries related to: {question} \n
Output (4 queries):"""
prompt_rag_fusion = ChatPromptTemplate.from_template(template)



generate_queries = (
    prompt_rag_fusion 
    | llm
    | StrOutputParser() 
    | (lambda x: x.split("\n"))
)



def reciprocal_rank_fusion(result: list[list], k=60):
    """ Reciprocal_rank_fusion that takes multiple lists of ranked documents 
        and an optional parameter k used in the RRF formula """
    
    # Initialize a dictionary to hold fused scores for each unique document
    fused_scores = {}
    # Iterate through each list of ranked documents
    for docs in result:
        # Iterate through each document in the list, with its rank (position in the list)
        for rank, doc in enumerate(docs):
            # Convert the document to a string format to use as a key (assumes documents can be serialized to JSON)
            doc_str = dumps(doc)
            # If the document is not yet in the fused_scores dictionary, add it with an initial score of 0
            if doc_str not in fused_scores:
                fused_scores[doc_str] = 0
            # Retrieve the current score of the document, if any
            previous_score = fused_scores[doc_str]
            # Update the score of the document using the RRF formula: 1 / (rank + k)
            fused_scores[doc_str] += 1 / (rank + k)

    # Sort the documents based on their fused scores in descending order to get the final reranked results
    reranked_results = [
        (loads(doc), score)
        for doc, score in sorted(fused_scores.items(), key=lambda x: x[1], reverse=True)
    ]
    #print(reranked_results)
    # Return the reranked results as a list of tuples, each containing the document and its fused score
    return reranked_results



retrieval_chain_rag_fusion = generate_queries | retriever.map() | reciprocal_rank_fusion
docs = retrieval_chain_rag_fusion.invoke({"question": question})

def query_with_index(student_name):
    """Query the Students table using an index on the name column."""
    with sqlite3.connect('my_database.db') as connection:
        cursor = connection.cursor()

        # SQL command to select a student by name
        select_query = 'SELECT * FROM Student WHERE id = ?;'

        # Execute the query with the provided student name
        cursor.execute(select_query, (student_name,))

        result = cursor.fetchall()  # Fetch all results

    return result

datastore_retrived=""
for i in range(int(len(docs)/2)):
    ind=query_with_index(docs[i][0].metadata['id'])
    datastore_retrived+=ind[0][1]


template = """Answer the following question based on this context:

{context}

Question: {question}
"""

prompt = ChatPromptTemplate.from_template(template)

final_rag_chain = (
     prompt
    | llm
    | StrOutputParser()
)


ans=final_rag_chain.invoke({"context":datastore_retrived,"question":question})

print(ans)