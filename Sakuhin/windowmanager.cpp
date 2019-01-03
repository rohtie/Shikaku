#include "windowmanager.h"

WindowManager::WindowManager(QObject *parent) : QObject(parent) {

}

void WindowManager::initialize(const QSurfaceFormat &format, BackEnd* backend, ShaderManager* shadermanager) {
    this->backend = backend;
    this->shadermanager = shadermanager;

    Window* previewWindow = new Window();

    previewWindow->initialize(backend, shadermanager, false, true);
    previewWindow->setFormat(format);
    previewWindow->resize(QSize(256, 256));
    previewWindow->setPosition(0, 400);
    previewWindow->setFlag(Qt::FramelessWindowHint);
    previewWindow->show();

    masterWindow = new Window();
    masterWindow->initialize(backend, shadermanager, true, false);
    masterWindow->setFormat(format);
    masterWindow->resize(QSize(756, 756));
    masterWindow->setPosition(256, 0);
    masterWindow->setFlag(Qt::FramelessWindowHint);
    masterWindow->show();

    windows.append(masterWindow);
    windows.append(previewWindow);

    emit windowsChanged();
}
