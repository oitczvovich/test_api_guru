from fastapi import HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import IntegrityError, DBAPIError, NoResultFound

from services.order_service import OrderService
from schemas.schemas import AddItemRequest, AddItemResponse


class OrderController:

    @staticmethod
    async def add_item_to_order(
            order_id: int,
            payload: AddItemRequest,
            db: AsyncSession
    ) -> AddItemResponse:
        """Контроллер для добавления товара в заказ"""
        if payload is None:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Отсутсвуют данные запроса"
            )

        try:
            order_service = OrderService(db)
            result = await order_service.add_item_to_order(order_id, payload)

            await db.commit()

            return result

        except NoResultFound as e:
            await db.rollback()
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=str(e)
            )
        except ValueError as e:
            await db.rollback()
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=str(e)
            )
        except IntegrityError as e:
            await db.rollback()
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Ошибка целосности данных: {str(e)}"
            )
        except DBAPIError as e:
            await db.rollback()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Ошибка базы данных: {str(e)}"
            )
        except Exception as e:
            await db.rollback()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Внутрення ошибка сервера: {str(e)}"
            )
