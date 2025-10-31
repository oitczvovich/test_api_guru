from sqlalchemy.ext.asyncio import AsyncSession

from repositories.order import OrderRepository
from schemas.schemas import AddItemRequest, AddItemResponse


class OrderService:
    def __init__(self, db: AsyncSession):
        self.db = db
        self.repository = OrderRepository(db)

    async def add_item_to_order(
            self,
            order_id: int,
            payload: AddItemRequest
    ) -> AddItemResponse:
        order = await self.repository.get_order_with_lock(order_id)
        product = await self.repository.get_product_with_lock(payload.product_id)

        existing_item = await self.repository.get_existing_order_item(order_id, payload.product_id)

        required_quantity = payload.quantity
        current_quantity_in_order = existing_item.quantity if existing_item else 0

        total_required = current_quantity_in_order + required_quantity

        if product.quantity_available < required_quantity:
            raise ValueError(
                f"Недостаточно товара на складе. Доступно: {product.quantity_available}, требуется: {required_quantity}"
            )

        if existing_item:
            existing_item.quantity = total_required
            new_quantity = total_required

        else:
            await self.repository.create_order_item(
                order_id,
                payload.product_id,
                required_quantity,
                product.price
            )
            new_quantity = required_quantity

        await self.repository.update_product_stock(product, required_quantity)

        return AddItemResponse(
            status="success",
            order_id=order_id,
            product_id=payload.product_id,
            added=required_quantity,
            new_quantity=new_quantity
        )
