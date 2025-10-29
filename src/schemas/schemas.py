from pydantic import BaseModel, PositiveInt


class AddItemRequest(BaseModel):
    product_id: PositiveInt
    quantity: PositiveInt
