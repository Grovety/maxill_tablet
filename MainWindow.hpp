#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QtSerialPort>

class MainWindow : public QObject {
        Q_OBJECT
        Q_PROPERTY(QStringList comPorts READ comPorts NOTIFY comPortsChanged)
        Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)
        Q_PROPERTY(QString requestString READ requestString NOTIFY requestStringChanged)
        Q_PROPERTY(QString responseString READ responseString NOTIFY responseStringChanged)
        Q_PROPERTY(bool replyWaiting READ replyWaiting NOTIFY replyWaitingChanged)
    public:
        explicit MainWindow(QObject *parent = nullptr);
        QStringList comPorts() const;
        bool connected() const { return _connected;}
        void setComPorts(const QStringList value);
        QString requestString() const { return _requestString; }
        QString responseString() const { return _responseString; }
        bool replyWaiting() const { return _replyWaiting; }
        Q_INVOKABLE void refreshComPorts();
        Q_INVOKABLE void connect(const QString& com);
        Q_INVOKABLE void sendRequestGetWellStatus();
        Q_INVOKABLE void sendRequestGetUcidList();
        Q_INVOKABLE void sendRequestGetResult(const QString& ucid);
        Q_INVOKABLE void sendRequestGetRawData(const QString& ucid);
        Q_INVOKABLE void sendRequestFlashDataLogger (const QString& label, const QString& filename);
        Q_INVOKABLE void loadPlotDataFromFile(const QString& filename);
        Q_INVOKABLE void sendRequestSetupDataLogger (
                const QString& label, const int sampleRate, const double startTemp, const double startPress, const int confirmationPeriod, const quint64 timestamp,
                const double targetTemp, const double targetPress, const double criticalTemp, const double criticalPress, const int targetTime, const int deivationPeriod);
    private:
        void updateReplyWaiting(const bool val);
        void updateRequestString(const QString& val);
        void updateResponseString(const QString& val);
        void sendRequest(const QString& request);
        void connectToPort();
        QQmlEngine* _engine;
        QStringList _comPorts;
        QSerialPort* _port;
        bool _connected;
        QString _requestString{};
        QString _responseString{};
        unsigned int idCntr{};
        bool _replyWaiting{};
    signals:
        void comPortsChanged();
        void connectedChanged();
        void requestStringChanged();
        void responseStringChanged();
        void replyWaitingChanged();
        void newTemperaturePointAdded(const float value);
};
