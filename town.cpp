#include "town.h"

Town::Town(QObject *parent)
    : QObject{parent}
{}

Town::Town(QString name, QVector2D pos, QDate start, QDate end, QObject *parent) : Town(parent)
{
    _name = name;
    _point = pos;
    _start = start;
    _end = end;
    if (!_start.isValid()) {
        qWarning() << "Start: " << _start << "End: " << _end;
        qWarning() << "First date invalid!";
    }
}

QVector2D Town::point() const
{
    return _point;
}

QDate Town::start() const
{
    return _start;
}

QDate Town::end() const
{
    return _end;
}

QString Town::name() const
{
    return _name;
}

bool Town::alive(QDate date)
{
    return ((!start().isValid()) || (start() <= date)) && ((!end().isValid()) || (date <= end()));
}

Town* Town::fromTSV(QString tsv_line, QObject *parent)
{
    QStringList colls = tsv_line.split('\t');
    return new Town(
        colls[0],
        QVector2D{colls[1].toFloat(), colls[2].toFloat()},
        (colls[3] == "—" ? QDate() : QDate(colls[3].toInt(), 1, 1)),
        (colls[4] == "—" ? QDate() : QDate(colls[4].toInt(), 1, 1))
        );
}

// Town::Town(const Town &other)
// {
//     _point = other.point();
//     _start = other.start();
//     _end = other.end();
//     emit pointChanged(_point);
//     emit startChanged(_start);
//     emit endChanged(_end);
// }
