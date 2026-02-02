import sys
import os
from login import LoginWidget
from PyQt5.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout, 
                             QHBoxLayout, QPushButton, QStackedWidget, QLabel, 
                             QFrame, QStatusBar, QToolButton, QMessageBox,
                             QDialog, QLineEdit, QFormLayout, QTabWidget, QScrollArea)
from PyQt5.QtCore import Qt, QSize, QTimer
from PyQt5.QtGui import QFont, QIcon, QPixmap

# 更新导入路径
from core.database import DatabaseManager
from core.config import Config
from core.db_config_dialog import DbConfigDialog
from pages.original_data_page import OriginalDataPage
from pages.transfer_data_page import TransferDataPage
from pages.frame_extraction import FrameExtractionPage
from pages.task_allocation import TaskAllocationPage
from pages.screening import ScreeningPage
from pages.user_manage import UserManagePage
from pages.my_task import MyTaskPage

class MainWindow(QMainWindow):
    def __init__(self, user_info=None):
        super().__init__()
        self.db = DatabaseManager()
        # 从登录信息中获取真实角色和信息
        self.current_user = user_info
        self.user_role = user_info.role if user_info else "管理员" 
        self.restarting = False
        
        # 隐藏右上角关闭按钮
        self.setWindowFlags(self.windowFlags() & ~Qt.WindowCloseButtonHint)
        
        # --- 自动退登逻辑 ---
        self.idle_timer = QTimer(self)
        self.idle_timer.setInterval(3600000)  # 3600秒 = 3600000毫秒
        self.idle_timer.timeout.connect(self.auto_logout)
        self.idle_timer.start()
        
        # 为整个应用程序安装事件过滤器以监控操作
        QApplication.instance().installEventFilter(self)

        self.initUI()
        self.showMaximized()
        
        # 初始加载第一个页面 (在窗口最大化显示后延迟触发，彻底解决首屏渲染空白问题)
        if hasattr(self, 'buttons') and self.buttons:
            #buttons:
            # 使用 lambda 延迟模拟点击第一个按钮，确保所有 UI 信号和状态同步
            QTimer.singleShot(300, lambda: self.buttons[0].click() if self.buttons else None)
    
    def initUI(self):
        self.setWindowTitle('标注数据管理平台')

        # 主窗口中央部件
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        
        # 全局垂直布局 (顶部标题栏 + 下方内容区)
        global_layout = QVBoxLayout(central_widget)
        global_layout.setContentsMargins(0, 0, 0, 0)
        global_layout.setSpacing(0)

        # --- 顶部自定义标题栏 ---
        header_bar = QFrame()
        header_bar.setFixedHeight(50)
        header_bar.setStyleSheet("""
            QFrame {
                background-color: #ffffff;
                border-bottom: 1px solid #dee2e6;
            }
        """)
        header_layout = QHBoxLayout(header_bar)
        header_layout.setContentsMargins(15, 0, 15, 0)
        header_layout.setSpacing(10)

        # 顶部图标 (使用 title.png)
        base_dir = os.path.dirname(os.path.abspath(__file__))
        icon_path = os.path.join(base_dir, "resources", "icons", "title.png")
        if os.path.exists(icon_path):
            logo_label = QLabel()
            logo_label.setPixmap(QIcon(icon_path).pixmap(QSize(28, 28)))
            header_layout.addWidget(logo_label)
            # 同时设置窗口系统图标
            self.setWindowIcon(QIcon(icon_path))

        # 下方内容布局
        content_layout = QHBoxLayout()
        content_layout.setSpacing(0)
        global_layout.addLayout(content_layout)

        # --- 左侧按钮区 ---
        left_panel = QFrame()
        left_panel.setFixedWidth(100)
        left_panel.setStyleSheet("""
            QFrame {
                background-color: #f8f9fa;
                border-right: 1px solid #dee2e6;
            }
            QToolButton {
                border: none;
                padding: 10px 5px;
                text-align: center;
                font-size: 12px;
                background-color: transparent;
                border-radius: 8px;
                margin: 5px 10px;
                width: 80px;
            }
            QToolButton:hover {
                background-color: #e9ecef;
            }
            QToolButton:checked {
                background-color: #0078d7;
                color: white;
                font-weight: bold;
            }
        """)
        
        left_layout = QVBoxLayout(left_panel)
        left_layout.setContentsMargins(0, 10, 0, 10)
        left_layout.setSpacing(2)

        base_dir = os.path.dirname(os.path.abspath(__file__))
        icon_dir = os.path.join(base_dir, "resources", "icons")

        self.buttons = []
        menu_items = [
            ("我的", "my_task"),
            ("原始数据", "original"),
            ("抽帧", "frame_extraction"),
            ("筛图分类", "screening"),
            ("任务分工", "labeling"),  
            ("数据转移", "transfer"),         
            ("人员管理", "user_manage"),
            ("训练样本", "train_sample"),            
            ("模型归档", "archiving"),
        ]

        # 权限过滤
        user_roles = self.user_role.split(',') if self.user_role else []
        
        if "管理员" in user_roles:
            # 管理员拥有所有权限
            pass
        elif "审核员" in user_roles:
            # 审核员拥有人员管理权限(仅查看任务细节)
            pass
        elif "一般人员" in user_roles:
            # 一般人员只有部分权限，增加人员管理权限(仅查看任务细节)
            allowed_items = ["抽帧", "筛图分类", "数据转移", "训练样本", "我的", "模型归档", "人员管理"]
            menu_items = [item for item in menu_items if item[0] in allowed_items]

        for text, key in menu_items:
            btn = QToolButton()
            btn.setText(text)
            btn.setCheckable(True)
            btn.setAutoExclusive(True)
            btn.setToolButtonStyle(Qt.ToolButtonTextUnderIcon)
            
            icon_path = os.path.join(icon_dir, f"{key}.png")
            if os.path.exists(icon_path):
                btn.setIcon(QIcon(icon_path))
                btn.setIconSize(QSize(32, 32))
            else:
                btn.setIconSize(QSize(32, 32)) 
            
            btn.clicked.connect(self.on_menu_click)
            left_layout.addWidget(btn, 0, Qt.AlignCenter)
            self.buttons.append(btn)

        left_layout.addStretch(1)

        # --- 帮助按钮 (位于底部) ---
        self.help_btn = QToolButton()
        self.help_btn.setText("帮助")
        self.help_btn.setToolButtonStyle(Qt.ToolButtonTextUnderIcon)
        help_icon_path = os.path.join(icon_dir, "hh.png")
        if os.path.exists(help_icon_path):
            self.help_btn.setIcon(QIcon(help_icon_path))
            self.help_btn.setIconSize(QSize(50, 32))
        self.help_btn.clicked.connect(self.on_help_click)
        left_layout.addWidget(self.help_btn, 0, Qt.AlignCenter)

        content_layout.addWidget(left_panel)

        # --- 右侧主显示区 ---
        self.stack = QStackedWidget()
        content_layout.addWidget(self.stack)

        # 缓存已创建的页面
        self.pages = {}
        self.menu_keys = [key for _, key in menu_items]
        
        # 为每个菜单项添加一个占位符
        for _ in menu_items:
            self.stack.addWidget(QWidget())

        if self.buttons:
            self.buttons[0].setChecked(True)

        self.statusBar = QStatusBar()
        self.setStatusBar(self.statusBar)
        self.statusBar.showMessage("准备就绪")

        # --- 状态栏右下角用户信息 ---
        user_widget = QWidget()
        user_layout = QHBoxLayout(user_widget)
        user_layout.setContentsMargins(5, 0, 5, 0)
        user_layout.setSpacing(8)

        # 使用方法按钮
        self.usage_btn = QToolButton()
        self.usage_btn.setText("使用方法")
        self.usage_btn.setToolButtonStyle(Qt.ToolButtonTextOnly)
        self.usage_btn.setStyleSheet("""
            QToolButton { border: none; color: #666; padding: 0 5px; }
            QToolButton:hover { color: #0078d7; font-weight: bold; }
        """)
        self.usage_btn.setCursor(Qt.PointingHandCursor)
        self.usage_btn.clicked.connect(self.show_usage_guide)
        user_layout.addWidget(self.usage_btn)

        # 用户图标 (admin.png)
        user_icon_label = QLabel()
        admin_icon_path = os.path.join(icon_dir, "admin.png")
        if os.path.exists(admin_icon_path):
            user_icon_label.setPixmap(QIcon(admin_icon_path).pixmap(18, 18))
        user_layout.addWidget(user_icon_label)

        # 用户名 (full_name)
        display_name = self.current_user.full_name if self.current_user and self.current_user.full_name else "未知用户"
        self.user_info_label = QLabel(display_name)
        self.user_info_label.setStyleSheet("font-weight: bold; color: #444; margin-right: 5px;")
        user_layout.addWidget(self.user_info_label)

        # 退出程序按钮 (out.png)
        self.logout_btn = QToolButton()
        out_icon_path = os.path.join(icon_dir, "out.png")
        if os.path.exists(out_icon_path):
            self.logout_btn.setIcon(QIcon(out_icon_path))
            self.logout_btn.setIconSize(QSize(18, 18))
        self.logout_btn.setToolTip("退出系统")
        self.logout_btn.setStyleSheet("""
            QToolButton { border: none; background: transparent; padding: 2px; }
            QToolButton:hover { background-color: #fcebea; border-radius: 4px; }
        """)
        self.logout_btn.clicked.connect(self.on_logout)
        user_layout.addWidget(self.logout_btn)

        self.statusBar.addPermanentWidget(user_widget)

    def show_usage_guide(self):
        """显示当前页面的使用方法"""
        current_index = self.stack.currentIndex()
        page_name = "未知页面"
        
        # 尝试从 buttons 获取当前页面名称
        if hasattr(self, 'buttons') and 0 <= current_index < len(self.buttons):
            page_name = self.buttons[current_index].text()
            
        # 查找对应的教程图片
        base_dir = os.path.dirname(os.path.abspath(__file__))
        icon_dir = os.path.join(base_dir, "resources", "icons")
        image_path = os.path.join(icon_dir, f"{page_name}.png")
        
        if os.path.exists(image_path):
            self._show_image_dialog(page_name, image_path)
        else:
            QMessageBox.information(self, f"{page_name} - 使用方法", 
                                  f"这里是【{page_name}】模块的使用说明。\n\n暂无图文教程，功能持续更新中！")

    def _show_image_dialog(self, title, image_path):
        """显示带有图片的自定义弹窗"""
        dialog = QDialog(self)
        dialog.setWindowTitle(f"{title} - 使用教程")
        
        # 加载图片
        pixmap = QPixmap(image_path)
        
        # 获取屏幕尺寸
        screen = QApplication.primaryScreen().availableGeometry()
        
        # 计算合适的窗口大小 (图片的宽+边距，高+边距，但不超过屏幕的 90%)
        # 预留一些边距给滚动条和按钮
        target_width = min(pixmap.width() + 60, int(screen.width() * 0.9))
        target_height = min(pixmap.height() + 100, int(screen.height() * 0.9))
        
        # 确保不小于一定的最小值，防止图片太小时窗口太小
        target_width = max(target_width, 800)
        target_height = max(target_height, 600)
        
        dialog.resize(target_width, target_height)
        
        layout = QVBoxLayout(dialog)
        
        # 滚动区域
        scroll = QScrollArea()
        scroll.setWidgetResizable(True)
        scroll.setStyleSheet("background-color: white; border: none;")
        
        # 图片容器
        content_widget = QWidget()
        content_layout = QVBoxLayout(content_widget)
        
        image_label = QLabel()
        
        # 这里保持原大，让滚动条工作
        image_label.setPixmap(pixmap)
        image_label.setAlignment(Qt.AlignCenter)
        
        content_layout.addWidget(image_label)
        scroll.setWidget(content_widget)
        
        layout.addWidget(scroll)
        
        # 关闭按钮
        btn_close = QPushButton("关闭")
        btn_close.setFixedWidth(100)
        btn_close.clicked.connect(dialog.accept)
        
        # 底部按钮布局
        btn_layout = QHBoxLayout()
        btn_layout.addStretch()
        btn_layout.addWidget(btn_close)
        btn_layout.addStretch()
        
        layout.addLayout(btn_layout)
        
        dialog.exec_()

    def on_logout(self):
        reply = QMessageBox.question(self, '确认退出', '确定要退出并关闭系统吗？',
                                    QMessageBox.Yes | QMessageBox.No, QMessageBox.No)
        if reply == QMessageBox.Yes:
            # 直接退出整个应用程序
            QApplication.quit()

    def auto_logout(self):
        """超时自动退出"""
        self.idle_timer.stop()
        # 超时直接退出程序
        QApplication.quit()
        # 可以在重新登录时给出一个提示
        print("由于长时间未操作，系统已自动退登。")

    def eventFilter(self, obj, event):
        """监控全局事件，如果有操作则重置定时器"""
        if event.type() in [event.MouseMove, event.MouseButtonPress, event.KeyPress, event.Wheel]:
            if hasattr(self, 'idle_timer') and self.idle_timer.isActive():
                self.idle_timer.start()  # 重新开始计时
        return super().eventFilter(obj, event)

    def closeEvent(self, event):
        """重写关闭事件，拦截系统关闭按钮"""
        # 统一使用退出逻辑
        reply = QMessageBox.question(self, '确认退出', '确定要退出并关闭系统吗？',
                                    QMessageBox.Yes | QMessageBox.No, QMessageBox.No)
        if reply == QMessageBox.Yes:
            event.accept()
            QApplication.quit()
        else:
            event.ignore()

    def switch_to_page(self, key, tab_index=None):
        """跳转到指定页面并可选设置标签页"""
        if key in self.menu_keys:
            index = self.menu_keys.index(key)
            # 模拟点击按钮
            self.buttons[index].setChecked(True)
            self._perform_switch(index, key)
            
            if tab_index is not None:
                page = self.pages.get(key)
                if page:
                    # 优先使用显式定义的 self.tabs，否则递归查找第一个 QTabWidget
                    tabs = getattr(page, 'tabs', None)
                    if not isinstance(tabs, QTabWidget):
                        tabs = page.findChild(QTabWidget)
                        
                    if tabs and 0 <= tab_index < tabs.count():
                        tabs.setCurrentIndex(tab_index)

    def on_menu_click(self):
        sender = self.sender()
        if not sender:
            # 初始加载
            if not self.buttons: return
            index = 0
        else:
            # 增加安全检查，确保 sender 确实在 buttons 列表中
            try:
                index = self.buttons.index(sender)
            except ValueError:
                # 如果 sender 不在 buttons 中（例如来自登录窗口的信号），不执行切换
                return
        
        key = self.menu_keys[index]
        self._perform_switch(index, key)

    def _perform_switch(self, index, key):
        """执行实际的页面切换逻辑"""
        # 检查页面是否已创建
        if key not in self.pages:
            self.statusBar.showMessage(f"正在加载页面...")
            QApplication.processEvents() # 刷新UI显示加载状态
            
            if key == "original":
                page = OriginalDataPage(self.db, user_info=self.current_user)
            elif key == "transfer":
                page = TransferDataPage(self.db, user_info=self.current_user)
            elif key == "frame_extraction":
                page = FrameExtractionPage(self.db, user_info=self.current_user)
            elif key == "screening":
                page = ScreeningPage(self.db, user_info=self.current_user)   
            elif key == "user_manage":
                page = UserManagePage(self.db, user_info=self.current_user)
            elif key == "labeling":
                page = TaskAllocationPage(self.db, user_info=self.current_user)
            elif key == "my_task":
                page = MyTaskPage(self.db, user_info=self.current_user)
            else:
                page = QWidget()
                layout = QVBoxLayout(page)
                label = QLabel(f"功能正在开发中......☺")
                label.setAlignment(Qt.AlignCenter)
                label.setFont(QFont('Arial', 20))
                layout.addWidget(label)
            
            self.pages[key] = page
            # 替换占位符
            old_widget = self.stack.widget(index)
            self.stack.removeWidget(old_widget)
            self.stack.insertWidget(index, page)

        # 切换到对应页面
        self.stack.setCurrentIndex(index)
        
        # 刷新页面数据
        current_page = self.pages.get(key)
        if current_page:
            # 强制刷新布局和显示
            current_page.show()
            current_page.raise_()
            if hasattr(current_page, 'refresh_data'):
                current_page.refresh_data()
            # 处理 QStackedWidget 可能的刷新延迟
            QApplication.processEvents()
            
        # 使用按钮文本更新状态栏
        if 0 <= index < len(self.buttons):
            btn_text = self.buttons[index].text()
            self.statusBar.showMessage(f"当前视图: {btn_text}")

    def on_help_click(self):
        dialog = DbConfigDialog(self)
        dialog.exec_()

from PyQt5.QtWidgets import QMessageBox

if __name__ == '__main__':
    # app = QApplication(sys.argv)
    # app.setStyleSheet("QMainWindow { background-color: white; }")
    # window = MainWindow()
    # window.show()
    # sys.exit(app.exec_())
    app = QApplication(sys.argv)
    app.setStyleSheet("QMainWindow { background-color: white; }")
    
    # 1. 初始化数据库
    db_manager = DatabaseManager()
    
    # 2. 登录与主程序启动逻辑
    def start_main_window(user_info):
        window = MainWindow(user_info=user_info)
        window.show()
        # 记录当前窗口，防止被回收
        app.main_window = window

    # 创建登录窗口
    login = LoginWidget(db_manager)
    # 绑定登录成功信号
    login.login_success.connect(start_main_window)
    login.show()
    
    sys.exit(app.exec_())
