from fastapi import FastAPI
import os

app = FastAPI(title="ML Service")

@app.get("/")
async def root():
    return {"message": "ML Service is running"}

@app.get("/health")
async def health():
    return {"status": "healthy"}

if __name__ == "__main__":
    import uvicorn
    port = int(os.getenv("PORT", 8000))
    uvicorn.run(app, host="0.0.0.0", port=port)
