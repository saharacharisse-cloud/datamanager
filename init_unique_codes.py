import sys
import os

# 将项目根目录添加到 python 路径，确保能导入 core 模块
project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if project_root not in sys.path:
    sys.path.append(project_root)

from core.database import DatabaseManager
from core.uniquecode_model import UniqueCode
from core.uniquecode_interface import UniqueCodeService

def init_data():
    db = DatabaseManager()
    
    # 1. 确保表已创建
    conn = db.get_connection()
    try:
        with conn:
            with conn.cursor() as cursor:
                print("正在检查/创建 unique_code 表...")
                cursor.execute(UniqueCode.get_create_table_sql())
    finally:
        conn.close()

    # 2. 批量插入 100 条数据
    service = UniqueCodeService(db)
    print("正在生成 100 条唯一码数据 (hhkj1 ~ hhkj30)...")
    
    success_count = 0
    fail_count = 0
    
    for i in range(1, 101):
        code_name = f"hhkj{i}"
        code_obj = UniqueCode(
            code_name=code_name,
            status="激活",
            modifier="admin"  # 默认修改者
        )
        
        if service.create_code(code_obj):
            success_count += 1
        else:
            # 可能是因为 code_name 已存在（UNIQUE 约束）
            fail_count += 1
            
    print(f"\n初始化完成！")
    print(f"- 成功插入: {success_count} 条")
    print(f"- 失败/跳过: {fail_count} 条 (可能已存在)")

if __name__ == "__main__":
    init_data()
