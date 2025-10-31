from pydantic import BaseModel, PositiveInt
from typing import Optional


class AddItemRequest(BaseModel):
    product_id: PositiveInt
    quantity: PositiveInt


class AddItemResponse(BaseModel):
    status: str
    order_id: int
    product_id: int
    added: int
    new_quantity: Optional[int] = None


class ErrorResponse(BaseModel):
    detail: str
