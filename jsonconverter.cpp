#include "jsonconverter.h"


QJsonObject parseObject(const msgpack11::MsgPack& msgPack);
static QJsonArray parseArray(const msgpack11::MsgPack& msgPack);

JsonConverter::JsonConverter()
{

}

QJsonObject parseObject(const msgpack11::MsgPack& msgPack) {
    QJsonObject ret;

    const auto map = msgPack.object_items();

    for (const auto& field : map) {
        if(field.second.is_string()) {
            ret[QString::fromStdString(field.first.string_value())] = QString::fromStdString(field.second.string_value());
        }
        else if (field.second.is_bool()) {
            ret[QString::fromStdString(field.first.string_value())] = field.second.bool_value();
        }
        else if (field.second.is_float32() or field.second.is_float64()) {
            ret[QString::fromStdString(field.first.string_value())] = field.second.float32_value();
        }
        else if (field.second.is_int()) {
            ret[QString::fromStdString(field.first.string_value())] = field.second.int_value();
        }
        else if (field.second.is_object()) {
            ret[QString::fromStdString(field.first.string_value())] = parseObject(field.second);
        }
        else if (field.second.is_array()) {
            ret[QString::fromStdString(field.first.string_value())] = parseArray(field.second);
        }


    }
    return ret;
}

QJsonArray parseArray(const msgpack11::MsgPack& msgPack) {
    QJsonArray ret;

    const auto values = msgPack.array_items();

    for (const auto& value : values) {
        if(value.is_string()) {
            ret.append(QString::fromStdString(value.string_value()));
        }
        else if (value.is_bool()) {
            ret.append(value.bool_value());
        }
        else if (value.is_float32() or value.is_float64()) {
           ret.append(value.float32_value());
        }
        else if (value.is_int()) {
            ret.append(value.int_value());
        }
        else if (value.is_object()) {
            ret.append(parseObject(value));
        }
    }
    return ret;
}

QJsonDocument JsonConverter::fromMsgPack(const msgpack11::MsgPack& msgPack) {

    if(msgPack.is_object()) {
        qDebug() << "root is object";
        QJsonObject root{parseObject(msgPack)};
        QJsonDocument doc{root};
        return doc;
    }
    return QJsonDocument{};
}
