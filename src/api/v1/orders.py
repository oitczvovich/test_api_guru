from fastapi import APIRouter, Path, status, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from controllers.order_controller import OrderController
from schemas.schemas import AddItemRequest, AddItemResponse , ErrorResponse
from configs.db import get_db

router = APIRouter(prefix="/orders", tags=["orders"])


@router.post(
    "/{order_id}/items",
    response_model=AddItemResponse,
    status_code=status.HTTP_200_OK,
    responses={
        400: {"model": ErrorResponse, "description": "Недостаточно товара или неверные данные"},
        404: {"model": ErrorResponse, "description": "Заказ или товар не найде"},
        500: {"model": ErrorResponse, "description": "Внутренняя ошибка сервера"}
    }
)
async def add_item_to_order(
        order_id: int = Path(..., gt=0, desription="Id заказа"),
        payload: AddItemRequest = None,
        db: AsyncSession = Depends(get_db)
):
    """
    Добавить товар в закак.

    - Если товар уже есть в заказе - увеличивет количество
    - Если торвара нет в наличии - возвращает ошибку  400
    - Фиксирует цену товара на момент добавления
    """
    return await OrderController.add_item_to_order(order_id, payload, db)
