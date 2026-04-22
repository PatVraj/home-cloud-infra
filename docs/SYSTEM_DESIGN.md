# System Design & Service Topology

This document outlines the application-layer architecture, data flows, and database isolation strategies for the home cloud infrastructure.

## 1. High-Level Service Architecture

The system is designed as a hybrid-cloud microservices architecture, connected via a Tailscale mesh VPN.

* **Ingress & UI Layer:** Open WebUI provides the human interface. 
* **Automation Layer:** n8n acts as the central nervous system, listening for webhooks and triggering background workflows.
* **LLM Gateway Layer:** LiteLLM serves as the universal API router, translating requests from Open WebUI and n8n to the appropriate local or cloud AI models.
* **Inferencing Layer:** * Local: Ollama running on `laptop-hp` for low-latency, smaller models.
    * Edge/Cloud: Cloud-hosted APIs (Gemini, OpenRouter) and Oracle A1 for background thinking models.

## 2. Database Topology

The infrastructure currently utilizes a **Database-per-Stack** pattern to ensure isolation between the AI environment and external edge data.

### Stack A: Internal AI Database (`openclaw`)
* **Engine:** PostgreSQL 16 (with `pgvector` extension)
* **Network Status:** Isolated (No ports exposed to host. Accessible only via Docker `ai-net`)
* **Logical Databases:**
    * `openwebui`: Stores chat history, user profiles, and RAG vector embeddings.
    * `n8n`: Stores workflow configurations, execution logs, and credentials.

### Stack B: External Edge Database (`edge-db`)
* **Engine:** PostgreSQL 16 (Standard)
* **Network Status:** Exposed (Port `5432` bound to host `192.168.86.201`)
* **Logical Databases:**
    * `edge_pipeline`: General-purpose datastore for external applications, scripts, and potential cloud-syncing.

## 3. Data & Request Flow Map

When a user interacts with the system, the data flows as follows:

1.  **User Request:** User sends a prompt via Open WebUI (`192.168.86.201:3002`).
2.  **Vector Search (Optional):** Open WebUI queries the internal `pgvector` database to retrieve relevant context (RAG).
3.  **LLM Routing:** Open WebUI sends the prompt to LiteLLM (`192.168.86.201:4000`).
4.  **Inference Execution:** LiteLLM evaluates the `model_list` and routes the request to:
    * *Route A:* Local Ollama container (via `http://ollama:11434`).
    * *Route B:* External API (Google Gemini, OpenRouter) via public internet.
    * *Route C:* Remote Oracle Edge Node (via Tailscale tunnel).
5.  **Automation Trigger:** n8n monitors the environment. If a specific webhook is hit or an LLM logic step requires an action, n8n executes the workflow and logs the state in its internal database.
