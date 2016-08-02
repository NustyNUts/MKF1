#include "compassport.h"
#include "QDebug"
#include <QThread>

#include "math.h"



CompassPort::CompassPort(QObject *parent) : QObject(parent)
{
    m_angle = m_pitch = m_roll = m_state = 0;
    portSensor = new QSerialPort(this);
    portDCon = new QSerialPort(this);
    m_compInProgress = false;
    connect(this,SIGNAL(compFinished()),this,SLOT(stopCompensation()));
    file = new QFile("angles");
    file->open(QFile::ReadWrite);
    out = new QTextStream(file);
    index = 0;
}

CompassPort::~CompassPort()
{
    portSensor->close();
    portDCon->close();
    delete portDCon;
    delete portSensor;
    file->close();
    emit finished();
}

void CompassPort::on()// метод для чтения из порта и его открытия, если не открыт
{

    emit timerStop();
    if(!portSensor->isOpen())
    {       

        if (portSensor->open(QIODevice::ReadWrite))// открываем порт если он еще не открыт
        {

            QSerialPortInfo *info = new QSerialPortInfo(*portSensor);//информация о порте для отладки
            m_state=1;// порт открыт
            delete info;
        }
        else
        {
            if(portSensor->isOpen())// если что-то пошло не так, закрываем порт
                portSensor->close();
        }
    }

    if(portSensor->isOpen() && portSensor->waitForReadyRead(100))// работа с открытым портом
    {
        QString data;
        QByteArray ByteArray,ByteArrayStart,ByteArrayFinish;
        bool startFinded = false;
         //qDebug()<<"read from port";
        m_state = 1;
        while(m_state)// пока порт открыт
        {
            //if(portSensor->waitForReadyRead(1))
            {
                qint64 byteAvail = portSensor->bytesAvailable();// просматриваем кол-во доступных байн для чтения
                qApp->processEvents();
                QThread::msleep(10);//усыпляем потом, чтобы не занимал времени( данные раз в 10 секунд)
                if(byteAvail >=23)// проверка кол-ва байт, для их обработки
                {
                    ByteArray = portSensor->readAll();// чтение из буфера порта
                    data = data.fromLocal8Bit(ByteArray).trimmed();
                    if(ByteArray[3]=='p')//то ли сообщение пришло(смотри даташит хоневеловского датчика)
                    {
                        QBitArray bitdata(184),two_bytes(16);
                        for(int i = 0,j; i < 184; ++i)//формирование массива бит для парсинга сообщения
                        {
                            j=i/8;
                            if(j<=18)
                                bitdata[i] = ByteArray[j] & (1 << i%8);
                            else

                                break;
                        }

                        for(int i=40,j=15;i<56&&j>=0;i++,j--){two_bytes[j]=bitdata[i];} //Roll

                        m_roll = Round(toDec(two_bytes,1)*1.41,1);
                        emit rollChanged(m_roll);
                        for(int i=56,j=15;i<72&&j>=0;i++,j--){two_bytes[j]=bitdata[i];} //Pitch

                        m_pitch = Round(toDec(two_bytes,1)*1.41,1);
                        emit pitchChanged(m_pitch);
                        for(int i=72,j=15;i<88&&j>=0;i++,j--){two_bytes[j]=bitdata[i];} //Azimuth

                        m_angle = Round(toDec(two_bytes,0)*1.41,1);
                        emit angleChanged(m_angle);

                        for(int i=136,j=15;i<152&&j>=0;i++,j--){two_bytes[j]=bitdata[i];} //coef B
                        m_B = Round(toDec(two_bytes,0)*1.41,1);

                        emit BChanged(m_B);

                        for(int i=152,j=15;i<168&&j>=0;i++,j--){two_bytes[j]=bitdata[i];} //coef C
                        m_C = Round(toDec(two_bytes,0)*1.41,1);

                        emit CChanged(m_C);

                        for(int i=168,j=15;i<184&&j>=0;i++,j--){two_bytes[j]=bitdata[i];} //coef Z
                        m_Z = Round(toDec(two_bytes,0)*1.41,1);
                        emit ZChanged(m_Z);
                        m_state=0;
                        qApp->processEvents();
                    }
                }
                // внимательно посмотреть этот код, кажется косяк с выбросами полей и курса в нем(!)
                else if(byteAvail >=4 && byteAvail <=23)// если сообщение не полное( разбито на два)
                {
                    ByteArray= portSensor->readAll();
                    data = data.fromLocal8Bit(ByteArray).trimmed();
                    if(ByteArray[3]=='p' && startFinded == false)
                    {
                        ByteArrayStart = ByteArray;
                        startFinded = true;

                    }
                    else if(startFinded == true)
                    {
                        ByteArrayFinish += ByteArray;
                        ByteArray = ByteArrayStart + ByteArrayFinish;
                        if(ByteArray.size() >= 23)
                        {
                            QBitArray bitdata(184),two_bytes(16);
                            for(int i = 0,j; i < 184; ++i)
                            {
                                j=i/8;
                                if(j<=23)
                                    bitdata[i] = ByteArray[j] & (1 << i%8);
                                else
                                    break;
                            }
                            for(int i=40,j=15;i<56&&j>=0;i++,j--){two_bytes[j]=bitdata[i];} //Roll

                            m_roll = Round(toDec(two_bytes,1)*1.41,1);
                            emit rollChanged(m_roll);
                            for(int i=56,j=15;i<72&&j>=0;i++,j--){two_bytes[j]=bitdata[i];} //Pitch

                            m_pitch = Round(toDec(two_bytes,1)*1.41,1);
                            emit pitchChanged(m_pitch);
                            for(int i=72,j=15;i<88&&j>=0;i++,j--){two_bytes[j]=bitdata[i];} //Azimuth

                            m_angle = Round(toDec(two_bytes,0)*1.41,1);
                            emit angleChanged(m_angle);

                            for(int i=136,j=15;i<1526&&j>=0;i++,j--){two_bytes[j]=bitdata[i];} //coef B
                            m_B = Round(toDec(two_bytes,1)*1.41,1);
                            emit BChanged(m_B);

                            for(int i=152,j=15;i<168&&j>=0;i++,j--){two_bytes[j]=bitdata[i];} //coef C
                            m_C = Round(toDec(two_bytes,1)*1.41,1);
                            emit CChanged(m_C);

                            for(int i=168,j=15;i<184&&j>=0;i++,j--){two_bytes[j]=bitdata[i];} //coef Z
                            m_Z = Round(toDec(two_bytes,1)*1.41,1);
                            emit ZChanged(m_Z);

                            m_state=0;
                            startFinded = false;
                        }
                    }
                    //ByteArrayStart="";

                }
            }
        }
    }
    else
    {

    }
    emit timerStart(10);
}
void CompassPort::sendCourse(double course)// бередача курса для БК
{
    // открытие порта если он закрыт
    if(!portDCon->isOpen()){
        portDCon->setPortName("ttyUSB0");
        portDCon->setBaudRate(9600);
        portDCon->open(QIODevice::ReadWrite);
        qDebug()<<portDCon->isOpen();
    }
    if(portDCon->isOpen()) // работа с портом
    {
        QByteArray dataForWrite;
        QString str;
        // формирование строки для передачи
        if(course>99)
            str = "$RP,"+QString::number(course,10,1)+",CRLF";
        else if(course>9)
            str = "$RP,0"+QString::number(course,10,1)+",CRLF";
        else
            str = "$RP,00"+QString::number(course,10,1)+",CRLF";
        dataForWrite = str.toLocal8Bit();// преобразование строки к массив байт
        portDCon->write(dataForWrite,dataForWrite.size());// запись в порт для передачи
    }
}

void CompassPort::initComp()//инициализация компенсации
{
    emit timerStop();// останавливаем прием курса
    emit compStarted();// сообщаем о начале компенсации
    m_compInProgress = true;
    // формируем сообщение для датчика о начале компенсации
    QByteArray dataForWrite;
    dataForWrite.insert(0,0x0d);
    dataForWrite.insert(1,0x0a);
    dataForWrite.insert(2,0x7e);
    dataForWrite.insert(3,0x72);
    dataForWrite.insert(4,0x01);
    dataForWrite.insert(5,0x01);
    dataForWrite.insert(6,0x09);
    //--------------------
    if(portSensor->isOpen())// проверка открыт ли порт
    {

        portSensor->write(dataForWrite,7);// передача сообщения датчику для начала компенсации
        if(!portSensor->waitForBytesWritten(1000))
        {
        }
        while(m_compInProgress)// пока калибровка не закончится
        {

            qApp->processEvents();// магическая строчка чтобы не тупили пользовательские интерфейсы
            if(portSensor->isOpen() && portSensor->waitForReadyRead(1000))// ждем данных
            {
                QString data;
                QByteArray ByteArray;
                qint64 byteAvail = portSensor->bytesAvailable();
                qApp->processEvents();
                if(byteAvail >=19)// буфер наполнился
                {
                    ByteArray = portSensor->readAll();// читаем из порта
                    data = data.fromLocal8Bit(ByteArray).trimmed();
                    if(ByteArray[3]=='r'&& ByteArray[0]=='\r' && ByteArray[1]=='\n' && ByteArray[2]=='~')// если сообщение нужное нам( смотри даташит)
                    {
                        //формирование массива бит для парсинга
                        QBitArray bitdata(152),one_byte(8);
                        for(int i = 0,j; i < 152; ++i)
                        {
                            j=i/8;
                            if(j<=19)
                                bitdata[i] = ByteArray[j] & (1 << i%8);
                            else
                                break;
                        }
                        // парс сообщения о состоянии бинов
                        for(int i=56,j=7;i<64 && j>=0;i++,j--){one_byte[j]=bitdata[i];}
                        //dial->setBar(7,toDecInt(one_byte));
                        emit dialCompProgressChanged(7,toDecInt(one_byte));
                        for(int i=64,j=7;i<72 && j>=0;i++,j--){one_byte[j]=bitdata[i];}
                        //dial->setBar(6,toDecInt(one_byte));
                        emit dialCompProgressChanged(6,toDecInt(one_byte));
                        for(int i=72,j=7;i<80 && j>=0;i++,j--){one_byte[j]=bitdata[i];}
                        //dial->setBar(5,toDecInt(one_byte));
                        emit dialCompProgressChanged(5,toDecInt(one_byte));
                        for(int i=80,j=7;i<88 && j>=0;i++,j--){one_byte[j]=bitdata[i];}
                        //dial->setBar(4,toDecInt(one_byte));
                        emit dialCompProgressChanged(4,toDecInt(one_byte));
                        for(int i=88,j=7;i<96 && j>=0;i++,j--){one_byte[j]=bitdata[i];}
                        //dial->setBar(3,toDecInt(one_byte));
                        emit dialCompProgressChanged(3,toDecInt(one_byte));
                        for(int i=96,j=7;i<104 && j>=0;i++,j--){one_byte[j]=bitdata[i];}
                        //dial->setBar(2,toDecInt(one_byte));
                        emit dialCompProgressChanged(2,toDecInt(one_byte));
                        for(int i=104,j=7;i<112 && j>=0;i++,j--){one_byte[j]=bitdata[i];}
                        //dial->setBar(1,toDecInt(one_byte));
                        emit dialCompProgressChanged(1,toDecInt(one_byte));
                        for(int i=112,j=7;i<120 && j>=0;i++,j--){one_byte[j]=bitdata[i];}
                        //dial->setBar(0,toDecInt(one_byte));
                        emit dialCompProgressChanged(0,toDecInt(one_byte));
                        //---------------------------------------------------------
                        // состоние компенсации
                        for(int i=48,j=7;i<56 && j>=0;i++,j--){one_byte[j]=bitdata[i];}
                        if(toDecInt(one_byte)==1)
                        {
                            //dial->setLabel("Success");
                            emit dialCompStatusChanged("НОРМА");
                        }
                        else if(toDecInt(one_byte)==0)
                        {
                            //dial->setLabel("No error");
                            emit dialCompStatusChanged("");
                        }
                        else if(toDecInt(one_byte)==2)
                        {
                            //dial->setLabel("Compensation Already Started");
                            emit dialCompStatusChanged("");
                        }
                        else if(toDecInt(one_byte)==3)
                        {
                            //dial->setLabel("Compensation Not Started");
                            emit dialCompStatusChanged("ОТКАЗ");
                        }
                        else if(toDecInt(one_byte)==4)
                        {
                            //dial->setLabel("Compensation Timeout");
                            emit dialCompStatusChanged("ВРЕМЯ");
                        }
                        else if(toDecInt(one_byte)==5)
                        {
                            //dial->setLabel("Compensation Computation Failure");
                            emit dialCompStatusChanged("ОШИБКА");
                        }
                        else if(toDecInt(one_byte)==6)
                        {
                            //dial->setLabel("New Computed Parameters No Better");
                            emit dialCompStatusChanged("НОРМА");
                        }
                        else if(toDecInt(one_byte)==7)
                        {
                            //dial->setLabel("Flash Write Fail");
                            emit dialCompStatusChanged("ОТКАЗ");
                        }
                        //----------------------------
                        qApp->processEvents();
                    }

                }
                // посылаем сообщение для получения данных о калибровке
                dataForWrite.insert(5,0x02);
                dataForWrite.insert(6,0x0a);
                portSensor->write(dataForWrite,7);
                if(!portSensor->waitForBytesWritten(1000))
                {
                }
                //-----------------------
            }
        }
    }
    emit compFinished();// калибровка закончена
    emit timerStart(10);// продолжаем прием сообщений о курсе
    m_compInProgress = false;
}


void CompassPort::stopCompensation()
{
    m_compInProgress = false;
}

void CompassPort::revert()// метод для сброса датчика
{
    emit timerStop();// останавливаем прием курса
    // формируем сообщения для сброса
    QByteArray dataForWrite;
    dataForWrite.insert(0,0x0d);
    dataForWrite.insert(1,0x0a);
    dataForWrite.insert(2,0x7e);
    dataForWrite.insert(3,0x72);
    dataForWrite.insert(4,0x01);
    dataForWrite.insert(5,0x04);
    dataForWrite.insert(6,0x0c);
    bool receivedMsg = false;
    //----------------------

    if(portSensor->isOpen())
    {

        portSensor->write(dataForWrite,7);// пишем в порт сообщение о сбросе
        if(!portSensor->waitForBytesWritten(1000))
        {
        }
        while(!receivedMsg)// ждем получения сообщения о сбросе
        {

            if(portSensor->isOpen() && portSensor->waitForReadyRead(1000))
            {

                QString data;
                QByteArray ByteArray;
                qint64 byteAvail = portSensor->bytesAvailable();
                qApp->processEvents();
                if(byteAvail >=19)
                {
                    ByteArray = portSensor->readAll();
                    data = data.fromLocal8Bit(ByteArray).trimmed();
                    if(ByteArray[3]=='r'&& ByteArray[0]=='\r' && ByteArray[1]=='\n' && ByteArray[2]=='~')
                    {
                        QBitArray bitdata(152),one_byte(8);
                        for(int i = 0,j; i < 152; ++i)
                        {
                            j=i/8;
                            if(j<=19)
                                bitdata[i] = ByteArray[j] & (1 << i%8);
                            else
                                break;
                        }
                        for(int i=40,j=7;i<48 && j>=0;i++,j--){one_byte[j]=bitdata[i];}
                        if(toDecInt(one_byte)==0)
                        {
                            //settings->setLabel("Compass Compensation Off");
                            //emit revertStatusChanged("Датчик сброшен");
                        }
                        else if(toDecInt(one_byte)==1)
                        {
                            //settings->setLabel("Compass Compensation Data Collection");
                            //emit revertStatusChanged("Сбор данных...");
                        }
                        else if(toDecInt(one_byte)==2)
                        {
                            //settings->setLabel("Compass Compensation Computation in Progress");
                            //emit revertStatusChanged("Вычисление...");
                        }
                        else if(toDecInt(one_byte)==3)
                        {
                            //settings->setLabel("Compass Compensation Procedure Abort");
                           // emit revertStatusChanged("Процедура прервана");
                        }
                        for(int i=48,j=7;i<56 && j>=0;i++,j--){one_byte[j]=bitdata[i];}

                        qApp->processEvents();
                        receivedMsg = true;// сообщение о сбросе получено
                    }
                }
                //запрашиваем состояние сброса
                dataForWrite.insert(5,0x02);
                dataForWrite.insert(6,0x0a);
                portSensor->write(dataForWrite,7);
                if(!portSensor->waitForBytesWritten(1000))
                {
                }
                //----------------------
            }
        }
    }
    emit timerStart(10);// продолжаем получение курса
}

void CompassPort::updateSettings(QStringList listOfSettings)// обновление настроек порта датчика
{
    if(portSensor->isOpen())
        portSensor->close();
    portSensor->setPortName(listOfSettings.at(0).toLocal8Bit());
    portSensor->setBaudRate(listOfSettings.at(1).toInt());
    portSensor->setDataBits(QSerialPort::DataBits(listOfSettings.at(2).toInt()));
    portSensor->setStopBits(QSerialPort::StopBits(listOfSettings.at(3).toInt()));
    portSensor->setParity(QSerialPort::Parity(listOfSettings.at(4).toInt()));
}


double CompassPort::toDec(QBitArray bitdata,int p)//преобразования в дес. формат
{
    double intpart=0;
    double fractpart=0;
    QBitArray bit1(8),bit2(8);
    bit1.fill(true);
    for(int i=0;i<8;i++)
    {
        bit2[i]=bitdata[i];
    }
    int k=1;
    if((p && bitdata[0]) || (!p && bit2 == bit1))//отрицаетельное число в обратном коде
    {
        bitdata=~bitdata;
        p==1? k=-1:k=1;
    }
    for(int i=0,j=7;i<8 && j>=0;i++,j--)
        intpart+=pow(2,j)*bitdata[i];
    for(int i=8,j=1;i<16 && j<=8;i++,j++)
        fractpart+=1/pow(2,j)*bitdata[i];
    return (intpart+QString::number(fractpart).left(5).toDouble())*k;

}

int CompassPort::toDecInt(QBitArray bitdata)
{
    int res = 0;
    int k=1,s=0;

    if(bitdata[0] == true)
    {
        bitdata=~bitdata;
        k=-1;
        s=1;
    }

    for(int i = 0;i < bitdata.size();i++)
    {
        res+=pow(2,i)*bitdata[(bitdata.size()-1)-i];
    }
    return (res+s)*k;
}

double CompassPort::Round(double st,int count)// округление
{
    double temp;
    double *pt=new double;
    if(st!=0)
    {
        temp=fabs(modf(st,pt));
        QString str = QString::number(temp),arg="0.";
        if(count<=str.size()+2)
        {
            if(QString(str[count+2]).toInt()<5)
            {
                str=str.left(count+2);
                temp=str.toDouble();
            }
            else
            {
                for(int i=0;i<count-1;i++)
                    arg.push_back("0");
                arg.push_back("1");
                temp+=arg.toDouble();
                temp=QString::number(temp).left(count+2).toDouble();
            }
        }
        return (fabs(*pt)+temp)*(st/fabs(st));
    }
    else return 0;

}
