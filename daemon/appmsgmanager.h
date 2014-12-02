#ifndef APPMSGMANAGER_H
#define APPMSGMANAGER_H

#include "watchconnector.h"
#include "appmanager.h"

class AppMsgManager : public QObject
{
    Q_OBJECT
    LOG4QT_DECLARE_QCLASS_LOGGER

public:
    explicit AppMsgManager(AppManager *apps, WatchConnector *watch, QObject *parent);

    void send(const QUuid &uuid, const QVariantMap &data,
              const std::function<void()> &ackCallback,
              const std::function<void()> &nackCallback);

public slots:
    void send(const QUuid &uuid, const QVariantMap &data);
    void launchApp(const QUuid &uuid);
    void closeApp(const QUuid &uuid);

signals:
    void appStarted(const QUuid &uuid);
    void appStopped(const QUuid &uuid);
    void messageReceived(const QUuid &uuid, const QVariantMap &data);

private:
    WatchConnector::Dict mapAppKeys(const QUuid &uuid, const QVariantMap &data);
    QVariantMap mapAppKeys(const QUuid &uuid, const WatchConnector::Dict &dict);

    static bool unpackPushMessage(const QByteArray &msg, uint *transaction, QUuid *uuid, WatchConnector::Dict *dict);

    static QByteArray buildPushMessage(uint transaction, const QUuid &uuid, const WatchConnector::Dict &dict);
    static QByteArray buildAckMessage(uint transaction);
    static QByteArray buildNackMessage(uint transaction);

private:
    AppManager *apps;
    WatchConnector *watch;
    quint8 lastTransactionId;
};

#endif // APPMSGMANAGER_H
