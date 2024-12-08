-- Select * FROM Debuglog;
use selection;
-- TRUNCATE TABLE DebugLog;
TRUNCATE TABLE Plan;
Call GeneratePlanWithTopoSort('12345678', 1, 1);
SELECT *
FROM Plan
ORDER BY 
    CASE 
        WHEN semester LIKE 'Fall%' THEN 1
        WHEN semester LIKE 'Spring%' THEN 2
    END,
    CAST(SUBSTRING(semester, 5) AS UNSIGNED), -- 按年份排序
    CASE 
        WHEN session_id = '7W1' THEN 1
        WHEN session_id = '7W2' THEN 2
    END;

