from sqlalchemy import Column, String, Integer
from sqlalchemy.orm import relationship

from configs.db import Base


class Client(Base):
    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False)
    address = Column(String)  # необходимо нормализовать, создать отдельно таблицу для адреса куда где будут поля Город, улица, дом , кв. и так далее.

    orders = relationship("Order", back_populates="client", lazy='select')
