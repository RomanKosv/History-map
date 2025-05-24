#include "database.h"
#include <QFile>

Database::Database(QObject *parent)
    : QObject{parent}
{}

QList<Town*> Database::towns()
{
    return _towns;
}

QString Database::file()
{
    return _file;
}

void Database::setFile(QString url)
{
    _file = url;
    update();
    emit fileChanged(url);
}

Database::~Database()
{
    for(auto i : _towns) {
        delete i;
    }
}

void Database::update()
{
    _towns.clear();
    // if ((!_file.isLocalFile())) {
    //     qWarning() << "Url not a file: " << _file;
    //     return;
    // }
    QFile f(_file/*.toLocalFile()*/);
    if (!f.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "File cant be opened: " << _file;
        return;
    }
    QTextStream in(&f);
    while (!in.atEnd()) {
        QString line = in.readLine();
        QStringList colls = line.split('\t');
        qWarning() << "Colls: " << colls;
        _towns.append(
            new Town{
                QVector2D{colls[0].toFloat(), colls[1].toFloat()},
                QDate::fromString(colls[2], Qt::ISODate),               //date must be yyyy-MM-dd
                colls[3] == "_" ? QDate() : QDate::fromString(colls[3], Qt::ISODate)       //date must be yyyy-MM-dd or _
            }
            );
    }
    emit townsChanged(_towns);
}
