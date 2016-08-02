#include "compassangle.h"
#include <math.h>
#include <QDebug>

Compassangle::Compassangle(QObject *parent) : QObject(parent),K(0.6), m_fullangle(0), m_angle(0), m_fractPart(0), m_last(0), m_last2(0), m_coef_A(0), m_lastAngle(0),
    m_lastAngle1(0), m_tmCourse(0), index(0), m_con(0), m_con1(0)
{
    m_fullangleStr = "000.0";
    m_skl = 0; // here will be another arg from file
    m_dempf = 0;
    m_sum = 0;
}

Compassangle::~Compassangle()
{
    deleteLater();
}
double Compassangle::correctFun(double d)// фильтр Калмана для демпфирования
{
    if(angleList.size()>60)// какое кол-во отсчетов усреднять
        angleList.removeFirst();
    if(angleList.size())
        // обработка разрыва в 0, если переходим через 0 набор отсчетов начинается сначала
        if(angleList.last()-d>-180 || angleList.last()-d<180)
            angleList.clear();
    angleList.push_back(d);
    double z=0;
    //сам фильтр Калмана
    for (int i=0;i<angleList.size();i++)
        z+=angleList[i];
    z /=angleList.size();
   return  K*z+(1-K)*d;//получение усредненого значения

}

void Compassangle::setM_fullangle(double a)
{
        if(m_dempf != 0)// демпфирование включено
        {
            K = 0.95;// увеличиваем коеф. Калмана
        }
        else
            K=0.6;// коеф. Калмана без демпфирования
    if(index == 0)
        m_last = a;
    //
    if(m_last - a > 180)
        a = m_last + ((a+360) - m_last)*0.5;
    else if(m_last - a < -180)
        a = (m_last-360) + (a - m_last + 360)*0.5;
    else
        a = m_last + (a - m_last)*0.5;
    // ограничение, курс в пределах 0-360
    if(a<0)
        a+=360;
     if(a>360)
        a-=360;
    a = Round(a,1);// округление до десятых
    m_last=a;

    // интерполируем на истином и магнитном курсах, на компасном нет
    if(m_tmCourse > 0){
        if(m_degaus)
            a = a + splineDG->f(a);
        else
            a = a + spline->f(a);
    }
    //-----------------


       a +=m_coef_A;// учитываем коеф.А
    if(m_tmCourse > 1)
        a = a + m_skl;// если истиный курс то учитываем склонение
    // ограничение, курс в пределах 0-360
    if(a<0)
        a+=360;
     if(a>360)
        a-=360;

     a = correctFun(a);// применяем усреднение


    //------------------------------------------
     m_course = a;
    if (a!=0)
    {
        double temp;
        double *pt=new double;
        temp=QString::number(modf(a,pt)).left(3).toDouble();
        m_fractPart=(QString::number(*pt).right(1).toDouble()+temp)*10;
        m_angle=*pt;
        delete pt;
        m_fullangle=m_angle+temp;
    }
    else
        m_fractPart = m_angle = m_fullangle = m_lastAngle = 0;

    // заставляем картушку крутиться в логичном направдении (направление меньшего оборота)
    if(m_angle-m_lastAngle > 180)
    {
        m_con--;
    }
    else if(m_angle-m_lastAngle < -180)
    {
         m_con++;
    }
    m_lastAngle=m_angle;
    m_angle=m_angle+360*m_con;


    if(m_fractPart-m_lastAngle1 > 50)
    {
        m_con1--;
    }
    else if(m_fractPart-m_lastAngle1 < -50)
    {
         m_con1++;
    }
    m_lastAngle1=m_fractPart;
    m_fractPart=m_fractPart+100*m_con1;
    //--------------------------------------------------------------------------------------
    index = 1;

    // формирование строки lcd панели
    m_fullangleStr = QString::number(m_fullangle);
    if(m_fullangle - (int)m_fullangle == 0)
        m_fullangleStr +=".0";
    if(m_fullangle / 10 < 1)
       m_fullangleStr="0"+m_fullangleStr;
    if(m_fullangle / 100 < 1)
        m_fullangleStr="0"+m_fullangleStr;
}

double Compassangle::Round(double st,int count)//  округление до десятых
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

double Compassangle::AbsAngle(double angle, double con)
{
    return angle + 360* con;// получение абсолютного угла(расширеный)
}
