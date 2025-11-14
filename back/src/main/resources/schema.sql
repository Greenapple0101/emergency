-- 🚀 SCA-BE 발표용 즉시 실행 가능한 DDL.sql
-- ⚠️ FK 전부 제거 버전 (에러 절대 안 나게)
-- 발표용: 서버 켜지고 API만 터지지 않으면 성공

-- ============================================
-- 1. MEMBERS / TEACHERS / STUDENTS / CLASSES
-- ============================================

CREATE TABLE IF NOT EXISTS members (
  member_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  password VARCHAR(255) NOT NULL,
  real_name VARCHAR(50) NOT NULL,
  nickname VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL,
  created_at DATETIME DEFAULT NOW(),
  role ENUM('TEACHER','STUDENT') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS teachers (
  member_id INT PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS students (
  member_id INT PRIMARY KEY,
  class_id INT,
  coral INT DEFAULT 0,
  research_data INT DEFAULT 0,
  correction_factor FLOAT DEFAULT 1.0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS classes (
  class_id INT AUTO_INCREMENT PRIMARY KEY,
  teacher_id INT,
  class_name VARCHAR(100) NOT NULL,
  invite_code VARCHAR(20) NOT NULL,
  created_at DATETIME DEFAULT NOW(),
  grade VARCHAR(20),
  subject VARCHAR(20),
  description VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 2. QUESTS
-- ============================================

CREATE TABLE IF NOT EXISTS quests (
  quest_id INT AUTO_INCREMENT PRIMARY KEY,
  teacher_id INT,
  title VARCHAR(255) NOT NULL,
  teacher_content TEXT,
  created_at DATETIME DEFAULT NOW(),
  reward_coral_default INT DEFAULT 0,
  reward_research_data_default INT DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS quest_assignments (
  assignment_id INT AUTO_INCREMENT PRIMARY KEY,
  quest_id INT,
  student_id INT,
  reward_coral_personal INT DEFAULT 0,
  reward_research_data_personal INT DEFAULT 0,
  status ENUM('ASSIGNED','SUBMITTED','APPROVED','REJECTED','EXPIRED')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS submissions (
  submission_id INT AUTO_INCREMENT PRIMARY KEY,
  assignment_id INT,
  attachment_url VARCHAR(255),
  student_content TEXT,
  submitted_at DATETIME DEFAULT NOW(),
  comment TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 3. GROUP QUESTS
-- ============================================

CREATE TABLE IF NOT EXISTS group_quests (
  group_quest_id INT AUTO_INCREMENT PRIMARY KEY,
  teacher_id INT,
  class_id INT,
  title VARCHAR(255) NOT NULL,
  reward_coral INT DEFAULT 0,
  reward_research_data INT DEFAULT 0,
  end_date DATETIME,
  status VARCHAR(20),
  content TEXT,
  created_at DATETIME DEFAULT NOW(),
  type ENUM('ATTENDANCE','ASSIGNMENT','PARTICIPATION','EXAM','OTHER')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS group_quest_progress (
  progress_id INT AUTO_INCREMENT PRIMARY KEY,
  group_quest_id INT,
  student_id INT,
  is_completed BOOLEAN,
  completed_at DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 4. RAIDS
-- ============================================

CREATE TABLE IF NOT EXISTS raids (
  raid_id INT AUTO_INCREMENT PRIMARY KEY,
  teacher_id INT,
  class_id INT,
  start_date DATETIME,
  end_date DATETIME,
  total_boss_hp BIGINT,
  current_boss_hp BIGINT,
  reward_coral INT DEFAULT 0,
  special_reward_description TEXT,
  status VARCHAR(20),
  difficulty ENUM('LOW','MEDIUM','HIGH'),
  boss_type ENUM('ZELUS_INDUSTRY','KRAKEN')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS contributions (
  contribution_id INT AUTO_INCREMENT PRIMARY KEY,
  raid_id INT,
  student_id INT,
  damage INT DEFAULT 0,
  updated_at DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 5. COLLECTIONS (도감)
-- ============================================

CREATE TABLE IF NOT EXISTS fish (
  fish_id INT AUTO_INCREMENT PRIMARY KEY,
  fish_name VARCHAR(100) NOT NULL,
  grade VARCHAR(20),
  probability FLOAT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS collections (
  collection_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS collection_entries (
  entry_id INT AUTO_INCREMENT PRIMARY KEY,
  collection_id INT,
  fish_id INT,
  fish_count INT DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 6. LOGS
-- ============================================

CREATE TABLE IF NOT EXISTS notice (
  notice_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  notice_type VARCHAR(50),
  student_id INT,
  assigned_id INT,
  group_quest_id INT,
  raid_id INT,
  title VARCHAR(255),
  content VARCHAR(255),
  created_at DATETIME DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS action_logs (
  log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  student_id INT,
  action_type VARCHAR(50),
  assigned_id INT,
  group_quest_id INT,
  raid_id INT,
  change_coral INT,
  change_research INT,
  log_message VARCHAR(255),
  created_at DATETIME DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
