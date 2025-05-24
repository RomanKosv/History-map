#ifndef DATABASE_H
#define DATABASE_H

#include "town.h"
#include <QObject>
#include <QQmlEngine>

class Database : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit Database(QObject *parent = nullptr);
    Q_PROPERTY(QList<Town*> towns READ towns NOTIFY townsChanged FINAL)
    Q_PROPERTY(QString file READ file WRITE setFile NOTIFY fileChanged FINAL)
    QList<Town*> towns();
    QString file();
    void setFile(QString);
    ~Database() override;
signals:
    void townsChanged(QList<Town*>);
    void fileChanged(QUrl);
private:
    QList<Town*> _towns;
    QString _file;
    void update();
};

#endif // DATABASE_H
