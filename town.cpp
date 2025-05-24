#include "town.h"

Town::Town(QObject *parent)
    : QObject{parent}
{}

Town::Town(QVector2D pos, QDate start, QDate end, QObject *parent) : Town(parent)
{
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

// Town::Town(const Town &other)
// {
//     _point = other.point();
//     _start = other.start();
//     _end = other.end();
//     emit pointChanged(_point);
//     emit startChanged(_start);
//     emit endChanged(_end);
// }
