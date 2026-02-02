import sys
import os
from PyQt5.QtWidgets import (QWidget, QVBoxLayout, QHBoxLayout, QLabel, 
                             QLineEdit, QPushButton, QFrame, QMessageBox, QApplication, QSystemTrayIcon, QMenu, QAction,
                             QRadioButton, QButtonGroup, QCheckBox)
from PyQt5.QtCore import Qt, pyqtSignal, QSettings
from PyQt5.QtGui import QFont, QColor, QPixmap, QIcon
from core.sysuser_interface import UserService
from core.sysuser_model import SysUser
from core.database import DatabaseManager

class LoginWidget(QWidget):
    # 定义登录成功信号
    login_success = pyqtSignal(object)

    def __init__(self, db_manager):
        super().__init__()
        self._drag_pos = None
        QApplication.setQuitOnLastWindowClosed(False)
        self.db = db_manager
        self.user_service = UserService(db_manager)
        self.user_info = None
        self.tray_icon = None
        self.settings = QSettings("DataManager", "LoginSettings")
        self.init_tray()
        self.initUI()

    def get_resource_path(self, relative_path):
        """统一获取资源路径"""
        base_path = os.path.dirname(os.path.abspath(__file__))
        path = os.path.join(base_path, relative_path)
        if not os.path.exists(path):
            # 备选路径逻辑
            return f":/{relative_path.replace('\\', '/')}"
        return path

    def init_tray(self):
        """初始化系统托盘"""
        self.tray_icon = QSystemTrayIcon(self)
        
        # 设置图标
        icon_path = self.get_resource_path(os.path.join("resources", "icons", "ai.png"))
        self.tray_icon.setIcon(QIcon(icon_path))
            
        # 托盘菜单
        tray_menu = QMenu()
        show_action = QAction("显示窗口", self)
        show_action.triggered.connect(self.show_and_activate)
        quit_action = QAction("退出程序", self)
        quit_action.triggered.connect(QApplication.quit)
        
        tray_menu.addAction(show_action)
        tray_menu.addSeparator()
        tray_menu.addAction(quit_action)
        
        self.tray_icon.setContextMenu(tray_menu)
        self.tray_icon.activated.connect(self.on_tray_icon_activated)
        self.tray_icon.show()

    def on_tray_icon_activated(self, reason):
        if reason == QSystemTrayIcon.Trigger:  # 单击托盘图标
            if self.isVisible():
                self.minimize_to_tray()
            else:
                self.show_and_activate()

    def show_and_activate(self):
        self.show()
        self.setWindowState(self.windowState() & ~Qt.WindowMinimized | Qt.WindowActive)
        self.activateWindow()
        self.raise_()

    # --- 窗口拖拽实现 ---
    def mousePressEvent(self, event):
        if event.button() == Qt.LeftButton:
            self._drag_pos = event.globalPos() - self.pos()
            event.accept()

    def mouseMoveEvent(self, event):
        if Qt.LeftButton and self._drag_pos:
            self.move(event.globalPos() - self._drag_pos)
            event.accept()

    def mouseReleaseEvent(self, event):
        self._drag_pos = None

    def on_logo_clicked(self, event):
        """Logo 点击事件处理"""
        try:
            if event.button() == Qt.LeftButton:
                self.minimize_to_tray()
        except Exception as e:
            print(f"点击 Logo 出错: {e}")

    def minimize_to_tray(self):
        """最小化到托盘"""
        try:
            # 隐藏窗口而不是最小化，因为对于对话框，这更可靠
            self.hide()
            
            if self.tray_icon and self.tray_icon.isVisible():
                self.tray_icon.showMessage(
                    "数据标注管理平台",
                    "程序已最小化到托盘",
                    QSystemTrayIcon.Information,
                    2000
                )
        except Exception as e:
            print(f"最小化到托盘出错: {e}")
            # 如果出错，尝试重新显示
            self.show_and_activate()

    def initUI(self):
        self.setWindowTitle("登录")
        self.setFixedSize(450, 500)
        # 设置无边框和圆角背景
        self.setWindowFlags(Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint)
        self.setAttribute(Qt.WA_TranslucentBackground)

        # 总布局
        main_layout = QVBoxLayout(self)
        main_layout.setContentsMargins(10, 10, 10, 10)

        # 外层背景容器
        bg_frame = QFrame()
        bg_frame.setStyleSheet("""
            QFrame {
                background-color: #f8f9fa;
                border-radius: 20px;
                border: 1px solid #dee2e6;
            }
        """)
        bg_layout = QVBoxLayout(bg_frame)
        bg_layout.setContentsMargins(30, 30, 30, 40)
        bg_layout.setSpacing(10)

        # 1. 顶部 Logo 和 温馨提示 (同一行并居中)
        header_row = QHBoxLayout()
        header_row.setContentsMargins(0, 0, 0, 0)
        header_row.setSpacing(10)
        header_row.addStretch()

        # Logo
        logo_label = QLabel()
        logo_path = self.get_resource_path(os.path.join("resources", "icons", "ai.png"))
        pixmap = QPixmap(logo_path)
        
        if pixmap and not pixmap.isNull():
            logo_label.setPixmap(pixmap.scaled(32, 32, Qt.KeepAspectRatio, Qt.SmoothTransformation))
        
        logo_label.setStyleSheet("border: none; background: transparent;")
        logo_label.setCursor(Qt.PointingHandCursor)
        # 让 Label 响应点击事件
        logo_label.mousePressEvent = self.on_logo_clicked
        header_row.addWidget(logo_label)

        # 温馨提示
        lbl_reminder = QLabel("温馨提示：即时打卡")
        lbl_reminder.setStyleSheet("color: #ff9800; font-size: 14px; font-weight: bold; border: none;")
        header_row.addWidget(lbl_reminder)
        
        header_row.addStretch()
        bg_layout.addLayout(header_row)

        # 2. 大标题
        lbl_title = QLabel("欢迎使用数据标注管理平台")
        lbl_title.setAlignment(Qt.AlignCenter)
        lbl_title.setStyleSheet("""
            color: #2c3e50; 
            font-size: 24px; 
            font-weight: 800; 
            margin-top: 5px; 
            margin-bottom: 15px; 
            border: none;
            letter-spacing: 1px;
        """)
        bg_layout.addWidget(lbl_title)

        # 3. 登录 Card 容器
        card = QFrame()
        card.setStyleSheet("""
            QFrame {
                background-color: white;
                border-radius: 12px;
                border: 1px solid #edf2f7;
            }
        """)
        card_layout = QVBoxLayout(card)
        card_layout.setContentsMargins(25, 30, 25, 30)
        card_layout.setSpacing(18)

        # 输入框通用样式
        input_style = """
            QLineEdit {
                border: 1px solid #e2e8f0;
                border-radius: 6px;
                padding: 10px 15px;
                font-size: 14px;
                background-color: #f7fafc;
                color: #2d3748;
            }
            QLineEdit:focus {
                border: 1.5px solid #00b9b9;
                background-color: #ffffff;
            }
        """

        # 用户名输入
        self.edit_user = QLineEdit()
        self.edit_user.setPlaceholderText("请输入用户名")
        self.edit_user.setFixedHeight(42)
        self.edit_user.setStyleSheet(input_style)
        card_layout.addWidget(self.edit_user)

        # 密码输入
        self.edit_pwd = QLineEdit()
        self.edit_pwd.setPlaceholderText("请输入密码")
        self.edit_pwd.setEchoMode(QLineEdit.Password)
        self.edit_pwd.setFixedHeight(42)
        self.edit_pwd.setStyleSheet(input_style)
        self.edit_pwd.returnPressed.connect(self.handle_login)
        card_layout.addWidget(self.edit_pwd)

        # 记住账号复选框
        checkbox_layout = QHBoxLayout()
        self.cb_remember = QCheckBox("记住账号")
        self.cb_remember.setChecked(False)
        checkbox_style = """
            QCheckBox {
                color: #4a5568;
                font-size: 13px;
                background: transparent;
                border: none;
            }
            QCheckBox::indicator {
                width: 16px;
                height: 16px;
            }
        """
        self.cb_remember.setStyleSheet(checkbox_style)
        checkbox_layout.addWidget(self.cb_remember)
        checkbox_layout.addStretch()
        card_layout.addLayout(checkbox_layout)

        # 角色选择
        role_layout = QHBoxLayout()
        role_layout.setSpacing(15)
        self.role_group = QButtonGroup(self)
        
        self.rb_admin = QRadioButton("管理员")
        self.rb_auditor = QRadioButton("审核员")
        self.rb_general = QRadioButton("一般人员")
        self.rb_general.setChecked(True) # 默认选中一般人员
        
        self.role_group.addButton(self.rb_admin)
        self.role_group.addButton(self.rb_auditor)
        self.role_group.addButton(self.rb_general)
        
        role_layout.addWidget(self.rb_admin)
        role_layout.addWidget(self.rb_auditor)
        role_layout.addWidget(self.rb_general)
        
        role_style = """
            QRadioButton {
                color: #4a5568;
                font-size: 13px;
                background: transparent;
                border: none;
            }
            QRadioButton::indicator {
                width: 16px;
                height: 16px;
            }
        """
        self.rb_admin.setStyleSheet(role_style)
        self.rb_auditor.setStyleSheet(role_style)
        self.rb_general.setStyleSheet(role_style)
        
        card_layout.addLayout(role_layout)

        # 按钮布局
        btn_layout = QVBoxLayout()
        btn_layout.setSpacing(25)
        btn_layout.setContentsMargins(0, 2, 0, 0)

        # 登录按钮
        btn_login = QPushButton("登 录")
        btn_login.setFixedHeight(45)
        btn_login.setCursor(Qt.PointingHandCursor)
        btn_login.setStyleSheet("""
            QPushButton {
                background-color: #00b9b9;
                color: white;
                border-radius: 6px;
                font-size: 16px;
                font-weight: bold;
                border: none;
            }
            QPushButton:hover { background-color: #00a3a3; }
            QPushButton:pressed { background-color: #008f8f; }
        """)
        btn_login.clicked.connect(self.handle_login)
        btn_layout.addWidget(btn_login)

        # 取消按钮
        btn_cancel = QPushButton("取 消")
        btn_cancel.setFixedHeight(38)
        btn_cancel.setCursor(Qt.PointingHandCursor)
        btn_cancel.setStyleSheet("""
            QPushButton {
                background-color: #f1f3f5;
                color: #495057;
                border: 1px solid #dee2e6;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 500;
            }
            QPushButton:hover { 
                background-color: #e9ecef;
                color: #212529;
            }
            QPushButton:pressed {
                background-color: #dee2e6;
            }
        """)
        btn_cancel.clicked.connect(self.on_cancel_clicked)
        btn_layout.addWidget(btn_cancel)

        card_layout.addLayout(btn_layout)
        bg_layout.addWidget(card)
        main_layout.addWidget(bg_frame)
        
        saved_username = self.settings.value("username", "", type=str)
        remember = self.settings.value("remember", False, type=bool)
        if saved_username and remember:
            self.edit_user.setText(saved_username)
            self.cb_remember.setChecked(True)

    def on_config_click(self):
        """打开数据库配置对话框"""
        dialog = DbConfigDialog(self)
        dialog.exec_()

    def on_config_click(self):
        """打开数据库配置对话框"""
        dialog = DbConfigDialog(self)
        dialog.exec_()

    def on_cancel_clicked(self):
        """处理取消按钮点击事件"""
        # 检查主窗口是否存在且可见
        app = QApplication.instance()
        if hasattr(app, 'main_window') and app.main_window and app.main_window.isVisible():
            # 如果主程序正在运行，取消按钮只需隐藏登录窗口
            self.hide()
        else:
            # 如果主程序未运行（初始登录阶段），取消按钮退出程序
            QApplication.quit()

    def handle_login(self):
        user_name = self.edit_user.text().strip()
        password = self.edit_pwd.text().strip()

        if not user_name or not password:
            QMessageBox.warning(self, "提示", "请输入用户名和密码")
            return

        # 显示等待光标
        QApplication.setOverrideCursor(Qt.WaitCursor)
        try:
            # 获取选中的角色
            selected_role = "一般人员"
            if self.rb_admin.isChecked(): selected_role = "管理员"
            elif self.rb_auditor.isChecked(): selected_role = "审核员"

            # 1. 查询用户
            user = self.user_service.get_user_by_user_name(user_name)
            if not user:
                QMessageBox.critical(self, "登录失败", "用户名不存在，请重新输入")
                return

            # 2. 状态检查
            if user.status != "激活":
                QMessageBox.warning(self, "权限提示", f"您的账号当前处于【{user.status}】状态，无法登录")
                return

            # 3. 验证密码
            if SysUser.verify_password(password, user.password):
                # 4. 验证角色权限
                user_roles = user.role.split(',') if user.role else []
                if selected_role not in user_roles:
                    QMessageBox.warning(self, "角色错误", f"您没有【{selected_role}】角色的访问权限。\n您的实际角色为: {user.role}")
                    return

                user.role = selected_role
                self.user_info = user
                
                if self.cb_remember.isChecked():
                    self.settings.setValue("username", user_name)
                    self.settings.setValue("remember", True)
                else:
                    self.settings.remove("username")
                    self.settings.setValue("remember", False)
                
                self.login_success.emit(user)
                self.hide()
            else:
                QMessageBox.critical(self, "登录失败", "密码错误，请检查后重试")
                self.edit_pwd.clear()
                self.edit_pwd.setFocus()
                
        except Exception as e:
            QMessageBox.critical(self, "系统错误", f"登录过程中发生异常:\n{str(e)}")
        finally:
            # 恢复正常光标
            QApplication.restoreOverrideCursor()

    def closeEvent(self, event):
        # 截获关闭事件，执行最小化到托盘的操作
        event.ignore()
        self.minimize_to_tray()

if __name__ == "__main__":
    app = QApplication(sys.argv)
    # 必须设置，否则隐藏窗口时程序会直接结束
    app.setQuitOnLastWindowClosed(False)
    
    db = DatabaseManager()
    login = LoginWidget(db)
    login.show() # 使用 show 而不是 exec_
    
    sys.exit(app.exec_())
