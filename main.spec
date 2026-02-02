# -*- mode: python ; coding: utf-8 -*-

block_cipher = None

a = Analysis(
    ['main.py'],
    pathex=['d:/AI/datamanager'],
    binaries=[],
    datas=[
        ('resources', 'resources'),
    ],
    hiddenimports=[
        'psycopg2',
        'psycopg2.pool',
        'requests',
        'paho.mqtt.client',
        'openpyxl',
        'PyQt5.QtCore',
        'PyQt5.QtGui',
        'PyQt5.QtWidgets',
        'core.database',
        'core.config',
        'core.workdir_interface',
        'core.sysuser_interface',
        'pages.original_data_page',
        'pages.transfer_data_page',
        'pages.frame_extraction',
        'pages.task_allocation',
        'pages.screening',
        'pages.user_manage',
        'pages.my_task',
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)
pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='数据管理平台',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon='resources/icons/title.png'
)
