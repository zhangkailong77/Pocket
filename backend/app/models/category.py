from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.core.database import Base

class Category(Base):
    __tablename__ = "categories"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    parent_id = Column(Integer, nullable=True)
    path = Column(String(500))
    sort_order = Column(Integer, default=0)
    icon = Column(String(50))
    created_at = Column(DateTime, server_default=func.now())

    resources = relationship("Resource", back_populates="category")
