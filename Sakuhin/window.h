#ifndef WINDOW_H
#define WINDOW_H

#include <QOpenGLWindow>
#include <QOpenGLFunctions>
#include <QOpenGLBuffer>
#include <QOpenGLVertexArrayObject>
#include <QOpenGLShaderProgram>
#include <QFileSystemWatcher>
#include <QDateTime>
#include <QElapsedTimer>
#include <QOpenGLTexture>
#include <QVector>
#include <QOpenGLDebugMessage>
#include <QMatrix4x4>

#include "backend.h"
#include "shadermanager.h"

class QOpenGLShaderProgram;
class Window : public QOpenGLWindow,
               protected QOpenGLFunctions {
    Q_OBJECT

    Q_PROPERTY(bool isMaster MEMBER isMaster NOTIFY isMasterChanged)
    Q_PROPERTY(bool isPreview MEMBER isPreview NOTIFY isPreviewChanged)
    Q_PROPERTY(bool isProjectionMapping MEMBER isProjectionMapping NOTIFY isProjectionMappingChanged)
    Q_PROPERTY(bool isVertical MEMBER isVertical NOTIFY isVerticalChanged)
    Q_PROPERTY(float distanceFromObject MEMBER distanceFromObject NOTIFY distanceFromObjectChanged)
    Q_PROPERTY(float projectorHeight MEMBER projectorHeight NOTIFY projectorHeightChanged)
    Q_PROPERTY(float objectHeightTarget MEMBER objectHeightTarget NOTIFY objectHeightTargetChanged)
    Q_PROPERTY(float fieldOfView MEMBER fieldOfView NOTIFY fieldOfViewChanged)

    public:
        explicit Window();

        void setupMapping(float distanceFromObject, float projectorHeight, float fieldOfView, bool isVertical, const QString &modelPath);
        void initialize(BackEnd* backend, ShaderManager* shadermanager, bool isMaster, bool isPreview);

        void initializeGL();

        void updateCalibrationPoints();
        void updateMesh();
        void drawRectangle();
        void drawBillboard(float x, float y);
        void render(Shader* shader);
        void renderScreen(Shader* shader);
        void paintGL();

        void keyPressEvent(QKeyEvent* event);

        QVector2D* normalizeCoordinates(float x, float y);
        void mousePressEvent(QMouseEvent* event);
        void mouseMoveEvent(QMouseEvent* event);

        void updatePerformanceInformation();
        void handleLoggedMessage(const QOpenGLDebugMessage &debugMessage);

        void resizeGL(int width, int height);

    public slots:
        void updateProjectionMapping();
        void updateProjectionMappingSettings();
        void updateMVPmatrix();

    signals:
        void isMasterChanged();
        void isPreviewChanged();
        void isProjectionMappingChanged();
        void isVerticalChanged();
        void distanceFromObjectChanged();
        void projectorHeightChanged();
        void objectHeightTargetChanged();
        void fieldOfViewChanged();

    private:
        bool isMaster = false;
        bool isPreview = false;
        bool isProjectionMapping = false;
        bool isCalibrating = false;
        bool hasLoadedProjectionObject = false;

        // No calibration point selected if -1
        int selectedCalibrationPoint = -1;

        float distanceFromObject = -400.0;
        float projectorHeight = 125.;
        float objectHeightTarget = 125.;
        float fieldOfView = 45.2397;

        float cameraNear = 1.0;
        float cameraFar = 1000.0;

        bool isVertical = false;
        QString modelPath;
        BackEnd* backend;
        ShaderManager* shadermanager;

        QOpenGLShaderProgram screenShader;
        QOpenGLVertexArrayObject rectangleVao;
        QOpenGLBuffer rectangleVertexBuffer;

        QOpenGLVertexArrayObject calibrationVao;
        QOpenGLBuffer calibrationVertexBuffer;

        QOpenGLShaderProgram meshShader;
        QOpenGLVertexArrayObject meshVao;
        QOpenGLBuffer meshVertexBuffer;
        QOpenGLBuffer meshUVbuffer;

        QVector<QVector2D*> calibrationPoints;
        QVector<QVector3D*> originalVertices;
        QVector<QVector3D*> vertices;
        QVector<QVector2D*> UVs;
        QVector<QVector<int>> vertexFaces;
        QVector<QVector<int>> UVFaces;

        QVector<GLfloat> meshVertices;
        QVector<GLfloat> meshUVs;


        QMatrix4x4 modelMatrix;
        QMatrix4x4 viewMatrix;
        QMatrix4x4 projectionMatrix;
        QMatrix4x4 mvpMatrix;

        QVector3D cameraForward;
        QVector3D cameraRight;
        QVector3D cameraUp;

        QOpenGLTexture* calibrationTexture;
        QMatrix4x4 calibrationMatrix;

        QElapsedTimer time;
        int frameCounter;
        qint64 currentTime = 0;
        qint64 lastTime = 0;
        QMargins oldMargins;

        QRect oldGeometry;
};

#endif // WINDOW_H
