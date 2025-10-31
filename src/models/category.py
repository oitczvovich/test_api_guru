from sqlalchemy import Column, String, Integer, ForeignKey
from sqlalchemy.orm import relationship

from configs.db import Base


class CategoryClosure(Base):
    __tablename__ = "category_closures"
    ancestor_id = Column(
        Integer,
        ForeignKey('categories.id', ondelete="CASCADE"),
        primary_key=True
    )
    descendant_id = Column(
        Integer,
        ForeignKey("categories.id", ondelete="CASCADE"),
        primary_key=True
    )
    depth = Column(Integer, nullable=False)

    ancestor = relationship(
        "Category",
        foreign_keys=[ancestor_id],
        primaryjoin="Category.id==CategoryClosure.ancestor_id"
    )
    descendant = relationship(
        "Category",
        foreign_keys=[descendant_id],
        primaryjoin="Category.id==CategoryClosure.descendant_id"
    )


class Category(Base):
    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False)
    parent_id = Column(Integer, ForeignKey("categories.id"), nullable=True)

    parent = relationship(
        "Category",
        remote_side=[id],
        back_populates="children",
    )
    children = relationship(
        "Category",
        back_populates="parent",
        cascade="all, delete-orphan",
    )

    products = relationship("Product", back_populates="category")
