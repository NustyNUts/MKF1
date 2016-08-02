#ifndef COMPASSANGLE_H
#define COMPASSANGLE_H

#include <QObject>
#include "cubic_spline.h"

class Compassangle : public QObject//  класс для обработки и корректировки значений азимута
{
    Q_OBJECT
public:
    explicit Compassangle(QObject *parent = 0);
    ~Compassangle();

    QString getM_fullangleStr()
    {
        return m_fullangleStr;
    }
    double correctFun(double);
    void setM_fullangle(double);

    double getM_fullangle()
    {
        return m_fullangle;
    }
    double getCourse()
    {
        return m_course;
    }

    int getM_tmCourse()
    {
        return m_tmCourse;
    }

    void setM_tmCourse(int arg)
    {
        m_tmCourse = arg;
    }

    void setM_angle(double angle)
    {
        m_angle = angle;
    }

    double getM_angle()
    {
        return m_angle;
    }

    void setM_fractPart(double fractPart)
    {
        m_fractPart = fractPart;
    }

    double getM_fractPart()
    {
        return m_fractPart;
    }

    void  setM_dempf(double dempf)
    {
        m_dempf = dempf;
        emit dempfChanged();
    }

    double getM_dempf()
    {
        return m_dempf;
    }
    void setA(double arg)
    {
        m_coef_A = arg;
    }
    void setSpline(cubic_spline* sp,cubic_spline* spDG)
    {
        spline = sp;
        splineDG = spDG;
    }
    void setDegaus(bool deg)
    {
        m_degaus = deg;
    }

private:
    bool m_degaus;
   double K;//коэф. для фильтра Кламана
   QList<double> angleList;
   QString m_fullangleStr;
   double m_fullangle;
   double m_angle;
   double m_fractPart;
   double m_last;
   double m_last2;
   double m_coef_A;
   double m_skl;
   double m_lastAngle;
   double m_lastAngle1;
   int m_tmCourse;
   double m_sum;
   int index;
   //расширение границ азимута 0-360 для поворота картушки
   int m_con;
   int m_con1;
   int m_con2;
   //------------------
   int m_dempf;

   cubic_spline *spline;
   cubic_spline *splineDG;

   double m_course;
   double Round(double st,int count);
   double AbsAngle(double, double);

private slots:


signals:
   void dempfChanged();

public slots:
   void setM_skl(double skl)
       {
           m_skl = skl;
       }

       void setM_coef_A(double coef_A)
       {
           m_coef_A = coef_A;
       }
};

#endif // COMPASSANGLE_H
