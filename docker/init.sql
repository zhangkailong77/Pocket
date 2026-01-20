-- Pocket 数据库初始化脚本

USE pocket;

-- 创建分类表
CREATE TABLE IF NOT EXISTS categories (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL COMMENT '分类名称',
    parent_id   INT NULL COMMENT '父分类ID',
    path        VARCHAR(500) COMMENT '完整路径',
    sort_order  INT DEFAULT 0 COMMENT '排序',
    icon        VARCHAR(50) COMMENT '图标',
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_parent (parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分类表';

-- 创建标签表
CREATE TABLE IF NOT EXISTS tags (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(50) NOT NULL UNIQUE COMMENT '标签名称',
    color       VARCHAR(7) DEFAULT '#409EFF' COMMENT '颜色',
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='标签表';

-- 创建资源表
CREATE TABLE IF NOT EXISTS resources (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(255) NOT NULL COMMENT '资源名称',
    original_name   VARCHAR(255) NOT NULL COMMENT '原始文件名',
    file_path       VARCHAR(500) NOT NULL COMMENT '存储路径',
    file_size       BIGINT COMMENT '文件大小(字节)',
    mime_type       VARCHAR(100) COMMENT 'MIME类型',
    file_type       VARCHAR(50) COMMENT '文件类型: document/image/video/audio/archive',
    category_id     INT NULL COMMENT '分类ID',
    description     TEXT COMMENT '描述',
    download_count  INT DEFAULT 0 COMMENT '下载次数',
    is_deleted      BOOLEAN DEFAULT FALSE COMMENT '软删除',
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category_id),
    INDEX idx_type (file_type),
    INDEX idx_created (created_at),
    FULLTEXT INDEX idx_search (name, description),
    CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='资源表';

-- 创建资源标签关联表
CREATE TABLE IF NOT EXISTS resource_tags (
    resource_id INT NOT NULL,
    tag_id      INT NOT NULL,
    PRIMARY KEY (resource_id, tag_id),
    CONSTRAINT fk_resource FOREIGN KEY (resource_id) REFERENCES resources(id) ON DELETE CASCADE,
    CONSTRAINT fk_tag FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='资源标签关联表';

-- 插入默认分类数据
INSERT INTO categories (name, parent_id, path, sort_order, icon) VALUES
('文档', NULL, '/文档', 1, 'Document'),
('图片', NULL, '/图片', 2, 'Picture'),
('视频', NULL, '/视频', 3, 'Video'),
('音频', NULL, '/音频', 4, 'Headset'),
('其他', NULL, '/其他', 5, 'Folder');

-- 插入默认标签数据
INSERT INTO tags (name, color) VALUES
('重要', '#F56C6C'),
('工作', '#409EFF'),
('学习', '#67C23A'),
('娱乐', '#E6A23C');

-- 创建视图用于统计
CREATE OR REPLACE VIEW resource_stats AS
SELECT
    COUNT(*) as total_count,
    SUM(file_size) as total_size,
    COUNT(DISTINCT category_id) as category_count,
    COUNT(DISTINCT file_type) as type_count
FROM resources
WHERE is_deleted = FALSE;

GRANT ALL PRIVILEGES ON pocket.* TO 'pocket'@'%';
FLUSH PRIVILEGES;
