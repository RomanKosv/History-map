#ifndef TOWN_H
#define TOWN_H

#include <QObject>
#include <QQmlEngine>
#include <QVector2D>
#include <QDate>

class Town : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    typedef double time;
    explicit Town(QObject *parent = nullptr);
    Town(QString name, QVector2D pos, QDate start, QDate end, QObject *parent = nullptr);
    Q_PROPERTY(QVector2D point READ point NOTIFY pointChanged FINAL)
    Q_PROPERTY(QDate start READ start NOTIFY startChanged FINAL)
    Q_PROPERTY(QDate end READ end NOTIFY endChanged FINAL)
    Q_PROPERTY(QString name READ name NOTIFY nameChanged FINAL)
    QVector2D point() const;
    QDate start() const;
    QDate end() const;
    QString name() const;
    Q_INVOKABLE bool alive(QDate);
    // Town(const Town&);
    static Town* fromTSV(QString tsv_line, QObject* parent = nullptr);
signals:
    void pointChanged(QVector2D);
    void startChanged(QDate);
    void endChanged(QDate);
    void nameChanged(QString);
private:
    QVector2D _point;
    QDate _start, _end;
    QString _name;
};

#endif // TOWN_H
