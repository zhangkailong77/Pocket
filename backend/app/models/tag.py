from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.core.database import Base

class Tag(Base):
    __tablename__ = "tags"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(50), unique=True, nullable=False)
    color = Column(String(50), default="#409EFF")
    created_at = Column(DateTime, server_default=func.now())

    resources = relationship("ResourceTag", back_populates="tag", cascade="all, delete-orphan")

class ResourceTag(Base):
    __tablename__ = "resource_tags"

    resource_id = Column(Integer, ForeignKey("resources.id", ondelete="CASCADE"), primary_key=True)
    tag_id = Column(Integer, ForeignKey("tags.id", ondelete="CASCADE"), primary_key=True)

    resource = relationship("Resource", back_populates="tags")
    tag = relationship("Tag", back_populates="resources")
