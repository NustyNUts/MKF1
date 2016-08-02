#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "compass.h"

int main(int argc, char *argv[])
{

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;// создание движка Qml
    QQmlContext *context = engine.rootContext();// создание контекста Qml
    Compass compass(context);// создание объекта компаса(логика работы)
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));
    return app.exec();
}
