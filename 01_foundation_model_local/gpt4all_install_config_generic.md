# GPT4All (Nomic) — Install & Configure (OS-agnostic)

These instructions cover the **GPT4All Desktop** client (the usual “chat app”) and optional developer-friendly ways to use GPT4All via a **local OpenAI-compatible API** or the **Python SDK**.

## 0) Prerequisites (hardware + basic expectations)

- **Supported OS:** Windows, macOS, Linux. citeturn1view2  
- **Minimum requirements (typical):**
  - CPU must support **AVX/AVX2**
  - Display at least **1280×720**
  - **≥ 8 GB RAM**
  - Recent OS (e.g., Windows 10+, macOS 12.6+, Ubuntu 22.04+) citeturn1view2  
- Models are typically **multi‑GB downloads**; make sure you have disk space and a stable connection.

---

## 1) Install the GPT4All Desktop app (generic steps)

1. Go to the GPT4All download page and choose your OS installer. citeturn1view0turn2view0  
2. Run the installer and follow the prompts.  
3. Launch **GPT4All**.

> Tip: If your environment blocks downloads, fetch the installer from the same “Download for Windows/Mac/Linux” links in the official docs. citeturn2view0

---

## 2) First run: download a model and start chatting

1. In GPT4All, click **Start Chatting**. citeturn2view0  
2. Click **+ Add Model**. citeturn2view0turn2view1  
3. Pick a model and click **Download**. The docs recommend starting with **Llama 3**. citeturn2view0turn2view1  
4. Go to **Chats** and click **Load Default Model** (or select the model you downloaded). citeturn2view0  

### Model selection basics (quick guidance)

GPT4All is optimized for models in roughly the **3–13B parameter** range on consumer hardware. citeturn2view1  

- Larger models → often better responses, but slower / more RAM needed.
- Smaller quantizations (e.g., 4‑bit) → faster and less RAM, sometimes slightly worse quality. citeturn2view1  

---

## 3) Core configuration to set once (Settings)

Open **Settings** in the app and review:

### Application settings (most important)

- **Device:** Auto / CPU / GPU / Metal (Apple Silicon). citeturn2view2  
- **Default Model:** Choose which model loads by default. citeturn2view2  
- **Download Path:** Change where models are stored on disk. The defaults vary by OS. citeturn2view2  
- **CPU Threads:** Increase/decrease to tune speed vs. responsiveness. citeturn2view2  

### Model settings (tuning knobs)

- **Context Length** and **Max Length** (token limits)
- **Temperature / Top‑P / Top‑K** (creativity vs. determinism)
- **GPU Layers** (how much of the model is loaded into VRAM) citeturn2view2  

> Practical tuning: If you get out‑of‑memory errors or your machine stalls, pick a smaller model (or more aggressive quantization), reduce context/max length, and/or lower GPU layers.

---

## 4) LocalDocs (RAG over your own files, fully local)

LocalDocs lets you “chat with your files” by indexing a folder into searchable snippets and adding relevant excerpts to prompts. citeturn3view0  

### Create a LocalDocs collection

1. Open **LocalDocs**.
2. Click **+ Add Collection**.
3. Name the collection and link it to a folder, then click **Create Collection**. citeturn3view0  
4. Wait until the collection shows **Ready** (you can often chat with partially-indexed files before completion). citeturn3view0  
5. In a chat, enable **LocalDocs** from the top-right button to add that collection as context. citeturn3view0  
6. Use **Sources** under responses to see which files were referenced. citeturn3view0  

### LocalDocs indexing settings

In **Settings → LocalDocs**, you can control which file types are indexed via **Allowed File Extensions** (defaults include `.txt`, `.pdf`, `.md`, `.rst`). citeturn2view2  

---

## 5) Optional: Enable the Local API Server (OpenAI-compatible)

GPT4All can expose an **HTTP API** that’s compatible with many OpenAI-style clients/tools. citeturn1view1  

### Enable it

1. Open GPT4All.
2. Go to **Settings → Application → Advanced**.
3. Enable **“Enable Local API Server”**.
4. Confirm/set the **API Server Port** (default **4891**). citeturn1view1turn2view2  

### Connect to it

- Base URL: `http://localhost:4891/v1` (or your chosen port). citeturn1view1  
- It listens on **localhost only** and accepts **HTTP (not HTTPS)**. citeturn1view1  

### LocalDocs with the API Server

You can activate LocalDocs for API calls via a special “server chat” entry in the GPT4All UI, then your API responses include retrieved references. citeturn1view1  

---

## 6) Optional: Use the Python SDK (for scripting)

If you want to call models programmatically:

- Install: `pip install gpt4all` citeturn1view0turn0search10  
- Example usage is shown in the official docs (download/load a model and generate text). citeturn1view0  

---

## 7) Troubleshooting checklist

- **App won’t start / crashes immediately:** verify your CPU supports **AVX/AVX2** and you meet minimum OS requirements. citeturn1view2  
- **Model downloads are slow or fail:** try a different network, check disk space, or change **Download Path**. citeturn2view2  
- **Out of memory / very slow inference:** pick a smaller model or lower‑bit quantization; reduce context/max length; tune CPU threads / GPU layers. citeturn2view1turn2view2  
- **API clients can’t connect:** ensure the API server is enabled and you’re using `http://localhost:<port>/v1` (HTTP only, localhost only). citeturn1view1turn2view2  

---

## References

- GPT4All Documentation (Desktop quickstart, models, settings, LocalDocs): citeturn2view0turn2view1turn2view2turn3view0  
- GPT4All Wiki (system requirements & supported OS): citeturn1view2  
- GPT4All API Server docs: citeturn1view1  
