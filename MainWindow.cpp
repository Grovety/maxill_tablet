#include "MainWindow.hpp"
#include <QDebug>
#include <QPainter>
#include <QSize>
#include <QFile>
#include <QtSerialPort/QtSerialPort>

#define BAUDRATE    QSerialPort::Baud115200


MainWindow::MainWindow(QObject *parent)
    :   QObject(parent),
        _engine(nullptr),
        _port{new QSerialPort()},
        _connected{} {

    _port->setBaudRate(BAUDRATE);
    _port->setDataBits(QSerialPort::DataBits::Data8);
    _port->setParity(QSerialPort::Parity::NoParity);
    _port->setStopBits(QSerialPort::StopBits::OneStop);
    _port->setFlowControl(QSerialPort::NoFlowControl);
}

QStringList MainWindow::comPorts() const {
    return _comPorts;
}

void MainWindow::refreshComPorts() {
    _comPorts.clear();
    qDebug() << "refreshing availabale com ports..";
    auto const portList {QSerialPortInfo::availablePorts()};

    for (auto port : portList) {
        _comPorts.append(port.portName().trimmed());
    }
    emit comPortsChanged();
}

void MainWindow::setComPorts(const QStringList value) {
    _comPorts = value;
}

Q_INVOKABLE void MainWindow::connect(const QString& com) {
    _port->setPortName(com);
    connectToPort();
}


void MainWindow::sendRequestGetWellStatus() {
    static QJsonDocument doc{QJsonDocument::fromJson(R"(
{
    "command": "get_well_status",
    "request_id": 1,
    "payload": {}
}
)")};

    QJsonObject root {doc.object()};
    root["request_id"] = static_cast<qint64>(++idCntr);

    doc.setObject(root);
    const QString reqString{doc.toJson(QJsonDocument::Indented)};

    sendRequest(reqString);
}

void MainWindow::sendRequestGetUcidList() {

    static QJsonDocument doc{QJsonDocument::fromJson(R"(
{
    "command": "get_ucid_list",
    "request_id": 1,
    "payload": {}
}
)")};

    QJsonObject root {doc.object()};
    root["request_id"] = static_cast<qint64>(++idCntr);

    doc.setObject(root);
    const QString reqString{doc.toJson(QJsonDocument::Indented)};

    sendRequest(reqString);
}

void MainWindow::sendRequestGetResult(const QString& ucid) {

    static QJsonDocument doc{QJsonDocument::fromJson(R"(
{
    "command": "get_result",
    "request_id": 1,
    "payload": {
        "ucid": ""
    }
}
)")};

    QJsonObject root {doc.object()};
    root["request_id"] = static_cast<qint64>(++idCntr);
    QJsonObject payload {root["payload"].toObject()};
    payload["ucid"] = ucid;
    root["payload"] = payload;

    doc.setObject(root);
    const QString reqString{doc.toJson(QJsonDocument::Indented)};

    sendRequest(reqString);
}

void MainWindow::sendRequestGetRawData(const QString& ucid) {
    static QJsonDocument doc{QJsonDocument::fromJson(R"(
{
    "command": "get_raw_data",
    "request_id": 1,
    "payload": {
        "ucid": ""
    }
}
)")};

    QJsonObject root {doc.object()};
    root["request_id"] = static_cast<qint64>(++idCntr);
    QJsonObject payload {root["payload"].toObject()};
    payload["ucid"] = ucid;
    root["payload"] = payload;

    doc.setObject(root);
    const QString reqString{doc.toJson(QJsonDocument::Indented)};

    sendRequest(reqString);
}

void MainWindow::sendRequestFlashDataLogger(const QString& label, const QString& filename) {

    qDebug() << "flashing with file: " << filename;
    static QJsonDocument doc{QJsonDocument::fromJson(R"(
{
    "command": "flash_dl",
    "request_id": 1,
    "payload": {}
}
)")};

    QJsonObject root {doc.object()};
    root["request_id"] = static_cast<qint64>(++idCntr);
    QJsonObject payload {root["payload"].toObject()};
    payload["label"] = label;

    QFile file(filename);
    if(!file.open(QFile::ReadOnly)) {
        payload["image"] = "";
    }
    else {
        qDebug() << "failed to open file!";
        QByteArray content {file.readAll()};
        const QString base64String {content.toBase64()};
        payload["image"] = base64String;
    }

    root["payload"] = payload;

    doc.setObject(root);
    const QString reqString{doc.toJson(QJsonDocument::Indented)};

    sendRequest(reqString);
}
void MainWindow::sendRequestSetupDataLogger(
    const QString& label, const int sampleRate, const double startTemp, const double startPress, const int confirmationPeriod, const quint64 timestamp,
    const double targetTemp, const double targetPress, const double criticalTemp, const double criticalPress, const int targetTime, const int deivationPeriod)
{
    static QJsonDocument doc{QJsonDocument::fromJson(R"(
{
    "command": "setup_dl",
    "request_id": 1,
    "payload": {
        "dl_config": {},
        "validation_config": {}
    }
}
)")};

    QJsonObject root {doc.object()};
    root["request_id"] = static_cast<qint64>(++idCntr);

    QJsonObject payload {root["payload"].toObject()};

    QJsonObject dlCfgObject {root["payload"].toObject()["dl_config"].toObject()};
    dlCfgObject["well"] = label;
    dlCfgObject["sample_rate"] = sampleRate;
    dlCfgObject["start_temperature"] = startTemp;
    dlCfgObject["start_pressure"] = startPress;
    dlCfgObject["confirmation_period"] = confirmationPeriod;
    dlCfgObject["timestamp"] = (float)timestamp;
    payload["dl_config"] = dlCfgObject;

    QJsonObject validationCfgObject {root["payload"].toObject()["validation_config"].toObject()};
    validationCfgObject["target_temperature"] = targetTemp;
    validationCfgObject["target_pressure"] = targetPress;
    validationCfgObject["critical_temperature"] = criticalTemp;
    validationCfgObject["critical_pressure"] = criticalPress;
    validationCfgObject["target_time"] = (int)targetTime;
    validationCfgObject["deviation_period"] = (int)deivationPeriod;
    payload["validation_config"] = validationCfgObject;

    root["payload"] = payload;

    doc.setObject(root);
    const QString reqString{doc.toJson(QJsonDocument::Indented)};

    sendRequest(reqString);
}

void MainWindow::sendRequest(const QString& request) {

    updateResponseString("");
    connectToPort();
    _port->flush();
    QEventLoop waitBytesLoop;
    QTimer timer;

    QObject::connect(_port, SIGNAL(readyRead()), &waitBytesLoop, SLOT(quit()));
    QObject::connect(&timer, SIGNAL(timeout()), &waitBytesLoop, SLOT(quit()));

    if (request.length() == _port->write(request.toStdString().c_str(), request.length())) {
        updateReplyWaiting(true);
        updateRequestString(request);
    }
    timer.start(5000);
    waitBytesLoop.exec();

    if (!_port->bytesAvailable()) {
        qDebug() << "reply timeout!";
    }
    else {
        qDebug() << "reply received!";
        QEventLoop waitLoop;
        QObject::connect(&timer, SIGNAL(timeout()), &waitLoop, SLOT(quit()));
        timer.start(500);
        waitLoop.exec();
        const auto replySize{_port->bytesAvailable()};
        qDebug() << "reply size: " << replySize;
        std::unique_ptr<char> replyBuffer {new char[replySize + 1] {}};
        _port->read(replyBuffer.get(), replySize);
        const QString reply {replyBuffer.get()};
        qDebug() << "reply received: " << reply;
        updateResponseString(reply);
    }
    updateReplyWaiting(false);
}

void MainWindow::connectToPort() {
    if (!_port->isOpen()){
        if (_port->open(QIODevice::ReadWrite)){
            qDebug() << "port is open";
            _connected = true;
        }
        else {
            qDebug() << "failed to open port ";
            _connected = false;
        }
    }
    else {
        qDebug() << "port already open";
    }
    connectedChanged();
}

void MainWindow::updateReplyWaiting(const bool val){
    _replyWaiting = val;
    emit replyWaitingChanged();
}
void MainWindow::updateRequestString(const QString& val) {
    _requestString = val;
    emit requestStringChanged();
}

void MainWindow::updateResponseString(const QString& val) {
    _responseString = val;
    emit responseStringChanged();
}
