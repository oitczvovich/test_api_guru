from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware


from api.v1 import order_router

app = FastAPI(title="Notification Service")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(order_router)


@app.get('/health')
async def health_check():
    """Проверка работоспособности сервиса"""
    return {
        "status": "healthy",
        "service": "notification"
    }


@app.get('/')
async def root():
    return {"message": "Notification Service API with Reliable Delivery"}
