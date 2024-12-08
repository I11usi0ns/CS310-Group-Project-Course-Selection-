CREATE TABLE DebugLog (
    log_id INT AUTO_INCREMENT PRIMARY KEY, -- 日志编号
    log_message TEXT,                     -- 日志信息
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- 时间戳
);