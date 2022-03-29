#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "MainWindow.hpp"
#include "jsonconverter.h"

int main(int argc, char *argv[])
{

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    app.setOrganizationName("MIR PLC");
    app.setOrganizationDomain("mir.dev");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    qmlRegisterType<MainWindow>("MainWindow", 1, 0, "MainWindow");

    engine.load(url);

    return app.exec();
}
