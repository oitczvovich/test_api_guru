from sqlalchemy import Column, String, Integer, DateTime, Numeric, ForeignKey, func, UniqueConstraint
from sqlalchemy.orm import relationship

from configs.db import Base


class Order(Base):
    id = Column(Integer, primary_key=True)
    client_id = Column(Integer, ForeignKey("clients.id"), nullable=False)
    order_date = Column(DateTime(timezone=True), server_default=func.now())
    status = Column(String, nullable=False, default="draft")

    client = relationship("Client", back_populates="orders", lazy="select")
    items = relationship("OrderItem", back_populates="order", lazy="select")


class OrderItem(Base):
    __tablename__ = 'order_items'
    id = Column(Integer, primary_key=True)
    order_id = Column(Integer, ForeignKey("orders.id"), nullable=False)
    product_id = Column(Integer, ForeignKey("products.id"), nullable=False)
    quantity = Column(Integer, nullable=False)
    price_at_order = Column(Numeric(12, 2), nullable=False)

    __table_args__ = (
        UniqueConstraint("order_id", "product_id", name="uix_order_product"),
    )
    order = relationship("Order", back_populates="items", lazy="select")
    product = relationship("Product", back_populates="order_items", lazy="select")
