#ifndef JSONCONVERTER_H
#define JSONCONVERTER_H

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include "msgpack11.hpp"

class JsonConverter
{
public:
    JsonConverter();
    QJsonDocument fromMsgPack(const msgpack11::MsgPack& msgPack);

};

#endif // JSONCONVERTER_H
