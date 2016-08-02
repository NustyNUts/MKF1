#include "compass.h"
#include "math.h"

Compass::Compass(QQmlContext *context, QObject *parent) :
    QObject(parent), k(0),m_comp_state(1),m_dempf(1),m_tmCourse(0),m_coef_A(0),
    m_last(0),m_last2(0),m_angle(0),m_fractPart(0),m_fullangle(0),m_state(0),
    m_connect(0),m_background(0),m_skl(0),m_savedCourse(0),m_roll(0),m_pitch(0),
    m_afterComma(0),m_lastAngle(0),m_lastAngle1(0),m_sum(0),m_con(0),m_con1(0),
    m_summ_ang(0),m_progress(0),skl_str("0"),a_str("0"),
    m_complable(""),delta_str("0"),deltaDegaus_str("0")
{
    m_compColor = "white";
    m_comp_state =false;
    gpioPi = new GpioPi();
    spline = new cubic_spline();
    splineDG = new cubic_spline();
    timerClearComp = new QTimer();
    context->setContextProperty("timerComp",timerClearComp);
    m_degaus = 0;

    for(int i=0;i<8;i++)
    {
        delta[i]=0;
        deltaDegaus[i]=0;
        m_points[i] = 0;
        m_points[i+8] = 0;
        m_points[i+16] = 0;

    }
    fileDev = new QFile(QApplication::applicationDirPath()+"/devCoef");
    fileDev ->open(QFile::ReadOnly);

    QTextStream* inDev = new QTextStream(fileDev);
    for (int i=0;i<8;i++){
        *inDev>>delta[i];
        *inDev>>deltaDegaus[i];
    }
    fileDev->close();

    delta_str = QString::number(delta[0]);
    delete inDev;

    fileSklA = new QFile(QApplication::applicationDirPath()+"/SklA");
    fileSklA->open(QFile::ReadOnly);
    QTextStream* inSklA = new QTextStream(fileSklA);
    *inSklA >> m_skl;
    *inSklA >> m_coef_A;
    fileSklA->close();

    skl_str = QString::number(m_skl);
    a_str = QString::number(m_coef_A);

    delete inSklA;

    context_m = context;
    dialComp = new DialogComp();
    compport = new CompassPort();
    timer = new QTimer(this);
    settingsViewControlTimer = new QTimer(this);
    settingsDialog = new Settings();
    //gpio signals
    connect(gpioPi,SIGNAL(updateAccState(bool)),this,SLOT(setAccState(bool)));//обновление индикации работы от акк
    //--------------------------------
    //timer signals
    connect(timer, SIGNAL(timeout()),compport, SLOT(on()));//переподключение к ком порту
    connect(compport, SIGNAL(timerStart(int)),timer, SLOT(start(int)));
    connect(compport, SIGNAL(timerStop()),timer, SLOT(stop()));

    connect(settingsViewControlTimer,SIGNAL(timeout()),this,SLOT(closeSettingsView()));//сигналы для закрытия экрана настроек через 5 минут
    connect(settingsViewControlTimer,SIGNAL(timeout()),settingsViewControlTimer,SLOT(stop()));//для единичного срабатывания
    /*//////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

    //angle signals
    connect(compport,SIGNAL(angleChanged(double)),this,SLOT(setAngle(double)));//обновление угла после получение из ком порта
    connect(compport,SIGNAL(pitchChanged(double)),this,SLOT(setPitch(double)));//установка крена
    connect(compport,SIGNAL(rollChanged(double)),this,SLOT(setRoll(double)));//установка дифф
    //установка полей
    connect(compport,SIGNAL(BChanged(double)),this,SLOT(setB(double)));
    connect(compport,SIGNAL(CChanged(double)),this,SLOT(setC(double)));
    connect(compport,SIGNAL(ZChanged(double)),this,SLOT(setZ(double)));
    //-------------------------
    connect(compport,SIGNAL(readyWriteToLog()),this,SLOT(writeTolog()));// сигнал для записи в лог угла и полей(не используется в релизных)
    connect(this,SIGNAL(sendMsg(double)),compport,SLOT(sendCourse(double)));//коннект для отправки сообщений для БК
    /*//////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

    //settings signals
    connect(settingsDialog,SIGNAL(settingsChanged(QStringList)),compport,SLOT(updateSettings(QStringList)));
    connect(settingsDialog,SIGNAL(revertRequest()),compport,SLOT(revert()));
    connect(this,SIGNAL(revertRequest()),compport,SLOT(revert()));
    connect(compport,SIGNAL(revertStatusChanged(QString)),settingsDialog,SLOT(setLable(QString)));
    //connect(compport,SIGNAL(revertStatusChanged(QString)),settingsDialog,SLOT(setCompensationLabel(QString)));
    /*//////////////////////////////////////////////////////////////////////////////////////////////////////////////*/


    compangle = new Compassangle(this);
    compangle->setM_skl(m_skl);// инициализация склонения
    compangle->setM_coef_A(m_coef_A);// инициализация коэф. А
    compangle->setDegaus(m_degaus);// установка состояния работы РУ
    //compensation signals
    connect(this,SIGNAL(compensationRequest()),compport,SLOT(initComp()));
    connect(this,SIGNAL(compensationRequest()),this,SLOT(setCompensationLabeltoDeafault()));

    connect(this,SIGNAL(sklChanged(double)),compangle,SLOT(setM_skl(double)));
    connect(this,SIGNAL(coef_AChanged(double)),compangle,SLOT(setM_coef_A(double)));

    //connect(compport,SIGNAL(compStarted()),dialComp,SLOT(show()));
    //connect(compport,SIGNAL(compFinished()),dialComp,SLOT(setBarstoDefault()));
    //connect(compport,SIGNAL(dialCompProgressChanged(int,int)),dialComp,SLOT(setBar(int,int)));
    //connect(compport,SIGNAL(dialCompStatusChanged(QString)),dialComp,SLOT(setLabel(QString)));

    connect(this,SIGNAL(compClosed()),compport,SLOT(stopCompensation()));
    connect(compport,SIGNAL(dialCompProgressChanged(int,int)),this,SLOT(updateCompensationInfo(int,int)));
    connect(compport,SIGNAL(dialCompStatusChanged(QString)),this,SLOT(setCompensationLabel(QString)));
    //connect(compport,SIGNAL(revertStatusChanged(QString)),this,SLOT(setCompensationLabel(QString)));
    connect(compport,SIGNAL(compFinished()),this,SLOT(setBarstoDefault()));
    connect(this,SIGNAL(compClosed()),this,SLOT(setCompensationLabeltoDeafault()));

    /*//////////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    connect(timerClearComp,SIGNAL(timeout()),timerClearComp,SLOT(stop()));

    portThread = new QThread;
    compport->moveToThread(portThread);//прием с порта в отдельном потоке
    connect(compport,SIGNAL(finished()),portThread,SLOT(quit()));
    connect(portThread,SIGNAL(finished()),portThread,SLOT(deleteLater()));

    portThread->start();//запуск работы потока для приема из ком порта
    settingsDialog->initSettigs();
    timer->start(10);//запуск таймера для получения курсов
    getDevCoef();// расчет коэффицентов девиации и построение интерполяционной функции
    //установка начальных значений для пользовательских интерфейсов
    context_m->setContextProperty("compass",this);//для вызова слотов из qml

    context_m->setContextProperty("coef_B","0.0");
    context_m->setContextProperty("coef_C","0.0");
    context_m->setContextProperty("coef_Z","0.0");

    context_m->setContextProperty("trueMagneticCourse",compangle->getM_tmCourse());
    context_m->setContextProperty("m_background",m_background);
    context_m->setContextProperty("m_degaus",(int)m_degaus);

    context_m->setContextProperty("angle_value",compangle->getM_angle());
    context_m->setContextProperty("fract_part",compangle->getM_fractPart());
    context_m->setContextProperty("full_angle",compangle->getM_fullangleStr());
    context_m->setContextProperty("afterComma",m_afterComma);
    context_m->setContextProperty("m_pitch",m_pitch);
    context_m->setContextProperty("m_roll",m_roll);

    context_m->setContextProperty("skl_str",skl_str);
    context_m->setContextProperty("a_str",a_str);
    context_m->setContextProperty("delta_str",delta_str);
    context_m->setContextProperty("deltaDegaus_str",deltaDegaus_str);
    context_m->setContextProperty("m_complable",m_complable);
    context_m->setContextProperty("m_dempf",compangle->getM_dempf());
    //-------------------------------------

    //создание файла для записи лога
    file = new QFile("Log, time:"+QTime::currentTime().toString());
    //file->open(QFile::ReadWrite);
    out = new QTextStream(file);
    *out<<"angle  '"<<"roll  '"<<"pitch  '"<<"B  '"<<"C  '"<<"Z  '"<<"Time '\n";
    index = 0;
    //---------------------
}

Compass::~Compass()
{
    delete compport;
    file->close();
    delete fileDev;
    delete  file;
    delete out;
    delete timer;
    delete compangle;
    delete settingsDialog;
    delete dialComp;
    delete settingsViewControlTimer;
    delete gpioPi ;
    delete spline ;
    delete splineDG ;
    delete timerClearComp ;

}
void Compass::setAccState(bool state)//слот для получения состояния акк
{
    m_accState = state;//обновление состояния акк
    context_m->setContextProperty("acc_state",m_accState);//передача состояния акк в ПИ(пользовательские интерфейсы)
}

void Compass::updateSklA()//обновление сколонения и кэф. А
{
    fileSklA->open(QFile::WriteOnly);//открытие файла
    QTextStream* inSklA = new QTextStream(fileSklA);
    //запись в файл склон. и коеф. А
    *inSklA << m_skl;
    *inSklA << " ";
    *inSklA << m_coef_A;
    //-------------
    fileSklA->close();//закрытие файла
    skl_str = QString::number(m_skl);
    a_str = QString::number(m_coef_A);
    getDevCoef();//обновление коэффициентов девиации и интерполирующей функции
    delete inSklA;
}

void Compass::writeTolog()
{
    *out<<m_fullangle<<"  '"<<m_roll<<"  '"<<m_pitch<<"  '"<<m_B<<"  '"<<m_C<<"  '"<<m_Z<<"  '"<<QTime::currentTime().toString()<<"\n";//запись в лог значений
}

void Compass::updateCompensationInfo(int binNum, int progress)
{
    if(progress == 16)//обновляем бины только при полном заполнении
    {
        m_progress = progress;
        switch(binNum)
        {
        case 0:
            m_bins.bin0=progress;
            break;
        case 1:
            m_bins.bin1=progress;
            break;
        case 2:
            m_bins.bin2=progress;
            break;
        case 3:
            m_bins.bin3=progress;
            break;
        case 4:
            m_bins.bin4=progress;
            break;
        case 5:
            m_bins.bin5=progress;
            break;
        case 6:
            m_bins.bin6=progress;
            break;
        case 7:
            m_bins.bin7=progress;
            break;
        default: return;
        }
        emit binsChanged();//сигнал о изменении бина в ПИ
    }
}

void Compass::setBarstoDefault()//установка всех бинов в 0
{
    m_bins.bin0=0;
    m_bins.bin1=0;
    m_bins.bin2=0;
    m_bins.bin3=0;
    m_bins.bin4=0;
    m_bins.bin5=0;
    m_bins.bin6=0;
    m_bins.bin7=0;
    emit binsChanged();
}

void Compass::setCompensationLabel(QString msg)//индикация состояния компенсации
{
    m_complable = msg;
    if(msg=="НОРМА" ||msg=="ОТКАЗ"|| msg=="ВРЕМЯ"||msg=="ОШИБКА")//компенсация завершилась
    {
        context_m->setContextProperty("m_complable",m_complable);
        compport->stopCompensation();
        qDebug()<<"start timer";
        timerClearComp->start(9000);//запуск таймера для сброса значений
        m_comp_state = false;
        sound();//звуковой сигнал
        qDebug()<<"stop";

    }
    else
        context_m->setContextProperty("m_complable","КАЛИБРОВКА");//если не конец, то индицируем калибровку


    emit compensationLabelChanged();
    if(m_complable == "НОРМА")// если завершилась успешно то сбрасываем коэф. девиации в 0
    {
        for (int i=0;i<8;i++){
            addDelta(i+1,0.0);
            addDeltaDegaus(i+1,0.0);
            qDebug()<<getDelta(i+1)<<getDeltaDegaus(i+1);
        }
        getDevCoef();// обновляем коэф. дев. и интерпол. фун.
    }


}
void Compass::setCompensationLabeltoDeafault()//сбрасываем индикацию компенсации
{
    m_complable = "";
    context_m->setContextProperty("m_complable",m_complable);
}


void Compass::setAngle(double a)// установка угла
{

    compangle->setM_fullangle(a);// передаем полученый из порта азимут в объект каласса для обработки

    context_m->setContextProperty("fract_part",compangle->getM_fractPart());
    if(m_comp_state == true)
        context_m->setContextProperty("full_angle","---.-");// если компенсация в процессе, то не индицируем курс
    else
        context_m->setContextProperty("full_angle",compangle->getM_fullangleStr());
    context_m->setContextProperty("angle_value",compangle->getM_angle());
    emit sendMsg(compangle->getCourse());// передаем сообщение для БК  с текущим курсом
}

void Compass::getDevCoef()
{
    //обновляем файл с отклонениями
    fileDev->remove();
    fileDev->open(QFile::WriteOnly);
    QTextStream* outDelta = new QTextStream(fileDev);
    m_coef_Dev.A = 0;
    m_coef_Dev.B = 0;
    m_coef_Dev.C = 0;
    m_coef_Dev.D = 0;
    m_coef_Dev.E = 0;
    for(int i = 0; i < 8; i++)
    {
        m_coef_Dev.A+=delta[i];
        m_coef_DevDG.A+=deltaDegaus[i];
        *outDelta<<delta[i];
        *outDelta<<" ";
        *outDelta<<deltaDegaus[i];
        *outDelta<<" ";
    }
    fileDev->close();
    delete outDelta;
    //------------------

    coefAForSAhow = m_coef_Dev.A/8 -m_coef_A;// коэф А для индикации
    // расчет коэф. девиации по мутной формуле
    m_coef_Dev.A = 0;// коэф. А для расчета(0 т.к. учитываем его отдельно
    m_coef_Dev.B = ((delta[2]-delta[6])/2 + (delta[1]-delta[5])/2 * sqrt(2)/2 + ((delta[3]-delta[7]) * sqrt(2)/2)/2)/2;
    m_coef_Dev.C = ((delta[0]-delta[4])/2 + (delta[1]-delta[5])/2 * sqrt(2)/2 + (delta[3]-delta[7]) * (-sqrt(2)/2)/2)/2;
    m_coef_Dev.D = ((delta[1]+delta[5])/2 - (delta[3]+delta[7])/2)/2;
    m_coef_Dev.E = ((delta[0]+delta[4])/2 - (delta[2]+delta[6])/2)/2;
    // тоже самое для работы с РУ
    m_coef_DevDG.A = m_coef_Dev.A;
    m_coef_DevDG.B = ((deltaDegaus[2]-deltaDegaus[6])/2 + (deltaDegaus[1]-deltaDegaus[5])/2 * sqrt(2)/2 + ((deltaDegaus[3]-deltaDegaus[7]) * sqrt(2)/2)/2)/2;
    m_coef_DevDG.C = ((deltaDegaus[0]-deltaDegaus[4])/2 + (deltaDegaus[1]-deltaDegaus[5])/2 * sqrt(2)/2 + (deltaDegaus[3]-deltaDegaus[7]) * (-sqrt(2)/2)/2)/2;
    m_coef_DevDG.D = ((deltaDegaus[1]+deltaDegaus[5])/2 - (deltaDegaus[3]+deltaDegaus[7])/2)/2;
    m_coef_DevDG.E = ((deltaDegaus[0]+deltaDegaus[4])/2 - (deltaDegaus[2]+deltaDegaus[6])/2)/2;
    //-----------------------------------------
    // формируем контейнеры для передачи коэф. девиации в ПИ
    QList<QString> listDevCoef;
    QList<QString> listDevCoefDG;
    listDevCoef<<QString::number(coefAForSAhow,10,2)<<QString::number(m_coef_Dev.B,10,2)<<
                 QString::number(m_coef_Dev.C,10,2)<<QString::number(m_coef_Dev.D,10,2)<<QString::number(m_coef_Dev.E,10,2);
    listDevCoefDG<<QString::number(coefAForSAhow,10,2)<<QString::number(m_coef_DevDG.B,10,2)<<
                   QString::number(m_coef_DevDG.C,10,2)<<QString::number(m_coef_DevDG.D,10,2)<<QString::number(m_coef_DevDG.E,10,2);
    // и передаем
    context_m->setContextProperty("devCoef",QVariant::fromValue(listDevCoef));
    context_m->setContextProperty("devCoefDG",QVariant::fromValue(listDevCoefDG));
    //------------------------------------------------
    calcPoints();// расчитываем интерполяционную функцию
}

void Compass::setDegaus(bool deg)// обновление состояние работы РУ
{
    m_degaus = deg;
    compangle->setDegaus(deg);
    context_m->setContextProperty("m_degaus",(int)m_degaus);
}

void Compass::startSettingsViewControlTimer(int msec)// стартуем таймер для закрытия настроект через 5 минут
{
    settingsViewControlTimer->start(msec);
}

void Compass::calcPoints()// расчет промежуточных значений для интерполяции
{
    double mass[4][12] = {{0.0,0.5,0.87,1.0,0.87,0.5,0.0,-0.5, -0.87,-1.0,-0.87,-0.5},
                         {1.0, 0.87,0.5, 0.0, -0.5,-0.87, -1.0,-0.87,-0.5,0.0, 0.5, 0.87},
                         {0.0,0.26,0.5, 0.71, 0.87, 0.96, 1.0,0.96, 0.87,0.71,0.5, 0.26},
                         {1.0,0.96, 0.87, 0.71,0.5,0.26,0.0,-0.26,-0.5,-0.71,-0.87,-0.96}};// странный масив построен на основе экселевского файла
    // расчет значений точек для узлов сетки кубического сплайна, на основе формулы вытащеной из экселевского файла
    for(int i = 0; i < 12; i++)
    {
        m_points[i] = m_coef_Dev.D * mass[0][i] + m_coef_Dev.E * mass[1][i] + m_coef_Dev.A + m_coef_Dev.B * mass[2][i] + m_coef_Dev.C * mass[3][i];
        m_points[i+12] = m_coef_Dev.D * mass[0][i] + m_coef_Dev.E * mass[1][i] + m_coef_Dev.A - (m_coef_Dev.B * mass[2][i] + m_coef_Dev.C * mass[3][i]);
    }

    double x[25];// создание узлов сетки интерполяции( ЧЕРЕЗ 15 ГРАДУСОВ)
    for(int i = 0; i < 25; i++)
    {
        x[i] = 15 * i;
    }
    //---------------------------
    m_points[24] = m_points[0];// 360 и 0 градусов-одно и тоже( необходимо для замкнутости

    spline->build_spline(x,m_points,25);// построение интерполяционного кубического сплайна для работы (!)без РУ
    // тоже самое для работы с РУ
    for(int i = 0; i < 12; i++)
    {
        m_pointsDG[i] = m_coef_DevDG.D * mass[0][i] + m_coef_DevDG.E * mass[1][i] + m_coef_DevDG.A + m_coef_DevDG.B * mass[2][i] + m_coef_DevDG.C * mass[3][i];
        m_pointsDG[i+12] = m_coef_DevDG.D * mass[0][i] + m_coef_DevDG.E * mass[1][i] + m_coef_DevDG.A - (m_coef_DevDG.B * mass[2][i] + m_coef_DevDG.C * mass[3][i]);

    }
    for(int i = 0; i < 25; i++)
    {
        x[i] = 15 * i;
    }
    m_pointsDG[24] = m_pointsDG[0];
    splineDG->build_spline(x,m_pointsDG,25);
    //---------------------
    compangle->setSpline(spline,splineDG);// передача сплайнов для внесения поправок курса
    //очиста контейнеров для таблици девиации
    resDev10.clear();
    resDev15.clear();
    resDevDG10.clear();
    resDevDG15.clear();
    //-------------------
    //--------
    //добавление точек для таблици девиации в контейнер и их передача в ПИ
    //через 15 градусов
    for(int i=0;i<24;i++)
    {
        resDev15<<QString::number(spline->f(i*15)+coefAForSAhow,10,1);
        resDevDG15<<QString::number(splineDG->f(i*15.0)+coefAForSAhow,10,1);
    }

    context_m->setContextProperty("deviation15",QVariant::fromValue(resDev15));
    context_m->setContextProperty("deviationDG15",QVariant::fromValue(resDevDG15));
    //-----------------------
    //через 10 градусов
    for(int i=0;i<36;i++)
    {
        resDev10<<QString::number(spline->f(i*10)+coefAForSAhow,10,1);
        resDevDG10<<QString::number(splineDG->f(i*10.0)+coefAForSAhow,10,1);
    }

    context_m->setContextProperty("deviation10",QVariant::fromValue(resDev10));
    context_m->setContextProperty("deviationDG10",QVariant::fromValue(resDevDG10));

}
//методы для обновления магнитных полей
void Compass::setB(double B)
{
    m_B = B;
    QString str;
    if(B-(int)B==0)
        str = QString::number(B) + ".0";
    else
        str = QString::number(B);
    context_m->setContextProperty("coef_B",str);
    return;
}
void Compass::setC(double C)
{
    m_C = C;
    QString str;
    if(C-(int)C==0)
        str = QString::number(C) + ".0";
    else
        str = QString::number(C);

    context_m->setContextProperty("coef_C",str);
    return;
}
void Compass::setZ(double Z)
{
    m_Z = Z;
    QString str;
    if(Z-(int)Z==0)
        str = QString::number(Z) + ".0";
    else
        str = QString::number(Z);
    context_m->setContextProperty("coef_Z",str);
    return;
}
//-------------------------------------
//ненужная функция, наверное, нужно посмотреть и проверить(!)
void Compass::addSKL(QString str)
{
    if(skl_str=="0" && (str=="<-" || str=="+/-" || str=="save"))
    {
        fileSklA->remove();
        fileSklA->open(QFile::WriteOnly);
        QTextStream* outSkl = new QTextStream(fileSklA);
        m_skl=skl_str.toDouble();
        *outSkl<<m_skl;
        *outSkl<<" ";
        *outSkl<<m_coef_A;
        *outSkl<<" ";
        fileSklA->close();
        delete outSkl;
        emit sklChanged(m_skl);
        return;
    }
    else if(str=="<-" || (skl_str=="0" && (str!="+0.1" || str!="-0.1")))
    {
        skl_str.remove(skl_str.size()-1,1);
        if(str=="<-" && (skl_str.isEmpty() || skl_str=="-"))
            skl_str="0";
    }
    else if(str=="save")
    {
        fileSklA->remove();
        fileSklA->open(QFile::WriteOnly);
        QTextStream* outSkl = new QTextStream(fileSklA);
        m_skl=skl_str.toDouble();
        *outSkl<<m_skl;
        *outSkl<<" ";
        *outSkl<<m_coef_A;
        *outSkl<<" ";
        fileSklA->close();
        delete outSkl;
        emit sklChanged(m_skl);
        return;
    }
    else if(str=="+0.1")
    {
        skl_str=QString::number(skl_str.toDouble()+0.1);
        if(skl_str.toDouble()<-180.0)
            skl_str="-180";
        else if(skl_str.toDouble()>180.0)
            skl_str="180";
        context_m->setContextProperty("skl_str",skl_str);
        return;
    }
    else if(str=="-0.1")
    {
        skl_str=QString::number(skl_str.toDouble()-0.1);
        if(skl_str.toDouble()<-180.0)
                skl_str="-180";
            else if(skl_str.toDouble()>180.0)
                skl_str="180";
        context_m->setContextProperty("skl_str",skl_str);
        return;
    }
    else if(str=="+/-")
    {
        skl_str=QString::number(skl_str.toDouble()*-1);
        context_m->setContextProperty("skl_str",skl_str);
        return;
    }

    if((str.toInt()>=0 || str.toInt()<=9) && str!= "<-")
    {
        if(skl_str.indexOf(".")!=-1 && skl_str.indexOf(".")!=skl_str.size()-1)
            skl_str.remove(skl_str.size()-1,1);
        skl_str+=str;
        if(skl_str.indexOf("+") == 0)
            skl_str.remove(0,1);
        if(skl_str.toInt()<-180)
            skl_str="-180";
        else if(skl_str.toInt()>180)
            skl_str="180";
    }
    context_m->setContextProperty("skl_str",skl_str);

}
void Compass::addA(QString str)
{
    if(a_str=="0" && (str=="<-" || str=="+/-" || str=="save"))
    {
        m_coef_A=a_str.toDouble();
        emit coef_AChanged(m_coef_A);
        return;
    }
    else if(str=="<-" || (a_str=="0" && (str!="+0.1" || str!="-0.1")))
    {
        a_str.remove(a_str.size()-1,1);
        if(str=="<-" && (a_str.isEmpty() || a_str=="-"))
            a_str="0";
    }
    else if(str=="save")
    {
        fileSklA->remove();
        fileSklA->open(QFile::WriteOnly);
        QTextStream* outSkl = new QTextStream(fileSklA);
        m_coef_A=a_str.toDouble();
        *outSkl<<m_skl;
        *outSkl<<" ";
        *outSkl<<m_coef_A;
        *outSkl<<" ";
        fileSklA->close();
        delete outSkl;
        emit coef_AChanged(m_coef_A);
        return;
    }
    else if(str=="+0.1")
    {
        a_str=QString::number(a_str.toDouble()+0.1);
        if(a_str.toDouble()<-10.0)
            a_str="-10";
        else if(a_str.toDouble()>10.0)
            a_str="10";
        context_m->setContextProperty("a_str",a_str);
        return;
    }
    else if(str=="-0.1")
    {
        a_str=QString::number(a_str.toDouble()-0.1);
        if(a_str.toDouble()<-10.0)
                a_str="-10";
            else if(a_str.toDouble()>10.0)
                a_str="10";
        context_m->setContextProperty("a_str",a_str);
        return;
    }
    else if(str=="+/-")
    {
        a_str=QString::number(a_str.toDouble()*-1);
        context_m->setContextProperty("a_str",a_str);
        return;
    }

    if((str.toInt()>=0 || str.toInt()<=9) && str!= "<-")
    {
        if(a_str.indexOf(".")!=-1 && a_str.indexOf(".")!=a_str.size()-1)
            a_str.remove(a_str.size()-1,1);
        a_str+=str;
        if(a_str.indexOf("+") == 0)
            a_str.remove(0,1);
        if(a_str.toInt()<-10)
            a_str="-10";
        else if(a_str.toInt()>10)
            a_str="10";
    }
    context_m->setContextProperty("a_str",a_str);

}
//------------------------------------------------
void Compass::addDelta(int course, double value)// добавление отклонения от курса без РУ
{
    delta[course-1] = value;
    context_m->setContextProperty("delta_str",delta_str);

}

void Compass::addDeltaDegaus(int course, double value)// добавление отклонения от курса с РУ
{
    deltaDegaus[course-1] = value;
    context_m->setContextProperty("deltaDegaus_str",deltaDegaus_str);

}
//обновление крена и дифф.
void Compass::setRoll(double st)
{
    m_roll=Round(st,1);
    QString str;
    if(m_roll-(int)m_roll==0)
        str = QString::number(m_roll) + ".0";
    else
        str = QString::number(m_roll);
    context_m->setContextProperty("m_roll",str);
}

void Compass::setPitch(double st)
{
    m_pitch=Round(st,1);
    QString str;
    if(m_pitch-(int)m_pitch==0)
        str = QString::number(m_pitch) + ".0";
    else
        str = QString::number(m_pitch);
    context_m->setContextProperty("m_pitch",str);
}
//-------------------------------

double Compass::Round(double st,int count)// функция для округления
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


void Compass::initComp()// инициализация компенсации
{
    m_comp_state = true;
    context_m->setContextProperty("m_complable","КАЛИБРОВКА");
    emit compensationRequest();//сигнал порту для передачи сообщения о начале компенсации
}

void Compass::revert()
{
    emit revertRequest();// сигнал для порта для передачи сообщения о сбросе датчика
}

void Compass::changeTrueMagneticCourse()// изменение компасного, магнитного истиного курсов
{
    //0-KK,1-MK,2-ИК
    if(compangle->getM_tmCourse() == 0)
    {

        compangle->setM_tmCourse(1);
        context_m->setContextProperty("trueMagneticCourse",compangle->getM_tmCourse());
    }
    else if(compangle->getM_tmCourse() == 1)
    {

        compangle->setM_tmCourse(2);
        context_m->setContextProperty("trueMagneticCourse",compangle->getM_tmCourse());
    }
    else if(compangle->getM_tmCourse() == 2)
    {
        compangle->setM_tmCourse(0);
        context_m->setContextProperty("trueMagneticCourse",compangle->getM_tmCourse());
    }
}

//запись в лог, формирование название файла на основе даты и времени
void Compass::startWriteLog()
{

    if(m_writeLog==0)
    {
        context_m->setContextProperty("logMsg","Stop write to log");
        m_oldTime = QTime::currentTime();
        file->open(QFile::ReadWrite);
        m_writeLog = 1;
    }
    else if(m_writeLog == 1)
    {
        context_m->setContextProperty("logMsg","Start write to log");
        m_writeLog = 0;
        file->close();
        file->rename("Log"+QString::number(k)+ " time:"+m_oldTime.toString());
        delete(file);
        delete(out);
        file = new QFile("Log, time:"+QTime::currentTime().toString());

        out = new QTextStream(file);
        *out<<"angle  '"<<"roll  '"<<"pitch  '"<<"B  '"<<"C  '"<<"Z  '"<<"Time '\n";
        k++;

    }
}
//----------------------------------------------
