USE templates_db;

CREATE TABLE IF NOT EXISTS admins (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS templates (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  description TEXT,
  article TEXT,
  preview_images TEXT,
  download_url VARCHAR(255) NOT NULL,
  tags VARCHAR(255),
  source_image VARCHAR(255),
  canvas_width INT DEFAULT 800,
  canvas_height INT DEFAULT 600,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS editable_regions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  template_id INT NOT NULL,
  region_type ENUM('text', 'color', 'qrcode') NOT NULL,
  region_name VARCHAR(50) NOT NULL,
  config JSON NOT NULL,
  is_editable TINYINT(1) DEFAULT 1,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (template_id) REFERENCES templates(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  template_id INT NOT NULL,
  custom_config JSON NOT NULL,
  status ENUM('pending', 'paid', 'expired') DEFAULT 'pending',
  preview_token VARCHAR(64),
  download_token VARCHAR(64),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMP NULL,
  FOREIGN KEY (template_id) REFERENCES templates(id) ON DELETE CASCADE,
  INDEX idx_preview_token (preview_token),
  INDEX idx_download_token (download_token)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO templates (title, description, article, preview_images, download_url, tags, source_image, canvas_width, canvas_height)
VALUES
('极简企业官网', '适合科技类公司的响应式企业官网模板，含产品、案例与联系表单。', '这是一套现代化的企业官网模板，支持移动端自适应，包含首页、产品、案例与联系我们板块。', '["https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=800&q=80"]', 'https://example.com/downloads/company-template.zip', '企业,响应式,科技', NULL, 800, 600),
('作品集展示', '为设计师或自由职业者打造的作品集模板，配色大胆，支持多图预览。', '模板包含首页、作品列表、作品详情与联系页面，可快速替换图片与文案。', '["https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1506765515384-028b60a970df?auto=format&fit=crop&w=800&q=80"]', 'https://example.com/downloads/portfolio-template.zip', '作品集,创意,展示', NULL, 800, 600),
('2024春季促销海报', '可在线编辑的促销海报模板，支持修改标题、主色和二维码位置。', '这是一张高质量的促销海报模板，作者已开放标题文字、主题色和二维码位置的编辑权限。用户可在浏览器内实时预览效果，购买后下载高清无水印原图。', '["https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?auto=format&fit=crop&w=800&q=80"]', 'https://example.com/downloads/spring-poster.zip', '海报,促销,可编辑', 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?auto=format&fit=crop&w=1200&q=90', 800, 1200);

INSERT INTO editable_regions (template_id, region_type, region_name, config, is_editable, sort_order)
VALUES
(3, 'text', '主标题', '{"x": 400, "y": 200, "fontSize": 48, "fontFamily": "Arial, sans-serif", "fontWeight": "bold", "color": "#ffffff", "textAlign": "center", "defaultValue": "春季大促销", "maxLength": 20}', 1, 1),
(3, 'text', '副标题', '{"x": 400, "y": 280, "fontSize": 24, "fontFamily": "Arial, sans-serif", "fontWeight": "normal", "color": "#ffe4e1", "textAlign": "center", "defaultValue": "全场5折起 · 限时抢购", "maxLength": 30}', 1, 2),
(3, 'color', '主题色', '{"defaultValue": "#ff6b6b", "targetElements": ["shape_overlay", "button_bg"]}', 1, 3),
(3, 'qrcode', '二维码', '{"x": 650, "y": 1050, "size": 100, "defaultValue": "https://example.com/promo", "draggable": true, "minX": 50, "maxX": 750, "minY": 900, "maxY": 1150}', 1, 4),
(3, 'text', '底部版权', '{"x": 400, "y": 1150, "fontSize": 14, "fontFamily": "Arial, sans-serif", "fontWeight": "normal", "color": "#ffffff", "textAlign": "center", "defaultValue": "© 2024 TemplateHub 版权所有", "maxLength": 30, "is_editable": 0}', 0, 5);
