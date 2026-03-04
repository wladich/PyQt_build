# coding: utf-8
import pytest

qt_modules = [
    "Qt",
    "QtCore",
    "QtNetwork",
    "QtGui",
    "QtWidgets",
    "QtQml",
    "QtBluetooth",
    "QtDBus",
    "QtDesigner",
    "QtHelp",
    "QtMultimedia",
    "QtMultimediaWidgets",
    "QtNetworkAuth",
    "QtNfc",
    "QtOpenGL",
    "QtPositioning",
    "QtLocation",
    "QtPrintSupport",
    "QtQuick",
    "QtQuickWidgets",
    "QtRemoteObjects",
    "QtSensors",
    "QtSerialPort",
    "QtSql",
    "QtSvg",
    "QtTest",
    "QtTextToSpeech",
    "QtWebChannel",
    "QtWebKit",
    "QtWebKitWidgets",
    "QtWebSockets",
    "QtX11Extras",
    "QtXml",
    "QtXmlPatterns",
]


@pytest.mark.parametrize("module_name", qt_modules)
def test_import(module_name):
    exec(f"from PyQt5 import {module_name}")

def test_subclasses():
    from PyQt5.QtCore import QObject
    class MyObject(QObject):
        def __init__(self):
            super().__init__()
    obj = MyObject()
    assert isinstance(obj, QObject)

def test_import_qtwidgets():
    from PyQt5 import QtWidgets