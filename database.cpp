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
        qWarning() << "Line: " << line;
        _towns.append(
            Town::fromTSV(line)
            );
    }
    emit townsChanged(_towns);
}
