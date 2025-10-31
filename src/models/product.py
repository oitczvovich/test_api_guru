from sqlalchemy import Column, String, Integer, Numeric, ForeignKey
from sqlalchemy.orm import relationship

from configs.db import Base


class Product(Base):
    id = Column(Integer, primary_key=True)
    sku = Column(String, unique=True)
    name = Column(String, nullable=False)
    category_id = Column(Integer, ForeignKey("categories.id"))
    quantity_available = Column(Integer, nullable=False, default=0)
    price = Column(Numeric(12, 2), nullable=False)

    category = relationship("Category", back_populates="products", lazy="select")
    order_items = relationship("OrderItem", back_populates="product", lazy="select")
