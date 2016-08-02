#ifndef GPIOPI_H
#define GPIOPI_H

#include <QObject>
#include <QTimer>
#include <QDebug>
#include "wiringPi.h"



class GpioPi : public QObject// класс для работы с пинами расбери
{
    Q_OBJECT
    int pinLed;
    int pinAcc;
    QTimer *timer;// таймер для определения продолжительности звукового сигнала
    QTimer *timerACC;// таймер для проверки работы от акк
    int accState;
public:
    explicit GpioPi(QObject *parent = 0);


signals:
    void updateAccState(bool);

public slots:
    void soundOff();
    void soundOn();
    void checkACC();
};

#endif // GPIOPI_H
