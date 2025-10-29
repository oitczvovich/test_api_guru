from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import ValidationError

# from models.user import UserNotification
# from services.senders import Senders
from services.logger_config import logger

app = FastAPI(title="Notification Service")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# @app.post('/notify')
# async def notify(
#     name: str = Query(..., min_length=1, description="Имя пользователя"),
#     message: str = Query(..., min_length=1, description="Текст сообщения"),
#     email: str = Query(None, description="Email адрес"),
#     phone: str = Query(None, description="Номер телефона"),
#     telegram_id: str = Query(None, description="Telegram ID")
# ):
#     """
#     Отправка уведомления пользователю
#     """
#     logger.info(f"Получен запрос на уведомление: {name}")

#     # Проверяем, что указан хотя бы один канал связи
#     if not any([email, phone, telegram_id]):
#         raise HTTPException(
#             status_code=400,
#             detail="Не указан ни один канал связи (email, phone, telegram_id)"
#         )

#     try:
#         user = UserNotification(
#             name=name,
#             message=message,
#             email=email,
#             phone=phone,
#             telegram_id=telegram_id
#         )
#     except ValidationError as e:
#         error_details = []
#         for error in e.errors():
#             field = error['loc'][0]
#             msg = error['msg']
#             error_details.append(f"{field}: {msg}")

#         raise HTTPException(
#             status_code=400,
#             detail={
#                 "status": "validation_error",
#                 "message": "Ошибка валидации данных",
#                 "errors": error_details
#             }
#         )

#     try:
#         sender = Senders()
#         result = await sender.sendler(user)

#         # Логируем итоговый результат
#         if result['success']:
#             logger.info(f"Уведомление для {name} доставлено через: {', '.join(result['successful_channels'])}")
#             return {
#                 "status": "success",
#                 "message": "Уведомление успешно доставлено",
#                 "user": name,
#                 "successful_channels": result['successful_channels'],
#                 "details": result['details']
#             }
#         else:
#             logger.error(f"Уведомление для {name} не доставлено ни одним каналом")
#             raise HTTPException(
#                 status_code=500,
#                 detail={
#                     "status": "error",
#                     "message": "Не удалось доставить уведомление ни одним каналом",
#                     "user": name,
#                     "failed_channels": result['failed_channels'],
#                     "details": result['details']
#                 }
#             )

#     except Exception as e:
#         logger.error(f"Неожиданная ошибка при отправке уведомления: {str(e)}")
#         raise HTTPException(
#             status_code=500,
#             detail={
#                 "status": "error",
#                 "message": "Внутренняя ошибка сервера",
#                 "error": str(e)
#             }
#         )


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
