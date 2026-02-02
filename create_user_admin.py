import sys
import os

# 确保可以导入 core 包
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from core.database import DatabaseManager
from core.sysuser_model import SysUser
from core.sysuser_interface import UserService

def create_admin():
    print("正在初始化管理员账号...")
    
    try:
        # 1. 初始化数据库管理器
        db_manager = DatabaseManager()
        
        # 2. 初始化用户服务接口
        user_service = UserService(db_manager)
        
        # 3. 检查是否已存在 admin 用户 (可选逻辑，防止重复创建)
        users = user_service.list_users()
        # 这里我们可以根据业务逻辑判断，由于 SysUser 模型暂未定义 username 字段，
        # 且您提供的 SQL 结构中 creator 记录了创建者，我们直接按照指令创建。
        
        # 4. 构造管理员对象
        # 注意：根据您提供的 SQL，sys_user 表包含 password, role, status, creator
        admin_user = SysUser(
            password="hhxtgly123!@#",
            role="管理员",
            status="激活",
            creator="系统初始化"
        )
        
        # 5. 执行创建
        user_uuid = user_service.create_user(admin_user)
        
        if user_uuid:
            print(f"成功创建管理员账号！")
            print(f"用户 UUID: {user_uuid}")
            print(f"角色: {admin_user.role}")
            print(f"初始状态: {admin_user.status}")
        else:
            print("创建失败：未返回 UUID")
            
    except Exception as e:
        print(f"创建过程中出现错误: {e}")

if __name__ == "__main__":
    create_admin()
