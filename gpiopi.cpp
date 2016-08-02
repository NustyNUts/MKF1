#include "gpiopi.h"


GpioPi::GpioPi(QObject *parent) :
    QObject(parent),pinLed(21),pinAcc(20)
{
//    wiringPiSetupGpio();// инициализация портов разбери
//    pinMode(pinLed,OUTPUT);// настройка пина на вывод
//    digitalWrite(pinLed,LOW);// пишем 0, чтобы не пищал сразу
//    timer = new QTimer();
//    timerACC = new QTimer();
//    connect(timer,SIGNAL(timeout()),this,SLOT(ledOff()));
//    connect(timerACC,SIGNAL(timeout()),this,SLOT(checkACC()));
//    accState = 2;
//    emit updateAccState(accState);
//    timerACC->start(1000);// стартуем таймер для опроса состояния работы от акк
}

void GpioPi::soundOn(){

//    digitalWrite(pinLed,HIGH);// ключаем пищалку
//    timer->start(200);//устанавливаем продолжительность звука
}

void GpioPi::soundOff(){
//    digitalWrite(pinLed,LOW);//прекращаем звуковой сигла
//    timer->stop();//останавливаем таймер
}

void GpioPi::checkACC(){
//    if(accState!=digitalRead(pinAcc)){// проверяем состояние пина
//        accState = digitalRead(pinAcc);
//        emit updateAccState(accState);// отправляем сигнал о изменении состояние работы
//    }
}
