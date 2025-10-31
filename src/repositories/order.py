from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import NoResultFound

from models import Order, Product, OrderItem


class OrderRepository:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def get_order_with_lock(self, order_id: int) -> Order:
        """Получить заказ с блокировкой для обновления"""
        result = await self.db.execute(
            select(Order)
            .where(Order.id == order_id)
            .with_for_update()
        )
        order = result.scalar_one_or_none()

        if not order:
            raise NoResultFound("Order with id {order_id} not found")

        return order

    async def get_product_with_lock(self, product_id: int) -> Product:
        """Получить товар с блокировкой для обновления"""
        result = await self.db.execute(
            select(Product)
            .where(Product.id == product_id)
            .with_for_update()
        )
        product = result.scalar_one_or_none()
        if not product:
            raise NoResultFound("Product with id {product_id} not found")

        return product

    async def get_existing_order_item(self, order_id: int, product_id: int) -> OrderItem:
        """Получить существующую позицию в заказе"""
        result = await self.db.execute(
            select(OrderItem)
            .where(
                OrderItem.order_id == order_id,
                OrderItem.product_id == product_id
            )
            .with_for_update()
        )
        return result.scalar_one_or_none()

    async def create_order_item(self, order_id: int, product_id: int, quantity: int, price: float) -> OrderItem:
        """Создать новую позицию в заказе"""
        order_item = OrderItem(
            order_id=order_id,
            product_id=product_id,
            quantity=quantity,
            price_at_order=price
        )
        self.db.add(order_item)

        return order_item

    async def update_product_stock(self, product: Product, quantity: int):
        """Обновить остаток товара"""
        product.quantity_available -= quantity
        self.db.add(product)
