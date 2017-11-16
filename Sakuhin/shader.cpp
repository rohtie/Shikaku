#include <QString>
#include <QFile>

#include "shader.h"
#include "channel.h"

Shader::Shader(int id, QString thumbnail, QString sessionpath) {
    this->id = id;
    this->thumbnail = thumbnail;

    program.addShaderFromSourceFile(QOpenGLShader::Vertex, ":/vertex.glsl");

    // TODO: Find out if it is better to only compile the session glsl and link
    // it together with header and footer files, instead of concatenating them
    QFile session(sessionpath);
    session.open(QIODevice::ReadOnly);
    program.addShaderFromSourceCode(QOpenGLShader::Fragment, build(session.readAll()));
    program.link();

    program.bind();
        program.setUniformValue("channel0", 0);
        program.setUniformValue("channel1", 1);
        program.setUniformValue("channel2", 2);
        program.setUniformValue("channel3", 3);
        program.setUniformValue("channel4", 4);
    program.release();

    for (int i = 0; i < 5; i++) {
        channels.append(new Channel(i));
    }
    emit channelsChanged();

    fbo = mainFbo;
}

void Shader::setPreview(bool isPreview) {
    if (isPreview == this->isPreview) {
        return;
    }

    this->isPreview = isPreview;

    if (isPreview) {
        fbo = previewFbo;
    }
    else {
        fbo = mainFbo;
    }
}

QString Shader::build(QByteArray shaderCode) {
    // TODO: Use QTextStream and cache static files
    QFile header(":/header.glsl");
    header.open(QIODevice::ReadOnly);

    QFile footer(":/footer.glsl");
    footer.open(QIODevice::ReadOnly);

    return (
        QString(header.readAll()) +
        QString(shaderCode) +
        QString(footer.readAll())
    );
}

bool Shader::recompile(QByteArray shaderCode) {
    QOpenGLShader* oldShader = program.shaders()[1];
    program.removeShader(oldShader);

    QString code = build(shaderCode);

    if (!program.addShaderFromSourceCode(QOpenGLShader::Fragment, code)) {
        program.addShader(oldShader);
        program.link();

        qDebug() << program.log();

        return false;
    }

    program.link();
    return true;
}

void Shader::bind() {
    program.bind();

    for (int i = 0; i < 5; i++) {
        Channel* channel = (Channel*) channels[i];
        channel->bind();
    }
}

void Shader::release() {
    program.release();
}

void Shader::setResolution(int width, int height) {
    if (fbo[pingPongIndex] == nullptr || (width != this->width() || height != this->height())) {
        fbo[pingPongIndex] = new QOpenGLFramebufferObject(width, height);
    }
}

void Shader::setTime(double time) {
    this->time = time;
}

void Shader::setUniformValues() {
    program.setUniformValue("resolution", width(), height());
    program.setUniformValue("time", (GLfloat) time);

    // TODO: Fix sliders
    // shader.setUniformValueArray("slider", (GLfloat*) backend->getSliders(), 4, 1);
}

int Shader::width() {
    return fbo[pingPongIndex]->width();
}

int Shader::height() {
    return fbo[pingPongIndex]->height();
}

QOpenGLFramebufferObject* Shader::currentFbo() {
    return fbo[pingPongIndex];
}

void Shader::updatePingPong() {
    previousPingPongIndex = pingPongIndex;
    pingPongIndex = (pingPongIndex + 1) % 2;
}

int Shader::currentFrame() {
    if (fbo[pingPongIndex] == nullptr) {
        return 0;
    }
    else {
        return fbo[pingPongIndex]->texture();
    }
}

int Shader::lastFrame() {
    if (fbo[previousPingPongIndex] == nullptr) {
        return 0;
    }
    else {
        return fbo[previousPingPongIndex]->texture();
    }
}
